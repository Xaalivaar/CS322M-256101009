# Two-Road Traffic Light Controller

## Overview
Given RTL implements a Moore state machine that controls traffic lights for **North-South (NS)** and **East-West (EW)** directions.  
Timing requirements:

- NS green for 5 ticks
- NS yellow for 2 ticks
- EW green for 5 ticks
- EW yellow for 2 ticks  
- Repeat continuously

A **1 Hz tick** is used to advance the internal tick counter. The FSM uses 4 states and a per-phase counter.
The traffic light controller doesn’t generate the tick itself — it assumes an external 1 Hz pulse is provided. In practice, this tick is usually derived from a faster FPGA system clock (e.g. 50 MHz or 100 MHz) using a frequency divider.<br>
Counts cycles of the fast clock and then generates a pulse or toggle after the required number of cycles.
The prescaler is just a frequency divider placed in-front of the circuit in concern.

---

## Deliverables

### 1. State Diagram
The FSM has 4 states:
- **S0:** NS = Green, EW = Red (5 ticks)
- **S1:** NS = Yellow, EW = Red (2 ticks)
- **S2:** NS = Red, EW = Green (5 ticks)
- **S3:** NS = Red, EW = Yellow (2 ticks)

Transitions occur when the tick counter exceeds the required duration.  
Outputs are Moore-type: depend only on state.

### 2. RTL Code
Implemented in `traffic_light.v`.  
- Synchronous, active-high reset (`rst`)  
- FSM state register (`state`) and tick counter (`tick_count`)  
- Outputs: `ns_g, ns_y, ns_r, ew_g, ew_y, ew_r` (mutually exclusive per road)

### 3. Testbench
The testbench `tb_traffic_light.v`:
- Generates a 100 MHz clock (`clk`)  
- Generates tick pulses at 1 Hz equivalent (simulated with faster time scaling)  
- Applies synchronous reset  
- Dumps waveform file (`traffic_light.vcd`) for visualization  

### 4. Waveforms
Open `traffic_light.vcd` in **GTKWave** or similar tool.  
Verify that:
- NS green lasts **5 ticks** before turning yellow  
- NS yellow lasts **2 ticks** before turning red  
- EW green lasts **5 ticks**  
- EW yellow lasts **2 ticks**  
- Exactly one of {green, yellow, red} is high per road at any time  

---

## How to Run

1. Compile:
    iverilog -o traffic_light_tb traffic_light.v tb_traffic_light.v

2. Run:
    vvp traffic_light_tb

3. Visualize:
    Use GTKWave to view waveform:
    gtkwave traffic.vcd

## One-hot encoding - Justification

Simplicity of output decoding — each state directly drives the one-hot outputs (ns_g/ns_y/ns_r and ew_g/ew_y/ew_r) without extra combinational logic, eliminating a separate decode stage and reducing chance of coding errors.
Clear Moore mapping — Moore outputs depend only on state; one-hot makes that mapping literal (one register bit per visible output), improving readability and maintainability.
Glitch-free outputs — with one-hot each output is driven by a single register bit rather than logic combining multiple bits, lowering combinational path complexity and reducing transient glitches when state bits change.
Easy timing verification — waveform inspection shows which state bit is high; assertions and coverage (e.g., exactly-one-hot) are trivial to write.
Small FSM: with only 4 states the area overhead (4 flip‑flops vs 2 for binary) is negligible on FPGA/ASIC but gives the benefits above.
Faster next-state logic in some flows — next-state or transition decoding can be simpler and faster because checks are single-bit tests rather than multi-bit comparators.
Safe for synchronous reset and power-up — explicit state bits reduce ambiguity about encoding on reset.
