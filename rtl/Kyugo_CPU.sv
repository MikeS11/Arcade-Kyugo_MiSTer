//============================================================================
//
//  Kyugo CPU board
//  Copyright (C) 2026 Rodimus
//
//  MAME reference: kyugo.cpp
//  Hardware: Z80 CPU1 + Z80 CPU2 @ 3.072 MHz (XTAL 18.432 / 6)
//            2x AY-3-8910 @ 1.536 MHz (18.432 / 12)
//  Screen: 396x260 total, visible 288x224 (lines 16-239), 59.66 Hz
//
//============================================================================

module Kyugo_CPU
(
	input         reset,
	input         clk_49m,
	output  [4:0] red, green, blue,
	output        video_hsync, video_vsync, video_csync,
	output        video_hblank, video_vblank,
	output        ce_pix,
	input   [7:0] p1_controls,
	input   [7:0] p2_controls,
	input   [7:0] sys_controls,
	input  [15:0] dip_sw,
    input         rot_flip,
	output signed [15:0] sound,
	input   [3:0] h_center, v_center,
	input         main_rom_cs_i, sub_rom_cs_i, fg_rom_cs_i,
	input         bg0_rom_cs_i, bg1_rom_cs_i, bg2_rom_cs_i,
	input         spr0_rom_cs_i, spr1_rom_cs_i, spr2_rom_cs_i,
	input         prom_r_cs_i, prom_g_cs_i, prom_b_cs_i,
	input         prom_lut_cs_i, prom_tim_cs_i,
	input  [24:0] ioctl_addr,
	input   [7:0] ioctl_data,
	input         ioctl_wr,
	input   [2:0] variant_sel,
	output  [1:0] coin_counter,
	input         pause,
	input  [15:0] hs_address,
	input   [7:0] hs_data_in,
	output  [7:0] hs_data_out,
	input         hs_write
);

//------------------------------------------------------- Clock enables -------------------------------------------------------//

// Pixel clock: 49.152 MHz * 4/32 = 6.144 MHz = XTAL/3 (matches MAME set_raw(XTAL/3, 396, 0, 288, 260, 16, 240) → 59.6575 Hz).
// jtframe_frac_cen produces a single-cycle pulse every 8 clk_49m cycles; a manual counter
// comparison (e.g. a bit-range == 0 test) instead yields a multi-cycle LEVEL, firing every
// `if (cen_pix)` block several times per intended pixel.
wire [1:0] pix_cen_o;
jtframe_frac_cen #(2) pix_cen (.clk(clk_49m), .n(10'd4), .m(10'd32), .cen(pix_cen_o), .cenb());
wire cen_pix = pix_cen_o[0];
assign ce_pix = cen_pix;

