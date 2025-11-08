0FF00093    # addi x1, x0, 0xFF     ; x1 = 255
0E600113    # addi x2, x0, 0xE6     ; x2 = 230
0020818B    # andn x3, x1, x2       ; x3 = x1 & ~x2 = 25
06302223    # sw   x3, 100(x0)      ; store 25 at address 100
