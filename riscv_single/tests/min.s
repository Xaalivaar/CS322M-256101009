# Test case for `min`
1	addi x8, x0, 100	06400413	address 100
2	addi x10, x0, 25	01900513	x10 = 25
3	addi x11, x0, 30	01E00593	x11 = 30
4	min x12, x10, x11	02B5060B	x12 = min(25,30)=25
5	sw x12, 0(x8)	    00C42023	store 25 at mem[100]