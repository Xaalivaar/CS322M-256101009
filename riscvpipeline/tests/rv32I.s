# A test for rv32I instructions
00A00293: addi x5, x0, 10      // x5 = 10
00F00313: addi x6, x0, 15      // x6 = 15
006283B3: add  x7, x5, x6      // x7 = x5 + x6 = 25
06400413: addi x8, x0, 100     // x8 = 100
00742023: sw   x7, 7(x8)       // MEM[x8 + 7] = x7 = 25
00042483: lw   x9, 0(x8)       // x9 = MEM[x8 + 0]
00048533: add  x10, x9, x0     // x10 = x9
00750463: beq  x10, x7, +7     // if x10 == x7 jump forward 7
00100593: addi x11, x0, 1      // x11 = 1
FFB00613: addi x12, x0, -5     // x12 = -5
0606069B: add  x13, x12, x12   // x13 = x12 + x12 = -10
00000063: beq  x0, x0, 0       // infinite loop