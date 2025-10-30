# Test case for `xnor`
06400413	addi x8, x0, 100	base address
00000593	addi x11, x0, 0	operand 1
FE600613	addi x12, x0, -26	operand 2
00C5950B	xnor x10, x11, x12	result (25)
00A42023	sw x10, 0(x8)	store result to address 100