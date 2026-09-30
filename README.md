```markdown
# AES-128 Cryptographic Processor

## RTL Design and VLSI Analysis of an AES-128 Hardware Cryptographic Engine

This project presents a hardware implementation of the Advanced Encryption Standard (AES-128) using Verilog RTL. The design supports both 128-bit encryption and decryption and was developed and analyzed using AMD/Xilinx Vivado.

The project covers RTL design, functional verification, FPGA synthesis, FPGA implementation, static timing analysis, resource utilization, and power estimation.

---

## Project Overview

AES-128 is a symmetric-key cryptographic algorithm that operates on a 128-bit data block using a 128-bit encryption key.

The processor implements the major AES transformations required for encryption and decryption.

### Encryption Operations

- AddRoundKey
- SubBytes
- ShiftRows
- MixColumns
- AddRoundKey

### Decryption Operations

- AddRoundKey
- InvShiftRows
- InvSubBytes
- InvMixColumns
- AddRoundKey

---

## High-Level Architecture

```text
                   +----------------------+
                   |   aes128_fpga_top    |
                   +----------+-----------+
                              |
                              v
                   +----------------------+
                   |     aes128_top       |
                   +----------+-----------+
                              |
                    +---------+---------+
                    |                   |
                    v                   v
           +----------------+  +----------------+
           | AES Encryption |  | AES Decryption |
           |    Engine      |  |     Engine     |
           +-------+--------+  +--------+-------+
                   |                   |
                   +---------+---------+
                             |
                             v
                    128-bit Data Output
```

---

## Main RTL Modules

### Top-Level Modules

- `aes128_fpga_top.v` - FPGA-level top wrapper
- `aes128_top.v` - AES processor top module
- `aes128_top_optimized.v` - Alternative top-level design structure

### Encryption and Decryption

- `aes128_encrypt.v` - AES-128 encryption engine
- `aes128_decrypt.v` - AES-128 decryption engine

### S-Box Modules

- `aes_sbox.v` - AES substitution box
- `aes_sbox_opt.v` - Alternative S-Box implementation
- `aes_inv_sbox.v` - Inverse AES S-Box

### AES Transformation Modules

- `sub_bytes.v`
- `inv_sub_bytes.v`
- `shift_rows.v`
- `inv_shift_rows.v`
- `mix_columns.v`
- `inv_mix_columns.v`
- `mix_columns_pipelined.v`

### Key Expansion

- `key_expand.v`
- `key_expand_shared.v`

---

## Functional Verification

The design is verified using dedicated Verilog testbenches.

### Testbench Files

```text
tb/
├── aes128_tb.v
└── aes128_comparison_tb.v
```

The standard AES-128 known-answer test vector is used for functional verification.

### Encryption Test

**Plaintext**

```text
00112233445566778899aabbccddeeff
```

**Key**

```text
000102030405060708090a0b0c0d0e0f
```

**Expected Ciphertext**

```text
69c4e0d86a7b0430d8cdb78070b4c55a
```

### Decryption Test

**Ciphertext**

```text
69c4e0d86a7b0430d8cdb78070b4c55a
```

**Key**

```text
000102030405060708090a0b0c0d0e0f
```

**Expected Plaintext**

```text
00112233445566778899aabbccddeeff
```

---

## FPGA Implementation

The design was synthesized and implemented using **AMD/Xilinx Vivado**.

### Target FPGA

```text
Device      : Kintex-7
Part        : xc7k70tfbv676-1
Speed Grade : -1
```

### Clock Constraint

```text
Clock Period     : 10 ns
Target Frequency : 100 MHz
```

The timing constraint is defined in:

```text
constraints/aes128_fpga_top.xdc
```

---

## Timing Analysis

Post-implementation timing analysis produced the following results:

| Parameter | Result |
|---|---:|
| WNS | +2.275 ns |
| TNS | 0.000 ns |
| WHS | +0.065 ns |
| THS | 0.000 ns |
| WPWS | +4.600 ns |
| Failing Endpoints | 0 |

---

## Resource Utilization

Post-implementation resource utilization:

| Resource | Utilization |
|---|---:|
| Slice LUTs | 3,944 |
| Slice Registers | 2,868 |
| F7 Muxes | 616 |
| F8 Muxes | 237 |
| Slices | 1,403 |
| Bonded IOB | 5 |
| BUFGCTRL | 1 |

---

## Power Analysis

Vivado power analysis produced the following estimated results:

| Power Component | Power |
|---|---:|
| Total On-Chip Power | 0.151 W |
| Dynamic Power | 0.069 W |
| Device Static Power | 0.081 W |

These values are Vivado power estimates based on the implemented design and are not measurements from a physical FPGA board.

---

## Design Flow

```text
Requirement Definition
          ↓
RTL Development
          ↓
Functional Simulation
          ↓
AES Verification
          ↓
Synthesis
          ↓
FPGA Implementation
          ↓
Timing Analysis
          ↓
Resource Utilization Analysis
          ↓
Power Analysis
          ↓
Final Documentation
```

---

## Repository Structure

```text
AES128-Cryptographic-Processor/
├── rtl/
├── tb/
├── synth/
├── sim/
├── docs/
├── results/
├── constraints/
├── README.md
└── PROJECT_SUMMARY.md
```

---

## Tools and Technologies

- Verilog HDL
- AMD/Xilinx Vivado
- FPGA RTL Design
- RTL Simulation
- Logic Synthesis
- FPGA Implementation
- Static Timing Analysis
- Resource Utilization Analysis
- Power Estimation
- Python
- Tcl
- Yosys
- Quartus synthesis scripting

---

## Key Features

- AES-128 encryption
- AES-128 decryption
- 128-bit data block
- 128-bit encryption key
- Modular RTL architecture
- Verilog-based hardware implementation
- Standard AES verification vector
- FPGA synthesis
- FPGA implementation
- Static timing analysis
- Resource utilization analysis
- Power estimation
- Structured VLSI design workflow

---

## Project Verification

The design was functionally verified using the standard AES-128 test vector.

The implementation was then taken through:

1. RTL simulation
2. Synthesis
3. FPGA implementation
4. Timing analysis
5. Resource utilization analysis
6. Power estimation

---

## Limitations

This project was evaluated using FPGA synthesis and implementation tools.

The design was **not physically programmed onto an FPGA development board** as part of this project.

Therefore:

- Power values are tool-based estimates.
- No physical-board power measurements were performed.
- No hardware-level performance measurements were performed.
- Board-specific I/O pin constraints were not used for physical deployment.

---

## Future Improvements

Possible future improvements include:

- Fully pipelined AES architecture
- Higher-throughput AES implementation
- Area optimization
- Low-power AES architecture
- Clock-gating techniques
- Resource sharing
- S-Box optimization
- Side-channel resistance
- FPGA hardware validation
- ASIC synthesis
- Physical design analysis
- Performance and throughput benchmarking

---

## Author

**Hareesh Yarabati**

B.Tech Electronics & Communication Engineering  
AIoT Specialization

---

## Project Status

| Stage | Status |
|---|---|
| RTL Design | Completed |
| Functional Verification | Completed |
| Synthesis | Completed |
| FPGA Implementation | Completed |
| Timing Analysis | Completed |
| Resource Utilization Analysis | Completed |
| Power Analysis | Completed |
| Physical FPGA Deployment | Not Performed |

---

## License

This project is provided for educational, academic, and research purposes.
```
