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
// Restored 2026-05-16: a previous edit replaced this with a manual 5-bit counter using
// `cen_pix = (pix_div[4:2] == 3'd0)` — that's a 4-cycle-wide LEVEL, not a 1-cycle pulse,
// so every `if (cen_pix)` block fired 4× per intended pixel. jtframe_frac_cen produces
// the correct single-cycle pulse every 8 clk_49m cycles.
wire [1:0] pix_cen_o;
jtframe_frac_cen #(2) pix_cen (.clk(clk_49m), .n(10'd4), .m(10'd32), .cen(pix_cen_o), .cenb());
wire cen_pix = pix_cen_o[0];
assign ce_pix = cen_pix;

// cen_cpu = 3.072 MHz CPU clock-enable (free-running /16). NOTE 2026-05-29: a phase-lock
// experiment (cen_cpu = cen_pix & cpu_phase, to mimic real HW's single-xtal ÷6/÷3 alignment)
// was tried to fix the boot race but REGRESSED it (couldn't reach attract) — the real root
// cause was the NMI PULSE WIDTH (see the cpu1_nmi block), not the clock phase. Reverted to
// the original here; phase-lock version kept commented in case a residual phase issue surfaces.
reg [3:0] cpu_div = 4'd0;
always_ff @(posedge clk_49m) cpu_div <= cpu_div + 4'd1;
wire cen_cpu = (cpu_div == 4'd0);
// PHASE-LOCK (tried 2026-05-29, regressed — see note above; re-enable only if needed):
// reg  cpu_phase = 1'b0;
// always_ff @(posedge clk_49m) if (cen_pix) cpu_phase <= ~cpu_phase;
// wire cen_cpu = cen_pix & cpu_phase;

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

//wire [8:0] hs_start = 9'd300 + {5'd0, h_center};
//wire [8:0] hs_end   = hs_start + 9'd16;
//wire [8:0] vs_start = 9'd244 + {5'd0, v_center};
//wire [8:0] vs_end   = vs_start + 9'd4;
//assign video_hsync = (h_cnt_rot >= hs_start && h_cnt_rot < hs_end);
//assign video_vsync = (v_cnt_rot >= vs_start && v_cnt_rot < vs_end);
//assign video_csync = ~(video_hsync ^ video_vsync);

wire [8:0] hs_start = 9'd292 + {5'd0, h_center};  // Try moving earlier into blanking (was 300)
wire [8:0] hs_end   = hs_start + 9'd16;
wire [8:0] vs_start = 9'd242 + {5'd0, v_center};  // Slight adjustment
wire [8:0] vs_end   = vs_start + 9'd4;
assign video_hsync = (h_cnt_sync >= hs_start && h_cnt_sync < hs_end);
assign video_vsync = (v_cnt_sync >= vs_start && v_cnt_sync < vs_end);
assign video_csync = ~(video_hsync ^ video_vsync);

// *** HACK — REQUIRED FOR BOOT, DO NOT REMOVE (cold-boot SUB CHECK is UNSOLVED) ***
// combined CPU-subsystem reset = power reset OR a watchdog soft-reboot pulse (wdog_rst, from the
// watchdog block below). reset_cpu pulses both Z80s + the LS259 mainlatch + NMI/IRQ state, like a
// real board reset (RAM NOT cleared — the boot self-test re-inits it).
// WHY IT'S A HACK: on COLD power-up the sub never writes its F004 handshake token → the main waits
// on it forever (the real root cause, STILL UNFIXED). We MASK it by leaning on the (Gyrodine)
// watchdog: main stops kicking E000 → ~2s timeout → RAM-preserving reset → the retry passes, like
// a manual light reset. Proper fix = the sub-side cold-boot handshake. Until then this STAYS, or
// the game won't boot. KILL SWITCH (only to work the real root): wdog_arm = 1'b0 → reset_cpu == reset.
wire       wdog_rst;            // forward ref — assigned in the watchdog block below
wire       wdog_arm = 1'b1;     // 1 = HACK ARMED (masks the unsolved cold-boot SUB CHECK; required to boot).
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

// NMI: scanline 240, gated by nmi_mask.
// NMI WIDTH (real fix): the T80 samples NMI_n for a FALLING EDGE only on CEN
// ticks (OldNMI_n updates on CEN). A pulse narrower than one cen_cpu period can fall between
// two CEN samples and be MISSED (see HDL/"Z80 NMI is edge-triggered sampled on CEN", surfaced
// on Kangaroo). The OLD clear-on-M1 made the pulse phase-sensitively narrow — when v_cnt==240
// landed next to an opcode fetch, the vblank NMI was dropped → main's NMI-driven loop stalled
// → the boot/attract LOCK (pause/unpause re-phased the pulse wider → NMI taken → escaped).
// FIX: hold NMI for a FIXED ~16 cen_cpu ticks so the edge is always sampled. Edge-triggered,
// so the wide level is still exactly ONE NMI; ~16 CPU cycles releases long before next frame.
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
// NMI enable = the game's own mainlatch[0]. An earlier "NMI bootstrap" force-enabled NMI to break
// an apparent boot deadlock; that deadlock turned out to be the missed-NMI bug (narrow pulse dropped
// on CEN), now fixed in the cpu1_nmi block above — so the bootstrap was removed (it caused flaky
// startup once NMI was reliable). The v3 bootstrap is kept COMMENTED below as a restore path in case
// a real boot deadlock ever reappears.
reg ml0_seen = 1'b0;   // kept (unused now) for easy restore of the v3 bootstrap
always_ff @(posedge clk_49m) begin
	if (!reset_cpu)        ml0_seen <= 1'b0;
	else if (mainlatch[0]) ml0_seen <= 1'b1;
end
wire nmi_mask = mainlatch[0];   // REAL: the game controls its own vblank-NMI enable
// v3 bootstrap (removed — restore if boot deadlocks):
// wire nmi_mask = ml0_seen ? mainlatch[0] : (mainlatch[0] | mainlatch[2]);
// FLIP-SCREEN-FIX-2026-07-01: was hardcoded 1'b0 (stubbed during initial bring-up, never
// revisited). Verified via Gyrodine's own disassembly (Useful Information/gyrodine.dasm) —
// its reset vector ($7E85, confirmed as the real boot entry via the `jp $7E85` at $0005)
// unconditionally does `ld a,$01 / out ($01),a` at $7E92-7E94, setting mainlatch bit 1
// (flip_screen) to 1 as a hardcoded part of ITS OWN boot code — not DIP-driven (DIP
// Cabinet default is identical Upright across Gyrodine/Repulse/SRD Mission, checked and
// ruled out). Our RTL's LS259 mainlatch emulation (line ~195-198) already correctly
// implements the write_d0 semantics (address selects bit, data bit0 sets/clears) and this
// exact bit was already probed once before (`ml1_ever`, "proves LS259 writes land") — so
// mainlatch[1] itself is trustworthy, it just wasn't being read. MAME's own flip_screen()
// (kyugo.cpp) is a PURE reflection of this latch bit — no XOR with anything else, so the
// old commented-out `rot_flip ^ mainlatch[1]` reference was itself wrong (conflating
// MAME's per-game flip signal with our separate rotation-direction bit).
// NOT yet addressed by this fix (flag for follow-up, don't guess-fix in the same commit):
// (1) our BG code responds to flip_screen by mirroring the screen coordinate (base_h_cnt
//     -> 287-base_h_cnt); MAME instead negates the scroll register and leaves the
//     coordinate alone — these aren't the same transform, may need reconciling once this
//     is live and testable. (2) sprite draw has ZERO flip_screen handling at all (MAME
//     mirrors sprite Y, inverts per-sprite flipX/flipY, reverses row-stacking order when
//     flipped) — if sprites look wrong after this compile, that's why.
// ============================================================================================
// FLIP-PATH-BYPASS-2026-07-29 — READ THIS BEFORE "FIXING" flip_screen AGAIN.
//
// `flip_screen` is forced to 0 ON PURPOSE. Everything above this line about mainlatch[1] is
// factually correct — Gyrodine really does set it at $7E92, our LS259 decode really is right,
// MAME really does honour it. The conclusion drawn from those facts was still wrong.
//
// WHY IT IS FORCED OFF: a 180 degree flip and the screen rotation COMMUTE, so
//     render-unflipped + rotate CCW   ==   render-flipped + rotate CW
// Both give the identical, correct final image. The first uses the exact same render path as
// SRD Mission / Repulse / Flashgal — proven, five games stable on it. The second is the only
// path Gyrodine ever took, and it has NEVER produced a correct frame in any compile.
//
// EVIDENCE (HW, 2026-07-29): with mainlatch[1] honoured and the flip-path maths made fully
// self-consistent (FLIP-LAYERS-FIX-2026-07-29 (a)-(e), still present below and still believed
// correct), Gyrodine rendered a clean 180 degree rotation with MANGLED TEXT — broken glyph
// rows on every character — while SRD Mission, running byte-identical graphics code with
// flip_screen=0, was perfect. flip_screen is the ONLY difference between them in the whole
// video path, which localises the remaining corruption to the flip branches themselves.
//
// So: enter the proven path, and let the rotation stage absorb the 180 degrees. That means
// Gyrodine.mra must stay at rot_flip=0 (core_config bit 3 clear, index=1 part 00) => CCW.
// The two settings are a MATCHED PAIR. Changing one without the other puts Gyrodine 180 out.
//
// This restores the pre-2026-07-01 configuration, which is the last one known to render
// Gyrodine correctly. FLIP-SCREEN-FIX-2026-07-01 was therefore a regression: it was right
// about the hardware and wrong about what to do with it.
//
// The (a)-(e) flip-path fixes are deliberately LEFT IN, dormant. They only matter when
// flip_screen==1, which now never happens. Live cocktail flip (Flashgal toggles the bit at
// $1342/$1369) is the one case that would need them, and it needs the flip path debugged
// first — separate job, not required by any of the 8 games' normal operation.
//
// DIAG-REVERT-2026-07-29: original below
// wire flip_screen = mainlatch[1];
// ============================================================================================
wire flip_screen = 1'b0;
wire cpu2_rst    = ~mainlatch[2];

