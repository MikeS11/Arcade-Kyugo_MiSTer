0000: 7F          ld   a,a
0001: 40          ld   b,b
0002: ED 56       im   1
0004: C3 EF 1D    jp   $1DEF
0007: FF          rst  $38
0008: DD 7E 00    ld   a,(ix+$00)
000B: E6 03       and  $03
000D: 4F          ld   c,a
000E: 21 2A 40    ld   hl,$402A
0011: 09          add  hl,bc
0012: 7E          ld   a,(hl)
0013: E6 10       and  $10
0015: 4F          ld   c,a
0016: C9          ret
0017: FF          rst  $38
0018: 1A          ld   a,(de)
0019: 77          ld   (hl),a
001A: 23          inc  hl
001B: 13          inc  de
001C: 1A          ld   a,(de)
001D: 77          ld   (hl),a
001E: E7          rst  $20
001F: 37          scf
0020: DD 34 06    inc  (ix+$06)
0023: C0          ret  nz
0024: DD 34 07    inc  (ix+$07)
0027: C9          ret
0028: DD 7E 00    ld   a,(ix+$00)
002B: E6 03       and  $03
002D: 20 01       jr   nz,$0030
002F: 37          scf
0030: 17          rla
0031: 17          rla
0032: 17          rla
0033: 17          rla
0034: 21 29 40    ld   hl,$4029
0037: C9          ret
0038: F3          di
0039: F5          push af
003A: C5          push bc
003B: D5          push de
003C: E5          push hl
003D: 21 0E 40    ld   hl,$400E
0040: CB C6       set  0,(hl)
0042: CD EF 02    call $02EF
0045: CD 22 04    call $0422
0048: CD 19 01    call $0119
004B: 21 0A 40    ld   hl,$400A
004E: 7E          ld   a,(hl)
004F: 23          inc  hl
0050: 23          inc  hl
0051: BE          cp   (hl)
0052: 28 05       jr   z,$0059
0054: 77          ld   (hl),a
0055: 23          inc  hl
0056: 36 00       ld   (hl),$00
0058: 2B          dec  hl
0059: 23          inc  hl
005A: 7E          ld   a,(hl)
005B: 34          inc  (hl)
005C: FE 02       cp   $02
005E: 20 08       jr   nz,$0068
0060: CD 0F 10    call $100F
0063: CD 89 12    call $1289
0066: 18 1B       jr   $0083
0068: E6 03       and  $03
006A: 20 08       jr   nz,$0074
006C: CD 61 01    call $0161
006F: CD AF 00    call $00AF
0072: 18 0F       jr   $0083
0074: FE 01       cp   $01
0076: 20 08       jr   nz,$0080
0078: CD 88 00    call $0088
007B: CD DB 00    call $00DB
007E: 18 03       jr   $0083
0080: CD EE 01    call $01EE
0083: E1          pop  hl
0084: D1          pop  de
0085: C1          pop  bc
0086: F1          pop  af
0087: C9          ret
0088: 3A 40 80    ld   a,($8040)
008B: 32 03 40    ld   ($4003),a
008E: 3A 00 80    ld   a,($8000)
0091: 32 04 40    ld   ($4004),a
0094: 3A 80 80    ld   a,($8080)
0097: 32 07 40    ld   ($4007),a
009A: 3E 0E       ld   a,$0E
009C: D3 00       out  ($00),a
009E: DB 02       in   a,($02)
00A0: 2F          cpl
00A1: 32 05 40    ld   ($4005),a
00A4: 3E 0F       ld   a,$0F
00A6: D3 00       out  ($00),a
00A8: DB 02       in   a,($02)
00AA: 2F          cpl
00AB: 32 06 40    ld   ($4006),a
00AE: C9          ret
00AF: 0E C0       ld   c,$C0
00B1: 21 14 40    ld   hl,$4014
00B4: CD BF 00    call $00BF
00B7: 0C          inc  c
00B8: 21 1A 40    ld   hl,$401A
00BB: CD BF 00    call $00BF
00BE: C9          ret
00BF: 7E          ld   a,(hl)
00C0: B7          or   a
00C1: 20 0D       jr   nz,$00D0
00C3: 2B          dec  hl
00C4: 7E          ld   a,(hl)
00C5: B7          or   a
00C6: C8          ret  z
00C7: 35          dec  (hl)
00C8: 23          inc  hl
00C9: 36 20       ld   (hl),$20
00CB: 3E 01       ld   a,$01
00CD: ED 79       out  (c),a
00CF: C9          ret
00D0: 3D          dec  a
00D1: 77          ld   (hl),a
00D2: C8          ret  z
00D3: FE 10       cp   $10
00D5: C0          ret  nz
00D6: 3E 00       ld   a,$00
00D8: ED 79       out  (c),a
00DA: C9          ret
00DB: 21 01 40    ld   hl,$4001
00DE: CB C6       set  0,(hl)
00E0: 11 12 40    ld   de,$4012
00E3: 21 0F 40    ld   hl,$400F
00E6: 7E          ld   a,(hl)
00E7: B7          or   a
00E8: 20 07       jr   nz,$00F1
00EA: 3E 63       ld   a,$63
00EC: 32 02 40    ld   ($4002),a
00EF: 18 22       jr   $0113
00F1: 3E 03       ld   a,$03
00F3: 08          ex   af,af'
00F4: 23          inc  hl
00F5: 3A 02 40    ld   a,($4002)
00F8: 86          add  a,(hl)
00F9: 2B          dec  hl
00FA: FE 64       cp   $64
00FC: 30 0A       jr   nc,$0108
00FE: 4F          ld   c,a
00FF: 1A          ld   a,(de)
0100: 96          sub  (hl)
0101: 38 05       jr   c,$0108
0103: 12          ld   (de),a
0104: 79          ld   a,c
0105: 32 02 40    ld   ($4002),a
0108: 01 06 00    ld   bc,$0006
010B: 09          add  hl,bc
010C: EB          ex   de,hl
010D: 09          add  hl,bc
010E: EB          ex   de,hl
010F: 08          ex   af,af'
0110: 3D          dec  a
0111: 20 E0       jr   nz,$00F3
0113: 21 01 40    ld   hl,$4001
0116: CB 86       res  0,(hl)
0118: C9          ret
0119: 3A 0F 40    ld   a,($400F)
011C: B7          or   a
011D: C8          ret  z
011E: 21 11 40    ld   hl,$4011
0121: 3A 07 40    ld   a,($4007)
0124: 4F          ld   c,a
0125: 06 03       ld   b,$03
0127: CD 33 01    call $0133
012A: C5          push bc
012B: 01 06 00    ld   bc,$0006
012E: 09          add  hl,bc
012F: C1          pop  bc
0130: 10 F5       djnz $0127
0132: C9          ret
0133: 7E          ld   a,(hl)
0134: CB 19       rr   c
0136: 38 0A       jr   c,$0142
0138: B7          or   a
0139: C8          ret  z
013A: 3D          dec  a
013B: FE 80       cp   $80
013D: 20 01       jr   nz,$0140
013F: AF          xor  a
0140: 77          ld   (hl),a
0141: C9          ret
0142: FE 84       cp   $84
0144: C8          ret  z
0145: 3C          inc  a
0146: FE 04       cp   $04
0148: 20 F6       jr   nz,$0140
014A: CB FF       set  7,a
014C: 77          ld   (hl),a
014D: 23          inc  hl
014E: 34          inc  (hl)
014F: 20 03       jr   nz,$0154
0151: 35          dec  (hl)
0152: 18 05       jr   $0159
0154: 3E 0C       ld   a,$0C
0156: 32 00 40    ld   ($4000),a
0159: 23          inc  hl
015A: 34          inc  (hl)
015B: 20 01       jr   nz,$015E
015D: 35          dec  (hl)
015E: 2B          dec  hl
015F: 2B          dec  hl
0160: C9          ret
0161: 3A 00 40    ld   a,($4000)
0164: FE FF       cp   $FF
0166: C8          ret  z
0167: 4F          ld   c,a
0168: AF          xor  a
0169: 32 00 40    ld   ($4000),a
016C: 47          ld   b,a
016D: 79          ld   a,c
016E: FE F2       cp   $F2
0170: 20 05       jr   nz,$0177
0172: CD C3 01    call $01C3
0175: 18 1B       jr   $0192
0177: 3A 08 40    ld   a,($4008)
017A: 07          rlca
017B: 79          ld   a,c
017C: 30 04       jr   nc,$0182
017E: FE 0C       cp   $0C
0180: 20 10       jr   nz,$0192
0182: E6 1F       and  $1F
0184: FE 12       cp   $12
0186: 30 0A       jr   nc,$0192
0188: CB 71       bit  6,c
018A: 20 0C       jr   nz,$0198
018C: 4F          ld   c,a
018D: 21 50 40    ld   hl,$4050
0190: 09          add  hl,bc
0191: 77          ld   (hl),a
0192: 3E FF       ld   a,$FF
0194: 32 00 40    ld   ($4000),a
0197: C9          ret
0198: 87          add  a,a
0199: 4F          ld   c,a
019A: 21 EC 04    ld   hl,$04EC
019D: 09          add  hl,bc
019E: 4E          ld   c,(hl)
019F: 23          inc  hl
01A0: EB          ex   de,hl
01A1: 21 33 40    ld   hl,$4033
01A4: 06 03       ld   b,$03
01A6: 1A          ld   a,(de)
01A7: 81          add  a,c
01A8: 3D          dec  a
01A9: BE          cp   (hl)
01AA: 20 08       jr   nz,$01B4
01AC: 2B          dec  hl
01AD: CB 7E       bit  7,(hl)
01AF: 28 02       jr   z,$01B3
01B1: CB EE       set  5,(hl)
01B3: 23          inc  hl
01B4: 7D          ld   a,l
01B5: C6 0A       add  a,$0A
01B7: 6F          ld   l,a
01B8: 3E 00       ld   a,$00
01BA: 8C          adc  a,h
01BB: 67          ld   h,a
01BC: 10 E8       djnz $01A6
01BE: 0D          dec  c
01BF: 20 E0       jr   nz,$01A1
01C1: 18 CF       jr   $0192
01C3: D3 80       out  ($80),a
01C5: D3 80       out  ($80),a
01C7: 21 21 40    ld   hl,$4021
01CA: 11 22 40    ld   de,$4022
01CD: 01 4E 00    ld   bc,$004E
01D0: 36 00       ld   (hl),$00
01D2: ED B0       ldir
01D4: 3E 38       ld   a,$38
01D6: 32 29 40    ld   ($4029),a
01D9: C9          ret
01DA: 3A 07 40    ld   a,($4007)
01DD: 21 11 40    ld   hl,$4011
01E0: 06 03       ld   b,$03
01E2: 11 06 00    ld   de,$0006
01E5: 1F          rra
01E6: 30 02       jr   nc,$01EA
01E8: 36 84       ld   (hl),$84
01EA: 19          add  hl,de
01EB: 10 F8       djnz $01E5
01ED: C9          ret
01EE: 3A 06 40    ld   a,($4006)
01F1: 11 0F 40    ld   de,$400F
01F4: 21 20 02    ld   hl,$0220
01F7: CD 14 02    call $0214
01FA: 3A 06 40    ld   a,($4006)
01FD: 1F          rra
01FE: 1F          rra
01FF: 1F          rra
0200: 11 15 40    ld   de,$4015
0203: 21 30 02    ld   hl,$0230
0206: CD 14 02    call $0214
0209: 11 1B 40    ld   de,$401B
020C: 21 20 02    ld   hl,$0220
020F: AF          xor  a
0210: CD 14 02    call $0214
0213: C9          ret
0214: E6 07       and  $07
0216: 87          add  a,a
0217: 4F          ld   c,a
0218: 06 00       ld   b,$00
021A: 09          add  hl,bc
021B: ED A0       ldi
021D: ED A0       ldi
021F: C9          ret
0220: 01 01 01    ld   bc,$0101
0223: 02          ld   (bc),a
0224: 01 03 01    ld   bc,$0103
0227: 04          inc  b
0228: 01 06 02    ld   bc,$0206
022B: 01 03 02    ld   bc,$0203
022E: 00          nop
022F: 00          nop
0230: 01 01 01    ld   bc,$0101
0233: 02          ld   (bc),a
0234: 01 03 03    ld   bc,$0303
0237: 04          inc  b
0238: 02          ld   (bc),a
0239: 01 03 01    ld   bc,$0103
023C: 04          inc  b
023D: 01 05 01    ld   bc,$0105
0240: F3          di
0241: 3E 00       ld   a,$00
0243: D3 C0       out  ($C0),a
0245: D3 C1       out  ($C1),a
0247: 21 0C 40    ld   hl,$400C
024A: 11 0D 40    ld   de,$400D
024D: 01 F3 02    ld   bc,$02F3
0250: 36 00       ld   (hl),$00
0252: ED B0       ldir
0254: 31 00 43    ld   sp,$4300
0257: CD C3 01    call $01C3
025A: CD 22 04    call $0422
025D: CD 88 00    call $0088
0260: CD DA 01    call $01DA
0263: CD EE 01    call $01EE
0266: 3E FF       ld   a,$FF
0268: 32 00 40    ld   ($4000),a
026B: FB          ei
026C: 21 0E 40    ld   hl,$400E
026F: CB 46       bit  0,(hl)
0271: 28 FC       jr   z,$026F
0273: 36 00       ld   (hl),$00
0275: 21 51 40    ld   hl,$4051
0278: 06 11       ld   b,$11
027A: 7E          ld   a,(hl)
027B: B7          or   a
027C: 28 25       jr   z,$02A3
027E: C5          push bc
027F: EB          ex   de,hl
0280: 87          add  a,a
0281: 4F          ld   c,a
0282: 06 00       ld   b,$00
0284: 21 EC 04    ld   hl,$04EC
0287: 09          add  hl,bc
0288: 3A 21 40    ld   a,($4021)
028B: 46          ld   b,(hl)
028C: 80          add  a,b
028D: FE 04       cp   $04
028F: EB          ex   de,hl
0290: 30 16       jr   nc,$02A8
0292: 36 00       ld   (hl),$00
0294: 32 21 40    ld   ($4021),a
0297: 13          inc  de
0298: 1A          ld   a,(de)
0299: 80          add  a,b
029A: 3D          dec  a
029B: D9          exx
029C: CD B3 02    call $02B3
029F: D9          exx
02A0: 10 F6       djnz $0298
02A2: C1          pop  bc
02A3: 23          inc  hl
02A4: 10 D4       djnz $027A
02A6: 18 C3       jr   $026B
02A8: C1          pop  bc
02A9: 05          dec  b
02AA: 28 BF       jr   z,$026B
02AC: AF          xor  a
02AD: 23          inc  hl
02AE: 77          ld   (hl),a
02AF: 10 FC       djnz $02AD
02B1: 18 B8       jr   $026B
02B3: 21 32 40    ld   hl,$4032
02B6: 11 0A 00    ld   de,$000A
02B9: 06 03       ld   b,$03
02BB: 4F          ld   c,a
02BC: AF          xor  a
02BD: BE          cp   (hl)
02BE: 28 05       jr   z,$02C5
02C0: 19          add  hl,de
02C1: 10 FA       djnz $02BD
02C3: 37          scf
02C4: C9          ret
02C5: E5          push hl
02C6: 05          dec  b
02C7: 70          ld   (hl),b
02C8: 23          inc  hl
02C9: 71          ld   (hl),c
02CA: EB          ex   de,hl
02CB: 69          ld   l,c
02CC: 67          ld   h,a
02CD: 29          add  hl,hl
02CE: 01 0F 05    ld   bc,$050F
02D1: 09          add  hl,bc
02D2: CB 7E       bit  7,(hl)
02D4: EB          ex   de,hl
02D5: 28 04       jr   z,$02DB
02D7: 2B          dec  hl
02D8: CB F6       set  6,(hl)
02DA: 23          inc  hl
02DB: 06 06       ld   b,$06
02DD: 23          inc  hl
02DE: 77          ld   (hl),a
02DF: 10 FC       djnz $02DD
02E1: 23          inc  hl
02E2: 1B          dec  de
02E3: 1A          ld   a,(de)
02E4: 77          ld   (hl),a
02E5: 23          inc  hl
02E6: 13          inc  de
02E7: 1A          ld   a,(de)
02E8: E6 7F       and  $7F
02EA: 77          ld   (hl),a
02EB: E1          pop  hl
02EC: CB FE       set  7,(hl)
02EE: C9          ret
02EF: DD 21 32 40 ld   ix,$4032
02F3: 21 32 40    ld   hl,$4032
02F6: CB 7E       bit  7,(hl)
02F8: C4 14 03    call nz,$0314
02FB: DD 21 3C 40 ld   ix,$403C
02FF: 21 3C 40    ld   hl,$403C
0302: CB 7E       bit  7,(hl)
0304: C4 14 03    call nz,$0314
0307: DD 21 46 40 ld   ix,$4046
030B: 21 46 40    ld   hl,$4046
030E: CB 7E       bit  7,(hl)
0310: C4 14 03    call nz,$0314
0313: C9          ret
0314: 4E          ld   c,(hl)
0315: CB 69       bit  5,c
0317: 20 52       jr   nz,$036B
0319: 23          inc  hl
031A: 23          inc  hl
031B: AF          xor  a
031C: B6          or   (hl)
031D: 23          inc  hl
031E: 20 17       jr   nz,$0337
0320: B6          or   (hl)
0321: 28 22       jr   z,$0345
0323: 35          dec  (hl)
0324: CB 61       bit  4,c
0326: C8          ret  z
0327: 3E 03       ld   a,$03
0329: A1          and  c
032A: 4F          ld   c,a
032B: 06 00       ld   b,$00
032D: 21 2A 40    ld   hl,$402A
0330: 09          add  hl,bc
0331: 7E          ld   a,(hl)
0332: E6 0F       and  $0F
0334: C8          ret  z
0335: 35          dec  (hl)
0336: C9          ret
0337: 7E          ld   a,(hl)
0338: B7          or   a
0339: 20 FA       jr   nz,$0335
033B: 23          inc  hl
033C: 7E          ld   a,(hl)
033D: 2B          dec  hl
033E: 77          ld   (hl),a
033F: 2B          dec  hl
0340: 35          dec  (hl)
0341: CB 59       bit  3,c
0343: 18 E1       jr   $0326
0345: 23          inc  hl
0346: 7E          ld   a,(hl)
0347: 2B          dec  hl
0348: 77          ld   (hl),a
0349: DD 6E 08    ld   l,(ix+$08)
034C: DD 66 09    ld   h,(ix+$09)
034F: DD 4E 06    ld   c,(ix+$06)
0352: DD 46 07    ld   b,(ix+$07)
0355: 09          add  hl,bc
0356: 7E          ld   a,(hl)
0357: FE FF       cp   $FF
0359: 20 20       jr   nz,$037B
035B: DD CB 00 76 bit  6,(ix+$00)
035F: 28 0A       jr   z,$036B
0361: DD 36 06 00 ld   (ix+$06),$00
0365: DD 36 07 00 ld   (ix+$07),$00
0369: 18 DE       jr   $0349
036B: CD EC 03    call $03EC
036E: 06 00       ld   b,$00
0370: CF          rst  $08
0371: AF          xor  a
0372: 77          ld   (hl),a
0373: DD 77 00    ld   (ix+$00),a
0376: 21 21 40    ld   hl,$4021
0379: 35          dec  (hl)
037A: C9          ret
037B: 01 9B 03    ld   bc,$039B
037E: C5          push bc
037F: 0F          rrca
0380: 0F          rrca
0381: 0F          rrca
0382: 0F          rrca
0383: E6 0F       and  $0F
0385: DD 77 02    ld   (ix+$02),a
0388: 7E          ld   a,(hl)
0389: E6 0F       and  $0F
038B: 07          rlca
038C: EB          ex   de,hl
038D: 21 3C 04    ld   hl,$043C
0390: 06 00       ld   b,$00
0392: 4F          ld   c,a
0393: 09          add  hl,bc
0394: 7E          ld   a,(hl)
0395: 23          inc  hl
0396: 66          ld   h,(hl)
0397: 6F          ld   l,a
0398: 13          inc  de
0399: E7          rst  $20
039A: E9          jp   (hl)
039B: 38 AC       jr   c,$0349
039D: C9          ret
039E: 37          scf
039F: C9          ret
03A0: CD A6 03    call $03A6
03A3: DF          rst  $18
03A4: 18 28       jr   $03CE
03A6: DD 7E 00    ld   a,(ix+$00)
03A9: E6 03       and  $03
03AB: 07          rlca
03AC: 4F          ld   c,a
03AD: 21 22 40    ld   hl,$4022
03B0: 09          add  hl,bc
03B1: C9          ret
03B2: CF          rst  $08
03B3: 1A          ld   a,(de)
03B4: DD 77 05    ld   (ix+$05),a
03B7: B1          or   c
03B8: 77          ld   (hl),a
03B9: E7          rst  $20
03BA: 37          scf
03BB: C9          ret
03BC: CF          rst  $08
03BD: 71          ld   (hl),c
03BE: C9          ret
03BF: 1A          ld   a,(de)
03C0: DD 77 03    ld   (ix+$03),a
03C3: DD 77 04    ld   (ix+$04),a
03C6: E7          rst  $20
03C7: 37          scf
03C8: C9          ret
03C9: CF          rst  $08
03CA: CB A6       res  4,(hl)
03CC: 37          scf
03CD: C9          ret
03CE: CF          rst  $08
03CF: DD 7E 05    ld   a,(ix+$05)
03D2: B1          or   c
03D3: 77          ld   (hl),a
03D4: B7          or   a
03D5: C9          ret
03D6: 1A          ld   a,(de)
03D7: 07          rlca
03D8: 21 44 04    ld   hl,$0444
03DB: 4F          ld   c,a
03DC: 09          add  hl,bc
03DD: EB          ex   de,hl
03DE: DD 7E 06    ld   a,(ix+$06)
03E1: DD 35 06    dec  (ix+$06)
03E4: B7          or   a
03E5: 20 03       jr   nz,$03EA
03E7: DD 35 07    dec  (ix+$07)
03EA: 18 B4       jr   $03A0
03EC: EF          rst  $28
03ED: B6          or   (hl)
03EE: 77          ld   (hl),a
03EF: 37          scf
03F0: C9          ret
03F1: EF          rst  $28
03F2: 2F          cpl
03F3: A6          and  (hl)
03F4: 77          ld   (hl),a
03F5: 37          scf
03F6: C9          ret
03F7: 21 28 40    ld   hl,$4028
03FA: 1A          ld   a,(de)
03FB: 77          ld   (hl),a
03FC: E7          rst  $20
03FD: 37          scf
03FE: C9          ret
03FF: 21 2D 40    ld   hl,$402D
0402: DF          rst  $18
0403: C9          ret
0404: CF          rst  $08
0405: CB E6       set  4,(hl)
0407: 21 2F 40    ld   hl,$402F
040A: 18 EE       jr   $03FA
040C: DD CB 00 E6 set  4,(ix+$00)
0410: 37          scf
0411: C9          ret
0412: DD CB 00 DE set  3,(ix+$00)
0416: 37          scf
0417: C9          ret
0418: DD CB 00 A6 res  4,(ix+$00)
041C: DD CB 00 9E res  3,(ix+$00)
0420: 37          scf
0421: C9          ret
0422: 21 22 40    ld   hl,$4022
0425: 06 0D       ld   b,$0D
0427: 0E 01       ld   c,$01
0429: AF          xor  a
042A: D3 00       out  ($00),a
042C: 3C          inc  a
042D: ED A3       outi
042F: 20 F9       jr   nz,$042A
0431: CB 7E       bit  7,(hl)
0433: 20 06       jr   nz,$043B
0435: D3 00       out  ($00),a
0437: CB FE       set  7,(hl)
0439: ED A3       outi
043B: C9          ret
043C: 9E          sbc  a,(hl)
043D: 03          inc  bc
043E: A0          and  b
043F: 03          inc  bc
0440: B2          or   d
0441: 03          inc  bc
0442: BC          cp   h
0443: 03          inc  bc
0444: BF          cp   a
0445: 03          inc  bc
0446: EC 03 C9    call pe,$C903
0449: 03          inc  bc
044A: CE 03       adc  a,$03
044C: D6 03       sub  $03
044E: F1          pop  af
044F: 03          inc  bc
0450: F7          rst  $30
0451: 03          inc  bc
0452: FF          rst  $38
0453: 03          inc  bc
0454: 04          inc  b
0455: 04          inc  b
0456: 0C          inc  c
0457: 04          inc  b
0458: 12          ld   (de),a
0459: 04          inc  b
045A: 18 04       jr   $0460
045C: A0          and  b
045D: 05          dec  b
045E: 50          ld   d,b
045F: 05          dec  b
0460: 02          ld   (bc),a
0461: 05          dec  b
0462: BA          cp   d
0463: 04          inc  b
0464: 76          halt
0465: 04          inc  b
0466: 38 04       jr   c,$046C
0468: FA 03 C2    jp   m,$C203
046B: 03          inc  bc
046C: 8C          adc  a,h
046D: 03          inc  bc
046E: 58          ld   e,b
046F: 03          inc  bc
0470: 28 03       jr   z,$0475
0472: FA 02 D0    jp   m,$D002
0475: 02          ld   (bc),a
0476: A8          xor  b
0477: 02          ld   (bc),a
0478: 81          add  a,c
0479: 02          ld   (bc),a
047A: 5D          ld   e,l
047B: 02          ld   (bc),a
047C: 3B          dec  sp
047D: 02          ld   (bc),a
047E: 1C          inc  e
047F: 02          ld   (bc),a
0480: FD          db   $fd
0481: 01 E1 01    ld   bc,$01E1
0484: C6 01       add  a,$01
0486: AC          xor  h
0487: 01 94 01    ld   bc,$0194
048A: 7D          ld   a,l
048B: 01 68 01    ld   bc,$0168
048E: 54          ld   d,h
048F: 01 41 01    ld   bc,$0141
0492: 2F          cpl
0493: 01 1E 01    ld   bc,$011E
0496: 0E 01       ld   c,$01
0498: FF          rst  $38
0499: 00          nop
049A: F0          ret  p
049B: 00          nop
049C: E3          ex   (sp),hl
049D: 00          nop
049E: D6 00       sub  $00
04A0: CA 00 BF    jp   z,$BF00
04A3: 00          nop
04A4: B4          or   h
04A5: 00          nop
04A6: AA          xor  d
04A7: 00          nop
04A8: A0          and  b
04A9: 00          nop
04AA: 97          sub  a
04AB: 00          nop
04AC: 8F          adc  a,a
04AD: 00          nop
04AE: 87          add  a,a
04AF: 00          nop
04B0: 7F          ld   a,a
04B1: 00          nop
04B2: 78          ld   a,b
04B3: 00          nop
04B4: 71          ld   (hl),c
04B5: 00          nop
04B6: 6B          ld   l,e
04B7: 00          nop
04B8: 65          ld   h,l
04B9: 00          nop
04BA: 5F          ld   e,a
04BB: 00          nop
04BC: 5A          ld   e,d
04BD: 00          nop
04BE: 55          ld   d,l
04BF: 00          nop
04C0: 50          ld   d,b
04C1: 00          nop
04C2: 4C          ld   c,h
04C3: 00          nop
04C4: 47          ld   b,a
04C5: 00          nop
04C6: 43          ld   b,e
04C7: 00          nop
04C8: 40          ld   b,b
04C9: 00          nop
04CA: 3C          inc  a
04CB: 00          nop
04CC: 39          add  hl,sp
04CD: 00          nop
04CE: 36 00       ld   (hl),$00
04D0: 33          inc  sp
04D1: 00          nop
04D2: 30 00       jr   nc,$04D4
04D4: 2D          dec  l
04D5: 00          nop
04D6: 2A 00 28    ld   hl,($2800)
04D9: 00          nop
04DA: 26 00       ld   h,$00
04DC: 23          inc  hl
04DD: 00          nop
04DE: 21 00 20    ld   hl,$2000
04E1: 00          nop
04E2: 1E 00       ld   e,$00
04E4: 1C          inc  e
04E5: 00          nop
04E6: 1B          dec  de
04E7: 00          nop
04E8: 19          add  hl,de
04E9: 00          nop
04EA: 18 00       jr   $04EC
04EC: 16 00       ld   d,$00
04EE: 01 01 01    ld   bc,$0101
04F1: 02          ld   (bc),a
04F2: 01 03 01    ld   bc,$0103
04F5: 04          inc  b
04F6: 01 05 01    ld   bc,$0105
04F9: 06 01       ld   b,$01
04FB: 07          rlca
04FC: 01 08 01    ld   bc,$0108
04FF: 1B          dec  de
0500: 01 09 01    ld   bc,$0109
0503: 0A          ld   a,(bc)
0504: 02          ld   (bc),a
0505: 0B          dec  bc
0506: 03          inc  bc
0507: 0D          dec  c
0508: 03          inc  bc
0509: 10 03       djnz $050E
050B: 13          inc  de
050C: 03          inc  bc
050D: 16 02       ld   d,$02
050F: 19          add  hl,de
0510: 09          add  hl,bc
0511: 8D          adc  a,l
0512: FA 8C 1F    jp   m,$1F8C
0515: 8D          adc  a,l
0516: FA 8C 2C    jp   m,$2C8C
0519: 0D          dec  c
051A: 4D          ld   c,l
051B: 0D          dec  c
051C: 67          ld   h,a
051D: 0E 09       ld   c,$09
051F: 0E 80       ld   c,$80
0521: 8F          adc  a,a
0522: D6 0E       sub  $0E
0524: 54          ld   d,h
0525: 0C          inc  c
0526: A7          and  a
0527: 0C          inc  c
0528: 46          ld   b,(hl)
0529: 05          dec  b
052A: 92          sub  d
052B: 05          dec  b
052C: 1F          rra
052D: 06 B3       ld   b,$B3
052F: 06 2C       ld   b,$2C
0531: 07          rlca
0532: C2 07 7B    jp   nz,$7B07
0535: 88          adc  a,b
0536: 2E 89       ld   l,$89
0538: E0          ret  po
0539: 89          adc  a,c
053A: 1B          dec  de
053B: 0B          dec  bc
053C: AF          xor  a
053D: 0B          dec  bc
053E: 00          nop
053F: 0C          inc  c
0540: 54          ld   d,h
0541: 0C          inc  c
0542: 54          ld   d,h
0543: 0C          inc  c
0544: CA 0F 04    jp   z,$040F
0547: 05          dec  b
0548: 02          ld   (bc),a
0549: 0F          rrca
054A: F3          di
054B: F3          di
054C: F3          di
054D: F3          di
054E: 08          ex   af,af'
054F: 1B          dec  de
0550: 18 1C       jr   $056E
0552: 03          inc  bc
0553: 38 1F       jr   c,$0574
0555: 33          inc  sp
0556: 38 21       jr   c,$0579
0558: 33          inc  sp
0559: 38 22       jr   c,$057D
055B: 33          inc  sp
055C: 28 23       jr   z,$0581
055E: 03          inc  bc
055F: 08          ex   af,af'
0560: 1B          dec  de
0561: 18 1C       jr   $057F
0563: 03          inc  bc
0564: 38 1F       jr   c,$0585
0566: 33          inc  sp
0567: 38 21       jr   c,$058A
0569: 33          inc  sp
056A: 38 22       jr   c,$058E
056C: 33          inc  sp
056D: 28 23       jr   z,$0592
056F: 03          inc  bc
0570: 08          ex   af,af'
0571: 1B          dec  de
0572: 18 1C       jr   $0590
0574: 03          inc  bc
0575: 28 1A       jr   z,$0591
0577: 03          inc  bc
0578: 28 17       jr   z,$0591
057A: 03          inc  bc
057B: 28 1A       jr   z,$0597
057D: 03          inc  bc
057E: 08          ex   af,af'
057F: 1B          dec  de
0580: 18 1C       jr   $059E
0582: 03          inc  bc
0583: 38 1F       jr   c,$05A4
0585: 33          inc  sp
0586: 38 20       jr   c,$05A8
0588: 33          inc  sp
0589: 38 21       jr   c,$05AC
058B: 33          inc  sp
058C: 28 22       jr   z,$05B0
058E: 03          inc  bc
058F: 38 23       jr   c,$05B4
0591: FF          rst  $38
0592: 04          inc  b
0593: 05          dec  b
0594: 02          ld   (bc),a
0595: 0F          rrca
0596: 0D          dec  c
0597: 0E 18       ld   c,$18
0599: 10 18       djnz $05B3
059B: 10 38       djnz $05D5
059D: 10 18       djnz $05B7
059F: 10 18       djnz $05B9
05A1: 10 38       djnz $05DB
05A3: 10 18       djnz $05BD
05A5: 10 18       djnz $05BF
05A7: 10 38       djnz $05E1
05A9: 10 18       djnz $05C3
05AB: 10 18       djnz $05C5
05AD: 10 38       djnz $05E7
05AF: 10 18       djnz $05C9
05B1: 10 18       djnz $05CB
05B3: 10 38       djnz $05ED
05B5: 10 18       djnz $05CF
05B7: 10 18       djnz $05D1
05B9: 10 38       djnz $05F3
05BB: 10 18       djnz $05D5
05BD: 10 18       djnz $05D7
05BF: 10 38       djnz $05F9
05C1: 10 18       djnz $05DB
05C3: 10 18       djnz $05DD
05C5: 10 38       djnz $05FF
05C7: 10 18       djnz $05E1
05C9: 10 18       djnz $05E3
05CB: 10 38       djnz $0605
05CD: 1C          inc  e
05CE: 18 10       jr   $05E0
05D0: 18 10       jr   $05E2
05D2: 38 1C       jr   c,$05F0
05D4: 18 10       jr   $05E6
05D6: 18 10       jr   $05E8
05D8: 38 1C       jr   c,$05F6
05DA: 18 10       jr   $05EC
05DC: 18 10       jr   $05EE
05DE: 38 1C       jr   c,$05FC
05E0: 18 10       jr   $05F2
05E2: 18 10       jr   $05F4
05E4: 38 1C       jr   c,$0602
05E6: 18 10       jr   $05F8
05E8: 18 10       jr   $05FA
05EA: 38 1C       jr   c,$0608
05EC: 18 10       jr   $05FE
05EE: 18 10       jr   $0600
05F0: 38 1C       jr   c,$060E
05F2: 18 10       jr   $0604
05F4: 18 10       jr   $0606
05F6: 38 1C       jr   c,$0614
05F8: 18 10       jr   $060A
05FA: 18 10       jr   $060C
05FC: 38 1C       jr   c,$061A
05FE: 18 10       jr   $0610
0600: 18 10       jr   $0612
0602: 38 1C       jr   c,$0620
0604: 18 10       jr   $0616
0606: 18 10       jr   $0618
0608: 38 1C       jr   c,$0626
060A: 18 10       jr   $061C
060C: 18 10       jr   $061E
060E: 38 1C       jr   c,$062C
0610: 18 10       jr   $0622
0612: 18 10       jr   $0624
0614: 38 1C       jr   c,$0632
0616: 18 10       jr   $0628
0618: 18 10       jr   $062A
061A: 38 1C       jr   c,$0638
061C: 58          ld   e,b
061D: 1C          inc  e
061E: FF          rst  $38
061F: 04          inc  b
0620: 05          dec  b
0621: 02          ld   (bc),a
0622: 0D          dec  c
0623: 0D          dec  c
0624: 0E 09       ld   c,$09
0626: 0A          ld   a,(bc)
0627: 05          dec  b
0628: 38 1F       jr   c,$0649
062A: 38 1F       jr   c,$064B
062C: 0A          ld   a,(bc)
062D: 0A          ld   a,(bc)
062E: 38 1F       jr   c,$064F
0630: 0A          ld   a,(bc)
0631: 05          dec  b
0632: 38 1F       jr   c,$0653
0634: 38 1F       jr   c,$0655
0636: 38 1F       jr   c,$0657
0638: 0A          ld   a,(bc)
0639: 0A          ld   a,(bc)
063A: 38 1F       jr   c,$065B
063C: 0A          ld   a,(bc)
063D: 05          dec  b
063E: 38 1F       jr   c,$065F
0640: 0A          ld   a,(bc)
0641: 05          dec  b
0642: 38 1F       jr   c,$0663
0644: 38 1F       jr   c,$0665
0646: 0A          ld   a,(bc)
0647: 0A          ld   a,(bc)
0648: 38 1F       jr   c,$0669
064A: 0A          ld   a,(bc)
064B: 05          dec  b
064C: 38 1F       jr   c,$066D
064E: 38 1F       jr   c,$066F
0650: 38 1F       jr   c,$0671
0652: 0A          ld   a,(bc)
0653: 0A          ld   a,(bc)
0654: 38 1F       jr   c,$0675
0656: 0A          ld   a,(bc)
0657: 05          dec  b
0658: 38 1F       jr   c,$0679
065A: 0A          ld   a,(bc)
065B: 05          dec  b
065C: 38 1F       jr   c,$067D
065E: 38 1F       jr   c,$067F
0660: 0A          ld   a,(bc)
0661: 0A          ld   a,(bc)
0662: 38 1F       jr   c,$0683
0664: 0A          ld   a,(bc)
0665: 05          dec  b
0666: 38 1F       jr   c,$0687
0668: 38 23       jr   c,$068D
066A: 38 23       jr   c,$068F
066C: 0A          ld   a,(bc)
066D: 0A          ld   a,(bc)
066E: 38 23       jr   c,$0693
0670: 0A          ld   a,(bc)
0671: 05          dec  b
0672: 38 23       jr   c,$0697
0674: 38 1F       jr   c,$0695
0676: 38 1F       jr   c,$0697
0678: 0A          ld   a,(bc)
0679: 0A          ld   a,(bc)
067A: 38 1F       jr   c,$069B
067C: 0A          ld   a,(bc)
067D: 05          dec  b
067E: 38 1F       jr   c,$069F
0680: 38 23       jr   c,$06A5
0682: 38 23       jr   c,$06A7
0684: 0A          ld   a,(bc)
0685: 0A          ld   a,(bc)
0686: 38 23       jr   c,$06AB
0688: 0A          ld   a,(bc)
0689: 05          dec  b
068A: 38 23       jr   c,$06AF
068C: 38 1F       jr   c,$06AD
068E: 38 1F       jr   c,$06AF
0690: 0A          ld   a,(bc)
0691: 0A          ld   a,(bc)
0692: 38 1F       jr   c,$06B3
0694: 0A          ld   a,(bc)
0695: 05          dec  b
0696: 38 1F       jr   c,$06B7
0698: 38 21       jr   c,$06BB
069A: 38 21       jr   c,$06BD
069C: 0A          ld   a,(bc)
069D: 0A          ld   a,(bc)
069E: 38 21       jr   c,$06C1
06A0: 0A          ld   a,(bc)
06A1: 05          dec  b
06A2: 38 21       jr   c,$06C5
06A4: 38 22       jr   c,$06C8
06A6: 38 22       jr   c,$06CA
06A8: 0A          ld   a,(bc)
06A9: 0A          ld   a,(bc)
06AA: 38 22       jr   c,$06CE
06AC: 0A          ld   a,(bc)
06AD: 05          dec  b
06AE: 38 22       jr   c,$06D2
06B0: 58          ld   e,b
06B1: 23          inc  hl
06B2: FF          rst  $38
06B3: 04          inc  b
06B4: 02          ld   (bc),a
06B5: 02          ld   (bc),a
06B6: 0F          rrca
06B7: 03          inc  bc
06B8: 38 24       jr   c,$06DE
06BA: 33          inc  sp
06BB: 38 2B       jr   c,$06E8
06BD: B3          or   e
06BE: 38 24       jr   c,$06E4
06C0: 33          inc  sp
06C1: 38 2B       jr   c,$06EE
06C3: 33          inc  sp
06C4: 38 2A       jr   c,$06F0
06C6: 33          inc  sp
06C7: 38 29       jr   c,$06F2
06C9: 33          inc  sp
06CA: 38 28       jr   c,$06F4
06CC: 33          inc  sp
06CD: 38 24       jr   c,$06F3
06CF: 33          inc  sp
06D0: 38 2B       jr   c,$06FD
06D2: B3          or   e
06D3: 38 24       jr   c,$06F9
06D5: 33          inc  sp
06D6: 38 2B       jr   c,$0703
06D8: 33          inc  sp
06D9: 38 2A       jr   c,$0705
06DB: 33          inc  sp
06DC: 38 29       jr   c,$0707
06DE: 33          inc  sp
06DF: 38 28       jr   c,$0709
06E1: 33          inc  sp
06E2: 38 29       jr   c,$070D
06E4: 33          inc  sp
06E5: 38 30       jr   c,$0717
06E7: B3          or   e
06E8: 38 29       jr   c,$0713
06EA: 33          inc  sp
06EB: 38 30       jr   c,$071D
06ED: 33          inc  sp
06EE: 38 2F       jr   c,$071F
06F0: 33          inc  sp
06F1: 38 2E       jr   c,$0721
06F3: 33          inc  sp
06F4: 38 2D       jr   c,$0723
06F6: 33          inc  sp
06F7: 38 29       jr   c,$0722
06F9: 33          inc  sp
06FA: 38 30       jr   c,$072C
06FC: B3          or   e
06FD: 38 29       jr   c,$0728
06FF: 33          inc  sp
0700: 38 30       jr   c,$0732
0702: 33          inc  sp
0703: 38 2F       jr   c,$0734
0705: 33          inc  sp
0706: 38 2E       jr   c,$0736
0708: 33          inc  sp
0709: 38 2D       jr   c,$0738
070B: 33          inc  sp
070C: 38 2B       jr   c,$0739
070E: 33          inc  sp
070F: 38 32       jr   c,$0743
0711: B3          or   e
0712: 38 2B       jr   c,$073F
0714: 33          inc  sp
0715: 78          ld   a,b
0716: 32 78 2F    ld   ($2F78),a
0719: 78          ld   a,b
071A: 2B          dec  hl
071B: 73          ld   (hl),e
071C: 38 2B       jr   c,$0749
071E: 33          inc  sp
071F: 38 32       jr   c,$0753
0721: B3          or   e
0722: 38 2F       jr   c,$0753
0724: 33          inc  sp
0725: 78          ld   a,b
0726: 32 78 34    ld   ($3478),a
0729: F8          ret  m
072A: 35          dec  (hl)
072B: FF          rst  $38
072C: 04          inc  b
072D: 02          ld   (bc),a
072E: 02          ld   (bc),a
072F: 0E 03       ld   c,$03
0731: 18 0C       jr   $073F
0733: 53          ld   d,e
0734: 58          ld   e,b
0735: 0C          inc  c
0736: 13          inc  de
0737: 18 0C       jr   $0745
0739: 53          ld   d,e
073A: 58          ld   e,b
073B: 0C          inc  c
073C: 13          inc  de
073D: 18 0C       jr   $074B
073F: 53          ld   d,e
0740: 58          ld   e,b
0741: 0C          inc  c
0742: 13          inc  de
0743: 18 0C       jr   $0751
0745: 53          ld   d,e
0746: 58          ld   e,b
0747: 0C          inc  c
0748: 13          inc  de
0749: 18 0C       jr   $0757
074B: 53          ld   d,e
074C: 58          ld   e,b
074D: 0C          inc  c
074E: 13          inc  de
074F: 18 0C       jr   $075D
0751: 53          ld   d,e
0752: 58          ld   e,b
0753: 0C          inc  c
0754: 13          inc  de
0755: 18 0C       jr   $0763
0757: 53          ld   d,e
0758: 58          ld   e,b
0759: 0C          inc  c
075A: 13          inc  de
075B: 18 0C       jr   $0769
075D: 53          ld   d,e
075E: 58          ld   e,b
075F: 0C          inc  c
0760: 13          inc  de
0761: 18 11       jr   $0774
0763: 53          ld   d,e
0764: 58          ld   e,b
0765: 11 13 18    ld   de,$1813
0768: 11 53 58    ld   de,$5853
076B: 11 13 18    ld   de,$1813
076E: 11 53 58    ld   de,$5853
0771: 11 13 18    ld   de,$1813
0774: 11 53 58    ld   de,$5853
0777: 11 13 18    ld   de,$1813
077A: 11 53 58    ld   de,$5853
077D: 11 13 18    ld   de,$1813
0780: 11 53 58    ld   de,$5853
0783: 11 13 18    ld   de,$1813
0786: 11 53 58    ld   de,$5853
0789: 11 13 18    ld   de,$1813
078C: 12          ld   (de),a
078D: 53          ld   d,e
078E: 58          ld   e,b
078F: 12          ld   (de),a
0790: 13          inc  de
0791: 18 13       jr   $07A6
0793: 53          ld   d,e
0794: 58          ld   e,b
0795: 13          inc  de
0796: 13          inc  de
0797: 18 13       jr   $07AC
0799: 53          ld   d,e
079A: 58          ld   e,b
079B: 13          inc  de
079C: 13          inc  de
079D: 18 13       jr   $07B2
079F: 53          ld   d,e
07A0: 58          ld   e,b
07A1: 13          inc  de
07A2: 13          inc  de
07A3: 18 13       jr   $07B8
07A5: 53          ld   d,e
07A6: 58          ld   e,b
07A7: 13          inc  de
07A8: 13          inc  de
07A9: 18 13       jr   $07BE
07AB: 53          ld   d,e
07AC: 58          ld   e,b
07AD: 13          inc  de
07AE: 13          inc  de
07AF: 18 13       jr   $07C4
07B1: 53          ld   d,e
07B2: 58          ld   e,b
07B3: 13          inc  de
07B4: 13          inc  de
07B5: 18 13       jr   $07CA
07B7: 53          ld   d,e
07B8: 58          ld   e,b
07B9: 13          inc  de
07BA: 13          inc  de
07BB: 18 13       jr   $07D0
07BD: 53          ld   d,e
07BE: 58          ld   e,b
07BF: 13          inc  de
07C0: 13          inc  de
07C1: FF          rst  $38
07C2: 04          inc  b
07C3: 03          inc  bc
07C4: 02          ld   (bc),a
07C5: 0A          ld   a,(bc)
07C6: 09          add  hl,bc
07C7: 01 00 00    ld   bc,$0000
07CA: 0D          dec  c
07CB: 0E 0A       ld   c,$0A
07CD: 05          dec  b
07CE: 57          ld   d,a
07CF: 0A          ld   a,(bc)
07D0: 05          dec  b
07D1: 57          ld   d,a
07D2: 02          ld   (bc),a
07D3: 0C          inc  c
07D4: 0A          ld   a,(bc)
07D5: 0A          ld   a,(bc)
07D6: 57          ld   d,a
07D7: 02          ld   (bc),a
07D8: 0A          ld   a,(bc)
07D9: 0A          ld   a,(bc)
07DA: 05          dec  b
07DB: 57          ld   d,a
07DC: 0A          ld   a,(bc)
07DD: 05          dec  b
07DE: 57          ld   d,a
07DF: 0A          ld   a,(bc)
07E0: 05          dec  b
07E1: 57          ld   d,a
07E2: 02          ld   (bc),a
07E3: 0C          inc  c
07E4: 0A          ld   a,(bc)
07E5: 0A          ld   a,(bc)
07E6: 57          ld   d,a
07E7: 02          ld   (bc),a
07E8: 0A          ld   a,(bc)
07E9: 0A          ld   a,(bc)
07EA: 05          dec  b
07EB: 57          ld   d,a
07EC: 0A          ld   a,(bc)
07ED: 05          dec  b
07EE: 57          ld   d,a
07EF: 0A          ld   a,(bc)
07F0: 05          dec  b
07F1: 57          ld   d,a
07F2: 02          ld   (bc),a
07F3: 0C          inc  c
07F4: 0A          ld   a,(bc)
07F5: 0A          ld   a,(bc)
07F6: 57          ld   d,a
07F7: 02          ld   (bc),a
07F8: 0A          ld   a,(bc)
07F9: 0A          ld   a,(bc)
07FA: 05          dec  b
07FB: 57          ld   d,a
07FC: 0A          ld   a,(bc)
07FD: 05          dec  b
07FE: 57          ld   d,a
07FF: 0A          ld   a,(bc)
0800: 05          dec  b
0801: 57          ld   d,a
0802: 02          ld   (bc),a
0803: 0C          inc  c
0804: 0A          ld   a,(bc)
0805: 0A          ld   a,(bc)
0806: 57          ld   d,a
0807: 02          ld   (bc),a
0808: 0A          ld   a,(bc)
0809: 0A          ld   a,(bc)
080A: 05          dec  b
080B: 57          ld   d,a
080C: 0A          ld   a,(bc)
080D: 05          dec  b
080E: 57          ld   d,a
080F: 0A          ld   a,(bc)
0810: 05          dec  b
0811: 57          ld   d,a
0812: 02          ld   (bc),a
0813: 0C          inc  c
0814: 0A          ld   a,(bc)
0815: 0A          ld   a,(bc)
0816: 57          ld   d,a
0817: 02          ld   (bc),a
0818: 0A          ld   a,(bc)
0819: 0A          ld   a,(bc)
081A: 05          dec  b
081B: 57          ld   d,a
081C: 0A          ld   a,(bc)
081D: 05          dec  b
081E: 57          ld   d,a
081F: 0A          ld   a,(bc)
0820: 05          dec  b
0821: 57          ld   d,a
0822: 02          ld   (bc),a
0823: 0C          inc  c
0824: 0A          ld   a,(bc)
0825: 0A          ld   a,(bc)
0826: 57          ld   d,a
0827: 02          ld   (bc),a
0828: 0A          ld   a,(bc)
0829: 0A          ld   a,(bc)
082A: 05          dec  b
082B: 57          ld   d,a
082C: 0A          ld   a,(bc)
082D: 05          dec  b
082E: 57          ld   d,a
082F: 57          ld   d,a
0830: 02          ld   (bc),a
0831: 0C          inc  c
0832: 0A          ld   a,(bc)
0833: 0A          ld   a,(bc)
0834: 57          ld   d,a
0835: 02          ld   (bc),a
0836: 0A          ld   a,(bc)
0837: 0A          ld   a,(bc)
0838: 05          dec  b
0839: 57          ld   d,a
083A: 57          ld   d,a
083B: 57          ld   d,a
083C: 02          ld   (bc),a
083D: 0C          inc  c
083E: 0A          ld   a,(bc)
083F: 0A          ld   a,(bc)
0840: 57          ld   d,a
0841: 02          ld   (bc),a
0842: 0A          ld   a,(bc)
0843: 0A          ld   a,(bc)
0844: 05          dec  b
0845: 57          ld   d,a
0846: 57          ld   d,a
0847: 57          ld   d,a
0848: 02          ld   (bc),a
0849: 0C          inc  c
084A: 0A          ld   a,(bc)
084B: 0A          ld   a,(bc)
084C: 57          ld   d,a
084D: 02          ld   (bc),a
084E: 0A          ld   a,(bc)
084F: 0A          ld   a,(bc)
0850: 05          dec  b
0851: 57          ld   d,a
0852: 57          ld   d,a
0853: 57          ld   d,a
0854: 02          ld   (bc),a
0855: 0C          inc  c
0856: 0A          ld   a,(bc)
0857: 0A          ld   a,(bc)
0858: 57          ld   d,a
0859: 02          ld   (bc),a
085A: 0A          ld   a,(bc)
085B: 0A          ld   a,(bc)
085C: 05          dec  b
085D: 57          ld   d,a
085E: 57          ld   d,a
085F: 57          ld   d,a
0860: 02          ld   (bc),a
0861: 0C          inc  c
0862: 0A          ld   a,(bc)
0863: 0A          ld   a,(bc)
0864: 57          ld   d,a
0865: 02          ld   (bc),a
0866: 0A          ld   a,(bc)
0867: 0A          ld   a,(bc)
0868: 05          dec  b
0869: 57          ld   d,a
086A: 57          ld   d,a
086B: 57          ld   d,a
086C: 02          ld   (bc),a
086D: 0C          inc  c
086E: 0A          ld   a,(bc)
086F: 0A          ld   a,(bc)
0870: 17          rla
0871: 02          ld   (bc),a
0872: 0A          ld   a,(bc)
0873: 0A          ld   a,(bc)
0874: 05          dec  b
0875: 17          rla
0876: 17          rla
0877: 17          rla
0878: 17          rla
0879: 17          rla
087A: FF          rst  $38
087B: 04          inc  b
087C: 07          rlca
087D: 02          ld   (bc),a
087E: 0E 0E       ld   c,$0E
0880: 0D          dec  c
0881: F8          ret  m
0882: 28 78       jr   z,$08FC
0884: 27          daa
0885: F8          ret  m
0886: 28 78       jr   z,$0900
0888: 29          add  hl,hl
0889: 0F          rrca
088A: F8          ret  m
088B: 28 F8       jr   z,$0885
088D: 28 0E       jr   z,$089D
088F: 0D          dec  c
0890: 78          ld   a,b
0891: 28 78       jr   z,$090B
0893: 28 F8       jr   z,$088D
0895: 29          add  hl,hl
0896: 78          ld   a,b
0897: 29          add  hl,hl
0898: 78          ld   a,b
0899: 29          add  hl,hl
089A: 78          ld   a,b
089B: 28 78       jr   z,$0915
089D: 29          add  hl,hl
089E: 0F          rrca
089F: F8          ret  m
08A0: 28 F8       jr   z,$089A
08A2: 28 0E       jr   z,$08B2
08A4: 0D          dec  c
08A5: F8          ret  m
08A6: 28 F8       jr   z,$08A0
08A8: 28 78       jr   z,$0922
08AA: 27          daa
08AB: F8          ret  m
08AC: 28 78       jr   z,$0926
08AE: 29          add  hl,hl
08AF: 0F          rrca
08B0: F8          ret  m
08B1: 28 F8       jr   z,$08AB
08B3: 28 0E       jr   z,$08C3
08B5: 0D          dec  c
08B6: 78          ld   a,b
08B7: 28 78       jr   z,$0931
08B9: 28 78       jr   z,$0933
08BB: 29          add  hl,hl
08BC: 78          ld   a,b
08BD: 2D          dec  l
08BE: 78          ld   a,b
08BF: 30 78       jr   nc,$0939
08C1: 2B          dec  hl
08C2: 78          ld   a,b
08C3: 2F          cpl
08C4: 78          ld   a,b
08C5: 32 78 2D    ld   ($2D78),a
08C8: 78          ld   a,b
08C9: 30 78       jr   nc,$0943
08CB: 34          inc  (hl)
08CC: 78          ld   a,b
08CD: 2F          cpl
08CE: 78          ld   a,b
08CF: 32 78 35    ld   ($3578),a
08D2: 78          ld   a,b
08D3: 37          scf
08D4: 78          ld   a,b
08D5: 36 78       ld   (hl),$78
08D7: 35          dec  (hl)
08D8: 78          ld   a,b
08D9: 34          inc  (hl)
08DA: 78          ld   a,b
08DB: 2F          cpl
08DC: 78          ld   a,b
08DD: 32 0F F8    ld   ($F80F),a
08E0: 30 F8       jr   nc,$08DA
08E2: 30 0D       jr   nc,$08F1
08E4: 0E F8       ld   c,$F8
08E6: 30 0F       jr   nc,$08F7
08E8: F8          ret  m
08E9: 35          dec  (hl)
08EA: F8          ret  m
08EB: 35          dec  (hl)
08EC: 0D          dec  c
08ED: 0E F8       ld   c,$F8
08EF: 35          dec  (hl)
08F0: 0F          rrca
08F1: F8          ret  m
08F2: 34          inc  (hl)
08F3: F8          ret  m
08F4: 34          inc  (hl)
08F5: 0D          dec  c
08F6: 0E F8       ld   c,$F8
08F8: 34          inc  (hl)
08F9: 0F          rrca
08FA: F8          ret  m
08FB: 30 F8       jr   nc,$08F5
08FD: 30 0D       jr   nc,$090C
08FF: 0E F8       ld   c,$F8
0901: 30 0F       jr   nc,$0912
0903: F8          ret  m
0904: 30 F8       jr   nc,$08FE
0906: 30 0D       jr   nc,$0915
0908: 0E F8       ld   c,$F8
090A: 30 0F       jr   nc,$091B
090C: 04          inc  b
090D: 09          add  hl,bc
090E: F8          ret  m
090F: 35          dec  (hl)
0910: 0E 0D       ld   c,$0D
0912: 78          ld   a,b
0913: 35          dec  (hl)
0914: 0F          rrca
0915: F8          ret  m
0916: 34          inc  (hl)
0917: 0E 0D       ld   c,$0D
0919: 78          ld   a,b
091A: 34          inc  (hl)
091B: 0F          rrca
091C: F8          ret  m
091D: 32 0E 0D    ld   ($0D0E),a
0920: 78          ld   a,b
0921: 32 0F B8    ld   ($B80F),a
0924: 30 0E       jr   nc,$0934
0926: 0D          dec  c
0927: 04          inc  b
0928: 07          rlca
0929: F8          ret  m
092A: 30 F3       jr   nc,$091F
092C: F3          di
092D: FF          rst  $38
092E: 04          inc  b
092F: 07          rlca
0930: 02          ld   (bc),a
0931: 0D          dec  c
0932: 0E F8       ld   c,$F8
0934: 24          inc  h
0935: 78          ld   a,b
0936: 24          inc  h
0937: F8          ret  m
0938: 24          inc  h
0939: 78          ld   a,b
093A: 26 0F       ld   h,$0F
093C: F8          ret  m
093D: 24          inc  h
093E: F8          ret  m
093F: 24          inc  h
0940: 0E 78       ld   c,$78
0942: 24          inc  h
0943: 78          ld   a,b
0944: 24          inc  h
0945: F8          ret  m
0946: 26 78       ld   h,$78
0948: 26 78       ld   h,$78
094A: 26 78       ld   h,$78
094C: 24          inc  h
094D: 78          ld   a,b
094E: 26 0F       ld   h,$0F
0950: F8          ret  m
0951: 24          inc  h
0952: F8          ret  m
0953: 24          inc  h
0954: 0E F8       ld   c,$F8
0956: 24          inc  h
0957: F8          ret  m
0958: 1F          rra
0959: 78          ld   a,b
095A: 1E F8       ld   e,$F8
095C: 1F          rra
095D: 78          ld   a,b
095E: 21 0F F8    ld   hl,$F80F
0961: 1F          rra
0962: F8          ret  m
0963: 1F          rra
0964: 0E 78       ld   c,$78
0966: 1F          rra
0967: 78          ld   a,b
0968: 20 78       jr   nz,$09E2
096A: 21 78 24    ld   hl,$2478
096D: 78          ld   a,b
096E: 29          add  hl,hl
096F: 78          ld   a,b
0970: 23          inc  hl
0971: 78          ld   a,b
0972: 26 78       ld   h,$78
0974: 2B          dec  hl
0975: 78          ld   a,b
0976: 24          inc  h
0977: 78          ld   a,b
0978: 28 78       jr   z,$09F2
097A: 2D          dec  l
097B: 78          ld   a,b
097C: 26 78       ld   h,$78
097E: 29          add  hl,hl
097F: 78          ld   a,b
0980: 2F          cpl
0981: 78          ld   a,b
0982: 54          ld   d,h
0983: 78          ld   a,b
0984: 54          ld   d,h
0985: 78          ld   a,b
0986: 54          ld   d,h
0987: 78          ld   a,b
0988: 54          ld   d,h
0989: 78          ld   a,b
098A: 54          ld   d,h
098B: 78          ld   a,b
098C: 54          ld   d,h
098D: 78          ld   a,b
098E: 54          ld   d,h
098F: 78          ld   a,b
0990: 54          ld   d,h
0991: 78          ld   a,b
0992: 54          ld   d,h
0993: 78          ld   a,b
0994: 54          ld   d,h
0995: 78          ld   a,b
0996: 54          ld   d,h
0997: 78          ld   a,b
0998: 54          ld   d,h
0999: 0F          rrca
099A: F8          ret  m
099B: 2D          dec  l
099C: F8          ret  m
099D: 2D          dec  l
099E: 0D          dec  c
099F: 0E F8       ld   c,$F8
09A1: 2D          dec  l
09A2: 0F          rrca
09A3: F8          ret  m
09A4: 2B          dec  hl
09A5: F8          ret  m
09A6: 2B          dec  hl
09A7: 0D          dec  c
09A8: 0E F8       ld   c,$F8
09AA: 2B          dec  hl
09AB: 0F          rrca
09AC: F8          ret  m
09AD: 29          add  hl,hl
09AE: F8          ret  m
09AF: 29          add  hl,hl
09B0: 0D          dec  c
09B1: 0E F8       ld   c,$F8
09B3: 29          add  hl,hl
09B4: 0F          rrca
09B5: F8          ret  m
09B6: 28 F8       jr   z,$09B0
09B8: 28 0D       jr   z,$09C7
09BA: 0E F8       ld   c,$F8
09BC: 28 0F       jr   z,$09CD
09BE: 04          inc  b
09BF: 09          add  hl,bc
09C0: F8          ret  m
09C1: 2D          dec  l
09C2: 0E 0D       ld   c,$0D
09C4: 78          ld   a,b
09C5: 2D          dec  l
09C6: 0F          rrca
09C7: F8          ret  m
09C8: 2B          dec  hl
09C9: 0E 0D       ld   c,$0D
09CB: 78          ld   a,b
09CC: 2B          dec  hl
09CD: 0F          rrca
09CE: F8          ret  m
09CF: 29          add  hl,hl
09D0: 0E 0D       ld   c,$0D
09D2: 78          ld   a,b
09D3: 29          add  hl,hl
09D4: 0F          rrca
09D5: B8          cp   b
09D6: 28 0E       jr   z,$09E6
09D8: 0D          dec  c
09D9: 04          inc  b
09DA: 07          rlca
09DB: F8          ret  m
09DC: 28 F3       jr   z,$09D1
09DE: F3          di
09DF: FF          rst  $38
09E0: 04          inc  b
09E1: 07          rlca
09E2: 02          ld   (bc),a
09E3: 0D          dec  c
09E4: 0D          dec  c
09E5: 0E 28       ld   c,$28
09E7: 0C          inc  c
09E8: 47          ld   b,a
09E9: 28 18       jr   z,$0A03
09EB: 47          ld   b,a
09EC: 28 18       jr   z,$0A06
09EE: 47          ld   b,a
09EF: 28 0C       jr   z,$09FD
09F1: 47          ld   b,a
09F2: 28 18       jr   z,$0A0C
09F4: 47          ld   b,a
09F5: 28 18       jr   z,$0A0F
09F7: 47          ld   b,a
09F8: 28 0C       jr   z,$0A06
09FA: 47          ld   b,a
09FB: 28 18       jr   z,$0A15
09FD: 47          ld   b,a
09FE: 28 18       jr   z,$0A18
0A00: 47          ld   b,a
0A01: 28 0C       jr   z,$0A0F
0A03: 47          ld   b,a
0A04: 28 18       jr   z,$0A1E
0A06: 47          ld   b,a
0A07: 28 18       jr   z,$0A21
0A09: 47          ld   b,a
0A0A: 28 11       jr   z,$0A1D
0A0C: 47          ld   b,a
0A0D: 28 1D       jr   z,$0A2C
0A0F: 47          ld   b,a
0A10: 28 1D       jr   z,$0A2F
0A12: 47          ld   b,a
0A13: 28 11       jr   z,$0A26
0A15: 47          ld   b,a
0A16: 28 1D       jr   z,$0A35
0A18: 47          ld   b,a
0A19: 28 1D       jr   z,$0A38
0A1B: 47          ld   b,a
0A1C: 28 0C       jr   z,$0A2A
0A1E: 47          ld   b,a
0A1F: 28 18       jr   z,$0A39
0A21: 47          ld   b,a
0A22: 28 18       jr   z,$0A3C
0A24: 47          ld   b,a
0A25: 28 0C       jr   z,$0A33
0A27: 47          ld   b,a
0A28: 28 18       jr   z,$0A42
0A2A: 47          ld   b,a
0A2B: 28 18       jr   z,$0A45
0A2D: 47          ld   b,a
0A2E: 28 0C       jr   z,$0A3C
0A30: 47          ld   b,a
0A31: 28 18       jr   z,$0A4B
0A33: 47          ld   b,a
0A34: 28 18       jr   z,$0A4E
0A36: 47          ld   b,a
0A37: 28 0C       jr   z,$0A45
0A39: 47          ld   b,a
0A3A: 28 18       jr   z,$0A54
0A3C: 47          ld   b,a
0A3D: 28 18       jr   z,$0A57
0A3F: 47          ld   b,a
0A40: 28 0C       jr   z,$0A4E
0A42: 47          ld   b,a
0A43: 28 18       jr   z,$0A5D
0A45: 47          ld   b,a
0A46: 28 18       jr   z,$0A60
0A48: 47          ld   b,a
0A49: 28 0C       jr   z,$0A57
0A4B: 47          ld   b,a
0A4C: 28 18       jr   z,$0A66
0A4E: 47          ld   b,a
0A4F: 28 18       jr   z,$0A69
0A51: 47          ld   b,a
0A52: 28 11       jr   z,$0A65
0A54: 47          ld   b,a
0A55: 28 1D       jr   z,$0A74
0A57: 47          ld   b,a
0A58: 28 1D       jr   z,$0A77
0A5A: 47          ld   b,a
0A5B: 28 13       jr   z,$0A70
0A5D: 47          ld   b,a
0A5E: 28 1F       jr   z,$0A7F
0A60: 47          ld   b,a
0A61: 28 1F       jr   z,$0A82
0A63: 47          ld   b,a
0A64: 28 15       jr   z,$0A7B
0A66: 47          ld   b,a
0A67: 28 21       jr   z,$0A8A
0A69: 47          ld   b,a
0A6A: 28 21       jr   z,$0A8D
0A6C: 47          ld   b,a
0A6D: 28 17       jr   z,$0A86
0A6F: 47          ld   b,a
0A70: 28 23       jr   z,$0A95
0A72: 47          ld   b,a
0A73: 28 23       jr   z,$0A98
0A75: 47          ld   b,a
0A76: 0F          rrca
0A77: 78          ld   a,b
0A78: 24          inc  h
0A79: 78          ld   a,b
0A7A: 1F          rra
0A7B: 78          ld   a,b
0A7C: 1E 78       ld   e,$78
0A7E: 1F          rra
0A7F: 78          ld   a,b
0A80: 17          rla
0A81: 78          ld   a,b
0A82: 1F          rra
0A83: 78          ld   a,b
0A84: 18 0D       jr   $0A93
0A86: 0E 28       ld   c,$28
0A88: 0C          inc  c
0A89: 47          ld   b,a
0A8A: 28 0C       jr   z,$0A98
0A8C: 47          ld   b,a
0A8D: 28 0C       jr   z,$0A9B
0A8F: 47          ld   b,a
0A90: 28 0C       jr   z,$0A9E
0A92: 47          ld   b,a
0A93: 28 0C       jr   z,$0AA1
0A95: 47          ld   b,a
0A96: 28 11       jr   z,$0AA9
0A98: 47          ld   b,a
0A99: 28 1D       jr   z,$0AB8
0A9B: 47          ld   b,a
0A9C: 28 1D       jr   z,$0ABB
0A9E: 47          ld   b,a
0A9F: 28 11       jr   z,$0AB2
0AA1: 47          ld   b,a
0AA2: 28 1D       jr   z,$0AC1
0AA4: 47          ld   b,a
0AA5: 28 1D       jr   z,$0AC4
0AA7: 47          ld   b,a
0AA8: 28 0C       jr   z,$0AB6
0AAA: 47          ld   b,a
0AAB: 28 18       jr   z,$0AC5
0AAD: 47          ld   b,a
0AAE: 28 18       jr   z,$0AC8
0AB0: 47          ld   b,a
0AB1: 28 0C       jr   z,$0ABF
0AB3: 47          ld   b,a
0AB4: 28 18       jr   z,$0ACE
0AB6: 47          ld   b,a
0AB7: 28 18       jr   z,$0AD1
0AB9: 47          ld   b,a
0ABA: 28 11       jr   z,$0ACD
0ABC: 47          ld   b,a
0ABD: 28 1D       jr   z,$0ADC
0ABF: 47          ld   b,a
0AC0: 28 1D       jr   z,$0ADF
0AC2: 47          ld   b,a
0AC3: 28 11       jr   z,$0AD6
0AC5: 47          ld   b,a
0AC6: 28 1D       jr   z,$0AE5
0AC8: 47          ld   b,a
0AC9: 28 1D       jr   z,$0AE8
0ACB: 47          ld   b,a
0ACC: 28 0C       jr   z,$0ADA
0ACE: 47          ld   b,a
0ACF: 28 18       jr   z,$0AE9
0AD1: 47          ld   b,a
0AD2: 28 18       jr   z,$0AEC
0AD4: 47          ld   b,a
0AD5: 28 0C       jr   z,$0AE3
0AD7: 47          ld   b,a
0AD8: 28 18       jr   z,$0AF2
0ADA: 47          ld   b,a
0ADB: 28 18       jr   z,$0AF5
0ADD: 47          ld   b,a
0ADE: 0F          rrca
0ADF: 04          inc  b
0AE0: 09          add  hl,bc
0AE1: 02          ld   (bc),a
0AE2: 0F          rrca
0AE3: 38 1A       jr   c,$0AFF
0AE5: 38 18       jr   c,$0AFF
0AE7: 38 17       jr   c,$0B00
0AE9: 38 15       jr   c,$0B00
0AEB: 38 13       jr   c,$0B00
0AED: 38 11       jr   c,$0B00
0AEF: B8          cp   b
0AF0: 10 38       djnz $0B2A
0AF2: 18 73       jr   $0B67
0AF4: 38 1D       jr   c,$0B13
0AF6: 38 1C       jr   c,$0B14
0AF8: 38 1A       jr   c,$0B14
0AFA: 38 18       jr   c,$0B14
0AFC: 38 13       jr   c,$0B11
0AFE: 38 11       jr   c,$0B11
0B00: B8          cp   b
0B01: 10 0D       djnz $0B10
0B03: 0E 04       ld   c,$04
0B05: 07          rlca
0B06: 02          ld   (bc),a
0B07: 0D          dec  c
0B08: 28 18       jr   z,$0B22
0B0A: 47          ld   b,a
0B0B: 28 18       jr   z,$0B25
0B0D: 47          ld   b,a
0B0E: 28 18       jr   z,$0B28
0B10: 47          ld   b,a
0B11: 28 0C       jr   z,$0B1F
0B13: 47          ld   b,a
0B14: 28 18       jr   z,$0B2E
0B16: 47          ld   b,a
0B17: 28 18       jr   z,$0B31
0B19: 47          ld   b,a
0B1A: FF          rst  $38
0B1B: 04          inc  b
0B1C: 00          nop
0B1D: 02          ld   (bc),a
0B1E: 0F          rrca
0B1F: 09          add  hl,bc
0B20: 0E 0A       ld   c,$0A
0B22: 1E 08       ld   e,$08
0B24: 0F          rrca
0B25: 23          inc  hl
0B26: 07          rlca
0B27: 23          inc  hl
0B28: 07          rlca
0B29: 23          inc  hl
0B2A: 07          rlca
0B2B: 23          inc  hl
0B2C: 0A          ld   a,(bc)
0B2D: 19          add  hl,de
0B2E: 07          rlca
0B2F: 23          inc  hl
0B30: 07          rlca
0B31: 23          inc  hl
0B32: 07          rlca
0B33: 23          inc  hl
0B34: 07          rlca
0B35: 23          inc  hl
0B36: 0A          ld   a,(bc)
0B37: 15          dec  d
0B38: 07          rlca
0B39: 23          inc  hl
0B3A: 07          rlca
0B3B: 23          inc  hl
0B3C: 07          rlca
0B3D: 23          inc  hl
0B3E: 07          rlca
0B3F: 23          inc  hl
0B40: 0A          ld   a,(bc)
0B41: 12          ld   (de),a
0B42: 07          rlca
0B43: 23          inc  hl
0B44: 07          rlca
0B45: 23          inc  hl
0B46: 07          rlca
0B47: 23          inc  hl
0B48: 07          rlca
0B49: 23          inc  hl
0B4A: 0A          ld   a,(bc)
0B4B: 10 07       djnz $0B54
0B4D: 23          inc  hl
0B4E: 07          rlca
0B4F: 23          inc  hl
0B50: 07          rlca
0B51: 23          inc  hl
0B52: 07          rlca
0B53: 23          inc  hl
0B54: 0A          ld   a,(bc)
0B55: 0F          rrca
0B56: 07          rlca
0B57: 23          inc  hl
0B58: 07          rlca
0B59: 23          inc  hl
0B5A: 07          rlca
0B5B: 23          inc  hl
0B5C: 07          rlca
0B5D: 23          inc  hl
0B5E: 0A          ld   a,(bc)
0B5F: 0E 07       ld   c,$07
0B61: 23          inc  hl
0B62: 0A          ld   a,(bc)
0B63: 0D          dec  c
0B64: 07          rlca
0B65: 23          inc  hl
0B66: 0A          ld   a,(bc)
0B67: 0C          inc  c
0B68: 07          rlca
0B69: 23          inc  hl
0B6A: 0A          ld   a,(bc)
0B6B: 0B          dec  bc
0B6C: 07          rlca
0B6D: 23          inc  hl
0B6E: 0A          ld   a,(bc)
0B6F: 0A          ld   a,(bc)
0B70: 07          rlca
0B71: 23          inc  hl
0B72: 0A          ld   a,(bc)
0B73: 09          add  hl,bc
0B74: 07          rlca
0B75: 23          inc  hl
0B76: 0A          ld   a,(bc)
0B77: 08          ex   af,af'
0B78: 07          rlca
0B79: 23          inc  hl
0B7A: 0A          ld   a,(bc)
0B7B: 07          rlca
0B7C: 07          rlca
0B7D: 23          inc  hl
0B7E: 0A          ld   a,(bc)
0B7F: 06 07       ld   b,$07
0B81: 23          inc  hl
0B82: 0A          ld   a,(bc)
0B83: 05          dec  b
0B84: 07          rlca
0B85: 23          inc  hl
0B86: 0A          ld   a,(bc)
0B87: 04          inc  b
0B88: 07          rlca
0B89: 23          inc  hl
0B8A: 0A          ld   a,(bc)
0B8B: 03          inc  bc
0B8C: 07          rlca
0B8D: 23          inc  hl
0B8E: 0A          ld   a,(bc)
0B8F: 02          ld   (bc),a
0B90: 07          rlca
0B91: 23          inc  hl
0B92: 0A          ld   a,(bc)
0B93: 01 07 23    ld   bc,$2307
0B96: 0A          ld   a,(bc)
0B97: 00          nop
0B98: 37          scf
0B99: 73          ld   (hl),e
0B9A: 02          ld   (bc),a
0B9B: 0D          dec  c
0B9C: 37          scf
0B9D: 73          ld   (hl),e
0B9E: 02          ld   (bc),a
0B9F: 0B          dec  bc
0BA0: 37          scf
0BA1: 73          ld   (hl),e
0BA2: 02          ld   (bc),a
0BA3: 09          add  hl,bc
0BA4: 37          scf
0BA5: 73          ld   (hl),e
0BA6: 02          ld   (bc),a
0BA7: 07          rlca
0BA8: 37          scf
0BA9: 73          ld   (hl),e
0BAA: 02          ld   (bc),a
0BAB: 05          dec  b
0BAC: 37          scf
0BAD: 73          ld   (hl),e
0BAE: FF          rst  $38
0BAF: 04          inc  b
0BB0: 00          nop
0BB1: 02          ld   (bc),a
0BB2: 0F          rrca
0BB3: 09          add  hl,bc
0BB4: 0A          ld   a,(bc)
0BB5: 1E 08       ld   e,$08
0BB7: 10 23       djnz $0BDC
0BB9: 07          rlca
0BBA: 23          inc  hl
0BBB: 07          rlca
0BBC: 23          inc  hl
0BBD: 07          rlca
0BBE: 23          inc  hl
0BBF: 07          rlca
0BC0: 23          inc  hl
0BC1: 07          rlca
0BC2: 23          inc  hl
0BC3: 07          rlca
0BC4: 23          inc  hl
0BC5: 07          rlca
0BC6: 73          ld   (hl),e
0BC7: 0A          ld   a,(bc)
0BC8: 14          inc  d
0BC9: 07          rlca
0BCA: 23          inc  hl
0BCB: 07          rlca
0BCC: 23          inc  hl
0BCD: 07          rlca
0BCE: 23          inc  hl
0BCF: 07          rlca
0BD0: 23          inc  hl
0BD1: 07          rlca
0BD2: 23          inc  hl
0BD3: 07          rlca
0BD4: 23          inc  hl
0BD5: 07          rlca
0BD6: 23          inc  hl
0BD7: 07          rlca
0BD8: 73          ld   (hl),e
0BD9: 0A          ld   a,(bc)
0BDA: 0A          ld   a,(bc)
0BDB: 07          rlca
0BDC: 23          inc  hl
0BDD: 07          rlca
0BDE: 23          inc  hl
0BDF: 07          rlca
0BE0: 23          inc  hl
0BE1: 07          rlca
0BE2: 23          inc  hl
0BE3: 07          rlca
0BE4: 23          inc  hl
0BE5: 07          rlca
0BE6: 23          inc  hl
0BE7: 07          rlca
0BE8: 23          inc  hl
0BE9: 77          ld   (hl),a
0BEA: 73          ld   (hl),e
0BEB: 02          ld   (bc),a
0BEC: 0D          dec  c
0BED: 37          scf
0BEE: 73          ld   (hl),e
0BEF: 02          ld   (bc),a
0BF0: 0B          dec  bc
0BF1: 37          scf
0BF2: 73          ld   (hl),e
0BF3: 02          ld   (bc),a
0BF4: 09          add  hl,bc
0BF5: 37          scf
0BF6: 73          ld   (hl),e
0BF7: 02          ld   (bc),a
0BF8: 07          rlca
0BF9: 37          scf
0BFA: 73          ld   (hl),e
0BFB: 02          ld   (bc),a
0BFC: 05          dec  b
0BFD: 37          scf
0BFE: 73          ld   (hl),e
0BFF: FF          rst  $38
0C00: 04          inc  b
0C01: 00          nop
0C02: 02          ld   (bc),a
0C03: 0F          rrca
0C04: 09          add  hl,bc
0C05: 0D          dec  c
0C06: 0A          ld   a,(bc)
0C07: 05          dec  b
0C08: 08          ex   af,af'
0C09: 0C          inc  c
0C0A: 33          inc  sp
0C0B: 0A          ld   a,(bc)
0C0C: 0A          ld   a,(bc)
0C0D: 07          rlca
0C0E: 33          inc  sp
0C0F: 0A          ld   a,(bc)
0C10: 0F          rrca
0C11: 08          ex   af,af'
0C12: 0D          dec  c
0C13: 33          inc  sp
0C14: 0A          ld   a,(bc)
0C15: 0A          ld   a,(bc)
0C16: 07          rlca
0C17: 33          inc  sp
0C18: 0A          ld   a,(bc)
0C19: 0F          rrca
0C1A: 08          ex   af,af'
0C1B: 10 33       djnz $0C50
0C1D: 0A          ld   a,(bc)
0C1E: 14          inc  d
0C1F: 07          rlca
0C20: 33          inc  sp
0C21: 0A          ld   a,(bc)
0C22: 0F          rrca
0C23: 08          ex   af,af'
0C24: 0D          dec  c
0C25: 33          inc  sp
0C26: 0A          ld   a,(bc)
0C27: 14          inc  d
0C28: 07          rlca
0C29: 33          inc  sp
0C2A: 0A          ld   a,(bc)
0C2B: 19          add  hl,de
0C2C: 08          ex   af,af'
0C2D: 10 33       djnz $0C62
0C2F: 0A          ld   a,(bc)
0C30: 14          inc  d
0C31: 07          rlca
0C32: 33          inc  sp
0C33: 0A          ld   a,(bc)
0C34: 19          add  hl,de
0C35: 08          ex   af,af'
0C36: 11 33 0A    ld   de,$0A33
0C39: 1E 07       ld   e,$07
0C3B: 33          inc  sp
0C3C: F7          rst  $30
0C3D: 02          ld   (bc),a
0C3E: 0D          dec  c
0C3F: 73          ld   (hl),e
0C40: 08          ex   af,af'
0C41: 10 02       djnz $0C45
0C43: 0B          dec  bc
0C44: 33          inc  sp
0C45: 07          rlca
0C46: 02          ld   (bc),a
0C47: 09          add  hl,bc
0C48: 33          inc  sp
0C49: 07          rlca
0C4A: 02          ld   (bc),a
0C4B: 07          rlca
0C4C: 33          inc  sp
0C4D: 08          ex   af,af'
0C4E: 11 02 05    ld   de,$0502
0C51: 33          inc  sp
0C52: 07          rlca
0C53: FF          rst  $38
0C54: 04          inc  b
0C55: 01 02 0F    ld   bc,$0F02
0C58: 08          ex   af,af'
0C59: 1F          rra
0C5A: 08          ex   af,af'
0C5B: 20 08       jr   nz,$0C65
0C5D: 21 08 22    ld   hl,$2208
0C60: 08          ex   af,af'
0C61: 23          inc  hl
0C62: 08          ex   af,af'
0C63: 24          inc  h
0C64: 08          ex   af,af'
0C65: 25          dec  h
0C66: 08          ex   af,af'
0C67: 26 08       ld   h,$08
0C69: 27          daa
0C6A: 08          ex   af,af'
0C6B: 28 08       jr   z,$0C75
0C6D: 29          add  hl,hl
0C6E: 08          ex   af,af'
0C6F: 2A 08 2B    ld   hl,($2B08)
0C72: 08          ex   af,af'
0C73: 24          inc  h
0C74: 08          ex   af,af'
0C75: 25          dec  h
0C76: 08          ex   af,af'
0C77: 26 08       ld   h,$08
0C79: 27          daa
0C7A: 08          ex   af,af'
0C7B: 28 08       jr   z,$0C85
0C7D: 29          add  hl,hl
0C7E: 08          ex   af,af'
0C7F: 2A 08 2B    ld   hl,($2B08)
0C82: 08          ex   af,af'
0C83: 2C          inc  l
0C84: 08          ex   af,af'
0C85: 2D          dec  l
0C86: 08          ex   af,af'
0C87: 2E 08       ld   l,$08
0C89: 2F          cpl
0C8A: 08          ex   af,af'
0C8B: 30 08       jr   nc,$0C95
0C8D: 2B          dec  hl
0C8E: 08          ex   af,af'
0C8F: 2C          inc  l
0C90: 08          ex   af,af'
0C91: 2D          dec  l
0C92: 08          ex   af,af'
0C93: 2E 08       ld   l,$08
0C95: 2F          cpl
0C96: 08          ex   af,af'
0C97: 30 08       jr   nc,$0CA1
0C99: 31 08 32    ld   sp,$3208
0C9C: 08          ex   af,af'
0C9D: 33          inc  sp
0C9E: 08          ex   af,af'
0C9F: 34          inc  (hl)
0CA0: 08          ex   af,af'
0CA1: 35          dec  (hl)
0CA2: 08          ex   af,af'
0CA3: 36 08       ld   (hl),$08
0CA5: 37          scf
0CA6: FF          rst  $38
0CA7: 04          inc  b
0CA8: 01 02 0D    ld   bc,$0D02
0CAB: 08          ex   af,af'
0CAC: 40          ld   b,b
0CAD: 08          ex   af,af'
0CAE: 41          ld   b,c
0CAF: 08          ex   af,af'
0CB0: 42          ld   b,d
0CB1: 08          ex   af,af'
0CB2: 43          ld   b,e
0CB3: 08          ex   af,af'
0CB4: 44          ld   b,h
0CB5: 08          ex   af,af'
0CB6: 45          ld   b,l
0CB7: 08          ex   af,af'
0CB8: 46          ld   b,(hl)
0CB9: 08          ex   af,af'
0CBA: 47          ld   b,a
0CBB: 08          ex   af,af'
0CBC: 48          ld   c,b
0CBD: 08          ex   af,af'
0CBE: 49          ld   c,c
0CBF: 08          ex   af,af'
0CC0: 4A          ld   c,d
0CC1: 08          ex   af,af'
0CC2: 4B          ld   c,e
0CC3: 08          ex   af,af'
0CC4: 4C          ld   c,h
0CC5: 08          ex   af,af'
0CC6: 45          ld   b,l
0CC7: 08          ex   af,af'
0CC8: 46          ld   b,(hl)
0CC9: 08          ex   af,af'
0CCA: 47          ld   b,a
0CCB: 08          ex   af,af'
0CCC: 48          ld   c,b
0CCD: 08          ex   af,af'
0CCE: 49          ld   c,c
0CCF: 08          ex   af,af'
0CD0: 4A          ld   c,d
0CD1: 08          ex   af,af'
0CD2: 4B          ld   c,e
0CD3: 08          ex   af,af'
0CD4: 4C          ld   c,h
0CD5: 08          ex   af,af'
0CD6: 4D          ld   c,l
0CD7: 08          ex   af,af'
0CD8: 4E          ld   c,(hl)
0CD9: 08          ex   af,af'
0CDA: 4F          ld   c,a
0CDB: 08          ex   af,af'
0CDC: 50          ld   d,b
0CDD: 08          ex   af,af'
0CDE: 51          ld   d,c
0CDF: 08          ex   af,af'
0CE0: 4C          ld   c,h
0CE1: 08          ex   af,af'
0CE2: 4D          ld   c,l
0CE3: 08          ex   af,af'
0CE4: 4E          ld   c,(hl)
0CE5: 08          ex   af,af'
0CE6: 4F          ld   c,a
0CE7: 08          ex   af,af'
0CE8: 50          ld   d,b
0CE9: 08          ex   af,af'
0CEA: 51          ld   d,c
0CEB: 08          ex   af,af'
0CEC: 52          ld   d,d
0CED: 08          ex   af,af'
0CEE: 53          ld   d,e
0CEF: 08          ex   af,af'
0CF0: 54          ld   d,h
0CF1: 08          ex   af,af'
0CF2: 53          ld   d,e
0CF3: 08          ex   af,af'
0CF4: 54          ld   d,h
0CF5: 08          ex   af,af'
0CF6: 53          ld   d,e
0CF7: 08          ex   af,af'
0CF8: 54          ld   d,h
0CF9: FF          rst  $38
0CFA: 04          inc  b
0CFB: 00          nop
0CFC: 02          ld   (bc),a
0CFD: 0F          rrca
0CFE: 09          add  hl,bc
0CFF: 0A          ld   a,(bc)
0D00: 0A          ld   a,(bc)
0D01: 08          ex   af,af'
0D02: 2D          dec  l
0D03: 13          inc  de
0D04: 07          rlca
0D05: 03          inc  bc
0D06: 07          rlca
0D07: 93          sub  e
0D08: FF          rst  $38
0D09: 04          inc  b
0D0A: 00          nop
0D0B: 02          ld   (bc),a
0D0C: 0F          rrca
0D0D: 09          add  hl,bc
0D0E: 0A          ld   a,(bc)
0D0F: 08          ex   af,af'
0D10: 01 14 00    ld   bc,$0014
0D13: 03          inc  bc
0D14: 07          rlca
0D15: 03          inc  bc
0D16: 07          rlca
0D17: 13          inc  de
0D18: 07          rlca
0D19: 03          inc  bc
0D1A: 07          rlca
0D1B: 03          inc  bc
0D1C: 07          rlca
0D1D: 33          inc  sp
0D1E: FF          rst  $38
0D1F: 04          inc  b
0D20: 00          nop
0D21: 02          ld   (bc),a
0D22: 0F          rrca
0D23: 09          add  hl,bc
0D24: 0A          ld   a,(bc)
0D25: 14          inc  d
0D26: 18 17       jr   $0D3F
0D28: 13          inc  de
0D29: 17          rla
0D2A: 93          sub  e
0D2B: FF          rst  $38
0D2C: 04          inc  b
0D2D: 00          nop
0D2E: 02          ld   (bc),a
0D2F: 0F          rrca
0D30: 08          ex   af,af'
0D31: 21 08 24    ld   hl,$2408
0D34: 08          ex   af,af'
0D35: 28 08       jr   z,$0D3F
0D37: 2D          dec  l
0D38: 08          ex   af,af'
0D39: 3C          inc  a
0D3A: 08          ex   af,af'
0D3B: 40          ld   b,b
0D3C: 08          ex   af,af'
0D3D: 45          ld   b,l
0D3E: 08          ex   af,af'
0D3F: 21 08 24    ld   hl,$2408
0D42: 08          ex   af,af'
0D43: 28 08       jr   z,$0D4D
0D45: 2D          dec  l
0D46: 08          ex   af,af'
0D47: 3C          inc  a
0D48: 08          ex   af,af'
0D49: 40          ld   b,b
0D4A: 08          ex   af,af'
0D4B: 45          ld   b,l
0D4C: FF          rst  $38
0D4D: 04          inc  b
0D4E: 00          nop
0D4F: 02          ld   (bc),a
0D50: 0F          rrca
0D51: 09          add  hl,bc
0D52: 0A          ld   a,(bc)
0D53: 0B          dec  bc
0D54: 08          ex   af,af'
0D55: 37          scf
0D56: 08          ex   af,af'
0D57: 38 08       jr   c,$0D61
0D59: 39          add  hl,sp
0D5A: 08          ex   af,af'
0D5B: 3A 08 36    ld   a,($3608)
0D5E: 08          ex   af,af'
0D5F: 37          scf
0D60: 0A          ld   a,(bc)
0D61: 0A          ld   a,(bc)
0D62: 08          ex   af,af'
0D63: 38 08       jr   c,$0D6D
0D65: 39          add  hl,sp
0D66: 08          ex   af,af'
0D67: 35          dec  (hl)
0D68: 08          ex   af,af'
0D69: 36 08       ld   (hl),$08
0D6B: 37          scf
0D6C: 08          ex   af,af'
0D6D: 38 08       jr   c,$0D77
0D6F: 34          inc  (hl)
0D70: 0A          ld   a,(bc)
0D71: 09          add  hl,bc
0D72: 08          ex   af,af'
0D73: 35          dec  (hl)
0D74: 08          ex   af,af'
0D75: 36 08       ld   (hl),$08
0D77: 37          scf
0D78: 08          ex   af,af'
0D79: 33          inc  sp
0D7A: 08          ex   af,af'
0D7B: 34          inc  (hl)
0D7C: 08          ex   af,af'
0D7D: 35          dec  (hl)
0D7E: 08          ex   af,af'
0D7F: 36 0A       ld   (hl),$0A
0D81: 08          ex   af,af'
0D82: 08          ex   af,af'
0D83: 32 08 33    ld   ($3308),a
0D86: 08          ex   af,af'
0D87: 34          inc  (hl)
0D88: 08          ex   af,af'
0D89: 35          dec  (hl)
0D8A: 08          ex   af,af'
0D8B: 31 08 32    ld   sp,$3208
0D8E: 08          ex   af,af'
0D8F: 33          inc  sp
0D90: 08          ex   af,af'
0D91: 34          inc  (hl)
0D92: 0A          ld   a,(bc)
0D93: 07          rlca
0D94: 08          ex   af,af'
0D95: 30 08       jr   nc,$0D9F
0D97: 31 08 32    ld   sp,$3208
0D9A: 08          ex   af,af'
0D9B: 33          inc  sp
0D9C: 08          ex   af,af'
0D9D: 2F          cpl
0D9E: 08          ex   af,af'
0D9F: 30 08       jr   nc,$0DA9
0DA1: 31 08 32    ld   sp,$3208
0DA4: 0A          ld   a,(bc)
0DA5: 06 08       ld   b,$08
0DA7: 2E 08       ld   l,$08
0DA9: 2F          cpl
0DAA: 08          ex   af,af'
0DAB: 30 08       jr   nc,$0DB5
0DAD: 31 08 2D    ld   sp,$2D08
0DB0: 08          ex   af,af'
0DB1: 2E 08       ld   l,$08
0DB3: 2F          cpl
0DB4: 08          ex   af,af'
0DB5: 30 0A       jr   nc,$0DC1
0DB7: 05          dec  b
0DB8: 08          ex   af,af'
0DB9: 2C          inc  l
0DBA: 08          ex   af,af'
0DBB: 2D          dec  l
0DBC: 08          ex   af,af'
0DBD: 2E 08       ld   l,$08
0DBF: 2F          cpl
0DC0: 08          ex   af,af'
0DC1: 2B          dec  hl
0DC2: 08          ex   af,af'
0DC3: 2C          inc  l
0DC4: 08          ex   af,af'
0DC5: 2D          dec  l
0DC6: 08          ex   af,af'
0DC7: 2E 0A       ld   l,$0A
0DC9: 06 08       ld   b,$08
0DCB: 2A 08 2B    ld   hl,($2B08)
0DCE: 08          ex   af,af'
0DCF: 2C          inc  l
0DD0: 08          ex   af,af'
0DD1: 2D          dec  l
0DD2: 08          ex   af,af'
0DD3: 29          add  hl,hl
0DD4: 08          ex   af,af'
0DD5: 2A 08 2B    ld   hl,($2B08)
0DD8: 08          ex   af,af'
0DD9: 2C          inc  l
0DDA: 0A          ld   a,(bc)
0DDB: 05          dec  b
0DDC: 18 28       jr   $0E06
0DDE: 18 29       jr   $0E09
0DE0: 18 2A       jr   $0E0C
0DE2: 18 2B       jr   $0E0F
0DE4: 18 27       jr   $0E0D
0DE6: 18 28       jr   $0E10
0DE8: 18 29       jr   $0E13
0DEA: 18 2A       jr   $0E16
0DEC: 0A          ld   a,(bc)
0DED: 04          inc  b
0DEE: 18 26       jr   $0E16
0DF0: 18 27       jr   $0E19
0DF2: 18 28       jr   $0E1C
0DF4: 18 29       jr   $0E1F
0DF6: 18 25       jr   $0E1D
0DF8: 18 26       jr   $0E20
0DFA: 18 27       jr   $0E23
0DFC: 18 28       jr   $0E26
0DFE: 0A          ld   a,(bc)
0DFF: 03          inc  bc
0E00: 18 24       jr   $0E26
0E02: 18 25       jr   $0E29
0E04: 18 26       jr   $0E2C
0E06: 18 27       jr   $0E2F
0E08: FF          rst  $38
0E09: 04          inc  b
0E0A: 00          nop
0E0B: 02          ld   (bc),a
0E0C: 0F          rrca
0E0D: 09          add  hl,bc
0E0E: 0A          ld   a,(bc)
0E0F: 1E 08       ld   e,$08
0E11: 43          ld   b,e
0E12: 0A          ld   a,(bc)
0E13: 1C          inc  e
0E14: 08          ex   af,af'
0E15: 47          ld   b,a
0E16: 0A          ld   a,(bc)
0E17: 1A          ld   a,(de)
0E18: 08          ex   af,af'
0E19: 4A          ld   c,d
0E1A: 0A          ld   a,(bc)
0E1B: 18 08       jr   $0E25
0E1D: 4D          ld   c,l
0E1E: 0A          ld   a,(bc)
0E1F: 16 08       ld   d,$08
0E21: 4E          ld   c,(hl)
0E22: 0A          ld   a,(bc)
0E23: 14          inc  d
0E24: 08          ex   af,af'
0E25: 4C          ld   c,h
0E26: 0A          ld   a,(bc)
0E27: 12          ld   (de),a
0E28: 08          ex   af,af'
0E29: 4A          ld   c,d
0E2A: 0A          ld   a,(bc)
0E2B: 10 08       djnz $0E35
0E2D: 48          ld   c,b
0E2E: 0A          ld   a,(bc)
0E2F: 0E 08       ld   c,$08
0E31: 46          ld   b,(hl)
0E32: 0A          ld   a,(bc)
0E33: 0C          inc  c
0E34: 08          ex   af,af'
0E35: 44          ld   b,h
0E36: 0A          ld   a,(bc)
0E37: 0A          ld   a,(bc)
0E38: 08          ex   af,af'
0E39: 42          ld   b,d
0E3A: 0A          ld   a,(bc)
0E3B: 08          ex   af,af'
0E3C: 08          ex   af,af'
0E3D: 40          ld   b,b
0E3E: 0A          ld   a,(bc)
0E3F: 06 08       ld   b,$08
0E41: 3E 0A       ld   a,$0A
0E43: 04          inc  b
0E44: 08          ex   af,af'
0E45: 3C          inc  a
0E46: 0A          ld   a,(bc)
0E47: 02          ld   (bc),a
0E48: 08          ex   af,af'
0E49: 3A 0A 00    ld   a,($000A)
0E4C: 08          ex   af,af'
0E4D: 38 08       jr   c,$0E57
0E4F: 36 08       ld   (hl),$08
0E51: 34          inc  (hl)
0E52: 08          ex   af,af'
0E53: 32 08 30    ld   ($3008),a
0E56: 08          ex   af,af'
0E57: 2E 08       ld   l,$08
0E59: 2C          inc  l
0E5A: 08          ex   af,af'
0E5B: 2A 08 28    ld   hl,($2808)
0E5E: 08          ex   af,af'
0E5F: 26 08       ld   h,$08
0E61: 24          inc  h
0E62: 08          ex   af,af'
0E63: 22 08 20    ld   ($2008),hl
0E66: FF          rst  $38
0E67: 04          inc  b
0E68: 00          nop
0E69: 02          ld   (bc),a
0E6A: 0F          rrca
0E6B: 09          add  hl,bc
0E6C: 0A          ld   a,(bc)
0E6D: 1E 08       ld   e,$08
0E6F: 0E 23       ld   c,$23
0E71: 0A          ld   a,(bc)
0E72: 1D          dec  e
0E73: 07          rlca
0E74: 23          inc  hl
0E75: 0A          ld   a,(bc)
0E76: 1C          inc  e
0E77: 07          rlca
0E78: 23          inc  hl
0E79: 0A          ld   a,(bc)
0E7A: 1B          dec  de
0E7B: 07          rlca
0E7C: 23          inc  hl
0E7D: 0A          ld   a,(bc)
0E7E: 1A          ld   a,(de)
0E7F: 07          rlca
0E80: 23          inc  hl
0E81: 0A          ld   a,(bc)
0E82: 19          add  hl,de
0E83: 07          rlca
0E84: 23          inc  hl
0E85: 0A          ld   a,(bc)
0E86: 18 07       jr   $0E8F
0E88: 23          inc  hl
0E89: 0A          ld   a,(bc)
0E8A: 17          rla
0E8B: 07          rlca
0E8C: 23          inc  hl
0E8D: 02          ld   (bc),a
0E8E: 0E 0A       ld   c,$0A
0E90: 16 07       ld   d,$07
0E92: 23          inc  hl
0E93: 0A          ld   a,(bc)
0E94: 15          dec  d
0E95: 07          rlca
0E96: 23          inc  hl
0E97: 0A          ld   a,(bc)
0E98: 14          inc  d
0E99: 07          rlca
0E9A: 23          inc  hl
0E9B: 0A          ld   a,(bc)
0E9C: 13          inc  de
0E9D: 07          rlca
0E9E: 23          inc  hl
0E9F: 02          ld   (bc),a
0EA0: 0D          dec  c
0EA1: 0A          ld   a,(bc)
0EA2: 12          ld   (de),a
0EA3: 07          rlca
0EA4: 23          inc  hl
0EA5: 0A          ld   a,(bc)
0EA6: 11 07 23    ld   de,$2307
0EA9: 0A          ld   a,(bc)
0EAA: 10 07       djnz $0EB3
0EAC: 23          inc  hl
0EAD: 0A          ld   a,(bc)
0EAE: 0F          rrca
0EAF: 07          rlca
0EB0: 23          inc  hl
0EB1: 02          ld   (bc),a
0EB2: 0B          dec  bc
0EB3: 0A          ld   a,(bc)
0EB4: 0E 07       ld   c,$07
0EB6: 23          inc  hl
0EB7: 0A          ld   a,(bc)
0EB8: 0D          dec  c
0EB9: 07          rlca
0EBA: 23          inc  hl
0EBB: 0A          ld   a,(bc)
0EBC: 0C          inc  c
0EBD: 07          rlca
0EBE: 23          inc  hl
0EBF: 0A          ld   a,(bc)
0EC0: 0B          dec  bc
0EC1: 07          rlca
0EC2: 23          inc  hl
0EC3: 02          ld   (bc),a
0EC4: 09          add  hl,bc
0EC5: 0A          ld   a,(bc)
0EC6: 0A          ld   a,(bc)
0EC7: 07          rlca
0EC8: 23          inc  hl
0EC9: 0A          ld   a,(bc)
0ECA: 09          add  hl,bc
0ECB: 07          rlca
0ECC: 23          inc  hl
0ECD: 0A          ld   a,(bc)
0ECE: 08          ex   af,af'
0ECF: 07          rlca
0ED0: 23          inc  hl
0ED1: 0A          ld   a,(bc)
0ED2: 07          rlca
0ED3: 07          rlca
0ED4: 23          inc  hl
0ED5: FF          rst  $38
0ED6: 04          inc  b
0ED7: 07          rlca
0ED8: 02          ld   (bc),a
0ED9: 0F          rrca
0EDA: 0E 0D       ld   c,$0D
0EDC: 01 1B 00    ld   bc,$001B
0EDF: 01 1A 00    ld   bc,$001A
0EE2: 01 19 00    ld   bc,$0019
0EE5: 01 18 00    ld   bc,$0018
0EE8: 01 17 00    ld   bc,$0017
0EEB: 01 16 00    ld   bc,$0016
0EEE: 01 15 00    ld   bc,$0015
0EF1: 01 14 00    ld   bc,$0014
0EF4: 01 13 00    ld   bc,$0013
0EF7: 01 12 00    ld   bc,$0012
0EFA: 01 11 00    ld   bc,$0011
0EFD: 01 10 00    ld   bc,$0010
0F00: 01 0F 00    ld   bc,$000F
0F03: 01 0E 00    ld   bc,$000E
0F06: 01 0D 00    ld   bc,$000D
0F09: 01 0C 00    ld   bc,$000C
0F0C: 01 0B 00    ld   bc,$000B
0F0F: 01 0A 00    ld   bc,$000A
0F12: 01 18 00    ld   bc,$0018
0F15: 01 17 00    ld   bc,$0017
0F18: 01 16 00    ld   bc,$0016
0F1B: 01 15 00    ld   bc,$0015
0F1E: 01 14 00    ld   bc,$0014
0F21: 01 13 00    ld   bc,$0013
0F24: 01 12 00    ld   bc,$0012
0F27: 01 11 00    ld   bc,$0011
0F2A: 01 10 00    ld   bc,$0010
0F2D: 01 0F 00    ld   bc,$000F
0F30: 01 0E 00    ld   bc,$000E
0F33: 01 0D 00    ld   bc,$000D
0F36: 01 0C 00    ld   bc,$000C
0F39: 01 0B 00    ld   bc,$000B
0F3C: 01 0A 00    ld   bc,$000A
0F3F: 01 09 00    ld   bc,$0009
0F42: 01 08 00    ld   bc,$0008
0F45: 01 07 00    ld   bc,$0007
0F48: 01 15 00    ld   bc,$0015
0F4B: 01 14 00    ld   bc,$0014
0F4E: 01 13 00    ld   bc,$0013
0F51: 01 12 00    ld   bc,$0012
0F54: 01 11 00    ld   bc,$0011
0F57: 01 10 00    ld   bc,$0010
0F5A: 01 0F 00    ld   bc,$000F
0F5D: 01 0E 00    ld   bc,$000E
0F60: 01 0D 00    ld   bc,$000D
0F63: 01 0C 00    ld   bc,$000C
0F66: 01 0B 00    ld   bc,$000B
0F69: 01 0A 00    ld   bc,$000A
0F6C: 01 09 00    ld   bc,$0009
0F6F: 01 08 00    ld   bc,$0008
0F72: 01 07 00    ld   bc,$0007
0F75: 01 06 00    ld   bc,$0006
0F78: 01 05 00    ld   bc,$0005
0F7B: 0E F1       ld   c,$F1
0F7D: 04          inc  b
0F7E: 00          nop
0F7F: FF          rst  $38
0F80: 04          inc  b
0F81: 01 02 05    ld   bc,$0502
0F84: 11 40 01    ld   de,$0140
0F87: 02          ld   (bc),a
0F88: 06 11       ld   b,$11
0F8A: 36 01       ld   (hl),$01
0F8C: 02          ld   (bc),a
0F8D: 07          rlca
0F8E: 11 2C 01    ld   de,$012C
0F91: 02          ld   (bc),a
0F92: 08          ex   af,af'
0F93: 11 22 01    ld   de,$0122
0F96: 02          ld   (bc),a
0F97: 09          add  hl,bc
0F98: 11 18 01    ld   de,$0118
0F9B: 02          ld   (bc),a
0F9C: 0A          ld   a,(bc)
0F9D: 11 0E 01    ld   de,$010E
0FA0: 02          ld   (bc),a
0FA1: 0B          dec  bc
0FA2: 11 04 01    ld   de,$0104
0FA5: 02          ld   (bc),a
0FA6: 0C          inc  c
0FA7: 11 FA 00    ld   de,$00FA
0FAA: 02          ld   (bc),a
0FAB: 0D          dec  c
0FAC: 11 F0 00    ld   de,$00F0
0FAF: 02          ld   (bc),a
0FB0: 0E 11       ld   c,$11
0FB2: E6 00       and  $00
0FB4: 02          ld   (bc),a
0FB5: 0F          rrca
0FB6: 11 DC 00    ld   de,$00DC
0FB9: 11 D2 00    ld   de,$00D2
0FBC: 11 C8 00    ld   de,$00C8
0FBF: 11 BE 00    ld   de,$00BE
0FC2: 11 B4 00    ld   de,$00B4
0FC5: 81          add  a,c
0FC6: AA          xor  d
0FC7: 00          nop
0FC8: 83          add  a,e
0FC9: FF          rst  $38
0FCA: 04          inc  b
0FCB: 01 02 0F    ld   bc,$0F02
0FCE: 08          ex   af,af'
0FCF: 28 08       jr   z,$0FD9
0FD1: 1D          dec  e
0FD2: 08          ex   af,af'
0FD3: 1C          inc  e
0FD4: 08          ex   af,af'
0FD5: 1D          dec  e
0FD6: 08          ex   af,af'
0FD7: 28 08       jr   z,$0FE1
0FD9: 1D          dec  e
0FDA: 08          ex   af,af'
0FDB: 1C          inc  e
0FDC: 08          ex   af,af'
0FDD: 1D          dec  e
0FDE: 08          ex   af,af'
0FDF: 28 08       jr   z,$0FE9
0FE1: 1D          dec  e
0FE2: 08          ex   af,af'
0FE3: 1C          inc  e
0FE4: 08          ex   af,af'
0FE5: 1D          dec  e
0FE6: 08          ex   af,af'
0FE7: 28 08       jr   z,$0FF1
0FE9: 1D          dec  e
0FEA: 08          ex   af,af'
0FEB: 1C          inc  e
0FEC: 08          ex   af,af'
0FED: 1D          dec  e
0FEE: 08          ex   af,af'
0FEF: 28 08       jr   z,$0FF9
0FF1: 1D          dec  e
0FF2: 08          ex   af,af'
0FF3: 1C          inc  e
0FF4: 08          ex   af,af'
0FF5: 1D          dec  e
0FF6: 08          ex   af,af'
0FF7: 28 08       jr   z,$1001
0FF9: 1D          dec  e
0FFA: 08          ex   af,af'
0FFB: 1C          inc  e
0FFC: 08          ex   af,af'
0FFD: 1D          dec  e
0FFE: 08          ex   af,af'
0FFF: 28 08       jr   z,$1009
1001: 1D          dec  e
1002: 08          ex   af,af'
1003: 1C          inc  e
1004: 08          ex   af,af'
1005: 1D          dec  e
1006: 08          ex   af,af'
1007: 28 08       jr   z,$1011
1009: 1D          dec  e
100A: 08          ex   af,af'
100B: 1C          inc  e
100C: 08          ex   af,af'
100D: 1D          dec  e
100E: FF          rst  $38
100F: 21 80 40    ld   hl,$4080
1012: 7E          ld   a,(hl)
1013: EE 11       xor  $11
1015: 5F          ld   e,a
1016: 16 00       ld   d,$00
1018: 23          inc  hl
1019: 19          add  hl,de
101A: 7E          ld   a,(hl)
101B: B7          or   a
101C: C8          ret  z
101D: 47          ld   b,a
101E: 23          inc  hl
101F: 11 A3 40    ld   de,$40A3
1022: C5          push bc
1023: E5          push hl
1024: 6E          ld   l,(hl)
1025: 26 00       ld   h,$00
1027: 29          add  hl,hl
1028: 29          add  hl,hl
1029: 01 52 10    ld   bc,$1052
102C: 09          add  hl,bc
102D: ED A0       ldi
102F: ED A0       ldi
1031: 7E          ld   a,(hl)
1032: 23          inc  hl
1033: 66          ld   h,(hl)
1034: 6F          ld   l,a
1035: CB 7C       bit  7,h
1037: 28 08       jr   z,$1041
1039: CB BC       res  7,h
103B: 7E          ld   a,(hl)
103C: F6 80       or   $80
103E: 12          ld   (de),a
103F: 23          inc  hl
1040: 13          inc  de
1041: 3E FF       ld   a,$FF
1043: BE          cp   (hl)
1044: 28 04       jr   z,$104A
1046: ED A0       ldi
1048: 18 F9       jr   $1043
104A: ED A0       ldi
104C: E1          pop  hl
104D: C1          pop  bc
104E: 23          inc  hl
104F: 10 D1       djnz $1022
1051: C9          ret
1052: 63          ld   h,e
1053: 91          sub  c
1054: F6 10       or   $10
1056: E2 90 65    jp   po,$6590
1059: 11 23 96    ld   de,$9623
105C: 02          ld   (bc),a
105D: 11 A2 95    ld   de,$95A2
1060: 6D          ld   l,l
1061: 11 23 93    ld   de,$9323
1064: 06 11       ld   b,$11
1066: 62          ld   h,d
1067: 93          sub  e
1068: 65          ld   h,l
1069: 11 03 F3    ld   de,$F303
106C: 22 91 00    ld   ($0091),hl
106F: 95          sub  l
1070: 0F          rrca
1071: 11 63 91    ld   de,$9163
1074: 16 11       ld   d,$11
1076: 23          inc  hl
1077: 96          sub  (hl)
1078: 16 11       ld   d,$11
107A: A2          and  d
107B: 95          sub  l
107C: 1A          ld   a,(de)
107D: 11 E2 90    ld   de,$90E2
1080: FA 10 A2    jp   m,$A210
1083: 95          sub  l
1084: FA 10 45    jp   m,$4510
1087: 93          sub  e
1088: 75          ld   (hl),l
1089: 11 83 92    ld   de,$9283
108C: 7C          ld   a,h
108D: 11 84 92    ld   de,$9284
1090: 8B          adc  a,e
1091: 11 02 93    ld   de,$9302
1094: 99          sbc  a,c
1095: 11 19 92    ld   de,$9219
1098: A2          and  d
1099: 11 19 92    ld   de,$9219
109C: B3          or   e
109D: 11 19 92    ld   de,$9219
10A0: C4 11 99    call nz,$9911
10A3: 93          sub  e
10A4: D5          push de
10A5: 11 57 92    ld   de,$9257
10A8: DA 11 17    jp   c,$1711
10AB: 92          sub  d
10AC: EA 11 95    jp   pe,$9511
10AF: 92          sub  d
10B0: FC 11 12    call m,$1211
10B3: 92          sub  d
10B4: 09          add  hl,bc
10B5: 12          ld   (de),a
10B6: 15          dec  d
10B7: 93          sub  e
10B8: 1A          ld   a,(de)
10B9: 12          ld   (de),a
10BA: 95          sub  l
10BB: 91          sub  c
10BC: 24          inc  h
10BD: 12          ld   (de),a
10BE: 98          sbc  a,b
10BF: 93          sub  e
10C0: 3A 12 E0    ld   a,($E012)
10C3: 91          sub  c
10C4: 49          ld   c,c
10C5: 12          ld   (de),a
10C6: 14          inc  d
10C7: 91          sub  c
10C8: 5C          ld   e,h
10C9: 12          ld   (de),a
10CA: 12          ld   (de),a
10CB: 91          sub  c
10CC: 60          ld   h,b
10CD: 12          ld   (de),a
10CE: 10 91       djnz $1061
10D0: 64          ld   h,h
10D1: 12          ld   (de),a
10D2: 0E 91       ld   c,$91
10D4: 68          ld   l,b
10D5: 12          ld   (de),a
10D6: 0C          inc  c
10D7: 91          sub  c
10D8: 6C          ld   l,h
10D9: 12          ld   (de),a
10DA: 0A          ld   a,(bc)
10DB: 91          sub  c
10DC: 70          ld   (hl),b
10DD: 12          ld   (de),a
10DE: 14          inc  d
10DF: 92          sub  d
10E0: 74          ld   (hl),h
10E1: 12          ld   (de),a
10E2: 12          ld   (de),a
10E3: 92          sub  d
10E4: 74          ld   (hl),h
10E5: 12          ld   (de),a
10E6: 10 92       djnz $107A
10E8: 74          ld   (hl),h
10E9: 12          ld   (de),a
10EA: 0E 92       ld   c,$92
10EC: 74          ld   (hl),h
10ED: 12          ld   (de),a
10EE: 0C          inc  c
10EF: 92          sub  d
10F0: 74          ld   (hl),h
10F1: 12          ld   (de),a
10F2: 0A          ld   a,(bc)
10F3: 92          sub  d
10F4: 74          ld   (hl),h
10F5: 12          ld   (de),a
10F6: 02          ld   (bc),a
10F7: 1F          rra
10F8: 1A          ld   a,(de)
10F9: FF          rst  $38
10FA: 00          nop
10FB: 00          nop
10FC: 00          nop
10FD: 00          nop
10FE: 00          nop
10FF: 00          nop
1100: 01 FF 03    ld   bc,$03FF
1103: 1F          rra
1104: 1A          ld   a,(de)
1105: FF          rst  $38
1106: 12          ld   (de),a
1107: 13          inc  de
1108: 2A 1D 0D    ld   hl,($0D1D)
110B: 19          add  hl,de
110C: 1C          inc  e
110D: 0F          rrca
110E: FF          rst  $38
110F: 0D          dec  c
1110: 1C          inc  e
1111: 0F          rrca
1112: 0E 13       ld   c,$13
1114: 1E FF       ld   e,$FF
1116: 00          nop
1117: 00          nop
1118: 00          nop
1119: FF          rst  $38
111A: 00          nop
111B: 00          nop
111C: 00          nop
111D: 00          nop
111E: 00          nop
111F: 00          nop
1120: 00          nop
1121: FF          rst  $38
1122: 20 35       jr   nz,$1159
1124: 00          nop
1125: 10 30       djnz $1157
1127: 00          nop
1128: 00          nop
1129: 27          daa
112A: 00          nop
112B: 00          nop
112C: 24          inc  h
112D: 00          nop
112E: 00          nop
112F: 21 00 00    ld   hl,$0000
1132: 20 00       jr   nz,$1134
1134: 18 0B       jr   $1141
1136: 19          add  hl,de
1137: 17          rla
1138: 13          inc  de
1139: 29          add  hl,hl
113A: 1D          dec  e
113B: 00          nop
113C: 15          dec  d
113D: 29          add  hl,hl
113E: 1E 00       ld   e,$00
1140: 00          nop
1141: 00          nop
1142: 00          nop
1143: 00          nop
1144: 17          rla
1145: 13          inc  de
1146: 15          dec  d
1147: 13          inc  de
1148: 00          nop
1149: 15          dec  d
114A: 1F          rra
114B: 18 18       jr   $1165
114D: 13          inc  de
114E: 0D          dec  c
114F: 0F          rrca
1150: 00          nop
1151: 23          inc  hl
1152: 29          add  hl,hl
1153: 18 1A       jr   $116F
1155: 19          add  hl,de
1156: 1A          ld   a,(de)
1157: 00          nop
1158: 15          dec  d
1159: 0B          dec  bc
115A: 21 0B 17    ld   hl,$170B
115D: 29          add  hl,hl
115E: 12          ld   (de),a
115F: 0B          dec  bc
1160: 1C          inc  e
1161: 0B          dec  bc
1162: 0E 0B       ld   c,$0B
1164: FF          rst  $38
1165: 00          nop
1166: 00          nop
1167: 04          inc  b
1168: 06 03       ld   b,$03
116A: 01 01 FF    ld   bc,$FF01
116D: 00          nop
116E: 00          nop
116F: 04          inc  b
1170: 01 02 01    ld   bc,$0102
1173: 01 FF 2D    ld   bc,$2DFF
1176: 00          nop
1177: 02          ld   (bc),a
1178: 0A          ld   a,(bc)
1179: 09          add  hl,bc
117A: 05          dec  b
117B: FF          rst  $38
117C: 0D          dec  c
117D: 1C          inc  e
117E: 1F          rra
117F: 22 00 0D    ld   ($0D00),hl
1182: 19          add  hl,de
1183: 29          add  hl,hl
1184: 28 00       jr   z,$1186
1186: 16 1E       ld   d,$1E
1188: 0E 29       ld   c,$29
118A: FF          rst  $38
118B: 2D          dec  l
118C: 00          nop
118D: 1E 0B       ld   e,$0B
118F: 13          inc  de
1190: 1E 19       ld   e,$19
1192: 00          nop
1193: 0D          dec  c
1194: 19          add  hl,de
1195: 1C          inc  e
1196: 1A          ld   a,(de)
1197: 29          add  hl,hl
1198: FF          rst  $38
1199: 38 39       jr   c,$11D4
119B: 3A 3B 3C    ld   a,($3C3B)
119E: 3D          dec  a
119F: 3E 3F       ld   a,$3F
11A1: FF          rst  $38
11A2: 1A          ld   a,(de)
11A3: 16 0B       ld   d,$0B
11A5: 23          inc  hl
11A6: 0F          rrca
11A7: 1C          inc  e
11A8: 00          nop
11A9: 19          add  hl,de
11AA: 18 0F       jr   $11BB
11AC: 00          nop
11AD: 1D          dec  e
11AE: 1E 0B       ld   e,$0B
11B0: 1C          inc  e
11B1: 1E FF       ld   e,$FF
11B3: 1A          ld   a,(de)
11B4: 16 0B       ld   d,$0B
11B6: 23          inc  hl
11B7: 0F          rrca
11B8: 1C          inc  e
11B9: 00          nop
11BA: 1E 21       ld   e,$21
11BC: 19          add  hl,de
11BD: 00          nop
11BE: 1D          dec  e
11BF: 1E 0B       ld   e,$0B
11C1: 1C          inc  e
11C2: 1E FF       ld   e,$FF
11C4: 0F          rrca
11C5: 22 1E 1C    ld   ($1C1E),hl
11C8: 0B          dec  bc
11C9: 00          nop
11CA: 1A          ld   a,(de)
11CB: 16 0B       ld   d,$0B
11CD: 23          inc  hl
11CE: 00          nop
11CF: 1D          dec  e
11D0: 1E 0B       ld   e,$0B
11D2: 1C          inc  e
11D3: 1E FF       ld   e,$FF
11D5: 1A          ld   a,(de)
11D6: 1F          rra
11D7: 1D          dec  e
11D8: 12          ld   (de),a
11D9: FF          rst  $38
11DA: 19          add  hl,de
11DB: 18 16       jr   $11F3
11DD: 23          inc  hl
11DE: 00          nop
11DF: 19          add  hl,de
11E0: 18 0F       jr   $11F1
11E2: 00          nop
11E3: 1A          ld   a,(de)
11E4: 16 0B       ld   d,$0B
11E6: 23          inc  hl
11E7: 0F          rrca
11E8: 1C          inc  e
11E9: FF          rst  $38
11EA: 19          add  hl,de
11EB: 18 0F       jr   $11FC
11ED: 00          nop
11EE: 19          add  hl,de
11EF: 1C          inc  e
11F0: 00          nop
11F1: 1E 21       ld   e,$21
11F3: 19          add  hl,de
11F4: 00          nop
11F5: 1A          ld   a,(de)
11F6: 16 0B       ld   d,$0B
11F8: 23          inc  hl
11F9: 0F          rrca
11FA: 1C          inc  e
11FB: FF          rst  $38
11FC: 1D          dec  e
11FD: 1E 0B       ld   e,$0B
11FF: 1C          inc  e
1200: 1E 00       ld   e,$00
1202: 0C          inc  c
1203: 1F          rra
1204: 1E 1E       ld   e,$1E
1206: 19          add  hl,de
1207: 18 FF       jr   $1208
1209: 1A          ld   a,(de)
120A: 1C          inc  e
120B: 19          add  hl,de
120C: 11 1C 0B    ld   de,$0B1C
120F: 17          rla
1210: 0F          rrca
1211: 0E 00       ld   c,$00
1213: 0C          inc  c
1214: 23          inc  hl
1215: 00          nop
1216: 0B          dec  bc
1217: 13          inc  de
1218: 17          rla
1219: FF          rst  $38
121A: 11 0B 17    ld   de,$170B
121D: 0F          rrca
121E: 00          nop
121F: 19          add  hl,de
1220: 20 0F       jr   nz,$1231
1222: 1C          inc  e
1223: FF          rst  $38
1224: 1F          rra
1225: 18 16       jr   $123D
1227: 1F          rra
1228: 0D          dec  c
1229: 15          dec  d
122A: 23          inc  hl
122B: 00          nop
122C: 17          rla
122D: 0B          dec  bc
122E: 1E 0B       ld   e,$0B
1230: 00          nop
1231: 15          dec  d
1232: 13          inc  de
1233: 1E 0F       ld   e,$0F
1235: 18 0F       jr   $1246
1237: 2B          dec  hl
1238: 2B          dec  hl
1239: FF          rst  $38
123A: 29          add  hl,hl
123B: 00          nop
123C: 00          nop
123D: 2A 00 00    ld   hl,($0000)
1240: 2B          dec  hl
1241: 00          nop
1242: 00          nop
1243: 2C          inc  l
1244: 00          nop
1245: 0F          rrca
1246: 18 0E       jr   $1256
1248: FF          rst  $38
1249: 1C          inc  e
124A: 0F          rrca
124B: 11 13 1D    ld   de,$1D13
124E: 1E 0F       ld   e,$0F
1250: 1C          inc  e
1251: 00          nop
1252: 23          inc  hl
1253: 19          add  hl,de
1254: 1F          rra
1255: 1C          inc  e
1256: 00          nop
1257: 18 0B       jr   $1264
1259: 17          rla
125A: 0F          rrca
125B: FF          rst  $38
125C: 1E 19       ld   e,$19
125E: 1A          ld   a,(de)
125F: FF          rst  $38
1260: 03          inc  bc
1261: 18 0E       jr   $1271
1263: FF          rst  $38
1264: 04          inc  b
1265: 1C          inc  e
1266: 0E FF       ld   c,$FF
1268: 05          dec  b
1269: 1E 12       ld   e,$12
126B: FF          rst  $38
126C: 06 1E       ld   b,$1E
126E: 12          ld   (de),a
126F: FF          rst  $38
1270: 07          rlca
1271: 1E 12       ld   e,$12
1273: FF          rst  $38
1274: 26 00       ld   h,$00
1276: 00          nop
1277: 00          nop
1278: 00          nop
1279: 00          nop
127A: 00          nop
127B: 01 27 00    ld   bc,$0027
127E: 26 00       ld   h,$00
1280: 00          nop
1281: 00          nop
1282: 00          nop
1283: 00          nop
1284: 00          nop
1285: 00          nop
1286: 00          nop
1287: 27          daa
1288: FF          rst  $38
1289: 21 00 42    ld   hl,$4200
128C: AF          xor  a
128D: BE          cp   (hl)
128E: C8          ret  z
128F: 23          inc  hl
1290: 23          inc  hl
1291: 11 16 42    ld   de,$4216
1294: 0E FF       ld   c,$FF
1296: 7E          ld   a,(hl)
1297: 23          inc  hl
1298: 46          ld   b,(hl)
1299: 23          inc  hl
129A: ED A0       ldi
129C: ED A0       ldi
129E: B7          or   a
129F: 28 3A       jr   z,$12DB
12A1: E5          push hl
12A2: F5          push af
12A3: 68          ld   l,b
12A4: 26 00       ld   h,$00
12A6: 29          add  hl,hl
12A7: 01 DB 12    ld   bc,$12DB
12AA: 09          add  hl,bc
12AB: 7E          ld   a,(hl)
12AC: 23          inc  hl
12AD: 66          ld   h,(hl)
12AE: 6F          ld   l,a
12AF: 7E          ld   a,(hl)
12B0: ED A0       ldi
12B2: 4F          ld   c,a
12B3: E6 70       and  $70
12B5: 0F          rrca
12B6: 0F          rrca
12B7: 0F          rrca
12B8: 0F          rrca
12B9: 47          ld   b,a
12BA: 79          ld   a,c
12BB: E6 0F       and  $0F
12BD: CB 79       bit  7,c
12BF: 28 01       jr   z,$12C2
12C1: 87          add  a,a
12C2: 4F          ld   c,a
12C3: AF          xor  a
12C4: 81          add  a,c
12C5: 10 FD       djnz $12C4
12C7: 4F          ld   c,a
12C8: F1          pop  af
12C9: 3D          dec  a
12CA: 28 04       jr   z,$12D0
12CC: 09          add  hl,bc
12CD: 3D          dec  a
12CE: 20 FC       jr   nz,$12CC
12D0: ED B0       ldir
12D2: 21 00 01    ld   hl,$0100
12D5: 22 00 42    ld   ($4200),hl
12D8: E1          pop  hl
12D9: 18 B9       jr   $1294
12DB: 12          ld   (de),a
12DC: C9          ret
12DD: 29          add  hl,hl
12DE: 13          inc  de
12DF: 7A          ld   a,d
12E0: 13          inc  de
12E1: 3F          ccf
12E2: 14          inc  d
12E3: 78          ld   a,b
12E4: 14          inc  d
12E5: BD          cp   l
12E6: 17          rla
12E7: D6 17       sub  $17
12E9: EF          rst  $28
12EA: 17          rla
12EB: 50          ld   d,b
12EC: 18 5D       jr   $134B
12EE: 18 76       jr   $1366
12F0: 18 A9       jr   $129B
12F2: 14          inc  d
12F3: CA 14 1B    jp   z,$1B14
12F6: 15          dec  d
12F7: AC          xor  h
12F8: 15          dec  d
12F9: FD          db   $fd
12FA: 15          dec  d
12FB: 1E 16       ld   e,$16
12FD: 37          scf
12FE: 16 B8       ld   d,$B8
1300: 16 19       ld   d,$19
1302: 17          rla
1303: 42          ld   b,d
1304: 17          rla
1305: 6B          ld   l,e
1306: 17          rla
1307: 94          sub  h
1308: 17          rla
1309: 8F          adc  a,a
130A: 18 00       jr   $130C
130C: 19          add  hl,de
130D: 71          ld   (hl),c
130E: 19          add  hl,de
130F: D2 19 33    jp   nc,$3319
1312: 1A          ld   a,(de)
1313: 94          sub  h
1314: 1A          ld   a,(de)
1315: B5          or   l
1316: 1A          ld   a,(de)
1317: 26 1B       ld   h,$1B
1319: 87          add  a,a
131A: 1B          dec  de
131B: E8          ret  pe
131C: 1B          dec  de
131D: 39          add  hl,sp
131E: 1C          inc  e
131F: 8A          adc  a,d
1320: 1C          inc  e
1321: 9B          sbc  a,e
1322: 1C          inc  e
1323: FC 1C 6D    call m,$6D1C
1326: 1D          dec  e
1327: DE 1D       sbc  a,$1D
1329: A5          and  l
132A: 32 33 B5    ld   ($B533),a
132D: C8          ret  z
132E: 34          inc  (hl)
132F: C0          ret  nz
1330: C0          ret  nz
1331: 43          ld   b,e
1332: 43          ld   b,e
1333: C0          ret  nz
1334: D0          ret  nc
1335: D2 B6 C9    jp   nc,$C9B6
1338: D2 43 43    jp   nc,$4343
133B: 43          ld   b,e
133C: 43          ld   b,e
133D: 4B          ld   c,e
133E: D1          pop  de
133F: D3 B7       out  ($B7),a
1341: CA D3 43    jp   z,$43D3
1344: 43          ld   b,e
1345: 43          ld   b,e
1346: 43          ld   b,e
1347: 4B          ld   c,e
1348: 32 B9 B8    ld   ($B8B9),a
134B: CB E0       set  4,b
134D: C0          ret  nz
134E: 43          ld   b,e
134F: 43          ld   b,e
1350: 43          ld   b,e
1351: 43          ld   b,e
1352: 34          inc  (hl)
1353: BA          cp   d
1354: C0          ret  nz
1355: C2 E1 C0    jp   nz,$C0E1
1358: 43          ld   b,e
1359: 52          ld   d,d
135A: 52          ld   d,d
135B: 43          ld   b,e
135C: 33          inc  sp
135D: BB          cp   e
135E: C1          pop  bc
135F: C3 E2 C0    jp   $C0E2
1362: 43          ld   b,e
1363: 52          ld   d,d
1364: 52          ld   d,d
1365: 43          ld   b,e
1366: 32 BC C4    ld   ($C4BC),a
1369: C6 E3       add  a,$E3
136B: C0          ret  nz
136C: 43          ld   b,e
136D: 52          ld   d,d
136E: 52          ld   d,d
136F: 43          ld   b,e
1370: 35          dec  (hl)
1371: BD          cp   l
1372: C5          push bc
1373: C7          rst  $00
1374: BD          cp   l
1375: C0          ret  nz
1376: 43          ld   b,e
1377: 52          ld   d,d
1378: 52          ld   d,d
1379: 47          ld   b,a
137A: A7          and  a
137B: BE          cp   (hl)
137C: CD C8 CA    call $CAC8
137F: D0          ret  nc
1380: E4 32 43    call po,$4332
1383: 43          ld   b,e
1384: 52          ld   d,d
1385: 52          ld   d,d
1386: 52          ld   d,d
1387: 63          ld   h,e
1388: C0          ret  nz
1389: BF          cp   a
138A: CE C9       adc  a,$C9
138C: CB D1       set  2,c
138E: E5          push hl
138F: F3          di
1390: 43          ld   b,e
1391: 53          ld   d,e
1392: 52          ld   d,d
1393: 52          ld   d,d
1394: 52          ld   d,d
1395: 63          ld   h,e
1396: C3 C0 CF    jp   $CFC0
1399: CC CE D2    call z,$D2CE
139C: E6 F4       and  $F4
139E: 43          ld   b,e
139F: 53          ld   d,e
13A0: 52          ld   d,d
13A1: 52          ld   d,d
13A2: 52          ld   d,d
13A3: 63          ld   h,e
13A4: C3 C1 D4    jp   $D4C1
13A7: CD CF D3    call $D3CF
13AA: E7          rst  $20
13AB: F5          push af
13AC: 43          ld   b,e
13AD: 53          ld   d,e
13AE: 52          ld   d,d
13AF: 52          ld   d,d
13B0: 52          ld   d,d
13B1: 63          ld   h,e
13B2: C3 C2 D5    jp   $D5C2
13B5: D4 D6 D8    call nc,$D8D6
13B8: E8          ret  pe
13B9: F6 43       or   $43
13BB: 53          ld   d,e
13BC: 52          ld   d,d
13BD: 52          ld   d,d
13BE: 52          ld   d,d
13BF: 63          ld   h,e
13C0: C3 C3 D6    jp   $D6C3
13C3: D5          push de
13C4: D7          rst  $10
13C5: D9          exx
13C6: E9          jp   (hl)
13C7: F7          rst  $30
13C8: 43          ld   b,e
13C9: 53          ld   d,e
13CA: 52          ld   d,d
13CB: 52          ld   d,d
13CC: 52          ld   d,d
13CD: 63          ld   h,e
13CE: 63          ld   h,e
13CF: C4 D7 DC    call nz,$DCD7
13D2: DE DA       sbc  a,$DA
13D4: EA F8 43    jp   pe,$43F8
13D7: 43          ld   b,e
13D8: 52          ld   d,d
13D9: 52          ld   d,d
13DA: 52          ld   d,d
13DB: 63          ld   h,e
13DC: 63          ld   h,e
13DD: C5          push bc
13DE: D8          ret  c
13DF: DD          db   $dd
13E0: DF          rst  $18
13E1: DB EB       in   a,($EB)
13E3: F7          rst  $30
13E4: 43          ld   b,e
13E5: 43          ld   b,e
13E6: 52          ld   d,d
13E7: 52          ld   d,d
13E8: 52          ld   d,d
13E9: 63          ld   h,e
13EA: 63          ld   h,e
13EB: C6 D9       add  a,$D9
13ED: E0          ret  po
13EE: E2 E4 EC    jp   po,$ECE4
13F1: F8          ret  m
13F2: 43          ld   b,e
13F3: 43          ld   b,e
13F4: 52          ld   d,d
13F5: 52          ld   d,d
13F6: 52          ld   d,d
13F7: 63          ld   h,e
13F8: 63          ld   h,e
13F9: C7          rst  $00
13FA: DA E1 E3    jp   c,$E3E1
13FD: E5          push hl
13FE: ED          db   $ed
13FF: F7          rst  $30
1400: 43          ld   b,e
1401: 43          ld   b,e
1402: 52          ld   d,d
1403: 52          ld   d,d
1404: 52          ld   d,d
1405: 63          ld   h,e
1406: 63          ld   h,e
1407: DB DC       in   a,($DC)
1409: E8          ret  pe
140A: E7          rst  $20
140B: E6 EE       and  $EE
140D: F8          ret  m
140E: 43          ld   b,e
140F: 43          ld   b,e
1410: 52          ld   d,d
1411: 52          ld   d,d
1412: 52          ld   d,d
1413: 63          ld   h,e
1414: 63          ld   h,e
1415: DD          db   $dd
1416: 01 DE DF    ld   bc,$DFDE
1419: E9          jp   (hl)
141A: EF          rst  $28
141B: F7          rst  $30
141C: 43          ld   b,e
141D: 40          ld   b,b
141E: 43          ld   b,e
141F: 43          ld   b,e
1420: 52          ld   d,d
1421: 63          ld   h,e
1422: 63          ld   h,e
1423: A0          and  b
1424: 01 01 01    ld   bc,$0101
1427: 01 AA F8    ld   bc,$F8AA
142A: 43          ld   b,e
142B: 40          ld   b,b
142C: 40          ld   b,b
142D: 40          ld   b,b
142E: 40          ld   b,b
142F: 43          ld   b,e
1430: 67          ld   h,a
1431: A1          and  c
1432: 01 B4 B4    ld   bc,$B4B4
1435: 01 AB F6    ld   bc,$F6AB
1438: 43          ld   b,e
1439: 40          ld   b,b
143A: 43          ld   b,e
143B: 4B          ld   c,e
143C: 40          ld   b,b
143D: 43          ld   b,e
143E: C7          rst  $00
143F: A7          and  a
1440: A2          and  d
1441: 01 B3 B3    ld   bc,$B3B3
1444: 01 AC F5    ld   bc,$F5AC
1447: 43          ld   b,e
1448: 40          ld   b,b
1449: 47          ld   b,a
144A: 4F          ld   c,a
144B: 40          ld   b,b
144C: 43          ld   b,e
144D: C7          rst  $00
144E: A3          and  e
144F: 01 B3 B3    ld   bc,$B3B3
1452: 01 AD F4    ld   bc,$F4AD
1455: 43          ld   b,e
1456: 40          ld   b,b
1457: 43          ld   b,e
1458: 4B          ld   c,e
1459: 40          ld   b,b
145A: 43          ld   b,e
145B: C7          rst  $00
145C: A4          and  h
145D: 01 01 01    ld   bc,$0101
1460: 01 AE F3    ld   bc,$F3AE
1463: 43          ld   b,e
1464: 40          ld   b,b
1465: 40          ld   b,b
1466: 40          ld   b,b
1467: 40          ld   b,b
1468: 43          ld   b,e
1469: C7          rst  $00
146A: A5          and  l
146B: 01 01 01    ld   bc,$0101
146E: 01 AF 34    ld   bc,$34AF
1471: 43          ld   b,e
1472: 40          ld   b,b
1473: 40          ld   b,b
1474: 40          ld   b,b
1475: 40          ld   b,b
1476: 43          ld   b,e
1477: C0          ret  nz
1478: A6          and  (hl)
1479: A6          and  (hl)
147A: 01 B3 B3    ld   bc,$B3B3
147D: 01 B0 43    ld   bc,$43B0
1480: 40          ld   b,b
1481: 47          ld   b,a
1482: 4F          ld   c,a
1483: 40          ld   b,b
1484: 43          ld   b,e
1485: 3C          inc  a
1486: A7          and  a
1487: B3          or   e
1488: B3          or   e
1489: 01 B1 C3    ld   bc,$C3B1
148C: 43          ld   b,e
148D: 43          ld   b,e
148E: 4B          ld   c,e
148F: 40          ld   b,b
1490: 43          ld   b,e
1491: 3C          inc  a
1492: A8          xor  b
1493: 01 01 F4    ld   bc,$F401
1496: B2          or   d
1497: C3 43 40    jp   $4043
149A: 40          ld   b,b
149B: 42          ld   b,d
149C: 43          ld   b,e
149D: FF          rst  $38
149E: A9          xor  c
149F: CC CC F5    call z,$F5CC
14A2: FF          rst  $38
14A3: C3 43 43    jp   $4343
14A6: 4B          ld   c,e
14A7: 42          ld   b,d
14A8: CB A8       res  5,b
14AA: 32 3A 1E    ld   ($1E3A),a
14AD: 1C          inc  e
14AE: 1C          inc  e
14AF: 1E 3A       ld   e,$3A
14B1: 33          inc  sp
14B2: C0          ret  nz
14B3: 91          sub  c
14B4: 99          sbc  a,c
14B5: 99          sbc  a,c
14B6: 91          sub  c
14B7: 91          sub  c
14B8: 99          sbc  a,c
14B9: C0          ret  nz
14BA: 39          add  hl,sp
14BB: 3B          dec  sp
14BC: 1F          rra
14BD: 1D          dec  e
14BE: 1D          dec  e
14BF: 1F          rra
14C0: 3B          dec  sp
14C1: 39          add  hl,sp
14C2: 91          sub  c
14C3: 91          sub  c
14C4: 99          sbc  a,c
14C5: 99          sbc  a,c
14C6: 91          sub  c
14C7: 91          sub  c
14C8: 99          sbc  a,c
14C9: 99          sbc  a,c
14CA: AA          xor  d
14CB: 29          add  hl,hl
14CC: 2B          dec  hl
14CD: 02          ld   (bc),a
14CE: 10 12       djnz $14E2
14D0: 07          rlca
14D1: 3E 3C       ld   a,$3C
14D3: 32 30 95    ld   ($9530),a
14D6: 95          sub  l
14D7: 95          sub  l
14D8: 91          sub  c
14D9: 91          sub  c
14DA: 91          sub  c
14DB: 99          sbc  a,c
14DC: 99          sbc  a,c
14DD: 99          sbc  a,c
14DE: 99          sbc  a,c
14DF: 28 2B       jr   z,$150C
14E1: 03          inc  bc
14E2: 11 13 06    ld   de,$0613
14E5: 3F          ccf
14E6: 3D          dec  a
14E7: 33          inc  sp
14E8: 31 95 95    ld   sp,$9595
14EB: 91          sub  c
14EC: 91          sub  c
14ED: 91          sub  c
14EE: 91          sub  c
14EF: 99          sbc  a,c
14F0: 99          sbc  a,c
14F1: 99          sbc  a,c
14F2: 99          sbc  a,c
14F3: 73          ld   (hl),e
14F4: 71          ld   (hl),c
14F5: 0F          rrca
14F6: 03          inc  bc
14F7: 45          ld   b,l
14F8: 41          ld   b,c
14F9: 3B          dec  sp
14FA: D7          rst  $10
14FB: 2A 28 9E    ld   hl,($9E28)
14FE: 9E          sbc  a,(hl)
14FF: 91          sub  c
1500: 91          sub  c
1501: B2          or   d
1502: B2          or   d
1503: B2          or   d
1504: A1          and  c
1505: 99          sbc  a,c
1506: 99          sbc  a,c
1507: 72          ld   (hl),d
1508: 70          ld   (hl),b
1509: 61          ld   h,c
150A: 00          nop
150B: 44          ld   b,h
150C: 3A 37 D9    ld   a,($D937)
150F: 2B          dec  hl
1510: 29          add  hl,hl
1511: 9E          sbc  a,(hl)
1512: 9E          sbc  a,(hl)
1513: 95          sub  l
1514: 91          sub  c
1515: B2          or   d
1516: B2          or   d
1517: B2          or   d
1518: A1          and  c
1519: 99          sbc  a,c
151A: 99          sbc  a,c
151B: AC          xor  h
151C: 76          halt
151D: 74          ld   (hl),h
151E: 61          ld   h,c
151F: 0F          rrca
1520: 07          rlca
1521: 06 01       ld   b,$01
1523: 0E 3E       ld   c,$3E
1525: 3C          inc  a
1526: 32 30 9A    ld   ($9A30),a
1529: 9A          sbc  a,d
152A: 91          sub  c
152B: 91          sub  c
152C: 91          sub  c
152D: 91          sub  c
152E: E1          pop  hl
152F: E1          pop  hl
1530: 99          sbc  a,c
1531: 99          sbc  a,c
1532: 99          sbc  a,c
1533: 99          sbc  a,c
1534: 77          ld   (hl),a
1535: 75          ld   (hl),l
1536: 05          dec  b
1537: 07          rlca
1538: 07          rlca
1539: 06 0F       ld   b,$0F
153B: 00          nop
153C: 3F          ccf
153D: 3D          dec  a
153E: 33          inc  sp
153F: 31 9A 9A    ld   sp,$9A9A
1542: 91          sub  c
1543: 91          sub  c
1544: E1          pop  hl
1545: E1          pop  hl
1546: E1          pop  hl
1547: E1          pop  hl
1548: 99          sbc  a,c
1549: 99          sbc  a,c
154A: 99          sbc  a,c
154B: 99          sbc  a,c
154C: 73          ld   (hl),e
154D: 71          ld   (hl),c
154E: 0C          inc  c
154F: 0E 45       ld   c,$45
1551: 41          ld   b,c
1552: 3B          dec  sp
1553: D7          rst  $10
1554: 01 03 2E    ld   bc,$2E03
1557: 2C          inc  l
1558: 9E          sbc  a,(hl)
1559: 9E          sbc  a,(hl)
155A: 91          sub  c
155B: 91          sub  c
155C: B2          or   d
155D: B2          or   d
155E: B2          or   d
155F: A1          and  c
1560: 91          sub  c
1561: 91          sub  c
1562: 99          sbc  a,c
1563: 99          sbc  a,c
1564: 72          ld   (hl),d
1565: 70          ld   (hl),b
1566: 0D          dec  c
1567: 0F          rrca
1568: 44          ld   b,h
1569: 3A 37 D9    ld   a,($D937)
156C: 00          nop
156D: 02          ld   (bc),a
156E: 2F          cpl
156F: 2D          dec  l
1570: 9E          sbc  a,(hl)
1571: 9E          sbc  a,(hl)
1572: 91          sub  c
1573: 91          sub  c
1574: B2          or   d
1575: B2          or   d
1576: B2          or   d
1577: A1          and  c
1578: 91          sub  c
1579: 91          sub  c
157A: 99          sbc  a,c
157B: 99          sbc  a,c
157C: 39          add  hl,sp
157D: 3B          dec  sp
157E: 3D          dec  a
157F: 3F          ccf
1580: 10 12       djnz $1594
1582: 0C          inc  c
1583: 0E 0E       ld   c,$0E
1585: 07          rlca
1586: 70          ld   (hl),b
1587: 72          ld   (hl),d
1588: 95          sub  l
1589: 95          sub  l
158A: 95          sub  l
158B: 95          sub  l
158C: 91          sub  c
158D: 91          sub  c
158E: 91          sub  c
158F: 91          sub  c
1590: 91          sub  c
1591: 91          sub  c
1592: 92          sub  d
1593: 92          sub  d
1594: 34          inc  (hl)
1595: 3A 3C 3E    ld   a,($3E3C)
1598: 11 13 0D    ld   de,$0D13
159B: 0F          rrca
159C: 00          nop
159D: 0F          rrca
159E: 71          ld   (hl),c
159F: 73          ld   (hl),e
15A0: C0          ret  nz
15A1: 95          sub  l
15A2: 95          sub  l
15A3: 95          sub  l
15A4: 91          sub  c
15A5: 91          sub  c
15A6: 91          sub  c
15A7: 91          sub  c
15A8: 91          sub  c
15A9: 91          sub  c
15AA: 92          sub  d
15AB: 92          sub  d
15AC: AA          xor  d
15AD: 29          add  hl,hl
15AE: 2B          dec  hl
15AF: 06 0E       ld   b,$0E
15B1: 14          inc  d
15B2: 16 10       ld   d,$10
15B4: 12          ld   (de),a
15B5: 74          ld   (hl),h
15B6: 76          halt
15B7: 95          sub  l
15B8: 95          sub  l
15B9: 91          sub  c
15BA: 91          sub  c
15BB: 91          sub  c
15BC: 91          sub  c
15BD: 91          sub  c
15BE: 91          sub  c
15BF: 92          sub  d
15C0: 92          sub  d
15C1: 28 2A       jr   z,$15ED
15C3: 02          ld   (bc),a
15C4: 0F          rrca
15C5: 15          dec  d
15C6: 17          rla
15C7: 11 13 75    ld   de,$7513
15CA: 77          ld   (hl),a
15CB: 95          sub  l
15CC: 95          sub  l
15CD: 91          sub  c
15CE: 91          sub  c
15CF: 91          sub  c
15D0: 91          sub  c
15D1: 91          sub  c
15D2: 91          sub  c
15D3: 92          sub  d
15D4: 92          sub  d
15D5: 31 33 3D    ld   sp,$3D33
15D8: 3F          ccf
15D9: 0C          inc  c
15DA: 0E 0F       ld   c,$0F
15DC: 07          rlca
15DD: 2B          dec  hl
15DE: 29          add  hl,hl
15DF: 95          sub  l
15E0: 95          sub  l
15E1: 95          sub  l
15E2: 95          sub  l
15E3: 91          sub  c
15E4: 91          sub  c
15E5: 91          sub  c
15E6: 91          sub  c
15E7: 9D          sbc  a,l
15E8: 9D          sbc  a,l
15E9: 30 32       jr   nc,$161D
15EB: 3C          inc  a
15EC: 3E 0D       ld   a,$0D
15EE: 0F          rrca
15EF: 06 05       ld   b,$05
15F1: 2A 28 95    ld   hl,($9528)
15F4: 95          sub  l
15F5: 95          sub  l
15F6: 95          sub  l
15F7: 91          sub  c
15F8: 91          sub  c
15F9: 91          sub  c
15FA: 91          sub  c
15FB: 9D          sbc  a,l
15FC: 9D          sbc  a,l
15FD: A8          xor  b
15FE: 29          add  hl,hl
15FF: 2B          dec  hl
1600: 00          nop
1601: 0F          rrca
1602: 3F          ccf
1603: 3D          dec  a
1604: 33          inc  sp
1605: 31 95 95    ld   sp,$9595
1608: 91          sub  c
1609: 91          sub  c
160A: 9D          sbc  a,l
160B: 9D          sbc  a,l
160C: 9D          sbc  a,l
160D: 9D          sbc  a,l
160E: 28 2A       jr   z,$163A
1610: 01 02 3E    ld   bc,$3E02
1613: 3C          inc  a
1614: 32 30 95    ld   ($9530),a
1617: 95          sub  l
1618: 91          sub  c
1619: 91          sub  c
161A: 9D          sbc  a,l
161B: 9D          sbc  a,l
161C: 9D          sbc  a,l
161D: 9D          sbc  a,l
161E: A6          and  (hl)
161F: 25          dec  h
1620: 27          daa
1621: 21 23 3B    ld   hl,$3B23
1624: 39          add  hl,sp
1625: 95          sub  l
1626: 95          sub  l
1627: 95          sub  l
1628: 95          sub  l
1629: 9D          sbc  a,l
162A: 9D          sbc  a,l
162B: 24          inc  h
162C: 26 20       ld   h,$20
162E: 22 3A 32    ld   ($323A),hl
1631: 95          sub  l
1632: 95          sub  l
1633: 95          sub  l
1634: 95          sub  l
1635: 9D          sbc  a,l
1636: C0          ret  nz
1637: A8          xor  b
1638: 34          inc  (hl)
1639: 3A B8 BA    ld   a,($BAB8)
163C: 20 22       jr   nz,$1660
163E: 3A 33 C0    ld   a,($C033)
1641: 91          sub  c
1642: 91          sub  c
1643: 91          sub  c
1644: 91          sub  c
1645: 91          sub  c
1646: 99          sbc  a,c
1647: C0          ret  nz
1648: 39          add  hl,sp
1649: 3B          dec  sp
164A: B9          cp   c
164B: BB          cp   e
164C: 21 23 3B    ld   hl,$3B23
164F: 39          add  hl,sp
1650: 91          sub  c
1651: 91          sub  c
1652: 91          sub  c
1653: 91          sub  c
1654: 91          sub  c
1655: 91          sub  c
1656: 99          sbc  a,c
1657: 99          sbc  a,c
1658: 72          ld   (hl),d
1659: 70          ld   (hl),b
165A: 06 05       ld   b,$05
165C: 2B          dec  hl
165D: 35          dec  (hl)
165E: 78          ld   a,b
165F: 7A          ld   a,d
1660: 9A          sbc  a,d
1661: 9A          sbc  a,d
1662: E1          pop  hl
1663: E1          pop  hl
1664: B2          or   d
1665: B2          or   d
1666: 92          sub  d
1667: 92          sub  d
1668: 72          ld   (hl),d
1669: 70          ld   (hl),b
166A: 0E 02       ld   c,$02
166C: 2E 38       ld   l,$38
166E: 79          ld   a,c
166F: 7B          ld   a,e
1670: 9E          sbc  a,(hl)
1671: 9E          sbc  a,(hl)
1672: E1          pop  hl
1673: E1          pop  hl
1674: B2          or   d
1675: B2          or   d
1676: 92          sub  d
1677: 92          sub  d
1678: 77          ld   (hl),a
1679: 75          ld   (hl),l
167A: 05          dec  b
167B: 01 2F 39    ld   bc,$392F
167E: 2B          dec  hl
167F: 29          add  hl,hl
1680: 9A          sbc  a,d
1681: 9A          sbc  a,d
1682: E1          pop  hl
1683: E1          pop  hl
1684: B2          or   d
1685: B2          or   d
1686: 9D          sbc  a,l
1687: 9D          sbc  a,l
1688: 76          halt
1689: 74          ld   (hl),h
168A: 0F          rrca
168B: 07          rlca
168C: 02          ld   (bc),a
168D: 03          inc  bc
168E: 2A 28 9A    ld   hl,($9A28)
1691: 9A          sbc  a,d
1692: E1          pop  hl
1693: E1          pop  hl
1694: E1          pop  hl
1695: E1          pop  hl
1696: 9D          sbc  a,l
1697: 9D          sbc  a,l
1698: 39          add  hl,sp
1699: 3B          dec  sp
169A: 1B          dec  de
169B: 19          add  hl,de
169C: 23          inc  hl
169D: 21 27 25    ld   hl,$2527
16A0: 95          sub  l
16A1: 95          sub  l
16A2: 9D          sbc  a,l
16A3: 9D          sbc  a,l
16A4: 9D          sbc  a,l
16A5: 9D          sbc  a,l
16A6: 9D          sbc  a,l
16A7: 9D          sbc  a,l
16A8: 32 3A 1A    ld   ($1A3A),a
16AB: 18 22       jr   $16CF
16AD: 20 26       jr   nz,$16D5
16AF: 24          inc  h
16B0: C0          ret  nz
16B1: 95          sub  l
16B2: 9D          sbc  a,l
16B3: 9D          sbc  a,l
16B4: 9D          sbc  a,l
16B5: 9D          sbc  a,l
16B6: 9D          sbc  a,l
16B7: 9D          sbc  a,l
16B8: A6          and  (hl)
16B9: 33          inc  sp
16BA: 6D          ld   l,l
16BB: 6E          ld   l,(hl)
16BC: 7E          ld   a,(hl)
16BD: 35          dec  (hl)
16BE: 32 C0 70    ld   ($70C0),a
16C1: 70          ld   (hl),b
16C2: 70          ld   (hl),b
16C3: C0          ret  nz
16C4: C0          ret  nz
16C5: 6B          ld   l,e
16C6: 6C          ld   l,h
16C7: 6F          ld   l,a
16C8: 7F          ld   a,a
16C9: 7E          ld   a,(hl)
16CA: 34          inc  (hl)
16CB: 70          ld   (hl),b
16CC: 70          ld   (hl),b
16CD: 70          ld   (hl),b
16CE: 70          ld   (hl),b
16CF: 70          ld   (hl),b
16D0: C0          ret  nz
16D1: DF          rst  $18
16D2: A0          and  b
16D3: 52          ld   d,d
16D4: 50          ld   d,b
16D5: 7F          ld   a,a
16D6: 8C          adc  a,h
16D7: 70          ld   (hl),b
16D8: 71          ld   (hl),c
16D9: 81          add  a,c
16DA: 81          add  a,c
16DB: 70          ld   (hl),b
16DC: 70          ld   (hl),b
16DD: DE A1       sbc  a,$A1
16DF: 50          ld   d,b
16E0: 51          ld   d,c
16E1: 54          ld   d,h
16E2: 8D          adc  a,l
16E3: 70          ld   (hl),b
16E4: 71          ld   (hl),c
16E5: 81          add  a,c
16E6: 81          add  a,c
16E7: 81          add  a,c
16E8: 70          ld   (hl),b
16E9: DF          rst  $18
16EA: A0          and  b
16EB: 51          ld   d,c
16EC: 52          ld   d,d
16ED: 51          ld   d,c
16EE: 8D          adc  a,l
16EF: 70          ld   (hl),b
16F0: 71          ld   (hl),c
16F1: 81          add  a,c
16F2: 81          add  a,c
16F3: 81          add  a,c
16F4: 70          ld   (hl),b
16F5: 5D          ld   e,l
16F6: 5C          ld   e,h
16F7: 53          ld   d,e
16F8: 50          ld   d,b
16F9: 49          ld   c,c
16FA: 8E          adc  a,(hl)
16FB: 70          ld   (hl),b
16FC: 70          ld   (hl),b
16FD: 81          add  a,c
16FE: 81          add  a,c
16FF: 70          ld   (hl),b
1700: 70          ld   (hl),b
1701: 5E          ld   e,(hl)
1702: D5          push de
1703: D3 A2       out  ($A2),a
1705: 68          ld   l,b
1706: 6A          ld   l,d
1707: 70          ld   (hl),b
1708: 70          ld   (hl),b
1709: 70          ld   (hl),b
170A: 71          ld   (hl),c
170B: 70          ld   (hl),b
170C: 70          ld   (hl),b
170D: 32 D7 D4    ld   ($D4D7),a
1710: A6          and  (hl)
1711: 69          ld   l,c
1712: 33          inc  sp
1713: C0          ret  nz
1714: 70          ld   (hl),b
1715: 70          ld   (hl),b
1716: 71          ld   (hl),c
1717: 70          ld   (hl),b
1718: C0          ret  nz
1719: AA          xor  d
171A: 3E 3C       ld   a,$3C
171C: 3A 60 34    ld   a,($3460)
171F: 35          dec  (hl)
1720: 39          add  hl,sp
1721: 3B          dec  sp
1722: 3D          dec  a
1723: 3F          ccf
1724: 99          sbc  a,c
1725: 99          sbc  a,c
1726: 99          sbc  a,c
1727: 94          sub  h
1728: C4 C4 95    call nz,$95C4
172B: 95          sub  l
172C: 95          sub  l
172D: 95          sub  l
172E: 3F          ccf
172F: 3D          dec  a
1730: 3B          dec  sp
1731: 39          add  hl,sp
1732: 32 34 60    ld   ($6034),a
1735: 3A 3C 3E    ld   a,($3E3C)
1738: 99          sbc  a,c
1739: 99          sbc  a,c
173A: 99          sbc  a,c
173B: 99          sbc  a,c
173C: C4 C0 98    call nz,$98C0
173F: 95          sub  l
1740: 95          sub  l
1741: 95          sub  l
1742: AA          xor  d
1743: 3E 3C       ld   a,$3C
1745: 18 63       jr   $17AA
1747: 35          dec  (hl)
1748: 34          inc  (hl)
1749: 39          add  hl,sp
174A: 3B          dec  sp
174B: 3D          dec  a
174C: 3F          ccf
174D: 99          sbc  a,c
174E: 99          sbc  a,c
174F: 91          sub  c
1750: 91          sub  c
1751: CC C8 95    call z,$95C8
1754: 95          sub  l
1755: 95          sub  l
1756: 95          sub  l
1757: 3F          ccf
1758: 3D          dec  a
1759: 19          add  hl,de
175A: 34          inc  (hl)
175B: 32 35 60    ld   ($6035),a
175E: 3A 3C 3E    ld   a,($3E3C)
1761: 99          sbc  a,c
1762: 99          sbc  a,c
1763: 91          sub  c
1764: 91          sub  c
1765: C4 C0 94    call nz,$94C0
1768: 95          sub  l
1769: 95          sub  l
176A: 95          sub  l
176B: AA          xor  d
176C: 3F          ccf
176D: 3D          dec  a
176E: 19          add  hl,de
176F: 34          inc  (hl)
1770: 32 35 60    ld   ($6035),a
1773: 3A 3C 3E    ld   a,($3E3C)
1776: 9D          sbc  a,l
1777: 9D          sbc  a,l
1778: 95          sub  l
1779: 95          sub  l
177A: C0          ret  nz
177B: C4 90 91    call nz,$9190
177E: 91          sub  c
177F: 91          sub  c
1780: 3E 3C       ld   a,$3C
1782: 18 63       jr   $17E7
1784: 35          dec  (hl)
1785: 34          inc  (hl)
1786: 39          add  hl,sp
1787: 3B          dec  sp
1788: 3D          dec  a
1789: 3F          ccf
178A: 9D          sbc  a,l
178B: 9D          sbc  a,l
178C: 95          sub  l
178D: 95          sub  l
178E: C8          ret  z
178F: C0          ret  nz
1790: 91          sub  c
1791: 91          sub  c
1792: 91          sub  c
1793: 91          sub  c
1794: AA          xor  d
1795: 3F          ccf
1796: 3D          dec  a
1797: 3B          dec  sp
1798: 39          add  hl,sp
1799: 32 34 60    ld   ($6034),a
179C: 3A 3C 3E    ld   a,($3E3C)
179F: 9D          sbc  a,l
17A0: 9D          sbc  a,l
17A1: 9D          sbc  a,l
17A2: 9D          sbc  a,l
17A3: C0          ret  nz
17A4: C4 9C 91    call nz,$919C
17A7: 91          sub  c
17A8: 91          sub  c
17A9: 3E 3C       ld   a,$3C
17AB: 3A 60 34    ld   a,($3460)
17AE: 35          dec  (hl)
17AF: 39          add  hl,sp
17B0: 3B          dec  sp
17B1: 3D          dec  a
17B2: 3F          ccf
17B3: 9D          sbc  a,l
17B4: 9D          sbc  a,l
17B5: 9D          sbc  a,l
17B6: 90          sub  b
17B7: C0          ret  nz
17B8: C0          ret  nz
17B9: 91          sub  c
17BA: 91          sub  c
17BB: 91          sub  c
17BC: 91          sub  c
17BD: A6          and  (hl)
17BE: BB          cp   e
17BF: BD          cp   l
17C0: BD          cp   l
17C1: BD          cp   l
17C2: BF          cp   a
17C3: 33          inc  sp
17C4: 30 30       jr   nc,$17F6
17C6: 30 30       jr   nc,$17F8
17C8: 30 C0       jr   nc,$178A
17CA: BC          cp   h
17CB: BE          cp   (hl)
17CC: BE          cp   (hl)
17CD: BE          cp   (hl)
17CE: CF          rst  $08
17CF: 32 30 30    ld   ($3030),a
17D2: 30 30       jr   nc,$1804
17D4: 30 C0       jr   nc,$1796
17D6: A6          and  (hl)
17D7: B3          or   e
17D8: B4          or   h
17D9: B5          or   l
17DA: B4          or   h
17DB: B3          or   e
17DC: 1E 44       ld   e,$44
17DE: 44          ld   b,h
17DF: 44          ld   b,h
17E0: 44          ld   b,h
17E1: 4C          ld   c,h
17E2: C0          ret  nz
17E3: B1          or   c
17E4: 01 01 01    ld   bc,$0101
17E7: B1          or   c
17E8: F8          ret  m
17E9: 40          ld   b,b
17EA: 40          ld   b,b
17EB: 40          ld   b,b
17EC: 40          ld   b,b
17ED: 4C          ld   c,h
17EE: 63          ld   h,e
17EF: A6          and  (hl)
17F0: B1          or   c
17F1: 01 B2 01    ld   bc,$01B2
17F4: B1          or   c
17F5: F7          rst  $30
17F6: 40          ld   b,b
17F7: 40          ld   b,b
17F8: 40          ld   b,b
17F9: 40          ld   b,b
17FA: 48          ld   c,b
17FB: 63          ld   h,e
17FC: B1          or   c
17FD: 01 B2 01    ld   bc,$01B2
1800: B1          or   c
1801: F8          ret  m
1802: 40          ld   b,b
1803: 40          ld   b,b
1804: 40          ld   b,b
1805: 40          ld   b,b
1806: 48          ld   c,b
1807: 63          ld   h,e
1808: B0          or   b
1809: 01 01 01    ld   bc,$0101
180C: B0          or   b
180D: F7          rst  $30
180E: 40          ld   b,b
180F: 40          ld   b,b
1810: 40          ld   b,b
1811: 40          ld   b,b
1812: 48          ld   c,b
1813: 63          ld   h,e
1814: B1          or   c
1815: 01 01 01    ld   bc,$0101
1818: B1          or   c
1819: F8          ret  m
181A: 40          ld   b,b
181B: 40          ld   b,b
181C: 40          ld   b,b
181D: 40          ld   b,b
181E: 48          ld   c,b
181F: 63          ld   h,e
1820: B1          or   c
1821: 01 B2 01    ld   bc,$01B2
1824: B1          or   c
1825: F7          rst  $30
1826: 40          ld   b,b
1827: 40          ld   b,b
1828: 40          ld   b,b
1829: 40          ld   b,b
182A: 48          ld   c,b
182B: 63          ld   h,e
182C: B1          or   c
182D: 01 B2 01    ld   bc,$01B2
1830: B1          or   c
1831: F8          ret  m
1832: 40          ld   b,b
1833: 40          ld   b,b
1834: 40          ld   b,b
1835: 40          ld   b,b
1836: 48          ld   c,b
1837: 63          ld   h,e
1838: B0          or   b
1839: 01 01 01    ld   bc,$0101
183C: B0          or   b
183D: F7          rst  $30
183E: 40          ld   b,b
183F: 40          ld   b,b
1840: 40          ld   b,b
1841: 40          ld   b,b
1842: 48          ld   c,b
1843: 63          ld   h,e
1844: B1          or   c
1845: 01 01 01    ld   bc,$0101
1848: B1          or   c
1849: F8          ret  m
184A: 40          ld   b,b
184B: 40          ld   b,b
184C: 40          ld   b,b
184D: 40          ld   b,b
184E: 48          ld   c,b
184F: 63          ld   h,e
1850: 96          sub  (hl)
1851: B6          or   (hl)
1852: 01 B2 01    ld   bc,$01B2
1855: B6          or   (hl)
1856: B7          or   a
1857: 40          ld   b,b
1858: 40          ld   b,b
1859: 40          ld   b,b
185A: 40          ld   b,b
185B: 48          ld   c,b
185C: 40          ld   b,b
185D: A6          and  (hl)
185E: B1          or   c
185F: 01 01 01    ld   bc,$0101
1862: B1          or   c
1863: F8          ret  m
1864: 44          ld   b,h
1865: 44          ld   b,h
1866: 44          ld   b,h
1867: 44          ld   b,h
1868: 4C          ld   c,h
1869: 67          ld   h,a
186A: B3          or   e
186B: B4          or   h
186C: B5          or   l
186D: B4          or   h
186E: B3          or   e
186F: 1E 40       ld   e,$40
1871: 40          ld   b,b
1872: 40          ld   b,b
1873: 40          ld   b,b
1874: 48          ld   c,b
1875: C4 A6 B6    call nz,$B6A6
1878: 01 B2 01    ld   bc,$01B2
187B: B6          or   (hl)
187C: B7          or   a
187D: 44          ld   b,h
187E: 44          ld   b,h
187F: 44          ld   b,h
1880: 44          ld   b,h
1881: 4C          ld   c,h
1882: 44          ld   b,h
1883: B1          or   c
1884: 01 B2 01    ld   bc,$01B2
1887: B1          or   c
1888: 1D          dec  e
1889: 44          ld   b,h
188A: 44          ld   b,h
188B: 44          ld   b,h
188C: 44          ld   b,h
188D: 4C          ld   c,h
188E: C4 A4 28    call nz,$28A4
1891: 2A 06 02    ld   hl,($0206)
1894: E1          pop  hl
1895: E1          pop  hl
1896: E1          pop  hl
1897: E1          pop  hl
1898: 29          add  hl,hl
1899: 2B          dec  hl
189A: 03          inc  bc
189B: 03          inc  bc
189C: E1          pop  hl
189D: E1          pop  hl
189E: E1          pop  hl
189F: E1          pop  hl
18A0: 31 33 3D    ld   sp,$3D33
18A3: 3F          ccf
18A4: E5          push hl
18A5: E5          push hl
18A6: E5          push hl
18A7: E5          push hl
18A8: 30 32       jr   nc,$18DC
18AA: 3C          inc  a
18AB: 3E E5       ld   a,$E5
18AD: E5          push hl
18AE: E5          push hl
18AF: E5          push hl
18B0: 9C          sbc  a,h
18B1: 9B          sbc  a,e
18B2: 2C          inc  l
18B3: 2E E9       ld   l,$E9
18B5: E1          pop  hl
18B6: E1          pop  hl
18B7: E1          pop  hl
18B8: 9A          sbc  a,d
18B9: 9D          sbc  a,l
18BA: 2D          dec  l
18BB: 2F          cpl
18BC: E1          pop  hl
18BD: ED          db   $ed
18BE: E1          pop  hl
18BF: E1          pop  hl
18C0: 9A          sbc  a,d
18C1: 9C          sbc  a,h
18C2: 28 2A       jr   z,$18EE
18C4: E5          push hl
18C5: E1          pop  hl
18C6: E1          pop  hl
18C7: E1          pop  hl
18C8: 9D          sbc  a,l
18C9: 9B          sbc  a,e
18CA: 29          add  hl,hl
18CB: 2B          dec  hl
18CC: E1          pop  hl
18CD: E1          pop  hl
18CE: E1          pop  hl
18CF: E1          pop  hl
18D0: 9C          sbc  a,h
18D1: 9A          sbc  a,d
18D2: 73          ld   (hl),e
18D3: 71          ld   (hl),c
18D4: E5          push hl
18D5: ED          db   $ed
18D6: EE EE       xor  $EE
18D8: 9B          sbc  a,e
18D9: 9B          sbc  a,e
18DA: 72          ld   (hl),d
18DB: 70          ld   (hl),b
18DC: ED          db   $ed
18DD: E5          push hl
18DE: EE EE       xor  $EE
18E0: 9A          sbc  a,d
18E1: 9D          sbc  a,l
18E2: 76          halt
18E3: 74          ld   (hl),h
18E4: E5          push hl
18E5: E1          pop  hl
18E6: EA EA 9C    jp   pe,$9CEA
18E9: 9D          sbc  a,l
18EA: 77          ld   (hl),a
18EB: 75          ld   (hl),l
18EC: E1          pop  hl
18ED: E5          push hl
18EE: EA EA 9D    jp   pe,$9DEA
18F1: 9B          sbc  a,e
18F2: 76          halt
18F3: 74          ld   (hl),h
18F4: ED          db   $ed
18F5: E1          pop  hl
18F6: EA EA 9A    jp   pe,$9AEA
18F9: 9C          sbc  a,h
18FA: 77          ld   (hl),a
18FB: 75          ld   (hl),l
18FC: E1          pop  hl
18FD: E1          pop  hl
18FE: EA EA A4    jp   pe,$A4EA
1901: 30 32       jr   nc,$1935
1903: 3C          inc  a
1904: 3E E1       ld   a,$E1
1906: E1          pop  hl
1907: E1          pop  hl
1908: E1          pop  hl
1909: 31 33 3D    ld   sp,$3D33
190C: 3F          ccf
190D: E1          pop  hl
190E: E1          pop  hl
190F: E1          pop  hl
1910: E1          pop  hl
1911: 29          add  hl,hl
1912: 2B          dec  hl
1913: 00          nop
1914: 0E E1       ld   c,$E1
1916: E1          pop  hl
1917: E1          pop  hl
1918: E1          pop  hl
1919: 28 2A       jr   z,$1945
191B: 02          ld   (bc),a
191C: 0F          rrca
191D: E1          pop  hl
191E: E1          pop  hl
191F: E1          pop  hl
1920: E1          pop  hl
1921: 76          halt
1922: 74          ld   (hl),h
1923: 0E 07       ld   c,$07
1925: EA EA E1    jp   pe,$E1EA
1928: E1          pop  hl
1929: 77          ld   (hl),a
192A: 75          ld   (hl),l
192B: 0F          rrca
192C: 06 EA       ld   b,$EA
192E: EA E1 E1    jp   pe,$E1E1
1931: 73          ld   (hl),e
1932: 71          ld   (hl),c
1933: 01 02 EE    ld   bc,$EE02
1936: EE E1       xor  $E1
1938: E1          pop  hl
1939: 72          ld   (hl),d
193A: 70          ld   (hl),b
193B: 00          nop
193C: 05          dec  b
193D: EE EE       xor  $EE
193F: E1          pop  hl
1940: E1          pop  hl
1941: B6          or   (hl)
1942: B4          or   h
1943: 10 12       djnz $1957
1945: E9          jp   (hl)
1946: E9          jp   (hl)
1947: E1          pop  hl
1948: E1          pop  hl
1949: B7          or   a
194A: B5          or   l
194B: 11 13 E9    ld   de,$E913
194E: E9          jp   (hl)
194F: E1          pop  hl
1950: E1          pop  hl
1951: 2D          dec  l
1952: 2F          cpl
1953: 00          nop
1954: 06 E5       ld   b,$E5
1956: E5          push hl
1957: E1          pop  hl
1958: E1          pop  hl
1959: 2C          inc  l
195A: 2E 07       ld   l,$07
195C: 00          nop
195D: E5          push hl
195E: E5          push hl
195F: E1          pop  hl
1960: E1          pop  hl
1961: 29          add  hl,hl
1962: 2B          dec  hl
1963: 02          ld   (bc),a
1964: 03          inc  bc
1965: E5          push hl
1966: E5          push hl
1967: E1          pop  hl
1968: E1          pop  hl
1969: 28 2A       jr   z,$1995
196B: 00          nop
196C: 01 E5 E5    ld   bc,$E5E5
196F: E1          pop  hl
1970: E1          pop  hl
1971: A4          and  h
1972: 33          inc  sp
1973: 34          inc  (hl)
1974: DE A1       sbc  a,$A1
1976: C0          ret  nz
1977: C0          ret  nz
1978: 70          ld   (hl),b
1979: 71          ld   (hl),c
197A: 35          dec  (hl)
197B: 32 DE DB    ld   ($DBDE),a
197E: CC CC 70    call z,$70CC
1981: 70          ld   (hl),b
1982: 32 34 DD    ld   ($DD34),a
1985: D8          ret  c
1986: C8          ret  z
1987: C0          ret  nz
1988: 70          ld   (hl),b
1989: 70          ld   (hl),b
198A: 32 33 DF    ld   ($DF33),a
198D: A0          and  b
198E: C0          ret  nz
198F: CC 70 71    call z,$7170
1992: 33          inc  sp
1993: 34          inc  (hl)
1994: D9          exx
1995: D8          ret  c
1996: C0          ret  nz
1997: C4 70 70    call nz,$7070
199A: 32 32 DF    ld   ($DF32),a
199D: A1          and  c
199E: C8          ret  z
199F: CC 70 71    call z,$7170
19A2: 33          inc  sp
19A3: 34          inc  (hl)
19A4: DD 5C       ld   e,ixh
19A6: C0          ret  nz
19A7: C4 70 70    call nz,$7070
19AA: 34          inc  (hl)
19AB: 32 DF D6    ld   ($D6DF),a
19AE: C4 C0 70    call nz,$70C0
19B1: 70          ld   (hl),b
19B2: 32 34 DD    ld   ($DD34),a
19B5: 5C          ld   e,h
19B6: C0          ret  nz
19B7: C0          ret  nz
19B8: 70          ld   (hl),b
19B9: 70          ld   (hl),b
19BA: 34          inc  (hl)
19BB: 35          dec  (hl)
19BC: DE DB       sbc  a,$DB
19BE: C0          ret  nz
19BF: CC 70 70    call z,$7070
19C2: 34          inc  (hl)
19C3: 33          inc  sp
19C4: DF          rst  $18
19C5: A1          and  c
19C6: C8          ret  z
19C7: C0          ret  nz
19C8: 70          ld   (hl),b
19C9: 71          ld   (hl),c
19CA: 35          dec  (hl)
19CB: 32 DE DB    ld   ($DBDE),a
19CE: C0          ret  nz
19CF: C4 70 70    call nz,$7070
19D2: A6          and  (hl)
19D3: 34          inc  (hl)
19D4: 32 D9 D4    ld   ($D4D9),a
19D7: D6 54       sub  $54
19D9: C0          ret  nz
19DA: C0          ret  nz
19DB: 70          ld   (hl),b
19DC: 70          ld   (hl),b
19DD: 70          ld   (hl),b
19DE: 81          add  a,c
19DF: 32 33 32    ld   ($3233),a
19E2: D9          exx
19E3: D8          ret  c
19E4: 52          ld   d,d
19E5: C0          ret  nz
19E6: C4 C0 70    call nz,$70C0
19E9: 70          ld   (hl),b
19EA: 81          add  a,c
19EB: 33          inc  sp
19EC: 34          inc  (hl)
19ED: 35          dec  (hl)
19EE: A7          and  a
19EF: D4 D6 C8    call nc,$C8D6
19F2: C8          ret  z
19F3: C4 71 70    call nz,$7071
19F6: 70          ld   (hl),b
19F7: 35          dec  (hl)
19F8: 34          inc  (hl)
19F9: 32 32 DE    ld   ($DE32),a
19FC: DB C0       in   a,($C0)
19FE: C4 CC C0    call nz,$C0CC
1A01: 70          ld   (hl),b
1A02: 70          ld   (hl),b
1A03: 33          inc  sp
1A04: 32 34 32    ld   ($3234),a
1A07: DD          db   $dd
1A08: DB C4       in   a,($C4)
1A0A: C0          ret  nz
1A0B: C8          ret  z
1A0C: CC 70 70    call z,$7070
1A0F: 32 32 35    ld   ($3532),a
1A12: 34          inc  (hl)
1A13: DE A1       sbc  a,$A1
1A15: C8          ret  z
1A16: C4 C0 C0    call nz,$C0C0
1A19: 70          ld   (hl),b
1A1A: 71          ld   (hl),c
1A1B: 33          inc  sp
1A1C: 32 34 35    ld   ($3534),a
1A1F: DE D8       sbc  a,$D8
1A21: C0          ret  nz
1A22: C4 C0 CC    call nz,$CCC0
1A25: 70          ld   (hl),b
1A26: 70          ld   (hl),b
1A27: 34          inc  (hl)
1A28: 32 32 34    ld   ($3432),a
1A2B: D9          exx
1A2C: D8          ret  c
1A2D: CC C8 C0    call z,$C0C8
1A30: C4 70 70    call nz,$7070
1A33: A6          and  (hl)
1A34: 32 35 34    ld   ($3435),a
1A37: 33          inc  sp
1A38: DE A1       sbc  a,$A1
1A3A: C0          ret  nz
1A3B: C4 C8 C0    call nz,$C0C8
1A3E: 70          ld   (hl),b
1A3F: 71          ld   (hl),c
1A40: 33          inc  sp
1A41: 32 34 A7    ld   ($A734),a
1A44: 11 13 C0    ld   de,$C013
1A47: CC C0 75    call z,$75C0
1A4A: 70          ld   (hl),b
1A4B: 70          ld   (hl),b
1A4C: 34          inc  (hl)
1A4D: 32 33 DE    ld   ($DE33),a
1A50: A1          and  c
1A51: 51          ld   d,c
1A52: C4 C0 C8    call nz,$C8C0
1A55: 70          ld   (hl),b
1A56: 71          ld   (hl),c
1A57: 81          add  a,c
1A58: 35          dec  (hl)
1A59: 32 34 11    ld   ($1134),a
1A5C: 13          inc  de
1A5D: 54          ld   d,h
1A5E: C4 C0 C0    call nz,$C0C0
1A61: 70          ld   (hl),b
1A62: 70          ld   (hl),b
1A63: 81          add  a,c
1A64: 32 32 DE    ld   ($DE32),a
1A67: D8          ret  c
1A68: 54          ld   d,h
1A69: 53          ld   d,e
1A6A: C8          ret  z
1A6B: C4 70 70    call nz,$7070
1A6E: 81          add  a,c
1A6F: 81          add  a,c
1A70: 34          inc  (hl)
1A71: 35          dec  (hl)
1A72: D9          exx
1A73: D8          ret  c
1A74: 52          ld   d,d
1A75: 50          ld   d,b
1A76: C0          ret  nz
1A77: CC 70 70    call z,$7070
1A7A: 81          add  a,c
1A7B: 81          add  a,c
1A7C: 32 32 DF    ld   ($DF32),a
1A7F: A0          and  b
1A80: 53          ld   d,e
1A81: 52          ld   d,d
1A82: C8          ret  z
1A83: C4 70 71    call nz,$7170
1A86: 81          add  a,c
1A87: 81          add  a,c
1A88: 34          inc  (hl)
1A89: 35          dec  (hl)
1A8A: D9          exx
1A8B: D8          ret  c
1A8C: 54          ld   d,h
1A8D: 50          ld   d,b
1A8E: C0          ret  nz
1A8F: CC 70 70    call z,$7070
1A92: 81          add  a,c
1A93: 81          add  a,c
1A94: A4          and  h
1A95: 32 33 DE    ld   ($DE33),a
1A98: A1          and  c
1A99: C0          ret  nz
1A9A: C4 70 71    call nz,$7170
1A9D: 33          inc  sp
1A9E: A7          and  a
1A9F: 11 13 CC    ld   de,$CC13
1AA2: 75          ld   (hl),l
1AA3: 70          ld   (hl),b
1AA4: 70          ld   (hl),b
1AA5: 34          inc  (hl)
1AA6: DE A1       sbc  a,$A1
1AA8: 50          ld   d,b
1AA9: C8          ret  z
1AAA: 70          ld   (hl),b
1AAB: 71          ld   (hl),c
1AAC: 81          add  a,c
1AAD: 32 DE D8    ld   ($D8DE),a
1AB0: 52          ld   d,d
1AB1: C8          ret  z
1AB2: 70          ld   (hl),b
1AB3: 70          ld   (hl),b
1AB4: 81          add  a,c
1AB5: A4          and  h
1AB6: 32 34 DE    ld   ($DE34),a
1AB9: A1          and  c
1ABA: C4 C0 70    call nz,$70C0
1ABD: 71          ld   (hl),c
1ABE: 33          inc  sp
1ABF: A7          and  a
1AC0: 11 13 C8    ld   de,$C813
1AC3: 75          ld   (hl),l
1AC4: 70          ld   (hl),b
1AC5: 70          ld   (hl),b
1AC6: 33          inc  sp
1AC7: DE A1       sbc  a,$A1
1AC9: 52          ld   d,d
1ACA: C0          ret  nz
1ACB: 70          ld   (hl),b
1ACC: 71          ld   (hl),c
1ACD: 81          add  a,c
1ACE: 34          inc  (hl)
1ACF: D9          exx
1AD0: D8          ret  c
1AD1: 51          ld   d,c
1AD2: C4 70 70    call nz,$7070
1AD5: 81          add  a,c
1AD6: 32 DE A1    ld   ($A1DE),a
1AD9: 54          ld   d,h
1ADA: C0          ret  nz
1ADB: 70          ld   (hl),b
1ADC: 71          ld   (hl),c
1ADD: 81          add  a,c
1ADE: 35          dec  (hl)
1ADF: 11 13 50    ld   de,$5013
1AE2: CC 70 70    call z,$7070
1AE5: 81          add  a,c
1AE6: DF          rst  $18
1AE7: A1          and  c
1AE8: 50          ld   d,b
1AE9: 52          ld   d,d
1AEA: 70          ld   (hl),b
1AEB: 71          ld   (hl),c
1AEC: 81          add  a,c
1AED: 81          add  a,c
1AEE: DE A0       sbc  a,$A0
1AF0: 54          ld   d,h
1AF1: 51          ld   d,c
1AF2: 70          ld   (hl),b
1AF3: 71          ld   (hl),c
1AF4: 81          add  a,c
1AF5: 81          add  a,c
1AF6: D9          exx
1AF7: D4 D6 52    call nc,$52D6
1AFA: 70          ld   (hl),b
1AFB: 70          ld   (hl),b
1AFC: 70          ld   (hl),b
1AFD: 81          add  a,c
1AFE: 33          inc  sp
1AFF: D9          exx
1B00: D8          ret  c
1B01: 53          ld   d,e
1B02: C8          ret  z
1B03: 70          ld   (hl),b
1B04: 70          ld   (hl),b
1B05: 81          add  a,c
1B06: 32 A7 D4    ld   ($D4A7),a
1B09: D6 C4       sub  $C4
1B0B: 71          ld   (hl),c
1B0C: 70          ld   (hl),b
1B0D: 70          ld   (hl),b
1B0E: 34          inc  (hl)
1B0F: 33          inc  sp
1B10: DE DB       sbc  a,$DB
1B12: C0          ret  nz
1B13: C8          ret  z
1B14: 70          ld   (hl),b
1B15: 70          ld   (hl),b
1B16: 34          inc  (hl)
1B17: 35          dec  (hl)
1B18: DD          db   $dd
1B19: DB CC       in   a,($CC)
1B1B: C0          ret  nz
1B1C: 70          ld   (hl),b
1B1D: 70          ld   (hl),b
1B1E: 34          inc  (hl)
1B1F: 32 DE A1    ld   ($A1DE),a
1B22: C4 C0 70    call nz,$70C0
1B25: 71          ld   (hl),c
1B26: A8          xor  b
1B27: DE DB       sbc  a,$DB
1B29: 54          ld   d,h
1B2A: 52          ld   d,d
1B2B: 50          ld   d,b
1B2C: 52          ld   d,d
1B2D: 54          ld   d,h
1B2E: 50          ld   d,b
1B2F: 70          ld   (hl),b
1B30: 70          ld   (hl),b
1B31: 81          add  a,c
1B32: 81          add  a,c
1B33: 81          add  a,c
1B34: 81          add  a,c
1B35: 81          add  a,c
1B36: 81          add  a,c
1B37: D9          exx
1B38: DC DA 53    call c,$53DA
1B3B: 51          ld   d,c
1B3C: 50          ld   d,b
1B3D: 51          ld   d,c
1B3E: 52          ld   d,d
1B3F: 70          ld   (hl),b
1B40: 70          ld   (hl),b
1B41: 70          ld   (hl),b
1B42: 81          add  a,c
1B43: 81          add  a,c
1B44: 81          add  a,c
1B45: 81          add  a,c
1B46: 81          add  a,c
1B47: 34          inc  (hl)
1B48: DD          db   $dd
1B49: DB 50       in   a,($50)
1B4B: 54          ld   d,h
1B4C: 51          ld   d,c
1B4D: 50          ld   d,b
1B4E: 53          ld   d,e
1B4F: C0          ret  nz
1B50: 70          ld   (hl),b
1B51: 70          ld   (hl),b
1B52: 81          add  a,c
1B53: 81          add  a,c
1B54: 81          add  a,c
1B55: 81          add  a,c
1B56: 81          add  a,c
1B57: 33          inc  sp
1B58: A7          and  a
1B59: D4 D5 D1    call nc,$D1D5
1B5C: DA 52 51    jp   c,$5152
1B5F: C8          ret  z
1B60: 71          ld   (hl),c
1B61: 70          ld   (hl),b
1B62: 70          ld   (hl),b
1B63: 70          ld   (hl),b
1B64: 70          ld   (hl),b
1B65: 81          add  a,c
1B66: 81          add  a,c
1B67: 35          dec  (hl)
1B68: 32 34 D0    ld   ($D034),a
1B6B: D2 D8 50    jp   nc,$50D8
1B6E: 53          ld   d,e
1B6F: C0          ret  nz
1B70: C0          ret  nz
1B71: C4 70 70    call nz,$7070
1B74: 70          ld   (hl),b
1B75: 81          add  a,c
1B76: 81          add  a,c
1B77: 32 34 35    ld   ($3534),a
1B7A: 33          inc  sp
1B7B: A7          and  a
1B7C: D4 D5 D3    call nc,$D3D5
1B7F: C0          ret  nz
1B80: C4 C8 C0    call nz,$C0C8
1B83: 71          ld   (hl),c
1B84: 70          ld   (hl),b
1B85: 70          ld   (hl),b
1B86: 70          ld   (hl),b
1B87: A4          and  h
1B88: 70          ld   (hl),b
1B89: 72          ld   (hl),d
1B8A: 32 33 92    ld   ($9233),a
1B8D: 92          sub  d
1B8E: CC C4 71    call z,$71C4
1B91: 73          ld   (hl),e
1B92: 34          inc  (hl)
1B93: 32 92 92    ld   ($9292),a
1B96: C8          ret  z
1B97: C8          ret  z
1B98: 3E 3C       ld   a,$3C
1B9A: 3A 35 99    ld   a,($9935)
1B9D: 99          sbc  a,c
1B9E: 99          sbc  a,c
1B9F: C0          ret  nz
1BA0: 3F          ccf
1BA1: 3D          dec  a
1BA2: 3B          dec  sp
1BA3: 39          add  hl,sp
1BA4: 99          sbc  a,c
1BA5: 99          sbc  a,c
1BA6: 99          sbc  a,c
1BA7: 99          sbc  a,c
1BA8: 05          dec  b
1BA9: 01 2A 28    ld   bc,$282A
1BAC: 91          sub  c
1BAD: 91          sub  c
1BAE: 99          sbc  a,c
1BAF: 99          sbc  a,c
1BB0: 00          nop
1BB1: 07          rlca
1BB2: 2B          dec  hl
1BB3: 29          add  hl,hl
1BB4: 91          sub  c
1BB5: 91          sub  c
1BB6: 99          sbc  a,c
1BB7: 99          sbc  a,c
1BB8: 3F          ccf
1BB9: 3D          dec  a
1BBA: 3B          dec  sp
1BBB: 39          add  hl,sp
1BBC: 9D          sbc  a,l
1BBD: 9D          sbc  a,l
1BBE: 9D          sbc  a,l
1BBF: 9D          sbc  a,l
1BC0: 3E 3C       ld   a,$3C
1BC2: 3A 32 9D    ld   a,($9D32)
1BC5: 9D          sbc  a,l
1BC6: 9D          sbc  a,l
1BC7: C0          ret  nz
1BC8: 2E 2C       ld   l,$2C
1BCA: 34          inc  (hl)
1BCB: 33          inc  sp
1BCC: 99          sbc  a,c
1BCD: 99          sbc  a,c
1BCE: C4 CC 2F    call nz,$2FCC
1BD1: 2D          dec  l
1BD2: 33          inc  sp
1BD3: 32 99 99    ld   ($9999),a
1BD6: C0          ret  nz
1BD7: C0          ret  nz
1BD8: 2A 28 32    ld   hl,($3228)
1BDB: 33          inc  sp
1BDC: 99          sbc  a,c
1BDD: 99          sbc  a,c
1BDE: C0          ret  nz
1BDF: C8          ret  z
1BE0: 2B          dec  hl
1BE1: 29          add  hl,hl
1BE2: 33          inc  sp
1BE3: 32 99 99    ld   ($9999),a
1BE6: C0          ret  nz
1BE7: C4 A4 3E    call nz,$3EA4
1BEA: 3C          inc  a
1BEB: 3A 35 99    ld   a,($9935)
1BEE: 99          sbc  a,c
1BEF: 99          sbc  a,c
1BF0: C0          ret  nz
1BF1: 3F          ccf
1BF2: 3D          dec  a
1BF3: 3B          dec  sp
1BF4: 39          add  hl,sp
1BF5: 99          sbc  a,c
1BF6: 99          sbc  a,c
1BF7: 99          sbc  a,c
1BF8: 99          sbc  a,c
1BF9: 07          rlca
1BFA: 06 2F       ld   b,$2F
1BFC: 2D          dec  l
1BFD: 91          sub  c
1BFE: 91          sub  c
1BFF: 9D          sbc  a,l
1C00: 9D          sbc  a,l
1C01: 02          ld   (bc),a
1C02: 03          inc  bc
1C03: 2E 2C       ld   l,$2C
1C05: 91          sub  c
1C06: 91          sub  c
1C07: 9D          sbc  a,l
1C08: 9D          sbc  a,l
1C09: 05          dec  b
1C0A: 01 2A 28    ld   bc,$282A
1C0D: 91          sub  c
1C0E: 91          sub  c
1C0F: 99          sbc  a,c
1C10: 99          sbc  a,c
1C11: 00          nop
1C12: 07          rlca
1C13: 2B          dec  hl
1C14: 29          add  hl,hl
1C15: 91          sub  c
1C16: 91          sub  c
1C17: 99          sbc  a,c
1C18: 99          sbc  a,c
1C19: 07          rlca
1C1A: 06 2A       ld   b,$2A
1C1C: 28 91       jr   z,$1BAF
1C1E: 91          sub  c
1C1F: 99          sbc  a,c
1C20: 99          sbc  a,c
1C21: 02          ld   (bc),a
1C22: 03          inc  bc
1C23: 2B          dec  hl
1C24: 29          add  hl,hl
1C25: 91          sub  c
1C26: 91          sub  c
1C27: 99          sbc  a,c
1C28: 99          sbc  a,c
1C29: 3F          ccf
1C2A: 3D          dec  a
1C2B: 3B          dec  sp
1C2C: 39          add  hl,sp
1C2D: 9D          sbc  a,l
1C2E: 9D          sbc  a,l
1C2F: 9D          sbc  a,l
1C30: 9D          sbc  a,l
1C31: 3E 3C       ld   a,$3C
1C33: 3A 32 9D    ld   a,($9D32)
1C36: 9D          sbc  a,l
1C37: 9D          sbc  a,l
1C38: C0          ret  nz
1C39: A4          and  h
1C3A: 70          ld   (hl),b
1C3B: 72          ld   (hl),d
1C3C: 32 33 92    ld   ($9233),a
1C3F: 92          sub  d
1C40: CC C4 71    call z,$71C4
1C43: 73          ld   (hl),e
1C44: 34          inc  (hl)
1C45: 32 92 92    ld   ($9292),a
1C48: C8          ret  z
1C49: C8          ret  z
1C4A: 3E 3C       ld   a,$3C
1C4C: 3A 35 99    ld   a,($9935)
1C4F: 99          sbc  a,c
1C50: 99          sbc  a,c
1C51: C0          ret  nz
1C52: 3F          ccf
1C53: 3D          dec  a
1C54: 3B          dec  sp
1C55: 39          add  hl,sp
1C56: 99          sbc  a,c
1C57: 99          sbc  a,c
1C58: 99          sbc  a,c
1C59: 99          sbc  a,c
1C5A: 05          dec  b
1C5B: 01 2A 28    ld   bc,$282A
1C5E: 91          sub  c
1C5F: 91          sub  c
1C60: 99          sbc  a,c
1C61: 99          sbc  a,c
1C62: 00          nop
1C63: 07          rlca
1C64: 2B          dec  hl
1C65: 29          add  hl,hl
1C66: 91          sub  c
1C67: 91          sub  c
1C68: 99          sbc  a,c
1C69: 99          sbc  a,c
1C6A: 3F          ccf
1C6B: 3D          dec  a
1C6C: 3B          dec  sp
1C6D: 39          add  hl,sp
1C6E: 9D          sbc  a,l
1C6F: 9D          sbc  a,l
1C70: 9D          sbc  a,l
1C71: 9D          sbc  a,l
1C72: 3E 3C       ld   a,$3C
1C74: 3A 32 9D    ld   a,($9D32)
1C77: 9D          sbc  a,l
1C78: 9D          sbc  a,l
1C79: C0          ret  nz
1C7A: 2E 2C       ld   l,$2C
1C7C: 34          inc  (hl)
1C7D: 33          inc  sp
1C7E: 99          sbc  a,c
1C7F: 99          sbc  a,c
1C80: C4 CC 2F    call nz,$2FCC
1C83: 2D          dec  l
1C84: 33          inc  sp
1C85: 32 99 99    ld   ($9999),a
1C88: C0          ret  nz
1C89: C0          ret  nz
1C8A: A4          and  h
1C8B: 2A 28 32    ld   hl,($3228)
1C8E: 33          inc  sp
1C8F: 99          sbc  a,c
1C90: 99          sbc  a,c
1C91: C0          ret  nz
1C92: C8          ret  z
1C93: 2B          dec  hl
1C94: 29          add  hl,hl
1C95: 33          inc  sp
1C96: 32 99 99    ld   ($9999),a
1C99: C0          ret  nz
1C9A: C4 A4 00    call nz,$00A4
1C9D: 05          dec  b
1C9E: 2E 2C       ld   l,$2C
1CA0: E1          pop  hl
1CA1: E1          pop  hl
1CA2: 9D          sbc  a,l
1CA3: 9D          sbc  a,l
1CA4: 0C          inc  c
1CA5: 0E 2F       ld   c,$2F
1CA7: 2D          dec  l
1CA8: E1          pop  hl
1CA9: E1          pop  hl
1CAA: 9D          sbc  a,l
1CAB: 9D          sbc  a,l
1CAC: 0D          dec  c
1CAD: 0F          rrca
1CAE: 2B          dec  hl
1CAF: 29          add  hl,hl
1CB0: E1          pop  hl
1CB1: E1          pop  hl
1CB2: 99          sbc  a,c
1CB3: 99          sbc  a,c
1CB4: 00          nop
1CB5: 02          ld   (bc),a
1CB6: 2A 28 E1    ld   hl,($E128)
1CB9: E1          pop  hl
1CBA: 99          sbc  a,c
1CBB: 99          sbc  a,c
1CBC: 01 03 2A    ld   bc,$2A03
1CBF: 28 E1       jr   z,$1CA2
1CC1: E1          pop  hl
1CC2: 9D          sbc  a,l
1CC3: 9D          sbc  a,l
1CC4: 02          ld   (bc),a
1CC5: 01 2B 29    ld   bc,$292B
1CC8: 91          sub  c
1CC9: 91          sub  c
1CCA: 9D          sbc  a,l
1CCB: 9D          sbc  a,l
1CCC: 06 00       ld   b,$00
1CCE: 2B          dec  hl
1CCF: 29          add  hl,hl
1CD0: 91          sub  c
1CD1: 91          sub  c
1CD2: 99          sbc  a,c
1CD3: 99          sbc  a,c
1CD4: 03          inc  bc
1CD5: 07          rlca
1CD6: 2A 28 91    ld   hl,($9128)
1CD9: 91          sub  c
1CDA: 99          sbc  a,c
1CDB: 99          sbc  a,c
1CDC: 0E 00       ld   c,$00
1CDE: 2B          dec  hl
1CDF: 29          add  hl,hl
1CE0: 91          sub  c
1CE1: 91          sub  c
1CE2: 9D          sbc  a,l
1CE3: 9D          sbc  a,l
1CE4: 02          ld   (bc),a
1CE5: 0F          rrca
1CE6: 2A 28 91    ld   hl,($9128)
1CE9: 91          sub  c
1CEA: 9D          sbc  a,l
1CEB: 9D          sbc  a,l
1CEC: 3F          ccf
1CED: 3D          dec  a
1CEE: 33          inc  sp
1CEF: 31 9D 9D    ld   sp,$9D9D
1CF2: 9D          sbc  a,l
1CF3: 9D          sbc  a,l
1CF4: 3E 3C       ld   a,$3C
1CF6: 32 30 9D    ld   ($9D30),a
1CF9: 9D          sbc  a,l
1CFA: 9D          sbc  a,l
1CFB: 9D          sbc  a,l
1CFC: A4          and  h
1CFD: 2F          cpl
1CFE: 2D          dec  l
1CFF: 32 34 99    ld   ($9934),a
1D02: 99          sbc  a,c
1D03: C4 C0 2E    call nz,$2EC0
1D06: 2C          inc  l
1D07: 33          inc  sp
1D08: 32 99 99    ld   ($9999),a
1D0B: C8          ret  z
1D0C: C0          ret  nz
1D0D: 2F          cpl
1D0E: 2D          dec  l
1D0F: 32 34 99    ld   ($9934),a
1D12: 99          sbc  a,c
1D13: C8          ret  z
1D14: C0          ret  nz
1D15: 2E 2C       ld   l,$2C
1D17: 34          inc  (hl)
1D18: 32 99 99    ld   ($9999),a
1D1B: C4 C8 2B    call nz,$2BC8
1D1E: 29          add  hl,hl
1D1F: 35          dec  (hl)
1D20: 32 9D 9D    ld   ($9D9D),a
1D23: CC C0 2A    call z,$2AC0
1D26: 28 33       jr   z,$1D5B
1D28: 35          dec  (hl)
1D29: 9D          sbc  a,l
1D2A: 9D          sbc  a,l
1D2B: C4 C8 2A    call nz,$2AC8
1D2E: 28 33       jr   z,$1D63
1D30: 34          inc  (hl)
1D31: 99          sbc  a,c
1D32: 99          sbc  a,c
1D33: C8          ret  z
1D34: C0          ret  nz
1D35: 2B          dec  hl
1D36: 29          add  hl,hl
1D37: 32 34 99    ld   ($9934),a
1D3A: 99          sbc  a,c
1D3B: C4 C0 2E    call nz,$2EC0
1D3E: 2C          inc  l
1D3F: 32 34 99    ld   ($9934),a
1D42: 99          sbc  a,c
1D43: C0          ret  nz
1D44: CC 2F 2D    call z,$2D2F
1D47: 35          dec  (hl)
1D48: 32 99 99    ld   ($9999),a
1D4B: C4 C8 3E    call nz,$3EC8
1D4E: 3C          inc  a
1D4F: 3A 33 99    ld   a,($9933)
1D52: 99          sbc  a,c
1D53: 99          sbc  a,c
1D54: C0          ret  nz
1D55: 3F          ccf
1D56: 3D          dec  a
1D57: 3B          dec  sp
1D58: 39          add  hl,sp
1D59: 99          sbc  a,c
1D5A: 99          sbc  a,c
1D5B: 99          sbc  a,c
1D5C: 99          sbc  a,c
1D5D: 01 02 2B    ld   bc,$2B02
1D60: 29          add  hl,hl
1D61: 91          sub  c
1D62: 91          sub  c
1D63: 9D          sbc  a,l
1D64: 9D          sbc  a,l
1D65: 00          nop
1D66: 03          inc  bc
1D67: 2A 28 91    ld   hl,($9128)
1D6A: 91          sub  c
1D6B: 9D          sbc  a,l
1D6C: 9D          sbc  a,l
1D6D: A4          and  h
1D6E: 33          inc  sp
1D6F: 16 18       ld   d,$18
1D71: 32 C0 60    ld   ($60C0),a
1D74: 60          ld   h,b
1D75: C0          ret  nz
1D76: 1A          ld   a,(de)
1D77: 17          rla
1D78: 19          add  hl,de
1D79: 33          inc  sp
1D7A: 60          ld   h,b
1D7B: 60          ld   h,b
1D7C: 60          ld   h,b
1D7D: C0          ret  nz
1D7E: 1B          dec  de
1D7F: 20 22       jr   nz,$1DA3
1D81: 32 60 60    ld   ($6060),a
1D84: 60          ld   h,b
1D85: C0          ret  nz
1D86: 1C          inc  e
1D87: 21 23 34    ld   hl,$3423
1D8A: 60          ld   h,b
1D8B: 60          ld   h,b
1D8C: 60          ld   h,b
1D8D: C0          ret  nz
1D8E: 24          inc  h
1D8F: 25          dec  h
1D90: 26 35       ld   h,$35
1D92: 60          ld   h,b
1D93: 60          ld   h,b
1D94: 60          ld   h,b
1D95: C0          ret  nz
1D96: 27          daa
1D97: 28 29       jr   z,$1DC2
1D99: 32 60 60    ld   ($6060),a
1D9C: 60          ld   h,b
1D9D: C0          ret  nz
1D9E: 2A 2B 2C    ld   hl,($2C2B)
1DA1: FD          db   $fd
1DA2: 50          ld   d,b
1DA3: 50          ld   d,b
1DA4: 60          ld   h,b
1DA5: 62          ld   h,d
1DA6: 2D          dec  l
1DA7: 2E 2F       ld   l,$2F
1DA9: FE 50       cp   $50
1DAB: 50          ld   d,b
1DAC: 60          ld   h,b
1DAD: 66          ld   h,(hl)
1DAE: 80          add  a,b
1DAF: 82          add  a,d
1DB0: 84          add  a,h
1DB1: FE 51       cp   $51
1DB3: 51          ld   d,c
1DB4: 61          ld   h,c
1DB5: 62          ld   h,d
1DB6: 81          add  a,c
1DB7: 83          add  a,e
1DB8: 85          add  a,l
1DB9: FD          db   $fd
1DBA: 51          ld   d,c
1DBB: 51          ld   d,c
1DBC: 61          ld   h,c
1DBD: 66          ld   h,(hl)
1DBE: 86          add  a,(hl)
1DBF: 88          adc  a,b
1DC0: EA FE 61    jp   pe,$61FE
1DC3: 61          ld   h,c
1DC4: 62          ld   h,d
1DC5: 62          ld   h,d
1DC6: 87          add  a,a
1DC7: 89          adc  a,c
1DC8: EB          ex   de,hl
1DC9: FD 61       ld   iyh,c
1DCB: 61          ld   h,c
1DCC: 62          ld   h,d
1DCD: 62          ld   h,d
1DCE: 91          sub  c
1DCF: 97          sub  a
1DD0: 92          sub  d
1DD1: FE 61       cp   $61
1DD3: 51          ld   d,c
1DD4: 61          ld   h,c
1DD5: 62          ld   h,d
1DD6: 93          sub  e
1DD7: 8F          adc  a,a
1DD8: 95          sub  l
1DD9: FE 61       cp   $61
1DDB: 63          ld   h,e
1DDC: 61          ld   h,c
1DDD: 66          ld   h,(hl)
1DDE: A4          and  h
1DDF: 94          sub  h
1DE0: 8F          adc  a,a
1DE1: 96          sub  (hl)
1DE2: FD 61       ld   iyh,c
1DE4: 63          ld   h,e
1DE5: 61          ld   h,c
1DE6: 62          ld   h,d
1DE7: FA FB FC    jp   m,$FCFB
1DEA: 33          inc  sp
1DEB: 62          ld   h,d
1DEC: 62          ld   h,d
1DED: 62          ld   h,d
1DEE: C0          ret  nz
1DEF: 21 00 00    ld   hl,$0000
1DF2: 06 01       ld   b,$01
1DF4: 11 00 20    ld   de,$2000
1DF7: AF          xor  a
1DF8: 86          add  a,(hl)
1DF9: 23          inc  hl
1DFA: 4F          ld   c,a
1DFB: 1B          dec  de
1DFC: 7B          ld   a,e
1DFD: B2          or   d
1DFE: 79          ld   a,c
1DFF: 20 F7       jr   nz,$1DF8
1E01: B7          or   a
1E02: 20 05       jr   nz,$1E09
1E04: 10 EE       djnz $1DF4
1E06: C3 40 02    jp   $0240
1E09: 3E F1       ld   a,$F1
1E0B: 90          sub  b
1E0C: 32 00 40    ld   ($4000),a
1E0F: 2B          dec  hl
1E10: 7E          ld   a,(hl)
1E11: 91          sub  c
1E12: C3 12 1E    jp   $1E12
1E15: 20 0E       jr   nz,$1E25
1E17: DD CB 0F 46 bit  0,(ix+$0f)
1E1B: 28 08       jr   z,$1E25
1E1D: E5          push hl
1E1E: FD E3       ex   (sp),iy
1E20: CD 95 01    call $0195
1E23: FD E1       pop  iy
1E25: AF          xor  a
1E26: 3C          inc  a
1E27: C9          ret
1E28: 3E 04       ld   a,$04
1E2A: DD CB 0F 76 bit  6,(ix+$0f)
1E2E: C0          ret  nz
1E2F: 21 14 37    ld   hl,$3714
1E32: 18 DD       jr   $1E11
1E34: ED 5B EA 38 ld   de,($38EA)
1E38: 21 2B 3C    ld   hl,$3C2B
1E3B: E5          push hl
1E3C: 36 00       ld   (hl),$00
1E3E: 23          inc  hl
1E3F: 72          ld   (hl),d
1E40: 23          inc  hl
1E41: 73          ld   (hl),e
1E42: 23          inc  hl
1E43: 36 01       ld   (hl),$01
1E45: 0E 3A       ld   c,$3A
1E47: AF          xor  a
1E48: 18 4B       jr   $1E95
1E4A: 79          ld   a,c
1E4B: 21 04 00    ld   hl,$0004
1E4E: 19          add  hl,de
1E4F: FD 75 FA    ld   (iy-$06),l
1E52: FD 74 FB    ld   (iy-$05),h
1E55: D6 04       sub  $04
1E57: 20 02       jr   nz,$1E5B
1E59: 3C          inc  a
1E5A: C9          ret
1E5B: D5          push de
1E5C: 12          ld   (de),a
1E5D: 13          inc  de
1E5E: 2A 1F 39    ld   hl,($391F)
1E61: EB          ex   de,hl
1E62: FD CB F4 66 bit  4,(iy-$0c)
1E66: 28 1B       jr   z,$1E83
1E68: 72          ld   (hl),d
1E69: 23          inc  hl
1E6A: 73          ld   (hl),e
1E6B: 23          inc  hl
1E6C: 36 00       ld   (hl),$00
1E6E: EB          ex   de,hl
1E6F: FD CB F4 7E bit  7,(iy-$0c)
1E73: 20 07       jr   nz,$1E7C
1E75: 22 EA 38    ld   ($38EA),hl
1E78: FD CB F4 FE set  7,(iy-$0c)
1E7C: 4F          ld   c,a
1E7D: 09          add  hl,bc
1E7E: 22 1F 39    ld   ($391F),hl
1E81: 18 0D       jr   $1E90
1E83: 36 00       ld   (hl),$00
1E85: 23          inc  hl
1E86: 36 00       ld   (hl),$00
1E88: 23          inc  hl
1E89: 36 04       ld   (hl),$04
1E8B: F5          push af
1E8C: CD 5D 2A    call $2A5D
1E8F: F1          pop  af
1E90: FD 4E F4    ld   c,(iy-$0c)
1E93: CB B9       res  7,c
1E95: E1          pop  hl
1E96: C6 04       add  a,$04
1E98: 47          ld   b,a
1E99: 11 B0 39    ld   de,$39B0
1E9C: AF          xor  a
1E9D: 18 47       jr   $1EE6
1E9F: 1E 00       ld   e,$00
1EA1: 3E 05       ld   a,$05
1EA3: 21 DC 38    ld   hl,$38DC
1EA6: 32 55 3C    ld   ($3C55),a
1EA9: 01 06 00    ld   bc,$0006
1EAC: D5          push de
1EAD: 11 B0 39    ld   de,$39B0
1EB0: ED B0       ldir
1EB2: D1          pop  de
1EB3: 06 03       ld   b,$03
1EB5: FE 05       cp   $05
1EB7: 20 09       jr   nz,$1EC2
1EB9: DD CB 0F 76 bit  6,(ix+$0f)
1EBD: 20 01       jr   nz,$1EC0
1EBF: 1C          inc  e
1EC0: 06 02       ld   b,$02
1EC2: ED 53 56 3C ld   ($3C56),de
1EC6: C5          push bc
1EC7: 21 B0 39    ld   hl,$39B0
1ECA: 01 00 03    ld   bc,$0300
1ECD: CD B6 2D    call $2DB6
1ED0: 07          rlca
1ED1: 07          rlca
1ED2: 07          rlca
1ED3: 07          rlca
1ED4: 81          add  a,c
1ED5: 4F          ld   c,a
1ED6: CD B6 2D    call $2DB6
1ED9: 81          add  a,c
1EDA: 4F          ld   c,a
1EDB: 10 F0       djnz $1ECD
1EDD: C1          pop  bc
1EDE: 11 B6 39    ld   de,$39B6
1EE1: 21 55 3C    ld   hl,$3C55
1EE4: 0E 24       ld   c,$24
1EE6: E5          push hl
1EE7: C5          push bc
1EE8: 86          add  a,(hl)
1EE9: 23          inc  hl
1EEA: 10 FC       djnz $1EE8
1EEC: 2F          cpl
1EED: 3C          inc  a
1EEE: 77          ld   (hl),a
1EEF: C1          pop  bc
1EF0: EB          ex   de,hl
1EF1: D1          pop  de
1EF2: 04          inc  b
1EF3: 79          ld   a,c
1EF4: 32 AF 39    ld   ($39AF),a
1EF7: 0E 00       ld   c,$00
1EF9: 78          ld   a,b
1EFA: CD 07 01    call $0107
1EFD: CD 24 1D    call $1D24
1F00: 22 F6 36    ld   ($36F6),hl
1F03: 0E 34       ld   c,$34
1F05: 79          ld   a,c
1F06: 0F          rrca
1F07: 0F          rrca
1F08: E6 1C       and  $1C
1F0A: FE 18       cp   $18
1F0C: 30 04       jr   nc,$1F12
1F0E: CB A1       res  4,c
1F10: 18 02       jr   $1F14
1F12: 3E 10       ld   a,$10
1F14: 21 D4 36    ld   hl,$36D4
1F17: 5F          ld   e,a
1F18: 16 00       ld   d,$00
1F1A: 19          add  hl,de
1F1B: 46          ld   b,(hl)
1F1C: 2B          dec  hl
1F1D: 7E          ld   a,(hl)
1F1E: 2B          dec  hl
1F1F: 5E          ld   e,(hl)
1F20: 19          add  hl,de
1F21: 1E 09       ld   e,$09
1F23: A7          and  a
1F24: ED 52       sbc  hl,de
1F26: 70          ld   (hl),b
1F27: 2B          dec  hl
1F28: 77          ld   (hl),a
1F29: 19          add  hl,de
1F2A: 23          inc  hl
1F2B: 79          ld   a,c
1F2C: E6 1F       and  $1F
1F2E: E5          push hl
1F2F: FD E3       ex   (sp),iy
1F31: 21 94 2B    ld   hl,$2B94
1F34: 5F          ld   e,a
1F35: 16 00       ld   d,$00
1F37: 19          add  hl,de
1F38: 5E          ld   e,(hl)
1F39: 19          add  hl,de
1F3A: CD 93 2B    call $2B93
1F3D: FD E1       pop  iy
1F3F: AF          xor  a
1F40: 3C          inc  a
1F41: C9          ret
1F42: E9          jp   (hl)
1F43: 30 2F       jr   nc,$1F74
1F45: 2E 2D       ld   l,$2D
1F47: 2C          inc  l
1F48: 1D          dec  e
1F49: 1C          inc  e
1F4A: 1B          dec  de
1F4B: 18 32       jr   $1F7F
1F4D: 12          ld   (de),a
1F4E: 60          ld   h,b
1F4F: 7F          ld   a,a
1F50: 3D          dec  a
1F51: 53          ld   d,e
1F52: 00          nop
1F53: 9C          sbc  a,h
1F54: 99          sbc  a,c
1F55: 01 21 7F    ld   bc,$7F21
1F58: 39          add  hl,sp
1F59: 1E 01       ld   e,$01
1F5B: CD C7 E3    call $E3C7
1F5E: C9          ret
1F5F: 3E 02       ld   a,$02
1F61: 18 02       jr   $1F65
1F63: 3E 04       ld   a,$04
1F65: FD 6E F6    ld   l,(iy-$0a)
1F68: FD 66 F7    ld   h,(iy-$09)
1F6B: E5          push hl
1F6C: FD E1       pop  iy
1F6E: FD CB FE 56 bit  2,(iy-$02)
1F72: C8          ret  z
1F73: CB 79       bit  7,c
1F75: 28 04       jr   z,$1F7B
1F77: FD CB FE CE set  1,(iy-$02)
1F7B: C3 95 01    jp   $0195
1F7E: 21 F8 2C    ld   hl,$2CF8
1F81: 7E          ld   a,(hl)
1F82: 4F          ld   c,a
1F83: 3C          inc  a
1F84: C8          ret  z
1F85: E5          push hl
1F86: CD 56 2B    call $2B56
1F89: E1          pop  hl
1F8A: 23          inc  hl
1F8B: 18 F4       jr   $1F81
1F8D: CD 4E 1A    call $1A4E
1F90: 2A 6F 39    ld   hl,($396F)
1F93: EB          ex   de,hl
1F94: CD AE 2D    call $2DAE
1F97: C4 60 2D    call nz,$2D60
1F9A: 3E C0       ld   a,$C0
1F9C: CD E5 33    call $33E5
1F9F: 11 AF 3B    ld   de,$3BAF
1FA2: 18 63       jr   $2007
1FA4: CD 7C 2D    call $2D7C
1FA7: 2A 73 39    ld   hl,($3973)
1FAA: 73          ld   (hl),e
1FAB: 23          inc  hl
1FAC: 72          ld   (hl),d
1FAD: C9          ret
1FAE: 2A 9C 37    ld   hl,($379C)
1FB1: 3E 67       ld   a,$67
1FB3: CD E0 33    call $33E0
1FB6: 2A C0 37    ld   hl,($37C0)
1FB9: 3E 69       ld   a,$69
1FBB: CD E0 33    call $33E0
1FBE: 2A 61 39    ld   hl,($3961)
1FC1: 3E 6D       ld   a,$6D
1FC3: CD E0 33    call $33E0
1FC6: CD 7C 2D    call $2D7C
1FC9: ED 53 61 39 ld   ($3961),de
1FCD: C9          ret
1FCE: ED 5B 6F 39 ld   de,($396F)
1FD2: 2A 61 39    ld   hl,($3961)
1FD5: CD 60 2D    call $2D60
1FD8: 3E CD       ld   a,$CD
1FDA: CD E5 33    call $33E5
1FDD: 22 61 39    ld   ($3961),hl
1FE0: 3E C7       ld   a,$C7
1FE2: CD E5 33    call $33E5
1FE5: EB          ex   de,hl
1FE6: 3E C9       ld   a,$C9
1FE8: CD E5 33    call $33E5
1FEB: 18 1A       jr   $2007
1FED: 18 48       jr   $2037
1FEF: FD 6E 02    ld   l,(iy+$02)
1FF2: FD 66 03    ld   h,(iy+$03)
1FF5: 2B          dec  hl
1FF6: 22 5F 39    ld   ($395F),hl
1FF9: FD 6E 00    ld   l,(iy+$00)
1FFC: CB BD       res  7,l
1FFE: FD 8C       adc  a,iyh