// cen_cpu = 3.072 MHz CPU clock-enable, free-running /16 division of clk_49m.
reg [3:0] cpu_div = 4'd0;
always_ff @(posedge clk_49m) cpu_div <= cpu_div + 4'd1;
wire cen_cpu = (cpu_div == 4'd0);

reg ay_toggle = 1'b0;
always_ff @(posedge clk_49m) if (cen_cpu) ay_toggle <= ~ay_toggle;
wire cen_ay = cen_cpu & ~ay_toggle & ~pause;

//-------------------------------------------------------- Video timing --------------------------------------------------------//

reg [8:0] base_h_cnt = 9'd0;
reg [8:0] v_cnt      = 9'd0;

wire [8:0] h_cnt_rot;
wire [8:0] v_cnt_rot;
wire [8:0] h_cnt_sync = base_h_cnt;
wire [8:0] v_cnt_sync = v_cnt;

assign h_cnt_rot = { base_h_cnt[8], base_h_cnt[7:0] ^ {8{flip_screen}} };
assign v_cnt_rot = { v_cnt[8],      v_cnt[7:0]      ^ {8{flip_screen}} };

always_ff @(posedge clk_49m) begin
	if (cen_pix) begin
		if (base_h_cnt == 9'd395) begin
			base_h_cnt <= 9'd0;
			v_cnt <= (v_cnt == 9'd259) ? 9'd0 : v_cnt + 9'd1;
		end else begin
			base_h_cnt <= base_h_cnt + 9'd1;
		end
	end
end

wire hblk = (base_h_cnt >= 9'd288);
wire vblk = (v_cnt < 9'd16) | (v_cnt >= 9'd240);
assign video_hblank = hblk;
assign video_vblank = vblk;

// HSYNC/VSYNC generation; h_center/v_center are OSD-adjustable centering offsets.
wire [8:0] hs_start = 9'd292 + {5'd0, h_center};
wire [8:0] hs_end   = hs_start + 9'd16;
wire [8:0] vs_start = 9'd242 + {5'd0, v_center};
wire [8:0] vs_end   = vs_start + 9'd4;
assign video_hsync = (h_cnt_sync >= hs_start && h_cnt_sync < hs_end);
assign video_vsync = (v_cnt_sync >= vs_start && v_cnt_sync < vs_end);
assign video_csync = ~(video_hsync ^ video_vsync);

// HACK — REQUIRED FOR BOOT, DO NOT REMOVE. Cold-boot SUB CHECK handshake is unsolved: on power-up
// the sub never writes its F004 handshake token, so the main CPU waits on it forever. Masked by
// leaning on the (Gyrodine) watchdog: once main stops kicking $E000, a ~2s timeout fires a
// RAM-preserving reset (reset_cpu), equivalent to a manual soft reset, and the retry succeeds.
// combined CPU-subsystem reset = power reset OR a watchdog soft-reboot pulse (wdog_rst, from the
// watchdog block below). reset_cpu pulses both Z80s + the LS259 mainlatch + NMI/IRQ state like a
// real board reset; RAM is NOT cleared (the boot self-test re-inits it).
// Proper fix is the sub-side cold-boot handshake itself; until then this hack must stay or the
// game won't boot. To test the real root cause directly: wdog_arm = 1'b0 makes reset_cpu == reset.
wire       wdog_rst;            // forward reference, driven by the watchdog block below
wire       wdog_arm = 1'b1;     // 1 = hack armed (masks the unsolved cold-boot SUB CHECK; required to boot)
wire       reset_cpu = reset & ~(wdog_rst & wdog_arm);

//------------------------------------------------------- CPU1 — Main ---------------------------------------------------------//

wire [15:0] cpu1_A;
wire [7:0]  cpu1_Dout;
wire        cpu1_WR_n, cpu1_RD_n, cpu1_MREQ_n, cpu1_IORQ_n, cpu1_M1_n, cpu1_RFSH_n;

T80s cpu1
(
	.RESET_n(reset_cpu), .CLK(clk_49m), .CEN(cen_cpu & ~pause), .WAIT_n(1'b1), // reset_cpu: +watchdog
	.INT_n(1'b1), .NMI_n(~cpu1_nmi),
	.M1_n(cpu1_M1_n), .MREQ_n(cpu1_MREQ_n), .IORQ_n(cpu1_IORQ_n),
	.RD_n(cpu1_RD_n), .WR_n(cpu1_WR_n), .RFSH_n(cpu1_RFSH_n),
	.A(cpu1_A), .DI(cpu1_Din), .DO(cpu1_Dout)
);

// NMI: fires at scanline 240 (base_h_cnt==0, v_cnt==240), gated by nmi_mask.
// The T80 core samples NMI_n for a falling edge only on CEN ticks, so a pulse narrower than one
// cen_cpu period can fall between two samples and be missed entirely. Held HIGH for a fixed ~16
// cen_cpu ticks (nmi_cnt) so the edge is always caught regardless of phase against the CPU's own
// fetch cycle; still exactly one NMI since the CPU is edge-triggered, and the hold releases well
// before the next frame's NMI.
reg cpu1_nmi = 1'b0;
reg [4:0] nmi_cnt = 5'd0;
always_ff @(posedge clk_49m) begin
	if (!reset_cpu) begin cpu1_nmi <= 1'b0; nmi_cnt <= 5'd0; end  // reset_cpu: +watchdog
	else if (cen_pix && (base_h_cnt == 9'd0) && (v_cnt == 9'd240) && nmi_mask) begin
		cpu1_nmi <= 1'b1;
		nmi_cnt  <= 5'd16;                         // assert + hold window (cen_cpu ticks)
	end else if (cen_cpu && (nmi_cnt != 5'd0)) begin
		nmi_cnt <= nmi_cnt - 5'd1;
		if (nmi_cnt == 5'd1) cpu1_nmi <= 1'b0;     // release after ~16 cen_cpu ticks
	end
end

//-------------------------------------------------- CPU1 Address Decoding (variant-aware) ------------------------------//

localparam [2:0] VAR_GYRO     = 3'd0,
                 VAR_REPULSE  = 3'd1,
                 VAR_FLASHGAL = 3'd2,
                 VAR_SRDMISSN = 3'd3,
                 VAR_LEGEND   = 3'd4;

wire cpu1_mem_valid = ~cpu1_MREQ_n & cpu1_RFSH_n;
wire cs_rom       = cpu1_mem_valid & ~cpu1_A[15];                              // 0000-7FFF
wire cs_bgvram    = cpu1_mem_valid & (cpu1_A[15:11] == 5'b10000);              // 8000-87FF
wire cs_bgattr    = cpu1_mem_valid & (cpu1_A[15:11] == 5'b10001);              // 8800-8FFF
wire cs_fgvram    = cpu1_mem_valid & (cpu1_A[15:11] == 5'b10010);              // 9000-97FF
wire cs_spram1    = cpu1_mem_valid & (cpu1_A[15:11] == 5'b10011);              // 9800-9FFF
wire cs_spram0    = cpu1_mem_valid & (cpu1_A[15:11] == 5'b10100);              // A000-A7FF
wire cs_scrollxlo = cpu1_mem_valid & ~cpu1_WR_n & (cpu1_A[15:0] == 16'hA800); // A800 W
wire cs_gfxctrl   = cpu1_mem_valid & ~cpu1_WR_n & (cpu1_A[15:0] == 16'hB000); // B000 W
wire cs_scrolly   = cpu1_mem_valid & ~cpu1_WR_n & (cpu1_A[15:0] == 16'hB800); // B800 W
// E000 region: Gyrodine = watchdog write, SRDMission = shared RAM mirror, others = unmapped
wire cs_e000_blk  = cpu1_mem_valid & (cpu1_A[15:11] == 5'b11100);              // E000-E7FF
wire cs_watchdog  = cs_e000_blk & (variant_sel == VAR_GYRO);
wire cs_shared_e  = cs_e000_blk & (variant_sel == VAR_SRDMISSN);
wire cs_shared    = cpu1_mem_valid & (cpu1_A[15:11] == 5'b11110);              // F000-F7FF
wire cs_mainlatch = ~cpu1_IORQ_n & ~cpu1_WR_n;                                 // IO 00-07 (global_mask 0x07)

// LS259 mainlatch (I/O port mapped, global_mask 0x07 → addr = cpu1_A[2:0])
reg [7:0] mainlatch = 8'd0;
always_ff @(posedge clk_49m) begin
	if (!reset_cpu) mainlatch <= 8'd0;  // reset_cpu: +watchdog (a real soft-reset clears the LS259)
	else if (cen_cpu && cs_mainlatch) mainlatch[cpu1_A[2:0]] <= cpu1_Dout[0];
end
// nmi_mask mirrors the game's own mainlatch[0] (the vblank-NMI enable the game controls itself).
// ml0_seen is currently unused by any live logic.
reg ml0_seen = 1'b0;
always_ff @(posedge clk_49m) begin
	if (!reset_cpu)        ml0_seen <= 1'b0;
	else if (mainlatch[0]) ml0_seen <= 1'b1;
end
wire nmi_mask = mainlatch[0];

// flip_screen is hardwired to 0. A 180-degree flip and the screen_rotate stage commute
// (render-unflipped + rotate-CCW == render-flipped + rotate-CW); the unflipped render path is
// the one proven correct across every game on this core, so 180-degree sets get their rotation
// from screen_rotate/rot_flip instead of from this coordinate mirror. Gyrodine.mra must keep
// rot_flip=0 (core_config bit 3 clear, index=1 part 00) — flip_screen=0 and rot_flip=0 are a
// matched pair. mainlatch[1] is still read elsewhere as flip_req (scroll_x negation, sprite
// mirroring); only the screen-coordinate mirror here is disabled, so the per-layer
// `^ flip_screen` code further down stays permanently unreachable while this is 0.
wire flip_screen = 1'b0;
wire cpu2_rst    = ~mainlatch[2];

//------------------------------------------------------- Watchdog (Gyrodine) -------------------------------------------------//
// Watchdog (the cold-boot SUB-CHECK recovery mechanism — see wdog_arm above): MAME gyrodine() adds
// WATCHDOG_TIMER; map(0xe000).w = watchdog reset. A write to E000 kicks it; if the main CPU stops
// kicking for WDOG_TIMEOUT frames, the board soft-resets (wdog_rst -> reset_cpu pulses both Z80s +
// the LS259 + NMI state, re-running boot). Gyrodine-only: other variants never increment so never
// trip. Frame-clocked on the vblk rising edge (once/frame). 120 frames (~2s) comfortably exceeds
// the normal E000 kick interval during boot while still giving a fairly fast attract-lock retry;
// lower toward ~60 for faster retries, raise only if a legitimate long no-kick gap ever causes a
// reset-loop.
localparam [8:0] WDOG_TIMEOUT = 9'd120;   // frames w/o an E000 kick before reboot (~2 s @ 60 Hz)
reg  [8:0] wdog_frames = 9'd0;
reg  [9:0] wdog_pulse  = 10'd0;           // reboot-pulse length, in clk_49m cycles
reg        wdog_vblk_d = 1'b0;
assign     wdog_rst    = (wdog_pulse != 10'd0);
always_ff @(posedge clk_49m) begin
	if (!reset) begin
		wdog_frames <= 9'd0; wdog_pulse <= 10'd0; wdog_vblk_d <= 1'b0;
	end else begin
		wdog_vblk_d <= vblk;
		if (wdog_rst) begin
			wdog_pulse  <= wdog_pulse - 10'd1;     // hold reset, count the pulse down
			wdog_frames <= 9'd0;
		end else if (cs_watchdog & ~cpu1_WR_n) begin
			wdog_frames <= 9'd0;                    // kicked
		end else if (pause) begin
			// Pause freezes both Z80s but not the video counters, so vblk keeps ticking with no CPU
			// alive to kick $E000. Clear (not freeze) the counter so a nearly-expired count can't
			// trip the watchdog just after resume.
			wdog_frames <= 9'd0;
		end else if (vblk & ~wdog_vblk_d & (variant_sel == VAR_GYRO)) begin
			if (wdog_frames >= WDOG_TIMEOUT) begin
				wdog_pulse  <= 10'h3FF;             // FIRE: ~1023 clk reset pulse (many cen_cpu)
				wdog_frames <= 9'd0;
			end else
				wdog_frames <= wdog_frames + 9'd1;
		end
	end
end

//------------------------------------------------------- CPU2 — Sub ----------------------------------------------------------//

wire [15:0] cpu2_A;
wire [7:0]  cpu2_Dout;
wire        cpu2_WR_n, cpu2_RD_n, cpu2_MREQ_n, cpu2_IORQ_n, cpu2_M1_n, cpu2_RFSH_n;

T80s cpu2
(
	.RESET_n(reset_cpu & ~cpu2_rst), .CLK(clk_49m),  // reset_cpu: +watchdog
	// Both Z80s are identical 3.072 MHz parts on the real board, so they must share one timing model:
	// the boot handshake depends on their RELATIVE speed. The main releases the sub, runs a 32KB ROM
	// checksum, then reads $F000 ONCE expecting the $FF the sub leaves there (gyro_main.asm $7F20 ->
	// $7F51, gyro_sub.asm $0268). Using a different T80 wrapper here made the sub lose that race and
	// the self-test reported "SUB CHECK". Keep this identical to cpu1.
	.CEN(cen_cpu & ~pause),
	.WAIT_n(1'b1),
	.INT_n(~cpu2_irq), .NMI_n(1'b1),
	.M1_n(cpu2_M1_n), .MREQ_n(cpu2_MREQ_n), .IORQ_n(cpu2_IORQ_n),
	.RD_n(cpu2_RD_n), .WR_n(cpu2_WR_n), .RFSH_n(cpu2_RFSH_n),
	.A(cpu2_A), .DI(cpu2_Din), .DO(cpu2_Dout)
);

// Sub IRQ: 4x per frame at (scanline & 0x3F) == 0x20 (scanlines 32, 96, 160, 224)
reg cpu2_irq = 1'b0;
always_ff @(posedge clk_49m) begin
	if (!reset_cpu || cpu2_rst) cpu2_irq <= 0;  // reset_cpu: +watchdog
	else begin
		if (cen_pix && (base_h_cnt == 9'd0) && (v_cnt[5:0] == 6'h20))
			cpu2_irq <= 1;
		if (~cpu2_IORQ_n & ~cpu2_M1_n) cpu2_irq <= 0;
	end
end

// Sub CPU memory decode — variant-aware (kyugo.cpp 484-532)
wire cpu2_mem_valid = ~cpu2_MREQ_n & cpu2_RFSH_n;

// ROM region: Gyrodine 0000-1FFF (8KB), all others 0000-7FFF (16KB+)
wire cs2_rom = cpu2_mem_valid & ((variant_sel == VAR_GYRO)
                                 ? (~cpu2_A[15] & ~cpu2_A[14] & ~cpu2_A[13])
                                 : ~cpu2_A[15]);

// Shared RAM region (per variant)
wire cs2_shared = cpu2_mem_valid &
    ( ((variant_sel == VAR_GYRO)     && (cpu2_A[15:11] == 5'b01000))    // 4000-47FF
    | ((variant_sel == VAR_REPULSE)  && (cpu2_A[15:11] == 5'b10100))    // A000-A7FF
    | ((variant_sel == VAR_FLASHGAL) && (cpu2_A[15:11] == 5'b11100))    // E000-E7FF
    | ((variant_sel == VAR_SRDMISSN) && (cpu2_A[15:11] == 5'b10000))    // 8000-87FF
    | ((variant_sel == VAR_LEGEND)   && (cpu2_A[15:11] == 5'b11000)) ); // C000-C7FF

// SRDMission has an extra 2KB sub-only RAM at 0x8800-0x8FFF
wire cs2_subram = cpu2_mem_valid & (variant_sel == VAR_SRDMISSN) & (cpu2_A[15:11] == 5'b10001);

// Input ports (P1, P2, SYSTEM) — addresses vary per variant
wire cs2_p1, cs2_p2, cs2_system;
assign cs2_system = cpu2_mem_valid &
    ( ((variant_sel == VAR_GYRO)     && (cpu2_A[15:0] == 16'h8080))
    | ((variant_sel == VAR_REPULSE)  && (cpu2_A[15:0] == 16'hC080))
    | ((variant_sel == VAR_FLASHGAL) && (cpu2_A[15:0] == 16'hC040))
    | ((variant_sel == VAR_SRDMISSN) && (cpu2_A[15:0] == 16'hF400))
    | ((variant_sel == VAR_LEGEND)   && (cpu2_A[15:0] == 16'hF800)) );
assign cs2_p1 = cpu2_mem_valid &
    ( ((variant_sel == VAR_GYRO)     && (cpu2_A[15:0] == 16'h8040))
    | ((variant_sel == VAR_REPULSE)  && (cpu2_A[15:0] == 16'hC040))
    | ((variant_sel == VAR_FLASHGAL) && (cpu2_A[15:0] == 16'hC080))
    | ((variant_sel == VAR_SRDMISSN) && (cpu2_A[15:0] == 16'hF401))
    | ((variant_sel == VAR_LEGEND)   && (cpu2_A[15:0] == 16'hF801)) );
assign cs2_p2 = cpu2_mem_valid &
    ( ((variant_sel == VAR_GYRO)     && (cpu2_A[15:0] == 16'h8000))
    | ((variant_sel == VAR_REPULSE)  && (cpu2_A[15:0] == 16'hC000))
    | ((variant_sel == VAR_FLASHGAL) && (cpu2_A[15:0] == 16'hC0C0))
    | ((variant_sel == VAR_SRDMISSN) && (cpu2_A[15:0] == 16'hF402))
    | ((variant_sel == VAR_LEGEND)   && (cpu2_A[15:0] == 16'hF802)) );

// I/O port decode — variant-aware (kyugo.cpp 547-583)
// AY1 base port: Gyro/Repulse = 0x00, Flashgal = 0x40, SRD/Legend = 0x80
// AY2 base port: Gyro = 0xC0, Repulse = 0x40, Flashgal = 0x80, SRD/Legend = 0x84
// Coin counter: Repulse/Flashgal = 0xC0/0xC1, SRD/Legend = 0x90/0x91 (none on Gyrodine)
wire io_active = ~cpu2_IORQ_n & cpu2_M1_n;   // exclude interrupt acknowledge cycles

wire [7:0] ay1_base = (variant_sel == VAR_FLASHGAL) ? 8'h40 :
                      (variant_sel == VAR_SRDMISSN || variant_sel == VAR_LEGEND) ? 8'h80 :
                      8'h00;
wire [7:0] ay2_base = (variant_sel == VAR_GYRO)     ? 8'hC0 :
                      (variant_sel == VAR_REPULSE)  ? 8'h40 :
                      (variant_sel == VAR_FLASHGAL) ? 8'h80 :
                                                      8'h84;   // SRD/Legend
wire [7:0] coin_base = (variant_sel == VAR_REPULSE || variant_sel == VAR_FLASHGAL) ? 8'hC0 :
                       (variant_sel == VAR_SRDMISSN || variant_sel == VAR_LEGEND)  ? 8'h90 :
                                                                                     8'hFF;  // unused for Gyro

wire cs2_ay1_addr = io_active & ~cpu2_WR_n & (cpu2_A[7:0] == ay1_base);
wire cs2_ay1_data = io_active & ~cpu2_WR_n & (cpu2_A[7:0] == (ay1_base | 8'h01));
wire cs2_ay1_rd   = io_active & ~cpu2_RD_n & (cpu2_A[7:0] == (ay1_base | 8'h02));
wire cs2_ay2_addr = io_active & ~cpu2_WR_n & (cpu2_A[7:0] == ay2_base);
wire cs2_ay2_data = io_active & ~cpu2_WR_n & (cpu2_A[7:0] == (ay2_base | 8'h01));
wire cs2_coin_w   = io_active & ~cpu2_WR_n & (variant_sel != VAR_GYRO) &
                    ((cpu2_A[7:0] == coin_base) | (cpu2_A[7:0] == (coin_base | 8'h01)));

// Coin counter (bit 0 of data per MAME coin_counter_w)
reg [1:0] coin_counter_r = 2'd0;
always_ff @(posedge clk_49m) begin
    if (!reset) coin_counter_r <= 2'd0;
    else if (cen_cpu && cs2_coin_w) coin_counter_r[cpu2_A[0]] <= cpu2_Dout[0];
end
assign coin_counter = coin_counter_r;

//---------------------------------------------------------- ROMs -------------------------------------------------------------//

wire [7:0] main_rom_D;
eprom_32k main_rom (.CLK(clk_49m), .ADDR(cpu1_A[14:0]), .CLK_DL(clk_49m),
	.ADDR_DL(ioctl_addr), .DATA_IN(ioctl_data), .CS_DL(main_rom_cs_i), .WR(ioctl_wr), .DATA(main_rom_D));

wire [7:0] sub_rom_D;
// sub_rom is 32KB (eprom_32k): sister games (Repulse/Flashgal/SonOfPhoenix) have 32KB sub ROMs;
// eprom_16k truncated them. Gyrodine (8KB sub) uses only the low 8KB → unaffected.
eprom_32k sub_rom (.CLK(clk_49m), .ADDR(cpu2_A[14:0]), .CLK_DL(clk_49m),
	.ADDR_DL(ioctl_addr), .DATA_IN(ioctl_data), .CS_DL(sub_rom_cs_i), .WR(ioctl_wr), .DATA(sub_rom_D));

//------------------------------------------------------- VRAM (Kyugo map) ---------------------------------------------------//

// bgvideoram 8000-87FF (2KB)
wire [7:0] bgvram_D, bgvram_rD;
reg [10:0] bgvram_raddr;
dpram_dc #(.widthad_a(11)) bgvram (
	.clock_a(clk_49m), .address_a(cpu1_A[10:0]), .data_a(cpu1_Dout),
	.wren_a(cs_bgvram & ~cpu1_WR_n), .q_a(bgvram_D),
	.clock_b(clk_49m), .address_b(bgvram_raddr), .data_b(8'd0), .wren_b(1'b0), .q_b(bgvram_rD));

// bgattribram 8800-8FFF (2KB)
wire [7:0] bgattr_D, bgattr_rD;
reg [10:0] bgattr_raddr;
dpram_dc #(.widthad_a(11)) bgattr (
	.clock_a(clk_49m), .address_a(cpu1_A[10:0]), .data_a(cpu1_Dout),
	.wren_a(cs_bgattr & ~cpu1_WR_n), .q_a(bgattr_D),
	.clock_b(clk_49m), .address_b(bgattr_raddr), .data_b(8'd0), .wren_b(1'b0), .q_b(bgattr_rD));

// fgvideoram 9000-97FF (2KB)
wire [7:0] fgvram_D, fgvram_rD;
reg [10:0] fgvram_raddr;
dpram_dc #(.widthad_a(11)) fgvram (
	.clock_a(clk_49m), .address_a(cpu1_A[10:0]), .data_a(cpu1_Dout),
	.wren_a(cs_fgvram & ~cpu1_WR_n), .q_a(fgvram_D),
	.clock_b(clk_49m), .address_b(fgvram_raddr), .data_b(8'd0), .wren_b(1'b0), .q_b(fgvram_rD));

// spriteram[1] 9800-9FFF (2KB, lower nibble only on CPU reads)
wire [7:0] spram1_D, spram1_rD;
reg [10:0] spram1_raddr;
dpram_dc #(.widthad_a(11)) spram1 (
	.clock_a(clk_49m), .address_a(cpu1_A[10:0]), .data_a(cpu1_Dout),
	.wren_a(cs_spram1 & ~cpu1_WR_n), .q_a(spram1_D),
	.clock_b(clk_49m), .address_b(spram1_raddr), .data_b(8'd0), .wren_b(1'b0), .q_b(spram1_rD));

// spriteram[0] A000-A7FF (2KB)
wire [7:0] spram0_D, spram0_rD;
reg [10:0] spram0_raddr;
dpram_dc #(.widthad_a(11)) spram0 (
	.clock_a(clk_49m), .address_a(cpu1_A[10:0]), .data_a(cpu1_Dout),
	.wren_a(cs_spram0 & ~cpu1_WR_n), .q_a(spram0_D),
	.clock_b(clk_49m), .address_b(spram0_raddr), .data_b(8'd0), .wren_b(1'b0), .q_b(spram0_rD));

// Shared RAM (2KB, dual-port). Main side accessed at F000-F7FF (all variants) and also E000-E7FF on SRDMission.
wire [7:0] shared_ram_D_cpu1, shared_ram_D_cpu2;
wire       cs_shared_main = cs_shared | cs_shared_e;
dpram_dc #(.widthad_a(11)) shared_ram (
	.clock_a(clk_49m),
	// Hiscore is not wired into this port: it's the main<->sub handshake RAM, and mixing in a
	// hiscore write here risks corrupting that handshake. hs_write is also tied off at 1'b0 in
	// Arcade-Kyugo.sv; both together keep hiscore from ever touching this region.
	.address_a(cpu1_A[10:0]),
	.data_a(cpu1_Dout),
	.wren_a(cs_shared_main & ~cpu1_WR_n),
	.q_a(shared_ram_D_cpu1),
	.clock_b(clk_49m), .address_b(cpu2_A[10:0]), .data_b(cpu2_Dout),
	.wren_b(cs2_shared & ~cpu2_WR_n), .q_b(shared_ram_D_cpu2));

assign hs_data_out = shared_ram_D_cpu1;

// SRDMission sub-only RAM 0x8800-0x8FFF (2KB)
wire [7:0] subram_D;
spram #(.ADDR_WIDTH(11), .DATA_WIDTH(8)) sub_ram (
	.clk(clk_49m), .addr(cpu2_A[10:0]), .data(cpu2_Dout),
	.we(cs2_subram & ~cpu2_WR_n), .q(subram_D));

// CPU1 data bus mux — spram1 reads return value | 0xF0 (lower nibble only per MAME spriteram_2_r)
wire [7:0] cpu1_Din = cs_rom         ? main_rom_D             :
                      cs_bgvram      ? bgvram_D                :
                      cs_bgattr      ? bgattr_D                :
                      cs_fgvram      ? fgvram_D                :
                      cs_spram1      ? (spram1_D | 8'hF0)     :
                      cs_spram0      ? spram0_D                :
                      cs_shared_main ? shared_ram_D_cpu1       : 8'hFF;

wire [7:0] p1_inputs     = p1_controls;
wire [7:0] p2_inputs     = p2_controls;
wire [7:0] system_inputs = sys_controls;

//---------------------------------------------- Scroll + GFX control registers ------------------------------------------//

reg [7:0] scroll_x_lo = 8'd0;
reg       scroll_x_hi = 1'b0;
reg [7:0] scroll_y_r  = 8'd0;
reg       fgcolor     = 1'b0;
reg       bgpalbank   = 1'b0;

always_ff @(posedge clk_49m) begin
	if (!reset) begin
		scroll_x_lo <= 8'd0; scroll_x_hi <= 1'b0;
		scroll_y_r  <= 8'd0; fgcolor     <= 1'b0; bgpalbank <= 1'b0;
	end else if (cen_cpu) begin
		if (cs_scrollxlo) scroll_x_lo <= cpu1_Dout;
		if (cs_scrolly)   scroll_y_r  <= cpu1_Dout;
		if (cs_gfxctrl) begin
			scroll_x_hi <= cpu1_Dout[0];
			fgcolor     <= cpu1_Dout[5];
			bgpalbank   <= cpu1_Dout[6];
		end
	end
end

//--------------------------------------------------------- AY-3-8910 x2 ---------------------------------------------------//

// AY1: DSW1 → port A, DSW2 → port B
wire [7:0] ay1_dout;
wire [9:0] ay1_sound;
jt49_bus ay1 (
	.rst_n(reset), .clk(clk_49m), .clk_en(cen_ay),
	.bdir(cs2_ay1_addr | cs2_ay1_data), .bc1(cs2_ay1_addr | cs2_ay1_rd),
	.din(cpu2_Dout), .dout(ay1_dout), .sel(1'b1),
	.sound(ay1_sound), .sample(), .A(), .B(), .C(),
	.IOA_in(dip_sw[7:0]), .IOB_in(dip_sw[15:8]), .IOA_out(), .IOB_out()
);

// AY2: sound output only, no input ports
wire [7:0] ay2_dout;
wire [9:0] ay2_sound;
jt49_bus ay2 (
	.rst_n(reset), .clk(clk_49m), .clk_en(cen_ay),
	.bdir(cs2_ay2_addr | cs2_ay2_data), .bc1(cs2_ay2_addr),
	.din(cpu2_Dout), .dout(ay2_dout), .sel(1'b1),
	.sound(ay2_sound), .sample(), .A(), .B(), .C(),
	.IOA_in(8'hFF), .IOB_in(8'hFF), .IOA_out(), .IOB_out()
);

// Mix at 50% each to stay within signed 16-bit range
assign sound = $signed({1'b0, ay1_sound, 4'd0}) + $signed({1'b0, ay2_sound, 4'd0});

wire [7:0] cpu2_Din = (~cpu2_IORQ_n) ? (cs2_ay1_rd ? ay1_dout : 8'hFF) :
                      cs2_rom    ? sub_rom_D         :
                      cs2_shared ? shared_ram_D_cpu2 :
                      cs2_subram ? subram_D          :
                      cs2_p2     ? p2_inputs         :
                      cs2_p1     ? p1_inputs         :
                      cs2_system ? system_inputs     : 8'hFF;

//----------------------------------------------- Graphics ROMs -----------------------------------------------------------//

reg [11:0] fgtile_addr;
wire [7:0] fgtile_D;
eprom_4k fgtile_rom (.CLK(clk_49m), .ADDR(fgtile_addr), .CLK_DL(clk_49m),
	.ADDR_DL(ioctl_addr), .DATA_IN(ioctl_data), .CS_DL(fg_rom_cs_i), .WR(ioctl_wr), .DATA(fgtile_D));

reg [13:0] bg0_addr, bg1_addr, bg2_addr;
wire [7:0] bg0_D, bg1_D, bg2_D;
eprom_16k bg0_rom (.CLK(clk_49m), .ADDR(bg0_addr), .CLK_DL(clk_49m),
    .ADDR_DL(ioctl_addr - 25'h11000), .DATA_IN(ioctl_data), .CS_DL(bg0_rom_cs_i), .WR(ioctl_wr), .DATA(bg0_D));
eprom_16k bg1_rom (.CLK(clk_49m), .ADDR(bg1_addr), .CLK_DL(clk_49m),
    .ADDR_DL(ioctl_addr - 25'h15000), .DATA_IN(ioctl_data), .CS_DL(bg1_rom_cs_i), .WR(ioctl_wr), .DATA(bg1_D));
eprom_16k bg2_rom (.CLK(clk_49m), .ADDR(bg2_addr), .CLK_DL(clk_49m),
    .ADDR_DL(ioctl_addr - 25'h19000), .DATA_IN(ioctl_data), .CS_DL(bg2_rom_cs_i), .WR(ioctl_wr), .DATA(bg2_D));

reg [14:0] spr_addr;
wire [7:0] spr0_D, spr1_D, spr2_D;
eprom_32k spr0_rom (.CLK(clk_49m), .ADDR(spr_addr), .CLK_DL(clk_49m),
    .ADDR_DL(ioctl_addr - 25'h1D000), .DATA_IN(ioctl_data), .CS_DL(spr0_rom_cs_i), .WR(ioctl_wr), .DATA(spr0_D));
eprom_32k spr1_rom (.CLK(clk_49m), .ADDR(spr_addr), .CLK_DL(clk_49m),
    .ADDR_DL(ioctl_addr - 25'h25000), .DATA_IN(ioctl_data), .CS_DL(spr1_rom_cs_i), .WR(ioctl_wr), .DATA(spr1_D));
eprom_32k spr2_rom (.CLK(clk_49m), .ADDR(spr_addr), .CLK_DL(clk_49m),
    .ADDR_DL(ioctl_addr - 25'h2D000), .DATA_IN(ioctl_data), .CS_DL(spr2_rom_cs_i), .WR(ioctl_wr), .DATA(spr2_D));

wire [7:0] prom_addr;
reg  [4:0] prom_lut_addr;
wire [7:0] prom_r_D, prom_g_D, prom_b_D;
eprom_256b prom_r_rom (.CLK(clk_49m), .ADDR(prom_addr), .CLK_DL(clk_49m),
	.ADDR_DL(ioctl_addr), .DATA_IN(ioctl_data), .CS_DL(prom_r_cs_i), .WR(ioctl_wr), .DATA(prom_r_D));
eprom_256b prom_g_rom (.CLK(clk_49m), .ADDR(prom_addr), .CLK_DL(clk_49m),
	.ADDR_DL(ioctl_addr), .DATA_IN(ioctl_data), .CS_DL(prom_g_cs_i), .WR(ioctl_wr), .DATA(prom_g_D));
eprom_256b prom_b_rom (.CLK(clk_49m), .ADDR(prom_addr), .CLK_DL(clk_49m),
	.ADDR_DL(ioctl_addr), .DATA_IN(ioctl_data), .CS_DL(prom_b_cs_i), .WR(ioctl_wr), .DATA(prom_b_D));

wire [7:0] prom_lut_D;
eprom_32b prom_lut_rom (.CLK(clk_49m), .ADDR(prom_lut_addr), .CLK_DL(clk_49m),
	.ADDR_DL(ioctl_addr), .DATA_IN(ioctl_data), .CS_DL(prom_lut_cs_i), .WR(ioctl_wr), .DATA(prom_lut_D));

wire [7:0] prom_tim_D;
eprom_32b prom_tim_rom (.CLK(clk_49m), .ADDR(5'd0), .CLK_DL(clk_49m),
	.ADDR_DL(ioctl_addr), .DATA_IN(ioctl_data), .CS_DL(prom_tim_cs_i), .WR(ioctl_wr), .DATA(prom_tim_D));

//----------------------------------------------- BG render pipeline -------------------------------------------------//

// Screen coords (mirrored about the visible window when flip_screen is set).
// The visible window is v_cnt 16..239 (vblk = v_cnt<16 | v_cnt>=240, see hblk/vblk above), not
// 0-based the way the horizontal window is (hblk = base_h_cnt>=288, visible 0..287). Mirroring a
// window [lo,hi] about its own centre is (lo+hi)-x, so X is 287-base_h_cnt (0+287) but Y must be
// 255-v_cnt (16+239), not 239-v_cnt -- using 239 shifts the whole BG up by 16 lines (2 tile rows).
wire [8:0] bg_sx = flip_screen ? (9'd287 - base_h_cnt) : base_h_cnt;
wire [8:0] bg_sy = flip_screen ? (9'd255 - v_cnt)      : v_cnt;

// World coords (BG has set_scrolldx(-32) → +32 in world space when not flipped)
wire [8:0] scroll_x_full = {scroll_x_hi, scroll_x_lo};

// MAME negates BG scroll_x whenever the game requests flip (kyugo.cpp:409-412: set_scrollx(0,
// -(lo+hi*256)) if flip_screen() else positive; scroll_y is never negated, :414). flip_screen
// itself is forced off in the render (screen_rotate supplies the 180 degrees instead), but the
// scroll_x negation is a separate part of flip semantics that rotation cannot supply -- it changes
// which direction the scroll counter walks the tilemap, not just how the finished frame is
// mirrored. Gated on flip_req = mainlatch[1] (the game's own flip request), so the sets that never
// assert it render bit-identical; the subtraction wraps correctly mod 512 in the low 9 bits.
// World offset when not flipped is +32 (MAME set_scrolldx(-32, ...), kyugo.cpp:271; world offset =
// -dx). The flipped-mode dx from that same call is 288+32=320, so the flipped offset is -320 =
// +192 (mod 512), not +32 -- using +32 in both branches puts the fetch window a full screen width
// off, so BG only covers half the screen.
wire flip_req = mainlatch[1];   // game's own flip request; honoured via screen_rotate, not in-render
wire [9:0] bg_world_x_pre = flip_req ? ({1'b0, bg_sx} - {1'b0, scroll_x_full} + 10'd192)
                                     : ({1'b0, bg_sx} + {1'b0, scroll_x_full} + 10'd32);
wire [8:0] bg_world_x = bg_world_x_pre[8:0];   // wraps mod 512 (matches 64x8 = 512 BG width)
wire [8:0] bg_world_y = bg_sy + {1'b0, scroll_y_r};

wire [5:0] bg_col = bg_world_x[8:3];   // 0..63
wire [4:0] bg_row = bg_world_y[7:3];   // 0..31
wire [2:0] bg_fx  = bg_world_x[2:0];   // 0..7
wire [2:0] bg_fy  = bg_world_y[2:0];

// BG tile fetch pipeline runs one tile (8 pixels) behind what's displayed, driven by bg_fx during
// normal display. base_h_cnt's total period (396, kyugo.cpp:946 screen.set_raw(...,396,0,288,260,
// 16,240)) is not a multiple of 8, and v_cnt only increments on the same tick base_h_cnt wraps
// 395->0 -- too late for column 0 of the new row to be ready via the normal same-row fetch. This
// window re-primes the pipeline early, during the last part of hblank, so the first tile of the
// new row is ready by base_h_cnt==0.
//
// bg_row_lookahead spans base_h_cnt 384..395. Two fetches happen back-to-back, sequenced directly
// by base_h_cnt (not by bg_fx, which drifts against base_h_cnt with scroll and would otherwise make
// the window's effective timing scroll-phase-dependent):
//   384: address col_zero (bg_fetch_row/bg_fetch_col target the upcoming row)
//   385: latch code/color/flip bits from col_zero; drive plane ROM addresses
//   386: latch plane data into _nxt
//   387: promote _nxt -> _lat -- col_zero becomes the tile that will be displayed at base_h_cnt==0
//   388: address col_zero+1 (mod 64, correct for the 64-tile-wide BG map)
//   389: latch code/color/flip bits from col_zero+1; drive plane ROM addresses
//   390: latch plane data into _nxt -- left there for the line's first fx==7 to promote
//   391-395: idle -- must NOT promote here, or the freshly primed _nxt (col_zero+1) is clobbered
//            before the normal per-tile sequence gets to use it.
// This keeps the steady-state invariant (_lat = currently displayed tile, _nxt = next tile) true
// at base_h_cnt==0, for every scroll phase.
wire bg_row_lookahead = (base_h_cnt >= 9'd384);

wire [8:0] v_cnt_next      = (v_cnt == 9'd259) ? 9'd0 : (v_cnt + 9'd1);
// Same mirror constant as bg_sy (255, not 239) -- must track it exactly or the lookahead-fetched
// column 0 disagrees with the rest of the line once flipped.
wire [8:0] bg_sy_next      = flip_screen ? (9'd255 - v_cnt_next) : v_cnt_next;
wire [8:0] bg_world_y_next = bg_sy_next + {1'b0, scroll_y_r};
wire [4:0] bg_row_next     = bg_world_y_next[7:3];

wire [8:0] bg_sx_zero           = flip_screen ? 9'd287 : 9'd0;
// Must mirror bg_world_x_pre's scroll-sign logic exactly -- this is the lookahead's column-0
// fetch, and a mismatched scroll sign here would make column 0 disagree with the rest of the line.
wire [9:0] bg_world_x_zero_pre  = flip_req ? ({1'b0, bg_sx_zero} - {1'b0, scroll_x_full} + 10'd192)
                                           : ({1'b0, bg_sx_zero} + {1'b0, scroll_x_full} + 10'd32);
wire [8:0] bg_world_x_zero      = bg_world_x_zero_pre[8:0];
wire [5:0] bg_col_zero          = bg_world_x_zero[8:3];

wire [4:0] bg_fetch_row = bg_row_lookahead ? bg_row_next : bg_row;
wire [5:0] bg_fetch_col = bg_row_lookahead ? bg_col_zero : (bg_col + 6'd1);

// The coarse row/col above target the NEXT row during the lookahead window; the fine within-tile
// Y used to address GFX ROM plane data must follow the same override (bg_world_y_next, not the
// old bg_world_y), or the lookahead-fetched tile gets the correct row but the wrong scanline
// within it.
wire [2:0] bg_fetch_fy = bg_row_lookahead ? bg_world_y_next[2:0] : bg_fy;

// "next" = data being fetched for the upcoming 8-pixel tile
// "lat" = data for the currently-displaying 8-pixel tile
reg  [9:0] bg_code_nxt;
reg  [4:0] bg_color_nxt;
reg        bg_fx_invert_nxt;       // 1 = display bit 0 is leftmost (per-tile flipx XOR screen flip)
reg  [2:0] bg_fy_eff;              // fine_y after applying flipy + screen flip
reg  [7:0] bg_p0_nxt, bg_p1_nxt, bg_p2_nxt;

reg  [4:0] bg_color_lat;
reg        bg_fx_invert_lat;
reg  [7:0] bg_p0_lat, bg_p1_lat, bg_p2_lat;

// Pipeline timing on cen_pix ticks within the 8-pixel tile:
//   fx=0: drive bgvram_raddr / bgattr_raddr for NEXT tile (col + 1)
//   fx=1: bgvram_rD / bgattr_rD valid → latch code, color, flip bits, fy_eff; drive plane ROM addrs
//   fx=2: bg0_D / bg1_D / bg2_D valid → latch into _nxt
//   fx=7: promote _nxt → _lat (becomes the displayed tile starting next fx=0)
// During the row-wrap lookahead window (bg_row_lookahead), this sequence is driven directly by
// base_h_cnt instead of bg_fx -- bg_fx's timing within the window depends on scroll phase, while
// base_h_cnt gives the same fixed ticks every line regardless of scroll. Exactly one of the two
// paths (lookahead XOR normal) is active on any given tick.
always_ff @(posedge clk_49m) begin
    if (cen_pix) begin
        if (bg_row_lookahead) begin
            case (base_h_cnt)
                // Two fetches happen here, not one: the first (384-387) promotes col_zero straight
                // into _lat so it's ready to display at base_h_cnt==0; the second (388-390) primes
                // _nxt with col_zero+1 so the mid-line invariant (_lat = displayed tile, _nxt = next
                // tile) already holds by the time the line's first fx==7 promotes it. A single fetch
                // would leave _nxt also holding col_zero with no pending fetch for col_zero+1, so the
                // first fx==7 of the line (at base_h_cnt = 7-phi, phi = (scroll_x+32) mod 8, which
                // drifts with scroll) would re-promote the same stale tile.
                9'd384: begin
                    bgvram_raddr <= {bg_fetch_row, bg_fetch_col};
                    bgattr_raddr <= {bg_fetch_row, bg_fetch_col};
                end
                9'd385: begin
                    bg_code_nxt      <= {bgattr_rD[1:0], bgvram_rD};
                    bg_color_nxt     <= {bgpalbank, bgattr_rD[7:4]};
                    // flip_screen is intentionally NOT XORed into fx-invert/fine-Y here. Flip is
                    // implemented by mirroring the screen COORDINATE (bg_sx/bg_sy above), so when
                    // flipped, bg_world_x/y already count backwards as the raster advances -- which
                    // already reverses both tile order and the pixel/line order within each tile.
                    // XOR-ing flip_screen into these terms as well would mirror each tile a second
                    // time, cancelling that and reversing only the tile order. Per-tile attr flips
                    // (bit2=flipX, bit3=flipY, MAME get_bg_tile_info) still apply as normal.
                    bg_fx_invert_nxt <= bgattr_rD[2];
                    bg_fy_eff        <= bg_fetch_fy ^ {3{bgattr_rD[3]}};
                    bg0_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3]}})};
                    bg1_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3]}})};
                    bg2_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3]}})};
                end
                9'd386: begin
                    bg_p0_nxt <= bg0_D;
                    bg_p1_nxt <= bg1_D;
                    bg_p2_nxt <= bg2_D;
                end
                // promote fetch #1 (col_zero) into _lat — must happen BEFORE fetch #2 overwrites _nxt
                9'd387: begin
                    bg_color_lat     <= bg_color_nxt;
                    bg_fx_invert_lat <= bg_fx_invert_nxt;
                    bg_p0_lat        <= bg_p0_nxt;
                    bg_p1_lat        <= bg_p1_nxt;
                    bg_p2_lat        <= bg_p2_nxt;
                end
                // fetch #2 = col_zero+1, left in _nxt for the line's first fx==7 to promote.
                // +1 wraps mod 64, which is correct for the 64-tile-wide BG map.
                9'd388: begin
                    bgvram_raddr <= {bg_fetch_row, (bg_col_zero + 6'd1)};
                    bgattr_raddr <= {bg_fetch_row, (bg_col_zero + 6'd1)};
                end
                9'd389: begin
                    bg_code_nxt      <= {bgattr_rD[1:0], bgvram_rD};
                    bg_color_nxt     <= {bgpalbank, bgattr_rD[7:4]};
                    bg_fx_invert_nxt <= bgattr_rD[2];
                    bg_fy_eff        <= bg_fetch_fy ^ {3{bgattr_rD[3]}};
                    bg0_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3]}})};
                    bg1_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3]}})};
                    bg2_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3]}})};
                end
                9'd390: begin
                    bg_p0_nxt <= bg0_D;
                    bg_p1_nxt <= bg1_D;
                    bg_p2_nxt <= bg2_D;
                end
                default: ; // 391-395 idle: no promote here, _lat/_nxt must survive to base_h_cnt==0
            endcase
        end else begin
            case (bg_fx)
                3'd0: begin
                    bgvram_raddr <= {bg_fetch_row, bg_fetch_col};
                    bgattr_raddr <= {bg_fetch_row, bg_fetch_col};
                end
                3'd1: begin
                    bg_code_nxt      <= {bgattr_rD[1:0], bgvram_rD};
                    bg_color_nxt     <= {bgpalbank, bgattr_rD[7:4]};
                    // MAME get_bg_tile_info: TILE_FLIPYX((attr&0x0c)>>2) -> flipX = attr bit 2, flipY =
                    // attr bit 3. flip_screen is not XORed in here for the same reason as the lookahead
                    // fetch above: the screen-coordinate mirror (bg_sx/bg_sy) already reverses tile and
                    // pixel order for free.
                    bg_fx_invert_nxt <= bgattr_rD[2];                           // flipX = attr bit 2 (MAME)
                    bg_fy_eff        <= bg_fetch_fy ^ {3{bgattr_rD[3]}};        // flipY = attr bit 3 (MAME)
                    bg0_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3]}})};
                    bg1_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3]}})};
                    bg2_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3]}})};
                end
                3'd2: begin
                    bg_p0_nxt <= bg0_D;
                    bg_p1_nxt <= bg1_D;
                    bg_p2_nxt <= bg2_D;
                end
                3'd7: begin
                    bg_color_lat     <= bg_color_nxt;
                    bg_fx_invert_lat <= bg_fx_invert_nxt;
                    bg_p0_lat        <= bg_p0_nxt;
                    bg_p1_lat        <= bg_p1_nxt;
                    bg_p2_lat        <= bg_p2_nxt;
                end
                default: ; // idle
            endcase
        end
    end
end

// Display: select bit from latched plane bytes
// Default (no per-tile flipx, no screen flip): bit 7 = leftmost pixel → use ~bg_fx
// With flip: bit 0 = leftmost pixel → use bg_fx
wire [2:0] bg_pix_bit_idx = bg_fx_invert_lat ? bg_fx : ~bg_fx;
wire bg_p0_bit = bg_p0_lat[bg_pix_bit_idx];
wire bg_p1_bit = bg_p1_lat[bg_pix_bit_idx];
wire bg_p2_bit = bg_p2_lat[bg_pix_bit_idx];
// Pen = {plane0, plane1, plane2}: MAME planeoffset[0] (= first ROM third, bg0) is the MSB.
wire [2:0] bg_pix = {bg_p0_bit, bg_p1_bit, bg_p2_bit};

wire [7:0] bg_palette_index = {bg_color_lat[4:0], bg_pix[2:0]};

//----------------------------------------------- FG render pipeline -------------------------------------------------//

// FG uses same flipped screen→world mapping as BG; no FG scroll
wire [5:0] fg_col = bg_sx[8:3];
wire [4:0] fg_row = bg_sy[7:3];
wire [2:0] fg_fx  = bg_sx[2:0];
wire [2:0] fg_fy  = bg_sy[2:0];

// FG has its own independent fetch-ahead pipeline (below); fg_fx derives straight from bg_sx[2:0],
// and since FG has no scroll this tracks base_h_cnt directly, giving it the same row-wrap
// discontinuity as the BG pipeline above (see that section for the full mechanism). Reuses
// bg_row_lookahead/bg_sy_next/bg_sx_zero since FG's world coords ARE the screen coords (no scroll
// offset to add).
wire [4:0] fg_row_next = bg_sy_next[7:3];
wire [5:0] fg_col_zero = bg_sx_zero[8:3];

wire [4:0] fg_fetch_row = bg_row_lookahead ? fg_row_next : fg_row;
wire [5:0] fg_fetch_col = bg_row_lookahead ? fg_col_zero : (fg_col + 6'd1);

// Same fine-Y override as bg_fetch_fy above: fg_row/col are overridden for the lookahead window,
// and fg_fy (used below to address the FG tile ROM) must follow the same override or the
// lookahead-fetched tile gets the correct row but the wrong scanline within it.
wire [2:0] fg_fetch_fy = bg_row_lookahead ? bg_sy_next[2:0] : fg_fy;

reg  [7:0] fg_code_nxt;
reg  [5:0] fg_color_nxt;   // 6-bit colour code: MAME color = color_codes[4:0]<<1 | fgcolor
reg  [7:0] fg_byte_l_nxt, fg_byte_r_nxt;

reg  [5:0] fg_color_lat;
reg  [7:0] fg_byte_l_lat, fg_byte_r_lat;

// Pipeline timing on cen_pix ticks within the 8-pixel tile:
//   fx=0: drive fgvram_raddr for NEXT tile (col + 1)
//   fx=1: latch fg_code_nxt; drive prom_lut_addr from code[7:3]
//   fx=2: latch fg_color_nxt from prom_lut_D; drive fgtile_addr (left byte: y)
//   fx=3: latch fg_byte_l_nxt; drive fgtile_addr (right byte: y+8)
//   fx=4: latch fg_byte_r_nxt
//   fx=7: promote _nxt → _lat
always_ff @(posedge clk_49m) begin
    if (cen_pix) begin
        // Same reasoning as the BG pipeline above: during the lookahead window this is sequenced by
        // base_h_cnt directly (fixed ticks every line) instead of fg_fx, and promotes at the latest
        // possible tick (395) for maximum freshness.
        if (bg_row_lookahead) begin
            case (base_h_cnt)
                9'd389: fgvram_raddr <= {fg_fetch_row, fg_fetch_col};
                9'd390: begin
                    fg_code_nxt   <= fgvram_rD;
                    prom_lut_addr <= fgvram_rD[7:3];
                end
                9'd391: begin
                    fg_color_nxt <= {prom_lut_D[4:0], fgcolor};
                    fgtile_addr  <= {fg_code_nxt, 1'b0, fg_fetch_fy};
                end
                9'd392: begin
                    fg_byte_l_nxt <= fgtile_D;
                    fgtile_addr   <= {fg_code_nxt, 1'b1, fg_fetch_fy};
                end
                9'd393: fg_byte_r_nxt <= fgtile_D;
                9'd395: begin
                    fg_color_lat  <= fg_color_nxt;
                    fg_byte_l_lat <= fg_byte_l_nxt;
                    fg_byte_r_lat <= fg_byte_r_nxt;
                end
                default: ; // idle (388-389 unused)
            endcase
        end else begin
            case (fg_fx)
                3'd0: fgvram_raddr <= {fg_fetch_row, fg_fetch_col};
                3'd1: begin
                    fg_code_nxt   <= fgvram_rD;
                    prom_lut_addr <= fgvram_rD[7:3];
                end
                3'd2: begin
                    fg_color_nxt <= {prom_lut_D[4:0], fgcolor};   // full 5-bit colour code from the LUT + fgcolor bank bit
                    fgtile_addr  <= {fg_code_nxt, 1'b0, fg_fetch_fy};   // left chunk byte at offset y
                end
                3'd3: begin
                    fg_byte_l_nxt <= fgtile_D;
                    fgtile_addr   <= {fg_code_nxt, 1'b1, fg_fetch_fy};   // right chunk byte at offset y+8
                end
                3'd4: fg_byte_r_nxt <= fgtile_D;
                3'd7: begin
                    fg_color_lat  <= fg_color_nxt;
                    fg_byte_l_lat <= fg_byte_l_nxt;
                    fg_byte_r_lat <= fg_byte_r_nxt;
                end
                default: ;
            endcase
        end
    end
end

// FG bit decode: gfxlayout puts plane 0 at bits[0..3] of bit-stream, plane 1 at bits[4..7].
//   In MSB-first byte packing: plane 0 → byte[7..4], plane 1 → byte[3..0].
//   Pixel x[2]=0 selects byte_l (offset y); x[2]=1 selects byte_r (offset y+8).
wire [7:0] fg_byte_sel = fg_fx[2] ? fg_byte_r_lat : fg_byte_l_lat;
wire [1:0] fg_xic      = ~fg_fx[1:0];
wire fg_p0_bit = fg_byte_sel[{1'b1, fg_xic}];   // bit (4 + ~x_in_chunk) = (7 - x_in_chunk)
wire fg_p1_bit = fg_byte_sel[{1'b0, fg_xic}];   // bit (0 + ~x_in_chunk) = (3 - x_in_chunk)
// Pen = {plane0, plane1}: plane0 (fg_p0_bit, high nibble) is the MSB per MAME planeoffset[0].
wire [1:0] fg_pix = {fg_p0_bit, fg_p1_bit};

// FG palette index: ((color_codes[code>>3] << 1 | fgcolor) << 2) | pen
//   = {color_codes[3:0], fgcolor, pen[1:0]} (7 bits, padded to 8)
wire [7:0] fg_palette_index = {fg_color_lat[5:0], fg_pix[1:0]};   // {color_codes[4:0], fgcolor, pen[1:0]} per MAME

//----------------------------------------------- Sprite engine (Phase 7) -------------------------------------------//

// Shadow fgvram BRAM for sprite area3 reads (FG pipeline owns the main fgvram read port)
wire [7:0]  fgvram_spr_rD;
reg  [10:0] fgvram_spr_raddr;
dpram_dc #(.widthad_a(11)) fgvram_spr (
    .clock_a(clk_49m), .address_a(cpu1_A[10:0]), .data_a(cpu1_Dout),
    .wren_a(cs_fgvram & ~cpu1_WR_n), .q_a(),
    .clock_b(clk_49m), .address_b(fgvram_spr_raddr), .data_b(8'd0), .wren_b(1'b0), .q_b(fgvram_spr_rD));

// Sprite line buffer (double-buffered). Each entry: bit 8 = valid (opaque), bits [7:0] = palette index.
reg [8:0] spr_lb_a [0:511];
reg [8:0] spr_lb_b [0:511];
reg       write_buf;            // 0 → write A / read B; 1 → write B / read A
reg       eol_d;
always_ff @(posedge clk_49m) begin
    if (cen_pix) begin
        eol_d <= (base_h_cnt == 9'd395);
        if (eol_d) write_buf <= ~write_buf;
    end
end

reg       lb_we;
reg [8:0] lb_waddr;
reg [8:0] lb_wdata;
reg [8:0] spr_lb_a_rdata, spr_lb_b_rdata;
always_ff @(posedge clk_49m) begin
    spr_lb_a_rdata <= spr_lb_a[base_h_cnt];
    spr_lb_b_rdata <= spr_lb_b[base_h_cnt];
    if (lb_we && !write_buf) spr_lb_a[lb_waddr] <= lb_wdata;
    if (lb_we &&  write_buf) spr_lb_b[lb_waddr] <= lb_wdata;
end
wire [8:0] spr_lb_rdata = write_buf ? spr_lb_a_rdata : spr_lb_b_rdata;

// Sprite evaluator FSM (clocked by clk_49m; 24 slots × ~24 clk + 288 clr ≈ 864 clk per scanline,
// scanline = ~4224 clk_49m cycles → easily fits)
localparam [4:0] SS_IDLE = 5'd0,  SS_CLR  = 5'd1,  SS_FS0  = 5'd2,  SS_FS1  = 5'd3,
                 SS_FS2  = 5'd4,  SS_FR0  = 5'd5,  SS_FR1  = 5'd6,  SS_FRL  = 5'd7,
                 SS_FRR  = 5'd8,  SS_WPX  = 5'd9,  SS_NEXT = 5'd10,
                 // dpram_dc/eprom q_a outputs are UNREGISTERED (outdata_reg_a="UNREGISTERED"): one
                 // cycle of read latency, plus a second cycle from the FSM's own *_raddr register,
                 // so data for an address set in state N isn't valid until N+2. These *W states are
                 // the inserted one-cycle wait after each address-set state, one per fetch. (The BG
                 // pipeline uses the same primitive but is cen_pix-gated at 4 clk/state, so it never
                 // needed an explicit wait state.)
                 SS_FS0W = 5'd11, SS_FS1W = 5'd12, SS_FR0W = 5'd13, SS_FR1W = 5'd14,
                 SS_FRLW = 5'd15;

reg [4:0] spr_st;
reg [4:0] slot_n;
reg [8:0] clr_idx;
reg [3:0] px_idx;
reg [8:0] base_h_prev;

reg [7:0] sy_y_raw;
reg [7:0] x_lo_lat;
reg       x_hi_lat;
reg [4:0] color_lat;
reg [8:0] sy_full;
reg signed [10:0] sx_full;   // widened to 11 bits signed; see sx_calc below for why
reg [3:0] y_in_tile;
reg [9:0] code_lat;
reg       flipx_lat, flipy_lat;
reg [7:0] p0_l, p1_l, p2_l;
reg [7:0] p0_r, p1_r, p2_r;

// Slot offset: offs = 2*(n%12) + 64*(n/12), then base 0x28
wire        slot_div  = (slot_n >= 5'd12);
wire [3:0]  slot_mod  = slot_div ? (slot_n[3:0] - 4'd12) : slot_n[3:0];
wire [10:0] slot_offs = 11'h28 + {6'd0, slot_mod, 1'b0} + (slot_div ? 11'd64 : 11'd0);

// Eval Y: next scanline's screen Y. Visible v_cnt 16..239 → screen Y 0..223. Eval for v_cnt+1.
wire [8:0] eval_y9   = v_cnt - 9'd15;
wire [7:0] eval_y    = eval_y9[7:0];

// MAME sy/sx wrap (sy = (257 - y_raw); if > 240 then -256)
wire [8:0] sy_pre  = 9'd257 - {1'b0, sy_y_raw};
wire [8:0] sy_calc = (sy_pre > 9'd240) ? (sy_pre - 9'd256) : sy_pre;
wire [8:0] sx_pre  = {x_hi_lat, x_lo_lat};
// MAME computes this sx wrap in a wide int (kyugo.cpp:369-370: sx = (x>320) ? x-512 : x), so there's
// no bit-width ambiguity there. In a 9-bit field, two problems would compound: the literal 512
// doesn't fit in 9 bits (truncates to 0, making the subtraction a no-op), and separately, sx_pre in
// [256,320] sets bit 8 despite being on the "stay positive" side of the >320 threshold, which a
// downstream sign-extension from bit 8 would misread as negative. Computed in an 11-bit signed
// field instead so 256..320 stays positive and only 321..511 goes negative, matching MAME exactly.
wire signed [10:0] sx_calc = (sx_pre > 9'd320) ? ($signed({2'd0, sx_pre}) - 11'sd512)
                                                : $signed({2'd0, sx_pre});

// Row hit (in SS_FR0): diff = eval_y - sy_full (9-bit two's complement); hit if diff[8:8]=0 (positive)
// Sprite row-stacking direction: MAME draws cell row y at `sx, flip ? sy - 16*y : sy + 16*y`
// (kyugo.cpp:401) -- when flipped, the 16 cells of a sprite stack UPWARD from sy instead of
// downward. The unflipped form encodes this as diff = eval_y - sy (cell index = diff[7:4],
// line-within-cell = diff[3:0]); the flipped/mirrored form is diff_f = (sy+15) - eval_y, with
// line-within-cell becoming 15 - diff_f[3:0]:
//   eval_y = sy      -> diff_f = 15 -> cell 0, yint  0   (cell 0 top    = sy)     OK
//   eval_y = sy + 15 -> diff_f =  0 -> cell 0, yint 15   (cell 0 bottom = sy+15)  OK
//   eval_y = sy -  1 -> diff_f = 16 -> cell 1, yint 15   (cell 1 bottom = sy-1)   OK
//   eval_y = sy - 16 -> diff_f = 31 -> cell 1, yint  0   (cell 1 top    = sy-16)  OK
// This is the RAW line-within-cell; the per-sprite flipy mirror is applied downstream by
// y_eff_now/y_eff_lat, so there is no double-application.
// Deliberately kept at 9 bits: a true diff of 256..270 is out of range (a sprite is only 16 cells),
// and the natural 9-bit wrap makes it read negative -> miss, the same property the unflipped path
// already relies on. Widening to 10 bits would truncate cell index 16 to 0 and fake a hit.
wire [8:0] hit_diff_norm = {1'b0, eval_y} - sy_full;
wire [8:0] hit_diff_flip = (sy_full + 9'd15) - {1'b0, eval_y};
wire [8:0] hit_diff = flip_screen ? hit_diff_flip : hit_diff_norm;
wire       hit      = (hit_diff[8] == 1'b0);
wire [3:0] hit_row  = hit_diff[7:4];
wire [3:0] hit_yint = flip_screen ? (4'd15 - hit_diff[3:0]) : hit_diff[3:0];

// Sprite code/flip from BRAM in SS_FR1 (combinational from BRAM outputs)
wire [9:0] code_now  = {spram1_rD[0], spram1_rD[1], fgvram_spr_rD};
// Per-sprite flip attributes must invert when the game requests flip (MAME kyugo.cpp:391-395:
// if (flip) { flipx = !flipx; flipy = !flipy; }). Unlike the BG, which gets its mirror for free
// from the flipped screen coordinate, the sprite engine addresses gfx by sprite-relative x/y
// (px_idx / y_in_tile), so nothing mirrors a sprite cell unless asked explicitly.
// flipx is XORed with flip_req: the screen_x pre-mirror below (screen_x_signed) cancels the
// rotation's position mirror on this axis but not MAME's per-cell mirror, so flipx must supply
// that mirror itself. flipy needs no XOR: the rotation's Y mirror already supplies MAME's flipy
// inversion, sy mirror, and stacking reversal together. Gated on flip_req, so the sets that never
// assert it are bit-identical.
wire       flipx_now = spram1_rD[3] ^ flip_req;
wire       flipy_now = spram1_rD[2];
wire [3:0] y_eff_now = flipy_now ? (4'd15 - y_in_tile) : y_in_tile;
wire [3:0] y_eff_lat = flipy_lat ? (4'd15 - y_in_tile) : y_in_tile;

// Pixel decode in SS_WPX
wire [3:0] tile_x_eff = flipx_lat ? (4'd15 - px_idx) : px_idx;
wire [7:0] byte0      = tile_x_eff[3] ? p0_r : p0_l;
wire [7:0] byte1      = tile_x_eff[3] ? p1_r : p1_l;
wire [7:0] byte2      = tile_x_eff[3] ? p2_r : p2_l;
wire [2:0] bit_idx    = ~tile_x_eff[2:0];   // 7 - tile_x_eff[2:0]
wire       pix_p0     = byte0[bit_idx];
wire       pix_p1     = byte1[bit_idx];
wire       pix_p2     = byte2[bit_idx];
// Pen = {plane0, plane1, plane2}: MAME planeoffset[0] (= first ROM third, spr0) is the MSB.
wire [2:0] spr_pix    = {pix_p0, pix_p1, pix_p2};
wire [7:0] spr_pal_idx = {color_lat[4:0], spr_pix[2:0]};

wire signed [10:0] sx_signed    = sx_full;   // already the correctly signed/widened value from sx_calc
wire signed [10:0] screen_x_raw = sx_signed + $signed({7'd0, px_idx});
// MAME's sprite flip is asymmetric: it mirrors sy (240-sy), inverts flipx/flipy and reverses
// stacking, but passes sx through UNCHANGED (kyugo.cpp:401). screen_rotate mirrors both render
// axes, which is correct for BG (MAME's tilemap flip also does both) but over-mirrors sprites on
// X -- render X is the displayed vertical on the ROT90 sets. Pre-mirroring here cancels the
// rotation's X mirror, leaving sprites unmirrored in display space to match MAME; mirroring
// preserves the in-range test since out-of-range values stay out on both sides. Gated on
// flip_req, so the sets that never assert it are bit-identical. Cell-internal orientation and
// stacking direction need no separate correction: the rotation's both-axis mirror already
// matches MAME inverting both flipx and flipy, and the +16y stacking used here plus the rotation
// lands the same as MAME's -16y.
wire signed [10:0] screen_x_signed = flip_req ? (11'sd287 - screen_x_raw) : screen_x_raw;
wire               screen_x_in_range = (screen_x_signed >= 11'sd0) && (screen_x_signed < 11'sd288);

always_ff @(posedge clk_49m) begin
    if (!reset) begin
        spr_st      <= SS_IDLE;
        slot_n      <= 5'd0;
        clr_idx     <= 9'd0;
        lb_we       <= 1'b0;
        base_h_prev <= 9'd0;
    end else begin
        lb_we <= 1'b0;
        if (cen_pix) base_h_prev <= base_h_cnt;

        if (cen_pix && (base_h_cnt == 9'd0) && (base_h_prev != 9'd0)) begin
            spr_st  <= SS_CLR;
            slot_n  <= 5'd0;
            clr_idx <= 9'd0;
        end else begin
            case (spr_st)
                SS_IDLE: ;
                SS_CLR: begin
                    lb_we    <= 1'b1;
                    lb_waddr <= clr_idx;
                    lb_wdata <= 9'd0;
                    if (clr_idx == 9'd287) begin
                        clr_idx <= 9'd0;
                        spr_st  <= SS_FS0;
                    end else begin
                        clr_idx <= clr_idx + 9'd1;
                    end
                end
                SS_FS0: begin
                    spram0_raddr     <= slot_offs;          // area1[offs]   -> sy
                    fgvram_spr_raddr <= slot_offs + 11'd1;  // area3[offs+1] -> x_lo
                    spram1_raddr     <= slot_offs + 11'd1;  // area2[offs+1] -> x_hi
                    spr_st <= SS_FS0W;
                end
                SS_FS0W: spr_st <= SS_FS1;                  // wait: dpram read settles (1-cyc latency)
                SS_FS1: begin
                    sy_y_raw     <= spram0_rD;
                    x_lo_lat     <= fgvram_spr_rD;
                    x_hi_lat     <= spram1_rD[0];
                    spram0_raddr <= slot_offs + 11'd1;       // area1[offs+1] -> color
                    spr_st       <= SS_FS1W;
                end
                SS_FS1W: spr_st <= SS_FS2;                  // wait
                SS_FS2: begin
                    color_lat <= spram0_rD[4:0];
                    // Sprite Y mirror: MAME applies `if (flip) sy = 240 - sy;` AFTER the 257-raw wrap
                    // (kyugo.cpp:376-377), so it applies to sy_calc here, not to sy_y_raw. MAME does NOT
                    // mirror sprite X when flipped -- sx is passed through unchanged at kyugo.cpp:401 --
                    // so sx_full stays as-is; that asymmetry is intentional on the reference hardware,
                    // not a bug here.
                    //
                    // The flip_req branch (sy_calc - 16) is a MEASURED offset against a matched MAME
                    // reference frame, confirmed on hardware. The algebra from MAME's `240 - raw` predicts
                    // -17; the measured, HW-confirmed value is -16. The 1px gap is real and most likely
                    // lives in the sprite line-buffer's one-line pipeline or the exact mirror constant
                    // inside screen_rotate. The measured value is what's correct on this core -- do not
                    // "correct" it back to -17 from the algebra. Gated on flip_req: only the
                    // rotation-supplied-180 sets need it.
                    sy_full   <= flip_screen ? (9'd240 - sy_calc)
                                             : (flip_req ? (sy_calc - 9'd16) : sy_calc);
                    sx_full   <= sx_calc;
                    spr_st    <= SS_FR0;
                end
                SS_FR0: begin
                    if (hit) begin
                        y_in_tile        <= hit_yint;
                        fgvram_spr_raddr <= slot_offs + {hit_row, 7'd0};
                        spram1_raddr     <= slot_offs + {hit_row, 7'd0};
                        spr_st           <= SS_FR0W;
                    end else begin
                        spr_st <= SS_NEXT;
                    end
                end
                SS_FR0W: spr_st <= SS_FR1;                  // wait: code/attr fetch settles
                SS_FR1: begin
                    code_lat  <= code_now;
                    flipx_lat <= flipx_now;
                    flipy_lat <= flipy_now;
                    spr_addr  <= {code_now[9:0], y_eff_now[3], 1'b0, y_eff_now[2:0]};   // left half
                    spr_st    <= SS_FR1W;
                end
                SS_FR1W: spr_st <= SS_FRL;                  // wait: gfx ROM read settles
                SS_FRL: begin
                    p0_l <= spr0_D;
                    p1_l <= spr1_D;
                    p2_l <= spr2_D;
                    spr_addr <= {code_lat[9:0], y_eff_lat[3], 1'b1, y_eff_lat[2:0]};    // right half
                    spr_st <= SS_FRLW;
                end
                SS_FRLW: spr_st <= SS_FRR;                  // wait: gfx ROM read settles
                SS_FRR: begin
                    p0_r   <= spr0_D;
                    p1_r   <= spr1_D;
                    p2_r   <= spr2_D;
                    px_idx <= 4'd0;
                    spr_st <= SS_WPX;
                end
                SS_WPX: begin
                    if (screen_x_in_range && (spr_pix != 3'b000)) begin
                        lb_we    <= 1'b1;
                        lb_waddr <= screen_x_signed[8:0];
                        lb_wdata <= {1'b1, spr_pal_idx};
                    end
                    if (px_idx == 4'd15) begin
                        spr_st <= SS_NEXT;
                    end else begin
                        px_idx <= px_idx + 4'd1;
                    end
                end
                SS_NEXT: begin
                    if (slot_n == 5'd23) begin
                        spr_st <= SS_IDLE;
                    end else begin
                        slot_n <= slot_n + 5'd1;
                        spr_st <= SS_FS0;
                    end
                end
                default: spr_st <= SS_IDLE;
            endcase
        end
    end
end

//----------------------------------------------- Composite + palette PROM lookup ------------------------------------//

// Priority: FG > sprite > BG (FG/sprite pen 0 = transparent). Matches MAME screen_update, which
// draws BG → sprites → FG, so FG is always on top.
wire       spr_opaque         = spr_lb_rdata[8];
wire [7:0] spr_palette_index  = spr_lb_rdata[7:0];
wire       fg_opaque          = (fg_pix != 2'b00);

wire [7:0] composite_pal = fg_opaque  ? fg_palette_index  :
                           spr_opaque ? spr_palette_index :
                                        bg_palette_index;
// 1-clk_49m latency through palette PROMs. 4-bit channel → 5-bit by replicating MSB.
wire visible = ~hblk & ~vblk;

assign prom_addr = composite_pal;
assign red   = !visible ? 5'd0 : {prom_r_D[3:0], prom_r_D[3]};
assign green = !visible ? 5'd0 : {prom_g_D[3:0], prom_g_D[3]};
assign blue  = !visible ? 5'd0 : {prom_b_D[3:0], prom_b_D[3]};

endmodule
