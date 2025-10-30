# Test case for `rol`
----------------------------------------------------
| Instruction       | Hex        | Comment         |
| ----------------- | ---------- | --------------- |
| addi x8, x0, 100  | 0x06400413 | base address    |
| addi x10, x0, 25  | 0x01900513 | value to store  |
| addi x11, x0, 0   | 0x00000593 | rotate amount   |
| rol x12, x10, x11 | 0x00B5068B | rotate value    |
| sw x12, 0(x8)     | 0x00A42023 | store in memory |
