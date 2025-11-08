# Test case for `ror`
01900513  // addi x10, x0, 25
00000593  // addi x11, x0, 0
02B5160B  // ror x12, x10, x11
06400413  // addi x8, x0, 100
00C42023  // sw x12, 0(x8)
