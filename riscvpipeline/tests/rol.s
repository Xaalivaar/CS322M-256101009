# Test case for `rol`
06400093    # addi x1, x0, 100
00300113    # addi x2, x0, 3
0420818B    # rol x3, x1, x2        ; rotate left test
01900193    # addi x3, x0, 25
06302223    # sw x3, 100(x0)
