# Test case for `maxu`
addi s1, x0, 120       # Load 120 into s1 (address to store result)
addi s2, x0, 25        # Load 25 into s2
addi s3, x0, 10        # Load 10 into s3 (≤25)
maxu s2, s2, s3        # s2 = maxu(25, 10) = 25
sw s2, 0(s1)           # Store 25 at address 120
