# The following tests if the code is correct or not
#      RISC-V Assembly              Description                       Addr     Machine Code
main: addi x1, x0, -25              # x1 = -25                        0x00     FEF00093
      abs  x2, x1                   # x2 = | -25 | = 25               0x04     0010C0B3   ; abs x2, x1
      addi x3, x0, 25               # x3 = 25                         0x08     01900193
      beq  x2, x3, continue         # check if abs was correct        0x0C     06310063   ; if x2 != 25, skip
      jal  x0, pitfall              # jump to pitfall (wrong abs)     0x10     0100006F
continue:
      addi x4, x0, 10               # x4 = 10                         0x14     00A00213
      addi x5, x0, 15               # x5 = 15                         0x18     00F00293
      rol  x6, x4, x5               # x6 = rol(10, 15)                0x1C     02F252B3
      ror  x7, x6, x5               # x7 = ror(rol(10,15), 15)        0x20     02F2D3B3
      beq  x4, x7, next             # if back to 10, rol/ror correct  0x24     04720863
      jal  x0, pitfall              # else, pitfall                   0x28     0080006F
next:
      andn x8, x3, x1               # x8 = 25 & ~(-25)                0x2C     0011C433
      xnor x9, x3, x1               # x9 = ~(25 ^ -25)                0x30     0021E4B3
      orn  x10, x3, x1              # x10 = 25 | ~(-25)               0x34     0011D533
      abs  x2, x2                   # redo abs check                  0x38     0010C0B3
      beq  x2, x3, store            # if still correct, store         0x3C     06310063
      jal  x0, pitfall              # else pitfall                    0x40     0100006F
store:
      sw   x2, 100(x0)              # store 25 at address 100         0x44     06412023
done: beq  x0, x0, done             # infinite loop                   0x48     00000063
pitfall:
      sw x0, 100(x0)                # incorrect store (0)             0x4C     00012023
      beq x0, x0, done              # infinite loop                   0x50     00000063
