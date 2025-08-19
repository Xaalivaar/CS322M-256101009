## Next state logic
| Current State | Input | Next State |
|---------------|-------|------------|
| S0            | 0     | S0         |
| S0            | 1     | S1         |
| S1            | 0     | S2         |
| S1            | 1     | S3         |
| S2            | 0     | S0         |
| S2            | 1     | S1         |
| S3            | 0     | S2         |
| S3            | 1     | S3         |

## Output logic
| Current State | Input | Next State |
|---------------|-------|------------|
| **S0**        | **0** | **S0**     |
| **S0**        | **1** | **S1**     |
| **S1**        | **0** | **S2**     |
| **S1**        | **1** | **S3**     |
| **S2**        | **0** | **S0**     |
| **S2**        | **1** | **S1**     |
| **S3**        | **0** | **S2**     |
| **S3**        | **1** | **S3**     |

# Overlapping Sequence Detector (1101)

## Overview
This project implements a Mealy state machine that detects the overlapping sequence "1101" in a serial input stream. The output is a 1-cycle pulse when the last bit of the sequence is detected.

## Files
- `seq_detect_mealy.v`: The main module implementing the sequence detector.
- `tb_seq_detect_mealy.v`: The testbench for simulating the sequence detector.
- `dump.vcd`: The waveform output file generated during simulation (created during runtime).

## Requirements
- Icarus Verilog (Iverilog) installed on your system.

## Compilation and Simulation Steps

1. **Open a Terminal**: Navigate to the directory containing the source files.

2. **Compile the Design**:
   Use the following command to compile the module and testbench:
   ```bash
   iverilog  -o seq_detect_tb seq_detect_mealy.v tb_seq_detect_mealy.v
