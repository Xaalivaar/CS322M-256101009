# Test case for orn
00000093    # addi x1, x0, 0x00      ; x1 = 0
FE600113    # addi x2, x0, -26       ; x2 = 0xFFFFFFE6 (which is ~25)
0020118B    # orn x3, x1, x2         ; x3 = x1 | ~x2 = 0 | ~(-26) = 25
06302223    # sw  x3, 100(x0)        ; store 25 at address 100