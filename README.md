# AES-128 VLSI Project

**RTL Design and VLSI Analysis of an AES-128 Hardware Cryptographic Engine**

## Overview

This project implements a complete AES-128 hardware cryptographic engine in Verilog HDL, supporting both encryption and decryption operations. The design follows a modular architecture with separate modules for each AES transformation, enabling independent verification and optimization.

## Features

- **AES-128 Encryption & Decryption**: Full implementation of FIPS-197 standard
- **Modular Architecture**: Separate modules for SubBytes, ShiftRows, MixColumns, KeyExpansion
- **Synchronous Design**: Single-clock domain with synchronous reset
- **Mode Selection**: Runtime selection between encryption (mode=0) and decryption (mode=1)
- **Standard Test Vectors**: NIST FIPS-197 validated test cases

## Project Structure

```
AES128_VLSI_PROJECT/
├── rtl/                    # RTL Verilog source files
│   ├── aes_sbox.v          # Forward S-box (combinational lookup)
│   ├── aes_inv_sbox.v      # Inverse S-box (combinational lookup)
│   ├── sub_bytes.v         # SubBytes transformation (16 parallel S-boxes)
│   ├── inv_sub_bytes.v     # Inverse SubBytes transformation
│   ├── shift_rows.v        # ShiftRows permutation
│   ├── inv_shift_rows.v    # Inverse ShiftRows permutation
│   ├── mix_columns.v       # MixColumns with xtime/mul3
│   ├── inv_mix_columns.v   # Inverse MixColumns with GF(2^8) multiplier
│   ├── key_expand.v        # Key expansion (generates 11 round keys)
│   ├── aes128_encrypt.v    # Encryption datapath with FSM control
│   ├── aes128_decrypt.v    # Decryption datapath with FSM control
│   └── aes128_top.v        # Top-level module with mode selection
├── tb/                     # Testbench
│   └── aes128_tb.v         # Self-checking testbench with NIST vectors
├── sim/                    # Simulation scripts and results
│   ├── waveforms/          # VCD/WLF waveform files
│   └── logs/               # Simulation logs
├── synth/                  # Synthesis scripts and constraints
│   ├── constraints/        # XDC/SDC constraint files
│   ├── reports/            # Synthesis reports
│   ├── synth_aes128.tcl    # Vivado synthesis script
│   └── simulate.do         # ModelSim simulation script
├── results/                # Analysis results
│   ├── timing/             # Timing reports
│   ├── area/               # Area/utilization reports
│   ├── power/              # Power estimation reports
│   └── screenshots/        # Screenshots for documentation
├── docs/                   # Documentation
│   ├── AES128_VLSI_PROJECT_BRAIN.pdf  # Project brain/reference
│   └── AES128_PROJECT_SPEC.md         # Complete specification
└── README.md               # This file
```

## Module Interfaces

### Top Module: `aes128_top`

| Signal | Direction | Width | Description |
|--------|-----------|-------|-------------|
| `clk` | Input | 1 | System clock |
| `rst` | Input | 1 | Synchronous reset (active high) |
| `start` | Input | 1 | Start pulse (1 cycle) |
| `mode` | Input | 1 | 0=encrypt, 1=decrypt |
| `data_in` | Input | 128 | Plaintext (encrypt) / Ciphertext (decrypt) |
| `key` | Input | 128 | AES-128 secret key |
| `data_out` | Output | 128 | Ciphertext (encrypt) / Plaintext (decrypt) |
| `done` | Output | 1 | Operation complete pulse |

## Test Vectors (NIST FIPS-197)

### Encryption
```
Plaintext:  00112233445566778899aabbccddeeff
Key:        000102030405060708090a0b0c0d0e0f
Ciphertext: 69c4e0d86a7b0430d8cdb78070b4c55a
```

### Decryption
```
Ciphertext: 69c4e0d86a7b0430d8cdb78070b4c55a
Key:        000102030405060708090a0b0c0d0e0f
Plaintext:  00112233445566778899aabbccddeeff
```

## Quick Start

### Simulation (ModelSim/QuestaSim)
```bash
cd sim
vsim -do simulate.do
```

### Synthesis (Vivado)
```bash
cd synth
vivado -mode batch -source synth_aes128.tcl
```

Or open Vivado GUI and run:
```tcl
source synth_aes128.tcl
```

## Design Details

### Encryption Flow
```
Plaintext XOR Key0
    |
    v
Round 1-9: SubBytes -> ShiftRows -> MixColumns -> AddRoundKey
    |
    v
Round 10: SubBytes -> ShiftRows -> AddRoundKey
    |
    v
Ciphertext
```

### Decryption Flow
```
Ciphertext XOR Key10
    |
    v
Round 9-1: InvShiftRows -> InvSubBytes -> InvMixColumns -> AddRoundKey
    |
    v
Round 0: InvShiftRows -> InvSubBytes -> AddRoundKey
    |
    v
Plaintext
```

### Key Expansion
Generates 11 round keys (128 bits each) from the 128-bit master key using AES key schedule with S-box, rotation, and Rcon.

## Performance Targets

| Metric | Target |
|--------|--------|
| Clock Frequency | 100 MHz (10 ns period) |
| Latency (encrypt) | ~12 cycles |
| Latency (decrypt) | ~22 cycles (includes key gen) |
| Throughput | ~1 block / 12 cycles |

## VLSI Analysis Flow

1. **Functional Verification**: Run testbench, verify PASS for encrypt/decrypt
2. **RTL Synthesis**: Synthesize with target constraints (10ns clock)
3. **Timing Analysis**: Check WNS, TNS, critical path
4. **Area Analysis**: LUT, FF, BRAM, DSP utilization
5. **Power Estimation**: Dynamic/static power at target frequency
6. **Optimization**: Identify bottlenecks, apply one optimization, re-verify

## Optimization Opportunities

1. **S-box Optimization**: Replace LUT with composite field arithmetic
2. **Resource Sharing**: Share SubBytes/InvSubBytes hardware
3. **Pipelining**: Add pipeline registers in MixColumns/KeyExpansion
4. **Round Unrolling**: Parallel round execution for higher throughput
5. **Clock Gating**: Reduce dynamic power in idle cycles

## Results Documentation

After synthesis, fill in the results table:

| Metric | Baseline | Optimized |
|--------|----------|-----------|
| LUT / Cell Area | TBD | TBD |
| Flip-flops | TBD | TBD |
| Max Frequency | TBD | TBD |
| Critical Path | TBD | TBD |
| Dynamic Power | TBD | TBD |
| Static Power | TBD | TBD |
| Latency (cycles) | TBD | TBD |
| Throughput (Mbps) | TBD | TBD |

## Requirements

- **Simulation**: ModelSim/QuestaSim, Vivado Simulator, or Icarus Verilog
- **Synthesis**: Vivado 2020.1+, Quartus Prime, or Yosys
- **Technology**: Target FPGA (Xilinx 7-series, Intel Cyclone) or ASIC library

## License

This project is for educational and research purposes. AES algorithm is defined in FIPS-197 (public domain).

## References

- FIPS-197: Advanced Encryption Standard (AES)
- NIST SP 800-38A: Block Cipher Modes
- "The Design of Rijndael" by Daemen and Rijmen