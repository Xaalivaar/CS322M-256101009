# RISC‑V Single‑Cycle (RV32I) — Icarus Verilog Quick Start

This repo contains a **pipelined RISC‑V (RV32I) CPU** and a test programs.
Follow these steps to build and run the simulation with **Icarus Verilog**.

Please find the REPORT.md in docs subdirectory

---

## Files

 - ALU_Decoder.v
 - ALU.v
 - a.out
 - Control_Unit_Top.v
 - Data_Memory.v
 - Decode_Cyle.v
 - dump.vcd
 - Execute_Cycle.v
 - Fetch_Cycle.v
 - hazard_detection_uni.v - hazard resolution implementing stall and flush logic
 - Hazard_unit.v - hazard resolution implementing data forwarding
 - Instruction_Memory.v
 - Main_Decoder.v
 - memfile.hex
 - Memory_Cycle.v
 - Mux.v
 - PC_Adder.v
 - PC.v
 - pipeline.gtkw
 - pipeline_tb.v
 - Pipeline_Top.v
 - Register_File.v
 - rv32I.txt - a test file for convinient testing
 - Sign_Extend.v
 - Writeback_Cycle.v


> ✅ The test prints **“Simulation succeeded”** when the CPU writes the value **25 (0x19)** to **address 100 (0x64)**.

---

## Requirements

- **Icarus Verilog** (iverilog / vvp)
  - Ubuntu/Debian: `sudo apt-get install iverilog`
  - macOS (Homebrew): `brew install icarus-verilog`
  - Windows: install from the official site or MSYS2; ensure `iverilog` and `vvp` are on **PATH**.
- (Optional) **GTKWave** for viewing waveforms: `sudo apt-get install gtkwave` / `brew install gtkwave`

---

## Directory Layout
```
.
├── docs
├── src
└── tests

docs
├── all the images from report.md in png format
└── REPORT.md

tests
├── 25to100.txt
├── abs.s
├── abs.txt
├── andn.s
├── andn.txt
├── max.s
├── max.txt
├── maxu.s
├── maxu.txt
├── min.s
├── min.txt
├── minu.s
├── minu.txt
├── orn.s
├── orn.txt
├── riscvtest.s
├── riscvtest.txt
├── rol.s
├── rol.txt
├── ror.s
├── ror.txt
├── rv32I.s
├── rv32I.txt
├── xnor.s
└── xnor.txt
```
---

## Build & Run (Terminal)

### Linux / macOS
<ol>
  <li>  For testing an instruction - put its path in $readmem
  <li>  goto src subdir - 'iverilog -g2012 pipeline_tb.v Pipeline_Top.v'
  <li>  vvp a.out
  <li>  gtkwave dump.vcd
</ol>
<br> <hr>


## Waveforms (Optional, with GTKWave)

- This is a **pipelined** RV32I subset implementation aimed at instructional use with RVX10 custom instructions.
- The provided program image exercises **ALU ops**, **load/store**, and **branches**.
- Success criterion: a store of value **25** to memory address **100**, which triggers the **“Simulation succeeded”** message from the testbench.

---

## License / Credits

This learning setup is adapted for course use. Original single‑cycle RISC‑V example design is based on standard educational resources for RV32I.
The following resource was used as a source of knowledge:
 - https://github.com/merldsu/RISCV_Pipeline_Core

The following resource was used for bootstrapping and comparison:
 - https://github.com/merldsu/RISCV_Pipeline_Core
