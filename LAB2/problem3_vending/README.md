# Vending Machine (Mealy) - Verilog

## Description
Implements a Mealy-type vending machine that accepts 5 or 10-unit coins. Dispenses product when total >= 20. Returns change if total = 25.

## Run Instructions
1. Compile:
    iverilog -o vending_tb vending_mealy.v tb_vending_mealy.v

2. Run:
    vvp vending_tb

3. Visualize:
    Use GTKWave to view waveform:
    gtkwave dump.vcd

## Expected Behavior
- Insert coins (5, 10) in sequences totaling >= 20.
- `dispense` goes high for 1 cycle on vend.
- `chg5` goes high if 25 was inserted.

## Justification for Mealy machine
- This is a Mealy Machine because the outputs (dispense and chg5) depend not only on the current state but also on the current input (e.g., a 10 coin at S2 causes a vend + change instantly without needing to enter a new state first). This immediate responsiveness avoids unnecessary extra states.