//------------------------------------------------------- Watchdog (Gyrodine) -------------------------------------------------//
// Watchdog (the cold-boot SUB-CHECK recovery hack — see wdog_arm above): MAME gyrodine() adds WATCHDOG_TIMER; map(0xe000).w =
// watchdog reset. A write to E000 kicks it; if the main CPU stops kicking for WDOG_TIMEOUT
// frames, the board soft-resets (assert wdog_rst -> reset_cpu pulses both Z80s + the LS259
// + NMI state, re-running boot). Gyrodine-only: other variants never increment so never
// trip. Frame-clocked on the vblk rising edge (once/frame).
//   TIMEOUT NOTE: the probe shows the main kicks E000 throughout boot (blue cell lit during
//   the self-tests), so there is NO multi-second no-kick gap to protect — the timeout only
//   needs to exceed the normal kick interval. 120 frames (~2 s) gives margin + fairly fast
//   auto-retry of the attract-transition lock. Lower toward ~60 for faster retries; raise
//   only if a legit long no-kick gap ever turns boot into a reset-loop.
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

T80pa cpu2
(
	.RESET_n(reset_cpu & ~cpu2_rst), .CLK(clk_49m),  // reset_cpu: +watchdog
	.CEN_p(cen_cpu & ~pause), .CEN_n(~cen_cpu & ~pause),
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
	// REMOVE-HISCORE-2026-06-12: hiscore was wired ONLY into this shared RAM (the main<->sub
	// handshake region). hs_write was already 1'b0, but strip the mux entirely so it can never
	// touch the handshake. Re-add later targeting the real hiscore RAM. Originals:
	// .address_a(hs_write ? hs_address[10:0] : cpu1_A[10:0]),
	// .data_a(hs_write ? hs_data_in : cpu1_Dout),
	// .wren_a((cs_shared_main & ~cpu1_WR_n) | hs_write),
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

// Screen coords (with flip)
// FLIP-LAYERS-FIX-2026-07-29 (a): the vertical mirror constant was wrong. The visible window is
// v_cnt 16..239 (`vblk = v_cnt<16 | v_cnt>=240`, Kyugo_CPU.sv:99) — it does NOT start at 0 the way
// the horizontal one does (`hblk = base_h_cnt>=288` ⇒ visible 0..287). Mirroring a window [lo,hi]
// about its own centre is `(lo+hi) - x`, so X is correctly `287 - base_h_cnt` (0+287) but Y must be
// `255 - v_cnt` (16+239), not `239 - v_cnt`. As written, enabling flip_screen ALSO shifted the whole
// BG up by exactly 16 lines = 2 tile rows. Unflipped path untouched (bit-identical).
// DIAG-REVERT-2026-07-29: originals below
// wire [8:0] bg_sx = flip_screen ? (9'd287 - base_h_cnt) : base_h_cnt;
// wire [8:0] bg_sy = flip_screen ? (9'd239 - v_cnt)      : v_cnt;
wire [8:0] bg_sx = flip_screen ? (9'd287 - base_h_cnt) : base_h_cnt;
wire [8:0] bg_sy = flip_screen ? (9'd255 - v_cnt)      : v_cnt;

// World coords (BG has set_scrolldx(-32) → +32 in world space when not flipped)
wire [8:0] scroll_x_full = {scroll_x_hi, scroll_x_lo};

// SCROLLX-NEGATE-FIX-2026-07-29: MAME negates BG scroll_x whenever the game requests flip
// (kyugo.cpp:409-412 — `set_scrollx(0, -(lo + hi*256))` if flip_screen(), positive otherwise);
// scroll_y is NOT negated (:414). FLIP-PATH-BYPASS forces the RENDER's flip_screen to 0 and lets
// screen_rotate supply the 180 degrees, which is right for the coordinate mirror — but it also
// dropped this scroll_x negation, which is a genuine part of flip semantics and NOT something the
// rotation can supply (rotation transforms the finished frame; it cannot change which direction a
// scroll counter walks the tilemap). Symptom: Gyrodine's land/sea scrolled smoothly but BACKWARDS
// (HW 2026-07-29) while SRD Mission was perfect — SRD never asserts the flip bit, so it never
// wanted the negation. Note Gyrodine is ROT90, so the scroll the player sees running vertically up
// the portrait screen is this RENDER-space scroll_x (render is 288x224 landscape pre-rotation).
// Gated on mainlatch[1] = the game's own flip request, so the 7 sets that never assert it are
// bit-identical. Modular arithmetic: the subtraction wraps correctly mod 512 in the low 9 bits.
// SCROLLDX-FLIP-FIX-2026-07-29: `set_scrolldx(-32, 288+32)` (kyugo.cpp:271) — 2nd arg is the
// FLIPPED-mode dx. World offset = -dx, so flipped needs -320 == +192 (mod 512), not +32. Being off
// by 288 (one screen width) put the window outside the tilemap region the game writes, so BG only
// covered part of the screen. HW 2026-07-29: scroll direction correct, BG started ~halfway.
wire flip_req = mainlatch[1];   // game asked for flip; honoured via screen_rotate, not in-render
wire [9:0] bg_world_x_pre = flip_req ? ({1'b0, bg_sx} - {1'b0, scroll_x_full} + 10'd192)
                                     : ({1'b0, bg_sx} + {1'b0, scroll_x_full} + 10'd32);
wire [8:0] bg_world_x = bg_world_x_pre[8:0];   // wraps mod 512 (matches 64x8 = 512 BG width)
wire [8:0] bg_world_y = bg_sy + {1'b0, scroll_y_r};

wire [5:0] bg_col = bg_world_x[8:3];   // 0..63
wire [4:0] bg_row = bg_world_y[7:3];   // 0..31
wire [2:0] bg_fx  = bg_world_x[2:0];   // 0..7
wire [2:0] bg_fy  = bg_world_y[2:0];

// BG-ROWWRAP-LOOKAHEAD-FIX-2026-07-01: base_h_cnt's total period (396) is the
// MAME-verified real hardware value (Useful Information/kyugo.cpp:946 —
// screen.set_raw(18.432_MHz_XTAL/3, 396, 0, 288, 260, 16, 240)) and is NOT a multiple
// of 8. That's fine for HSYNC (matches real hardware) but the BG fetch-ahead pipeline
// below needs one full 8-tick window to fetch+latch+promote a tile before it's
// displayed — and v_cnt (the row) only increments at the SAME tick base_h_cnt wraps
// 395->0, too late for column 0 of the new row to be ready in time. Real hardware must
// anticipate the row change a bit early; we do the same: during the LAST 8 ticks of
// blanking, override the fetch target to "column 0 of the UPCOMING row" (v_cnt_next)
// instead of the normal same-row off-screen lookahead column. bg_fx is glitch-free
// through this whole window (the only discontinuity is the single 395->0 tick, which
// falls right at this window's end), so the fx==0/1/2/7 sequence still fires cleanly
// once each inside it — promote (fx==7) always lands in time for base_h_cnt==0.
// Symptom this fixes: stale/wrong-stage BG tile data at one screen edge every line —
// vertical band on Flashgal (no_rotate), horizontal band on Gyrodine (rotated) — same
// root cause, axis differs only because screen_rotate is a downstream, content-agnostic
// transform. Does NOT address the separate missing-HUD-icon symptom at the same
// x-position (sprite/line-buffer swap logic resets at the same base_h_cnt==0 boundary,
// Kyugo_CPU.sv:707-818, but via a different mechanism — untouched here).
// DETERMINISTIC-LOOKAHEAD-FIX-2026-07-01 (v3, replaces WINDOW-SHIFT-FIX/WINDOW-WIDEN-FIX):
// both prior attempts tried to find the right scroll-phase-relative WINDOW for a fetch
// still sequenced by bg_fx (which drifts against base_h_cnt depending on scroll) — shift
// made it worse, widen was better but incomplete. The actual fix: stop sequencing the
// lookahead fetch by bg_fx at all. It's now driven directly by base_h_cnt (see the
// `case (base_h_cnt)` blocks below, BG and FG), deterministic regardless of scroll, pinned
// to promote at the latest possible tick (395). TIGHTEN-LOOKAHEAD-FIX then BISECT-LOOKAHEAD-
// FIX-2026-07-01: fully-compressed (zero idle) tested worse than the original padded version
// — not monotonic, there's a sweet spot, not an extreme. Currently bisecting: BG starts at
// 390 (2-tick idle before promote), FG starts at 389 (1-tick idle). This range covers FG's
// (earlier) start; BG's case statement simply idles (`default`) on 389.
wire bg_row_lookahead = (base_h_cnt >= 9'd389);   // covers both sequences (FG starts earliest, at 389)

wire [8:0] v_cnt_next      = (v_cnt == 9'd259) ? 9'd0 : (v_cnt + 9'd1);
// FLIP-LAYERS-FIX-2026-07-29 (a, cont): same 16-line mirror-constant fix as bg_sy above. Must track
// bg_sy exactly or the lookahead-fetched column 0 disagrees with the rest of the line when flipped.
// DIAG-REVERT-2026-07-29: original below
// wire [8:0] bg_sy_next      = flip_screen ? (9'd239 - v_cnt_next) : v_cnt_next;
wire [8:0] bg_sy_next      = flip_screen ? (9'd255 - v_cnt_next) : v_cnt_next;
wire [8:0] bg_world_y_next = bg_sy_next + {1'b0, scroll_y_r};
wire [4:0] bg_row_next     = bg_world_y_next[7:3];

wire [8:0] bg_sx_zero           = flip_screen ? 9'd287 : 9'd0;
// SCROLLX-NEGATE-FIX-2026-07-29 (cont): must mirror bg_world_x_pre exactly — this is the lookahead's
// column-0 fetch, and if its scroll sign differs from the main path, column 0 disagrees with the rest
// of the line. DIAG-REVERT-2026-07-29: original was the unconditional `+ scroll_x_full` form.
wire [9:0] bg_world_x_zero_pre  = flip_req ? ({1'b0, bg_sx_zero} - {1'b0, scroll_x_full} + 10'd192)
                                           : ({1'b0, bg_sx_zero} + {1'b0, scroll_x_full} + 10'd32);
wire [8:0] bg_world_x_zero      = bg_world_x_zero_pre[8:0];
wire [5:0] bg_col_zero          = bg_world_x_zero[8:3];

wire [4:0] bg_fetch_row = bg_row_lookahead ? bg_row_next : bg_row;
wire [5:0] bg_fetch_col = bg_row_lookahead ? bg_col_zero : (bg_col + 6'd1);

// FINE-Y-LOOKAHEAD-FIX-2026-07-01: the coarse row/col above were correctly overridden to
// target the NEXT row during the lookahead window, but the FINE within-tile Y (bg_fy) used
// below to address the actual GFX ROM plane data was NOT — it stayed on bg_world_y (built
// from the OLD, not-yet-incremented v_cnt) throughout. Since fine-Y usually just increments
// by 1 across a row boundary, this fetched the tile's CORRECT row-of-tiles but the WRONG
// scanline-within-that-tile (one row stale) for the one tile this window covers — exactly
// the reported symptom: a single 8px-wide column (the lookahead-fetched tile), off by
// exactly one pixel row, everything else on screen unaffected.
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
// DETERMINISTIC-LOOKAHEAD-FIX-2026-07-01: user tried the window-shift fix and reported it
// got WORSE (leftmost columns "changing faster" during scroll) — the opposite of the
// window-widen attempt, which was better but still ~1 frame stale. Direction of the effect
// says fetching EARLIER (more safety margin before the wrap) makes staleness worse, and
// fetching LATER (closer to the actual display moment) makes it better — i.e. freshness,
// not spillover-safety margin, is what actually matters here. So: stop routing the
// lookahead through bg_fx (whose timing within the window depends on scroll phase, which
// is exactly the "sometimes early, sometimes late" behavior that caused the inconsistent
// results) and instead drive it from base_h_cnt DIRECTLY — deterministic, always the same
// ticks every line regardless of scroll, and pinned to complete (promote) at the LATEST
// possible tick, 395, one cycle before the wrap. This also fully replaces the old
// window-shift/widen mechanism; only one fetch path is active at a time (lookahead XOR
// normal), so there's no ambiguity or redundant-cycle risk to reason about anymore.
always_ff @(posedge clk_49m) begin
    if (cen_pix) begin
        if (bg_row_lookahead) begin
            // BISECT-LOOKAHEAD-FIX-2026-07-01: two data points now — 388/389/390/(4-tick idle)/395
            // was "really really close" (best so far); 392/393/394/395 (0-tick idle, fully
            // compressed) was "too far, worse". Not monotonic — there's a sweet spot somewhere
            // between "some padding" and "none", not at either extreme. Splitting the
            // difference: 390/391/392/(2-tick idle)/395, to bracket it further before assuming
            // either endpoint is optimal.
            case (base_h_cnt)
                9'd390: begin
                    bgvram_raddr <= {bg_fetch_row, bg_fetch_col};
                    bgattr_raddr <= {bg_fetch_row, bg_fetch_col};
                end
                9'd391: begin
                    bg_code_nxt      <= {bgattr_rD[1:0], bgvram_rD};
                    bg_color_nxt     <= {bgpalbank, bgattr_rD[7:4]};
                    // FLIP-LAYERS-FIX-2026-07-29 (b): the `^ flip_screen` terms here were a DOUBLE flip
                    // that cancelled the screen mirror. We implement flip by mirroring the screen
                    // COORDINATE (bg_sx/bg_sy above), so when flipped bg_world_x/y COUNT BACKWARDS as
                    // the raster advances — which already reverses both the tile ORDER and the
                    // pixel/line order WITHIN each tile, for free. XOR-ing flip_screen into the
                    // fx-invert and fine-Y terms mirrored each tile a SECOND time, un-mirroring it:
                    // net result was reversed tile order with individually un-reversed tiles (and the
                    // matching line-order error vertically). Per-tile attr flips (bit2=flipX,
                    // bit3=flipY, MAME get_bg_tile_info) still apply — only the screen-flip XOR goes.
                    // Unflipped path bit-identical (x ^ 0 == x).
                    // DIAG-REVERT-2026-07-29: originals below
                    // bg_fx_invert_nxt <= bgattr_rD[2] ^ flip_screen;
                    // bg_fy_eff        <= bg_fetch_fy ^ {3{bgattr_rD[3] ^ flip_screen}};
                    // bg0_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3] ^ flip_screen}})};
                    // bg1_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3] ^ flip_screen}})};
                    // bg2_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3] ^ flip_screen}})};
                    bg_fx_invert_nxt <= bgattr_rD[2];
                    bg_fy_eff        <= bg_fetch_fy ^ {3{bgattr_rD[3]}};
                    bg0_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3]}})};
                    bg1_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3]}})};
                    bg2_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3]}})};
                end
                9'd392: begin
                    bg_p0_nxt <= bg0_D;
                    bg_p1_nxt <= bg1_D;
                    bg_p2_nxt <= bg2_D;
                end
                9'd395: begin
                    bg_color_lat     <= bg_color_nxt;
                    bg_fx_invert_lat <= bg_fx_invert_nxt;
                    bg_p0_lat        <= bg_p0_nxt;
                    bg_p1_lat        <= bg_p1_nxt;
                    bg_p2_lat        <= bg_p2_nxt;
                end
                default: ; // idle (388-391): no longer used, freed up by tightening
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
                    // BG-FLIP-SWAP-FIX-2026-06-12: MAME get_bg_tile_info uses TILE_FLIPYX((attr&0x0c)>>2) ⇒
                    // flipX = attr BIT 2, flipY = attr BIT 3. We had them swapped (bit3/bit2 = the SPRITE
                    // convention), mirroring BG tiles on the wrong axis. (FG has no per-tile flip — correct.)
                    // FLIP-LAYERS-FIX-2026-07-29 (b, cont): same double-flip removal as the lookahead
                    // block above — see that comment for the full reasoning. Must match it exactly.
                    // DIAG-REVERT-2026-07-29: originals below
                    // bg_fx_invert_nxt <= bgattr_rD[2] ^ flip_screen;            // flipX = attr bit 2 (MAME)
                    // bg_fy_eff        <= bg_fetch_fy ^ {3{bgattr_rD[3] ^ flip_screen}}; // flipY = attr bit 3 (MAME)
                    // bg0_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3] ^ flip_screen}})};
                    // bg1_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3] ^ flip_screen}})};
                    // bg2_addr <= {1'b0, {bgattr_rD[1:0], bgvram_rD}, (bg_fetch_fy ^ {3{bgattr_rD[3] ^ flip_screen}})};
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

