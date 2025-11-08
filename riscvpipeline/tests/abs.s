# Test case for `abs`
| Instruction       | Hex      |
| ----------------- | -------- |
| addi x5, x0, -25  | FFE00593 |
| abs x6, x5        | 00B5058B |
| addi x10, x0, 100 | 06400413 |
| addi x7, x0, 25   | 01900513 |
| sw x7, 0(x10)     | 00A42023 |
