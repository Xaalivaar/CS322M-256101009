# RISC‑V Single‑Cycle (RV32I) — Icarus Verilog Quick Start

This repo contains a **single‑cycle RISC‑V (RV32I) CPU** and a tiny test program.
Follow these steps to build and run the simulation with **Icarus Verilog**.

---

## Files

- `riscvsingle.sv` — SystemVerilog source with the **CPU + testbench**. The testbench top module is `testbench` and instantiates `top` (the CPU).
- `riscvtest.txt` — **Instruction memory image** loaded by `$readmemh` (one 32‑bit hex word per line).
- `riscvtest.s` — (optional) **Assembly** source corresponding to `riscvtest.txt` (for reference).

> ✅ The test prints **“Simulation succeeded”** when the CPU writes the value **25 (0x19)** to **address 100 (0x64)**.

---

## Requirements

- **Icarus Verilog** (iverilog / vvp)
  - Ubuntu/Debian: `sudo apt-get install iverilog make`
  - macOS (Homebrew): `brew install icarus-verilog`
  - Windows: install from the official site or MSYS2; ensure `iverilog` and `vvp` are on **PATH**.
- (Optional) **GTKWave** for viewing waveforms: `sudo apt-get install gtkwave` / `brew install gtkwave`

---

## Directory Layout
```
cpu_tb
├── docs
│   ├── ENCODINGS.md
│   └── TESTPLAN.md
├── image.png
├── Makefile
├── README.md
├── riscvsingle.sv
├── simsuccessfulRV321.png
├── single.vcd
├── tests
│   ├── 25to100.txt
│   ├── abs.s
│   ├── abs.txt
│   ├── andn.s
│   ├── andn.txt
│   ├── max.s
│   ├── max.txt
│   ├── maxu.s
│   ├── maxu.txt
│   ├── min.s
│   ├── min.txt
│   ├── minu.s
│   ├── minu.txt
│   ├── orn.s
│   ├── orn.txt
│   ├── riscvtest.s
│   ├── riscvtest.txt
│   ├── rol.s
│   ├── rol.txt
│   ├── ror.s
│   ├── ror.txt
│   ├── xnor.s
│   └── xnor.txt
└── waves
    └── RV321-postImplement
        ├── alu1.png
        ├── alu2.png
        ├── alu3.png
        ├── aluDecoder.png
        ├── datapath1.png
        ├── datapath2.png
        ├── datapath3.png
        ├── decoder.png
        ├── dmem.png
        └── imem.png
```
---

## Build & Run (Terminal)

### Linux / macOS
<ol>
  <li>  For testing an instruction - put its path in $readmem
  <li>  make run - for generating vvp and vcd files
  <li>  make waves - for using gtkwaves to visualise waves
</ol>
<br> <hr>

Use the included `Makefile`:

```bash
make run        # build + run
make waves      # build + run + open wave.vcd in GTKWave
make clean      # remove generated files
```

If you prefer not to use Make, just run the iverilog/vvp commands shown above.

---

## Waveforms (Optional, with GTKWave)

- This is a **single‑cycle** RV32I subset implementation aimed at instructional use with RVX10 custom instructions.
- The provided program image exercises **ALU ops**, **load/store**, and **branches**.
- Success criterion: a store of value **25** to memory address **100**, which triggers the **“Simulation succeeded”** message from the testbench.

---

## License / Credits

This teaching setup is adapted for course use. Original single‑cycle RISC‑V example design is based on standard educational resources for RV32I.