// FG-ROWWRAP-LOOKAHEAD-FIX-2026-07-01: FG has its OWN independent fetch-ahead pipeline
// (below) and derives fg_fx straight from bg_sx[2:0] — since FG has no scroll, this tracks
// base_h_cnt even more directly than BG's did, so it has the exact same row-wrap
// discontinuity as BG-ROWWRAP-LOOKAHEAD-FIX-2026-07-01 above (see that comment for the
// full mechanism). Reuses bg_row_lookahead/bg_sy_next/bg_sx_zero since FG's world coords
// ARE the screen coords (no scroll offset to add).
wire [4:0] fg_row_next = bg_sy_next[7:3];
wire [5:0] fg_col_zero = bg_sx_zero[8:3];

wire [4:0] fg_fetch_row = bg_row_lookahead ? fg_row_next : fg_row;
wire [5:0] fg_fetch_col = bg_row_lookahead ? fg_col_zero : (fg_col + 6'd1);

// FINE-Y-LOOKAHEAD-FIX-2026-07-01: same class of bug as BG's bg_fetch_fy above — fg_row/col
// were overridden for the lookahead window but fg_fy (used below to address the FG tile ROM)
// was not, fetching the right tile but the wrong scanline within it (one row stale) for the
// lookahead-fetched tile specifically.
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
        // DETERMINISTIC-LOOKAHEAD-FIX-2026-07-01: same reasoning as the BG pipeline above —
        // sequencing this by base_h_cnt directly (fixed ticks, every line) instead of fg_fx
        // (scroll-phase-dependent timing) during the lookahead window, promoting at the
        // latest possible tick (395) for maximum freshness.
        if (bg_row_lookahead) begin
            // BISECT-LOOKAHEAD-FIX-2026-07-01: BG's 4-tick-idle version tested best so far, 0-tick
            // tested worse — splitting the difference. FG bracketed proportionally: was
            // 388/389/390/391/392/(2-tick idle)/395 (best-so-far analog), tightened attempt was
            // 390/391/392/393/394/395 (0-tick, analog of "too far"); middle here is a 1-tick gap:
            // 389/390/391/392/393/(1-tick idle)/395.
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
                default: ; // idle (388-389): no longer used, freed up by tightening
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
                 // SPR-READ-LATENCY-FIX-2026-06-13: dpram_dc/eprom q_a are UNREGISTERED
                 // (outdata_reg_a="UNREGISTERED") → 1-cycle read latency, and the FSM's own
                 // *_raddr register adds a second, so data for an address set in state N is
                 // not valid until N+2. The FSM read at N+1 → every slot/gfx fetch sampled
                 // one cycle early → garbage Y/code → sprites off-screen/missing. The BG FSM
                 // uses the same primitive but is cen_pix-gated (4 clk/state) so never saw it.
                 // These *W states are the inserted wait cycles (one per address-set).
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
reg signed [10:0] sx_full;   // SPR-X-WRAP-SIGNEXT-FIX-2026-07-01: was [8:0], see sx_calc below
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
// SPR-X-WRAP-SIGNEXT-FIX-2026-07-01: was `wire [8:0] sx_calc = (sx_pre>320)?(sx_pre-9'd512):sx_pre`.
// Two compounding problems in a 9-bit field: (1) the literal 9'd512 doesn't fit in 9 bits and
// truncates to 0, making the subtraction a no-op; (2) even setting that aside, the downstream
// sign-extension ({{2{sx_full[8]}}, sx_full}) treats bit8==1 as "negative" — but sx_pre in
// [256,320] also has bit8 set despite being on the "stay positive" side of the >320 threshold
// (MAME kyugo.cpp:369-370 does this subtraction in a wide int, where no such bit-8 ambiguity
// exists). Result: any sprite with raw X in [256,320] sign-extends to a large negative value
// (e.g. 300 -> -212) and fails the on-screen check for its ENTIRE width — a hard, consistent
// vanish at X=256, well short of the real 288px edge, exactly the reported symptom. Fix: do
// the subtraction in a properly wide (11-bit) signed field so 256..320 stays correctly
// positive and only 321..511 goes negative.
wire signed [10:0] sx_calc = (sx_pre > 9'd320) ? ($signed({2'd0, sx_pre}) - 11'sd512)
                                                : $signed({2'd0, sx_pre});

// Row hit (in SS_FR0): diff = eval_y - sy_full (9-bit two's complement); hit if diff[8:8]=0 (positive)
// FLIP-LAYERS-FIX-2026-07-29 (c): sprite row-STACKING direction was missing. MAME draws cell row y at
// `sx, flip ? sy - 16*y : sy + 16*y` (kyugo.cpp:401) — when flipped, the 16 cells of a sprite stack
// UPWARD from sy instead of downward. Our per-scanline evaluator encodes stacking as
// diff = eval_y - sy (cell index = diff[7:4], line-within-cell = diff[3:0]), so the mirrored form is
// diff_f = (sy + 15) - eval_y, with line-within-cell becoming 15 - diff_f[3:0]:
//   eval_y = sy      -> diff_f = 15 -> cell 0, yint  0   (cell 0 top    = sy)     OK
//   eval_y = sy + 15 -> diff_f =  0 -> cell 0, yint 15   (cell 0 bottom = sy+15)  OK
//   eval_y = sy -  1 -> diff_f = 16 -> cell 1, yint 15   (cell 1 bottom = sy-1)   OK
//   eval_y = sy - 16 -> diff_f = 31 -> cell 1, yint  0   (cell 1 top    = sy-16)  OK
// This is the RAW line-within-cell; the per-sprite flipy mirror is applied downstream by
// y_eff_now/y_eff_lat, so there is no double-application.
// Deliberately kept at 9 bits: a true diff of 256..270 is out of range (a sprite is only 16 cells)
// and the natural 9-bit wrap makes it read negative -> miss, the same property the unflipped path
// already relies on. Widening to 10 bits would truncate cell index 16 to 0 and fake a hit.
// DIAG-REVERT-2026-07-29: originals below
// wire [8:0] hit_diff = {1'b0, eval_y} - sy_full;
// wire       hit      = (hit_diff[8] == 1'b0);
// wire [3:0] hit_row  = hit_diff[7:4];
// wire [3:0] hit_yint = hit_diff[3:0];
wire [8:0] hit_diff_norm = {1'b0, eval_y} - sy_full;
wire [8:0] hit_diff_flip = (sy_full + 9'd15) - {1'b0, eval_y};
wire [8:0] hit_diff = flip_screen ? hit_diff_flip : hit_diff_norm;
wire       hit      = (hit_diff[8] == 1'b0);
wire [3:0] hit_row  = hit_diff[7:4];
wire [3:0] hit_yint = flip_screen ? (4'd15 - hit_diff[3:0]) : hit_diff[3:0];

// Sprite code/flip from BRAM in SS_FR1 (combinational from BRAM outputs)
wire [9:0] code_now  = {spram1_rD[0], spram1_rD[1], fgvram_spr_rD};
// FLIP-LAYERS-FIX-2026-07-29 (d): per-sprite flip attributes must INVERT when the screen is flipped
// (MAME kyugo.cpp:391-395 `if (flip) { flipx = !flipx; flipy = !flipy; }`). Unlike the BG — which
// gets its mirror for free from the flipped screen coordinate — the sprite engine addresses gfx by
// sprite-relative x/y (px_idx / y_in_tile), so nothing mirrors a sprite cell unless we ask.
// Unflipped path bit-identical (x ^ 0 == x).
// DIAG-REVERT-2026-07-29: originals below
// wire       flipx_now = spram1_rD[3];
// wire       flipy_now = spram1_rD[2];
wire       flipx_now = spram1_rD[3] ^ flip_screen;
wire       flipy_now = spram1_rD[2] ^ flip_screen;
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

// SPR-X-WRAP-SIGNEXT-FIX-2026-07-01: sx_full is already correctly signed+wide (see sx_calc
// above) — no re-extension needed here, was the bug (re-deriving sign from bit8 of a
// too-narrow field).
wire signed [10:0] sx_signed    = sx_full;
wire signed [10:0] screen_x_raw = sx_signed + $signed({7'd0, px_idx});
// SPR-X-UNMIRROR-FIX-2026-07-29: MAME's sprite flip is ASYMMETRIC — it mirrors sy (240-sy),
// inverts flipx/flipy and reverses stacking, but passes sx through UNCHANGED (kyugo.cpp:401).
// screen_rotate mirrors BOTH render axes, which is correct for BG (MAME's tilemap flip also does
// both) but over-mirrors sprites on X. Render X is the displayed VERTICAL on ROT90, so the symptom
// was inverted sprite height: helicopter at the top instead of the bottom, enemies entering from
// the bottom instead of the top (HW 2026-07-29). Pre-mirroring here cancels the rotation's X
// mirror, leaving sprites unmirrored in display space, matching MAME. Mirroring preserves the
// in-range test (out-of-range values stay out on both sides). Gated on flip_req ⇒ other 7 sets
// bit-identical. Cell-internal orientation and stacking direction need no change: the rotation's
// both-axis mirror already matches MAME inverting both flipx and flipy, and our +16y stacking
// plus the rotation lands the same as MAME's -16y.
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
                    // FLIP-LAYERS-FIX-2026-07-29 (e): sprite Y mirror. MAME applies `if (flip) sy = 240 - sy;`
                    // AFTER the 257-raw wrap (kyugo.cpp:376-377), so it goes here, on sy_calc, not on
                    // sy_y_raw. NOTE: MAME does NOT mirror sprite X when flipped — sx is passed through
                    // unchanged at kyugo.cpp:401 — so sx_full stays as-is. That asymmetry looks odd but it
                    // is what the reference does; replicating it exactly, revisit only if HW disagrees.
                    // DIAG-REVERT-2026-07-29: original below
                    // sy_full   <= sy_calc;
                    sy_full   <= flip_screen ? (9'd240 - sy_calc) : sy_calc;
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

// Priority: sprite > FG > BG (sprite/FG pen 0 = transparent)
wire       spr_opaque         = spr_lb_rdata[8];
wire [7:0] spr_palette_index  = spr_lb_rdata[7:0];
wire       fg_opaque          = (fg_pix != 2'b00);

// RENDER-LAYER-FIX-2026-06-12: MAME screen_update draws BG → sprites → FG, so FG is ON TOP of sprites.
// We had sprite>FG>BG (sprites covered the text). Match MAME: FG > sprite > BG.
wire [7:0] composite_pal = fg_opaque  ? fg_palette_index  :
                           spr_opaque ? spr_palette_index :
                                        bg_palette_index;
// 1-clk_49m latency through palette PROMs. 4-bit channel → 5-bit by replicating MSB.
wire visible = ~hblk & ~vblk;

//========================================================================
// DIAG-REVERT-2026-05-29: video-state diagnostic overlay   >>> DIAGNOSTIC >>>
// Display path is confirmed good (force-color test), so we use it as a scope.
// One screenshot tells us which render stage is dead. Regions, top of image:
//
//   v_cnt 16..47 : 8 STATUS CELLS, 32px each (base_h_cnt 0..255). Each cell is
//                  its DISTINCT colour when its sticky condition is TRUE, else
//                  BLACK (no greys):
//     cell0 GREEN   cpu_alive    — Z80 address bus is changing (executing)
//     cell1 CYAN    cpu_m1_ever  — Z80 fetched at least one opcode
//     cell2 BLUE    nmi_ever     — the vblank NMI has fired
//     cell3 RED     bg_wr_ever   — CPU has written bgvram
//     cell4 YELLOW  fg_wr_ever   — CPU has written fgvram
//     cell5 MAGENTA spr_wr_ever  — CPU has written sprite RAM
//     cell6 ORANGE  nmimask_ever — mainlatch[0] (NMI enable) has been set
//     cell7 WHITE   calibration  — ALWAYS on (proves overlay renders + rbf fresh)
//   v_cnt 48..79 : CPU-PC BAR — RGB straight from cpu1_A. Noisy stipple = Z80
//                  executing across many addresses; a solid block = stuck/halted.
//   v_cnt 80..207: PALETTE SWATCH — 16x16 grid, prom_addr forced to the cell
//                  index, shown via the normal PROM path. Real colours = palette
//                  PROM good; all-black = palette empty/black (look at PROM load).
//   v_cnt 208..239: untouched normal game render.
//
// READING IT: cell7 white but cell0 black -> Z80 halted (root cause).
//   cell0 green but cell3/4 black -> CPU runs but never writes VRAM (stuck in
//   init / waiting). cells green + swatch colourful + game area still black ->
//   renderer bug. swatch all black -> palette PROM is the problem.
//
// REVERT: delete this whole block + the 4 DIAG assigns, uncomment the 4
// originals just below. (The sticky-latch always_ff is harmless if left.)
//========================================================================
reg cpu_m1_ever, nmi_ever, bg_wr_ever, fg_wr_ever, spr_wr_ever, nmimask_ever;
reg [15:0] diag_a_prev;
reg [19:0] diag_alive_cnt;
// DIAG-REVERT-2026-05-29 (row 2): pin down WHY the main CPU never sets the LS259
// (NMI mask). These probe the LS259 I/O writes + the sub-CPU handshake.
reg io_wr_ever, ml1_ever, ml2_ever, cpu2_m1_ever, shared_wr_ever, gfxctrl_ever;
reg [15:0] diag2_a_prev;
reg [19:0] diag2_alive_cnt;
// DIAG-REVERT-2026-05-29 (row 3, thin top strip): the SUB's HALF of the handshake +
// whether the main ever self-enables NMI. These pin the attract-mode lock.
reg sub_swr_ever, cpu2_iack_ever, ml0_ever;
always_ff @(posedge clk_49m) begin
    if (!reset) begin
        cpu_m1_ever <= 1'b0; nmi_ever <= 1'b0; bg_wr_ever <= 1'b0;
        fg_wr_ever  <= 1'b0; spr_wr_ever <= 1'b0; nmimask_ever <= 1'b0;
        diag_a_prev <= 16'd0; diag_alive_cnt <= 20'd0;
        io_wr_ever <= 1'b0; ml1_ever <= 1'b0; ml2_ever <= 1'b0;
        cpu2_m1_ever <= 1'b0; shared_wr_ever <= 1'b0; gfxctrl_ever <= 1'b0;
        diag2_a_prev <= 16'd0; diag2_alive_cnt <= 20'd0;
        sub_swr_ever <= 1'b0; cpu2_iack_ever <= 1'b0; ml0_ever <= 1'b0;
    end else begin
        if (~cpu1_M1_n & ~cpu1_MREQ_n)            cpu_m1_ever  <= 1'b1;
        if (cpu1_nmi)                             nmi_ever     <= 1'b1;
        if (cs_bgvram & ~cpu1_WR_n)               bg_wr_ever   <= 1'b1;
        if (cs_fgvram & ~cpu1_WR_n)               fg_wr_ever   <= 1'b1;
        if ((cs_spram0 | cs_spram1) & ~cpu1_WR_n) spr_wr_ever  <= 1'b1;
        if (nmi_mask)                             nmimask_ever <= 1'b1;
        diag_a_prev <= cpu1_A;
        if (cpu1_A != diag_a_prev)        diag_alive_cnt <= 20'hFFFFF;
        else if (diag_alive_cnt != 20'd0) diag_alive_cnt <= diag_alive_cnt - 20'd1;
        // Row 2 — LS259 / sub-CPU handshake
        if (cs_mainlatch)              io_wr_ever     <= 1'b1;  // ANY OUT to ports 0-7
        if (mainlatch[1])              ml1_ever       <= 1'b1;  // flip bit set
        if (mainlatch[2])              ml2_ever       <= 1'b1;  // sub-CPU released
        if (~cpu2_M1_n & ~cpu2_MREQ_n) cpu2_m1_ever   <= 1'b1;  // sub fetched opcode
        if (cs_shared & ~cpu1_WR_n)    shared_wr_ever <= 1'b1;  // main wrote shared RAM
        if (cs_gfxctrl)                gfxctrl_ever   <= 1'b1;  // main wrote $B000 (late init)
        // Row 3 — the SUB's half of the handshake + main's own NMI-enable
        if (cs2_shared & ~cpu2_WR_n)   sub_swr_ever   <= 1'b1;  // SUB wrote shared RAM (its response)
        if (~cpu2_IORQ_n & ~cpu2_M1_n) cpu2_iack_ever <= 1'b1;  // sub took an IRQ (int-ack)
        if (mainlatch[0])              ml0_ever       <= 1'b1;  // main set NMI-enable ON ITS OWN
        diag2_a_prev <= cpu2_A;
        if (cpu2_A != diag2_a_prev)        diag2_alive_cnt <= 20'hFFFFF;
        else if (diag2_alive_cnt != 20'd0) diag2_alive_cnt <= diag2_alive_cnt - 20'd1;
    end
end
wire cpu_alive  = (diag_alive_cnt  != 20'd0);
wire cpu2_alive = (diag2_alive_cnt != 20'd0);

// Row 1 = v_cnt 16..31 (original 8 cells). Row 2 = v_cnt 32..47 (NMI/LS259 probes).
wire diag_row1  = (v_cnt >= 9'd16) & (v_cnt < 9'd32) & (base_h_cnt < 9'd256);
wire diag_row2  = (v_cnt >= 9'd32) & (v_cnt < 9'd48) & (base_h_cnt < 9'd256);
wire diag_pcbar = (v_cnt >= 9'd48) & (v_cnt < 9'd80);
wire diag_swatch= (v_cnt >= 9'd80) & (v_cnt < 9'd208) & (base_h_cnt < 9'd256);

wire [2:0] diag_cell = base_h_cnt[7:5];           // 0..7, 32px cells
wire [3:0] sw_col    = base_h_cnt[7:4];           // 0..15, 16px cells
wire [3:0] sw_row    = (v_cnt - 9'd80) >> 3;      // 0..15, 8 lines per row
wire [7:0] diag_swatch_index = {sw_row, sw_col};

// Row 1 (existing): distinct saturated colours; BLACK when the condition is false.
reg [4:0] cell_r, cell_g, cell_b;
always_comb begin
    cell_r = 5'd0; cell_g = 5'd0; cell_b = 5'd0;
    case (diag_cell)
        3'd0: if (cpu_alive)    cell_g = 5'd31;                                  // GREEN
        3'd1: if (cpu_m1_ever)  begin cell_g = 5'd31; cell_b = 5'd31; end        // CYAN
        3'd2: if (nmi_ever)     cell_b = 5'd31;                                  // BLUE
        3'd3: if (bg_wr_ever)   cell_r = 5'd31;                                  // RED
        3'd4: if (fg_wr_ever)   begin cell_r = 5'd31; cell_g = 5'd31; end        // YELLOW
        3'd5: if (spr_wr_ever)  begin cell_r = 5'd31; cell_b = 5'd31; end        // MAGENTA
        3'd6: if (nmimask_ever) begin cell_r = 5'd31; cell_g = 5'd16; end        // ORANGE
        3'd7:                   begin cell_r = 5'd31; cell_g = 5'd31; cell_b = 5'd31; end // WHITE (calib)
    endcase
end

// Row 2 (NEW) — NMI / LS259 / sub-CPU handshake. Same colour key as row 1:
//   0 GREEN   io_wr_ever     — main CPU did ANY OUT to ports 0-7 (the LS259)
//   1 CYAN    ml2_ever       — mainlatch[2] set (sub-CPU released from reset)
//   2 BLUE    ml1_ever       — mainlatch[1] set (flip) — proves LS259 writes land
//   3 RED     cpu2_alive     — sub-CPU address bus changing (executing)
//   4 YELLOW  cpu2_m1_ever   — sub-CPU fetched an opcode
//   5 MAGENTA shared_wr_ever — main CPU wrote shared RAM (talking to the sub)
//   6 ORANGE  gfxctrl_ever   — main CPU wrote $B000 gfxctrl (reached late init)
//   7 WHITE   calibration (always)
reg [4:0] cell2_r, cell2_g, cell2_b;
always_comb begin
    cell2_r = 5'd0; cell2_g = 5'd0; cell2_b = 5'd0;
    case (diag_cell)
        3'd0: if (io_wr_ever)     cell2_g = 5'd31;                                  // GREEN
        3'd1: if (ml2_ever)       begin cell2_g = 5'd31; cell2_b = 5'd31; end        // CYAN
        3'd2: if (ml1_ever)       cell2_b = 5'd31;                                  // BLUE
        3'd3: if (cpu2_alive)     cell2_r = 5'd31;                                  // RED
        3'd4: if (cpu2_m1_ever)   begin cell2_r = 5'd31; cell2_g = 5'd31; end        // YELLOW
        3'd5: if (shared_wr_ever) begin cell2_r = 5'd31; cell2_b = 5'd31; end        // MAGENTA
        3'd6: if (gfxctrl_ever)   begin cell2_r = 5'd31; cell2_g = 5'd16; end        // ORANGE
        3'd7:                     begin cell2_r = 5'd31; cell2_g = 5'd31; cell2_b = 5'd31; end // WHITE
    endcase
end

wire       diag_direct = diag_row1 | diag_row2 | diag_pcbar;
wire [4:0] diag_r = diag_row1 ? cell_r : diag_row2 ? cell2_r : cpu1_A[15:11];  // PC bar = addr bus
wire [4:0] diag_g = diag_row1 ? cell_g : diag_row2 ? cell2_g : cpu1_A[10:6];
wire [4:0] diag_b = diag_row1 ? cell_b : diag_row2 ? cell2_b : cpu1_A[5:1];

// DIAG-REVERT-2026-05-29 (row 3): THIN TOP STRIP (v_cnt 16..23) overlaid on the REAL
// game so we keep the picture. 4 cells (32px), colour if sticky-true else BLACK:
//   0 GREEN cpu2_iack_ever — sub services IRQs (expected green; sound works)
//   1 CYAN  sub_swr_ever   — sub WRITES shared RAM = completes its handshake half (KEY)
//   2 BLUE  ml0_ever       — main set mainlatch[0] (NMI-enable) ON ITS OWN = handshake done
//   7 WHITE calibration
// READ: CYAN black -> sub never writes back -> handshake can't complete -> main locks at
//   attract (fix the sub IRQ handler / handshake). CYAN green + BLUE black -> sub writes
//   but main still won't self-enable NMI -> its wait is a specific value, not just "sub
//   wrote". BLUE green -> handshake DID complete -> the attract lock is NOT the sub.
reg [4:0] strip_r, strip_g, strip_b;
always_comb begin
    strip_r = 5'd0; strip_g = 5'd0; strip_b = 5'd0;
    case (diag_cell)
        3'd0: if (cpu2_iack_ever) strip_g = 5'd31;                            // GREEN
        3'd1: if (sub_swr_ever)   begin strip_g = 5'd31; strip_b = 5'd31; end // CYAN
        3'd2: if (ml0_ever)       strip_b = 5'd31;                            // BLUE
        3'd7:                     begin strip_r = 5'd31; strip_g = 5'd31; strip_b = 5'd31; end // WHITE
        default: ;
    endcase
end
wire diag_strip = (v_cnt >= 9'd16) & (v_cnt < 9'd24) & (base_h_cnt < 9'd256);

//------------------------------------------------------------------------
// DIAG-REVERT-2026-05-29 (LOCK PROBE): read the HUNG main-CPU state.
// The "ever" cells above all latched TRUE at boot, so they say nothing about a
// mid-game lock. These cells are RECENT-ACTIVITY WINDOWS instead: each reloads on
// its event and DECAYS over ~0.68 s @ clk_49m. Play until it hard-locks, then
// screenshot the FROZEN frame — a cell that is now BLACK = that activity STOPPED at
// the lock; a cell still lit = it's ongoing. Cells at v_cnt 16..31, PC bar 32..63.
//
//   0 GREEN   main vblank-NMI fired recently   (main game-loop heartbeat)
//   1 CYAN    main wrote VRAM recently          (still drawing)
//   2 BLUE    main kicked watchdog E000 recently(still in its main loop)
//   3 RED     main READ shared RAM recently     (polling the sub = handshake wait)
//   4 YELLOW  sub WROTE shared RAM recently     (sub still responding)
//   5 MAGENTA sub CPU executing recently        (sound side alive — expect lit)
//   6 ORANGE  nmi_mask is HIGH right NOW (LIVE)  (is the main's NMI even enabled?)
//   7 WHITE   calibration (always on)
//
// DECISION TREE (read at the lock):
//   6 ORANGE BLACK  -> NMI is masked OFF now: main starved of its vblank IRQ ->
//                      game loop can't run. Prime v3-bandaid suspect (game cleared
//                      mainlatch[0] at BG setup, never re-set; ml0_seen already
//                      latched so v3 follows the real bit -> NMI dies). FIX = NMI path.
//   6 ORANGE LIT but 0 GREEN BLACK -> NMI enabled but not firing/landing -> NMI-gen
//                      or the CPU is HALTed/wedged below the IRQ. Check PC bar.
//   0/1/2 all dark, 3 RED LIT -> main spinning, reading shared RAM = handshake spin.
//                      Then 4 YELLOW: dark = sub stalled its half; lit = main waits on
//                      a SPECIFIC value the sub isn't producing. (a real cpu1<->cpu2 sync)
//   3 RED dark too + 0/1/2 dark -> spinning on non-shared-RAM (or crashed) -> PC bar.
//   PC bar (v_cnt 32..63, RGB=cpu1_A): solid 1 colour=HALT/tight park; few stable
//      stripes=small loop; wide noisy=wandering/crash. Dominant hue's red chan =
//      cpu1_A[15:11]: low/dark = ROM (<0x8000), bright = RAM/IO region (ran off).
// REVERT: delete this block + restore the assign lines below (see their DIAG tag).
//------------------------------------------------------------------------
localparam [24:0] LP_WIN = 25'h1FFFFFF;   // ~0.68 s recent-activity window
reg [24:0] lp_nmi, lp_vramwr, lp_wdog, lp_shrd, lp_subwr, lp_cpu2;
reg [15:0] lp_a1_prev, lp_a2_prev;
always_ff @(posedge clk_49m) begin
    if (!reset) begin
        lp_nmi<=0; lp_vramwr<=0; lp_wdog<=0; lp_shrd<=0; lp_subwr<=0; lp_cpu2<=0;
        lp_a1_prev<=16'd0; lp_a2_prev<=16'd0;
    end else begin
        lp_a1_prev <= cpu1_A; lp_a2_prev <= cpu2_A;
        if (cpu1_nmi)                                                 lp_nmi    <= LP_WIN; else if (lp_nmi)    lp_nmi    <= lp_nmi    - 1'b1;
        if ((cs_bgvram|cs_fgvram|cs_spram0|cs_spram1) & ~cpu1_WR_n)   lp_vramwr <= LP_WIN; else if (lp_vramwr) lp_vramwr <= lp_vramwr - 1'b1;
        if (cs_watchdog & ~cpu1_WR_n)                                 lp_wdog   <= LP_WIN; else if (lp_wdog)   lp_wdog   <= lp_wdog   - 1'b1;
        if (cs_shared & ~cpu1_RD_n)                                   lp_shrd   <= LP_WIN; else if (lp_shrd)   lp_shrd   <= lp_shrd   - 1'b1;
        if (cs2_shared & ~cpu2_WR_n)                                  lp_subwr  <= LP_WIN; else if (lp_subwr)  lp_subwr  <= lp_subwr  - 1'b1;
        if (cpu2_A != lp_a2_prev)                                     lp_cpu2   <= LP_WIN; else if (lp_cpu2)   lp_cpu2   <= lp_cpu2   - 1'b1;
    end
end
wire lp_nmi_act    = (lp_nmi    != 0);
wire lp_vramwr_act = (lp_vramwr != 0);
wire lp_wdog_act   = (lp_wdog   != 0);
wire lp_shrd_act   = (lp_shrd   != 0);
wire lp_subwr_act  = (lp_subwr  != 0);
wire lp_cpu2_act   = (lp_cpu2   != 0);

reg [4:0] lpc_r, lpc_g, lpc_b;
always_comb begin
    lpc_r = 5'd0; lpc_g = 5'd0; lpc_b = 5'd0;
    case (diag_cell)
        3'd0: if (lp_nmi_act)    lpc_g = 5'd31;                                  // GREEN
        3'd1: if (lp_vramwr_act) begin lpc_g = 5'd31; lpc_b = 5'd31; end          // CYAN
        3'd2: if (lp_wdog_act)   lpc_b = 5'd31;                                  // BLUE
        3'd3: if (lp_shrd_act)   lpc_r = 5'd31;                                  // RED
        3'd4: if (lp_subwr_act)  begin lpc_r = 5'd31; lpc_g = 5'd31; end          // YELLOW
        3'd5: if (lp_cpu2_act)   begin lpc_r = 5'd31; lpc_b = 5'd31; end          // MAGENTA
        3'd6: if (nmi_mask)      begin lpc_r = 5'd31; lpc_g = 5'd16; end          // ORANGE (LIVE level)
        3'd7:                    begin lpc_r = 5'd31; lpc_g = 5'd31; lpc_b = 5'd31; end // WHITE
    endcase
end
wire       diag_lp_cells = (v_cnt >= 9'd16) & (v_cnt < 9'd32) & (base_h_cnt < 9'd256);
wire       diag_lp_pcbar = (v_cnt >= 9'd32) & (v_cnt < 9'd64) & (base_h_cnt < 9'd256);
wire       diag_lp       = diag_lp_cells | diag_lp_pcbar;
wire [4:0] lp_r = diag_lp_cells ? lpc_r : cpu1_A[15:11];   // PC bar = main addr bus
wire [4:0] lp_g = diag_lp_cells ? lpc_g : cpu1_A[10:6];
wire [4:0] lp_b = diag_lp_cells ? lpc_b : cpu1_A[5:1];

//------------------------------------------------------------------------
// DIAG-REVERT-2026-05-29 (HANDSHAKE PROBE): pin the exact main<->sub shared-RAM
// handshake at the deterministic self-test->attract lock. Watchdog DISARMED so the lock
// is permanent and these latches hold. Each row is a 16-bit value, MSB at the LEFT, 16
// cells (16px each): lit cell = 1, dark = 0. Read each row L->R as binary (4 nibbles).
//   v_cnt 16..23  WHITE   calibration (all 16 lit = probe live + rbf fresh)
//   v_cnt 24..31  GREEN   poll_addr = last shared-RAM offset the MAIN read  (bits[10:0]; abs = F000+offset)
//   v_cnt 32..39  CYAN    poll_val  = value the MAIN read there             (bits[7:0])
//   v_cnt 40..47  YELLOW  subw_addr = last shared-RAM offset the SUB wrote  (bits[10:0]; abs = 4000+offset)
//   v_cnt 48..55  MAGENTA subw_val  = value the SUB wrote there             (bits[7:0])
//   v_cnt 56..63  ORANGE  spin_pc   = main cpu1_A at last opcode fetch (the spin PC; flickers within the loop)
// READ: poll_addr==subw_addr => main & sub share the same byte (value/timing issue);
//   differ => main waits on a byte the sub never writes (protocol/addr bug). poll_val is
//   what the main keeps seeing (vs the value it wants — from disasm). spin_pc's stable
//   upper bits = the ROM page to disassemble; low bits flicker over the loop body.
// REVERT: delete this block + restore an assign triplet below.
//------------------------------------------------------------------------
reg [10:0] hs_poll_addr; reg [7:0] hs_poll_val;
reg [10:0] hs_subw_addr; reg [7:0] hs_subw_val;
reg [15:0] hs_spin_pc;
reg hs_cpu2_m1_ever = 1'b0;   // sub fetched any opcode
reg hs_ml2_ever     = 1'b0;   // mainlatch[2] set = sub released from reset
always_ff @(posedge clk_49m) begin
    if (!reset) begin
        hs_poll_addr<=11'd0; hs_poll_val<=8'd0;
        hs_subw_addr<=11'd0; hs_subw_val<=8'd0; hs_spin_pc<=16'd0;
        hs_cpu2_m1_ever<=1'b0; hs_ml2_ever<=1'b0;
    end else begin
        if (cs_shared  & ~cpu1_RD_n)   begin hs_poll_addr <= cpu1_A[10:0]; hs_poll_val <= shared_ram_D_cpu1; end
        // DIAG-2026-06-12: latch ONLY the sub's write to offset 004 (the handshake token), held sticky,
        // so MAGENTA subw_val shows if the sub committed $FF there. subw_val=FF + CYAN poll_val=00
        // => write committed on port B but invisible on port A's read = cross-port (read-side) bug.
        // Original (last-any-write): if (cs2_shared & ~cpu2_WR_n) begin hs_subw_addr <= cpu2_A[10:0]; hs_subw_val <= cpu2_Dout; end
        if (cs2_shared & ~cpu2_WR_n & (cpu2_A[10:0]==11'h004)) begin hs_subw_addr <= cpu2_A[10:0]; hs_subw_val <= cpu2_Dout; end
        if (~cpu1_M1_n & ~cpu1_MREQ_n) hs_spin_pc <= cpu1_A;
        if (~cpu2_M1_n & ~cpu2_MREQ_n) hs_cpu2_m1_ever <= 1'b1;
        if (mainlatch[2])               hs_ml2_ever     <= 1'b1;
    end
end
wire [3:0]  hs_cell    = base_h_cnt[7:4];
wire [3:0]  hs_bitsel  = 4'd15 - hs_cell;          // MSB (bit 15) at the leftmost cell
wire [15:0] hs_v_paddr = {5'd0, hs_poll_addr};
wire [15:0] hs_v_pval  = {8'd0, hs_poll_val};
wire [15:0] hs_v_saddr = {5'd0, hs_subw_addr};
wire [15:0] hs_v_sval  = {8'd0, hs_subw_val};
wire [15:0] hs_v_pc    = hs_spin_pc;
wire hs_row_calib = (v_cnt>=9'd16)&(v_cnt<9'd24);
wire hs_row_paddr = (v_cnt>=9'd24)&(v_cnt<9'd32);
wire hs_row_pval  = (v_cnt>=9'd32)&(v_cnt<9'd40);
wire hs_row_saddr = (v_cnt>=9'd40)&(v_cnt<9'd48);
wire hs_row_sval  = (v_cnt>=9'd48)&(v_cnt<9'd56);
wire hs_row_pc    = (v_cnt>=9'd56)&(v_cnt<9'd64);
wire hs_active = (hs_row_calib|hs_row_paddr|hs_row_pval|hs_row_saddr|hs_row_sval|hs_row_pc) & (base_h_cnt<9'd256);
reg [4:0] hs_r, hs_g, hs_b;
always_comb begin
    hs_r=5'd0; hs_g=5'd0; hs_b=5'd0;
    if (hs_row_calib)                         begin hs_r=5'd31; hs_g=5'd31; hs_b=5'd31; end // WHITE
    if (hs_row_paddr & hs_v_paddr[hs_bitsel]) hs_g=5'd31;                                   // GREEN
    if (hs_row_pval  & hs_v_pval[hs_bitsel])  begin hs_g=5'd31; hs_b=5'd31; end              // CYAN
    if (hs_row_saddr & hs_v_saddr[hs_bitsel]) begin hs_r=5'd31; hs_g=5'd31; end              // YELLOW
    if (hs_row_sval  & hs_v_sval[hs_bitsel])  begin hs_r=5'd31; hs_b=5'd31; end              // MAGENTA
    if (hs_row_pc    & hs_ml2_ever)                                   begin hs_r=5'd31; hs_g=5'd16; end              // ORANGE left half  = mainlatch[2] ever set (sub released)
    if (hs_row_pc    & hs_cpu2_m1_ever & (base_h_cnt >= 9'd128))    begin hs_r=5'd31; hs_b=5'd31; end              // MAGENTA right half = sub CPU fetched opcode
end

// Video output mux. PRISTINE (clean game render) is ACTIVE. The diagnostic overlays below are kept
// COMMENTED for re-arming (handy for the open scrolling + cold-boot work); exactly ONE triplet is
// active at a time. To re-arm a probe: comment the PRISTINE triplet and uncomment one of —
//   (2) LOCK PROBE     — activity cells (v_cnt 16..31) + PC bar (32..63): where the main CPU is stuck.
//   (3) STRIP          — sub-handshake strip overlaid on the live game.
//   (4) HANDSHAKE PROBE — full main<->sub shared-RAM handshake read.
//   FULL OVERLAY       — rows 1/2 + PC bar + PALETTE SWATCH (also swap in the diag_swatch prom_addr line).
assign prom_addr = composite_pal;
// (1) PRISTINE — ACTIVE (overlay OFF for screenshots; re-arm a probe below to debug):
assign red   = !visible ? 5'd0 : {prom_r_D[3:0], prom_r_D[3]};
assign green = !visible ? 5'd0 : {prom_g_D[3:0], prom_g_D[3]};
assign blue  = !visible ? 5'd0 : {prom_b_D[3:0], prom_b_D[3]};
// (2) LOCK PROBE:
// assign red   = !visible ? 5'd0 : diag_lp ? lp_r : {prom_r_D[3:0], prom_r_D[3]};
// assign green = !visible ? 5'd0 : diag_lp ? lp_g : {prom_g_D[3:0], prom_g_D[3]};
// assign blue  = !visible ? 5'd0 : diag_lp ? lp_b : {prom_b_D[3:0], prom_b_D[3]};
// (4) HANDSHAKE PROBE (OFF — uncomment this triplet + comment PRISTINE to re-arm):
// assign red   = !visible ? 5'd0 : hs_active ? hs_r : {prom_r_D[3:0], prom_r_D[3]};
// assign green = !visible ? 5'd0 : hs_active ? hs_g : {prom_g_D[3:0], prom_g_D[3]};
// assign blue  = !visible ? 5'd0 : hs_active ? hs_b : {prom_b_D[3:0], prom_b_D[3]};
// (3) STRIP (old) — sub-handshake strip on live game:
// assign red   = !visible ? 5'd0 : diag_strip ? strip_r : {prom_r_D[3:0], prom_r_D[3]};
// assign green = !visible ? 5'd0 : diag_strip ? strip_g : {prom_g_D[3:0], prom_g_D[3]};
// assign blue  = !visible ? 5'd0 : diag_strip ? strip_b : {prom_b_D[3:0], prom_b_D[3]};
// Full-overlay drive (DISABLED — swap with the 4 lines above to re-arm rows 1/2/PC/swatch):
// assign prom_addr = diag_swatch ? diag_swatch_index : composite_pal;
// assign red   = !visible ? 5'd0 : diag_direct ? diag_r : {prom_r_D[3:0], prom_r_D[3]};
// assign green = !visible ? 5'd0 : diag_direct ? diag_g : {prom_g_D[3:0], prom_g_D[3]};
// assign blue  = !visible ? 5'd0 : diag_direct ? diag_b : {prom_b_D[3:0], prom_b_D[3]};
// DIAG-REVERT-2026-05-29: video-state diagnostic overlay   <<< END DIAGNOSTIC <<<
//========================================================================

endmodule
