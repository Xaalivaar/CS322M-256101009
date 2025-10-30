addi s1, x0, 100       # Load 100 into s1 (address to store result)
addi s2, x0, 25        # Load 25 into s2
addi s3, x0, 0         # Load 0 into s3
orn s2, s2, s3          # Perform OR with NOT of s3 -> s2 = 25 | ~0 = 25 | -1 = -1 ??? 
sw s2, 0(s1)           # Store 25 at address 100

-------------------------------------------------------------------------------------------------------------

addi s1, x0, 100       # Address
addi s2, x0, 0         # s2 = 0
addi s3, x0, -26       # s3 = -26
orn s2, s2, s3         # s2 = 0 | ~(-26) = 0 | 25 = 25
sw s2, 0(s1)           # Store 25 at address 100
