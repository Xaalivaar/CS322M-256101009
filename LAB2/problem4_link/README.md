
# Master–Slave 4‑Phase Handshake (Two FSMs)

This repo contains synthesizable RTL for a **master** and **slave** FSM implementing a 4‑phase `req/ack` handshake over an 8‑bit data bus. The master sends **4 bytes** (`A0..A3`), the slave latches data on `req`, asserts `ack` for **2 cycles**, and de‑asserts after `req` drops. A 1‑cycle `done` pulse is asserted by the master when the burst completes.

## Files
- `master_fsm.sv` – Master FSM (Moore). States: `M0_IDLE`, `M1_REQ`, `M2_WAITACKLOW`, `M3_CLEANUP`.
- `slave_fsm.sv` – Slave FSM (Moore ack). States: `S0_IDLE`, `S1_ACK`. Latches `last_byte` on `req` edge; holds `ack` >= 2 cycles.
- `link_top.sv` – Wires master and slave.
- `tb_link_top.sv` – Testbench with clock/reset, monitors, and VCD.
- `wave.vcd` – Generated on simulation (Icarus Verilog).
- `timing.png` – Annotated timing showing the 4 handshakes and the `done` pulse.

## Build & Run

Using **Icarus Verilog**:

```bash
iverilog -g2012 -o simv tb_link_top.sv link_top.sv master_fsm.sv slave_fsm.sv
vvp simv
# will write wave.vcd
```

View waveforms in GTKWave:
```bash
gtkwave wave.vcd
```

## Expected Behavior
- 4 handshakes occur; master drives `A0`..`A3` on `data`.
- `req` stays high during each transfer until `ack` is seen.
- Slave asserts `ack` within 1 cycle of `req`, holds it **2 cycles**, and drops it only after `req` is low.
- Master de‑asserts `req` after observing `ack=1`, waits for `ack=0`, then advances to the next byte.
- `done` pulses **1 cycle** after the fourth transfer completes (when `ack` drops the final time).

## Encoding / Style
- Moore outputs -> clean timing.
- Binary encoding via SystemVerilog `enum`.
- Synchronous, active‑high reset; all transitions on `posedge clk`.

## State transition logic - Master
| Current State | Input Conditions                | Next State | Output (ack) | Output (done) |
|---------------|----------------------------------|-------------|--------------|---------------|
| M0            | req=1, byte_count<4             | M1          | 0            | 0             |
| M1            | byte_count<4, done=0            | M2          | 0            | 0             |
| M1            | done=1                           | M3          | 0            | 1             |
| M2            | done=0                           | M1          | 0            | 0             |
| M2            | done=1                           | M3          | 0            | 1             |
| M3            | req=1                            | M1          | 0            | 0             |

## State transition logic - Slave
| Current State | Input Conditions | Next State | Output (latch_data) |
|---------------|------------------|-------------|----------------------|
| S0            | req=1            | S1          | latch_data=bus_data  |
| S0            | req=0            | S0          | -                    |
| S1            | ack=1            | S0          | -                    |
| S1            | ack=0            | S1          | -                    |