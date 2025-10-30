# Test case for `andn`
addi x8, x0, 100     # x8 = 100
addi x10, x0, 25     # x10 = 25
addi x11, x0, 5      # x11 = 5
andn x12, x10, x11   # x12 = x10 & ~x11   -> 24, uses andn
sw   x10, 0(x8)      # MEM[100] = 25
