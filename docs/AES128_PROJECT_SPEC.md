# AES-128 VLSI PROJECT — COMPLETE SPECIFICATION

## 0. Resource baseline

Primary resource file:

`AES128_ALL_VERILOG_CODE(2).txt`

The supplied resource contains these Verilog modules:

- `aes_sbox`
- `aes_inv_sbox`
- `sub_bytes`
- `inv_sub_bytes`
- `shift_rows`
- `inv_shift_rows`
- `mix_columns`
- `inv_mix_columns`
- `key_expand`
- `aes128_encrypt`
- `aes128_decrypt`
- `aes128_top`
- `aes128_tb`

The implementation includes AES S-box/inverse S-box, byte substitution, row shifts, column mixing, key expansion, encryption, decryption, top-level mode selection, and a testbench.

---

# 1. Project title

**RTL Design and VLSI Analysis of an AES-128 Hardware Cryptographic Engine**

## 2. Project objective

Design, verify, synthesize and analyze a hardware AES-128 engine using Verilog HDL.

The project must demonstrate:

1. RTL design
2. Modular digital hardware architecture
3. AES-128 encryption
4. AES-128 decryption
5. Functional verification
6. Synthesis
7. Timing analysis
8. Area/utilization analysis
9. Power estimation where supported
10. Optional architecture optimization

---

# 3. Functional specification

## Inputs

| Signal | Width | Purpose |
|---|---:|---|
| `clk` | 1 | System clock |
| `rst` | 1 | Synchronous reset in the supplied sequential blocks |
| `start` | 1 | Starts the selected operation |
| `mode` | 1 | `0 = encrypt`, `1 = decrypt` |
| `data_in` | 128 | Plaintext for encryption / ciphertext for decryption |
| `key` | 128 | AES-128 secret key |

## Outputs

| Signal | Width | Purpose |
|---|---:|---|
| `data_out` | 128 | Ciphertext or recovered plaintext |
| `done` | 1 | Indicates completion |

The supplied top module connects the encryption engine when `mode=0` and the decryption engine when `mode=1`.

---

# 4. Required project hierarchy

```text
AES128_VLSI_PROJECT/
│
├── rtl/
│   ├── aes_sbox.v
│   ├── aes_inv_sbox.v
│   ├── sub_bytes.v
│   ├── inv_sub_bytes.v
│   ├── shift_rows.v
│   ├── inv_shift_rows.v
│   ├── mix_columns.v
│   ├── inv_mix_columns.v
│   ├── key_expand.v
│   ├── aes128_encrypt.v
│   ├── aes128_decrypt.v
│   └── aes128_top.v
│
├── tb/
│   └── aes128_tb.v
│
├── sim/
│   ├── waveforms/
│   └── logs/
│
├── synth/
│   ├── reports/
│   └── constraints/
│
├── results/
│   ├── timing/
│   ├── area/
│   ├── power/
│   └── screenshots/
│
├── docs/
│   ├── AES128_VLSI_PROJECT_BRAIN.pdf
│   └── AES128_PROJECT_SPEC.md
│
└── README.md
```

---

# 5. RTL module specification

## 5.1 `aes_sbox.v`

**Purpose:** AES forward substitution.

**Interface:**
```verilog
module aes_sbox(
    input wire [7:0] a,
    output reg [7:0] d
);
```

**Implementation in baseline:** combinational `case` lookup table.

**Verification:** test all 256 input values if possible.

---

## 5.2 `aes_inv_sbox.v`

**Purpose:** inverse AES substitution.

**Interface:**
```verilog
module aes_inv_sbox(
    input wire [7:0] a,
    output reg [7:0] d
);
```

**Verification:** confirm inverse mapping against the AES table.

---

## 5.3 `sub_bytes.v`

**Purpose:** apply the S-box to all 16 bytes of the 128-bit AES state.

**Architecture:**

```text
128-bit state
   |
   +-- byte 0 -> SBOX
   +-- byte 1 -> SBOX
   ...
   +-- byte 15 -> SBOX
   |
128-bit result
```

The baseline uses 16 generated S-box instances.

---

## 5.4 `inv_sub_bytes.v`

Same architecture as SubBytes but using the inverse S-box.

---

## 5.5 `shift_rows.v`

**Purpose:** AES row permutation.

Input/output width: 128 bits.

No clock is required in this combinational module.

---

## 5.6 `inv_shift_rows.v`

**Purpose:** reverse row permutation for decryption.

---

## 5.7 `mix_columns.v`

**Purpose:** forward AES column transformation.

The baseline uses `xtime`, multiplication by 2 and multiplication by 3.

This block is a key candidate for synthesis/timing inspection.

---

## 5.8 `inv_mix_columns.v`

**Purpose:** inverse MixColumns.

The baseline uses a general finite-field multiplier function and AES constants:

```text
09, 0B, 0D, 0E
```

This block should be checked carefully for area/timing after synthesis.

---

## 5.9 `key_expand.v`

**Purpose:** produce the next 128-bit AES-128 round key.

Inputs:

```text
key_in[127:0]
round[3:0]
```

Output:

```text
key_out[127:0]
```

Contains:

- word split
- S-box transformation
- Rcon
- XOR chain

AES-128 requires round keys for the initial key plus 10 rounds.

---

# 6. Encryption datapath

The encryption controller must implement:

```text
START
  |
  v
Plaintext XOR Key
  |
  v
Round 1
  |
  +--> SubBytes
  +--> ShiftRows
  +--> MixColumns
  +--> AddRoundKey
  |
  v
Rounds 2...9
  |
  v
Round 10
  |
  +--> SubBytes
  +--> ShiftRows
  +--> AddRoundKey
  |
  v
Ciphertext
```

The final AES round must not perform MixColumns.

The supplied baseline implements the round operation using registered state and round-key registers.

---

# 7. Decryption datapath

The supplied design:

1. Accepts ciphertext and key.
2. Generates/stores the 11 round keys.
3. Starts from ciphertext XOR round key 10.
4. Applies inverse transformations.
5. Produces the original plaintext.

Conceptually:

```text
Ciphertext
   |
XOR Round Key 10
   |
InvShiftRows
   |
InvSubBytes
   |
InvMixColumns
   |
... rounds ...
   |
InvShiftRows
   |
InvSubBytes
   |
XOR Round Key 0
   |
Plaintext
```

---

# 8. Top-level specification

`aes128_top.v`

```text
                   +-------------------+
 data_in --------->|                   |
 key -------------->|   AES128 TOP     |----> data_out
 start ------------>|                   |
 mode -------------->|                   |----> done
 clk -------------->|                   |
 rst -------------->|                   |
                   +---------+---------+
                             |
                   +---------+---------+
                   |                   |
              mode=0              mode=1
                   |                   |
                   v                   v
              ENCRYPT              DECRYPT
```

The baseline top-level implementation instantiates both datapaths and selects the output using `mode`.

---

# 9. Verification specification

## Required encryption vector

```text
Plaintext:
00112233445566778899aabbccddeeff

Key:
000102030405060708090a0b0c0d0e0f

Expected ciphertext:
69c4e0d86a7b0430d8cdb78070b4c55a
```

## Required decryption vector

```text
Ciphertext:
69c4e0d86a7b0430d8cdb78070b4c55a

Key:
000102030405060708090a0b0c0d0e0f

Expected plaintext:
00112233445566778899aabbccddeeff
```

The supplied testbench already checks these values.

## Verification sequence

```text
Reset
  ↓
Load plaintext + key
  ↓
mode = encrypt
  ↓
start pulse
  ↓
wait(done)
  ↓
compare ciphertext
  ↓
Load ciphertext + key
  ↓
mode = decrypt
  ↓
start pulse
  ↓
wait(done)
  ↓
compare plaintext
```

---

# 10. Simulation deliverables

Capture:

1. RTL elaboration/hierarchy
2. Encryption waveform
3. Decryption waveform
4. Console PASS result
5. Input plaintext
6. Key
7. Ciphertext
8. Recovered plaintext
9. `start`
10. `done`
11. Clock
12. Reset

---

# 11. Synthesis process

## Stage A — RTL compile

Check:

- Syntax
- Width mismatches
- Multiple drivers
- Undriven signals
- Latches
- Unsupported constructs
- Hierarchy

## Stage B — RTL synthesis

Set:

```text
Top module = aes128_top
```

Do not use `aes128_tb` as synthesis top.

## Stage C — Constraints

At minimum define:

- clock period
- input/output timing assumptions if required by tool

Do not invent final timing values; choose the target clock based on the selected FPGA/ASIC technology and document it.

## Stage D — Reports

Collect:

### Performance
- Worst negative slack
- Worst setup path
- Maximum achievable frequency if available

### Area / utilization
For FPGA:
- LUT
- FF
- BRAM
- DSP
- I/O

For ASIC:
- cell area
- gate count
- sequential/combinational area

### Power
Where supported:
- dynamic power
- static/leakage power
- total estimated power

---

# 12. VLSI optimization phase

Do NOT optimize before obtaining a working baseline.

Use this loop:

```text
Baseline RTL
     ↓
Functional verification
     ↓
Synthesis
     ↓
PPA measurement
     ↓
Identify bottleneck
     ↓
One architectural change
     ↓
Re-simulate
     ↓
Re-synthesize
     ↓
Compare PPA
```

Possible optimization directions:

### A. S-box optimization
Compare lookup-table implementation against another hardware realization if the target flow supports it.

### B. Resource sharing
Reduce duplicated hardware at the expense of latency.

### C. Pipelining
Improve clock frequency by dividing long combinational paths into stages.

### D. Clock/control optimization
Reduce unnecessary switching where appropriate.

### E. Round architecture
Compare iterative versus more parallel round implementations.

---

# 13. Recommended project phases

## Phase 1 — Understand
Study every module and draw the datapath.

## Phase 2 — Build
Create the project directory and add the RTL files.

## Phase 3 — Simulate
Get encryption PASS.

## Phase 4 — Simulate
Get decryption PASS.

## Phase 5 — Synthesize
Generate hardware reports.

## Phase 6 — Analyze
Identify the dominant area/timing/power block.

## Phase 7 — Optimize
Make one controlled architectural improvement.

## Phase 8 — Verify again
Run the same AES vectors.

## Phase 9 — Compare
Create a before/after table.

## Phase 10 — Document
Prepare report, PPT, GitHub README and interview explanation.

---

# 14. Final project results table

Fill this only with actual tool-generated values:

| Metric | Baseline | Optimized |
|---|---:|---:|
| LUT / cell area | TBD | TBD |
| Flip-flops | TBD | TBD |
| Maximum frequency | TBD | TBD |
| Critical path | TBD | TBD |
| Dynamic power | TBD | TBD |
| Static power | TBD | TBD |
| Latency | TBD | TBD |
| Throughput | TBD | TBD |

Never invent these numbers.

---

# 15. Final architecture to present

```text
                         AES-128 HARDWARE ENGINE
                                  |
              +-------------------+-------------------+
              |                                       |
        ENCRYPTION                              DECRYPTION
              |                                       |
        +-----v-----+                            +----v-----+
        | SubBytes  |                            | InvShift |
        +-----+-----+                            +----+-----+
              |                                       |
        +-----v-----+                            +----v-----+
        | ShiftRows |                            | InvSub  |
        +-----+-----+                            +----+-----+
              |                                       |
        +-----v-----+                            +----v-----+
        |MixColumns |                            |InvMixCol|
        +-----+-----+                            +----+-----+
              |                                       |
              +----------------+----------------------+
                               |
                         +-----v------+
                         | Key Expand |
                         +-----+------+
                               |
                         Round Keys
                               |
                         +-----v------+
                         | AES TOP    |
                         +-----+------+
                               |
                           data_out
```

---

# 16. Definition of done

The project is complete when all of these are true:

- [ ] All RTL modules compile
- [ ] Encryption test passes
- [ ] Decryption test passes
- [ ] Waveforms captured
- [ ] RTL hierarchy captured
- [ ] Synthesis completed
- [ ] Timing report collected
- [ ] Area/utilization report collected
- [ ] Power estimate collected if supported
- [ ] Critical path identified
- [ ] At least one optimization investigated
- [ ] Optimized design re-verified
- [ ] Before/after results documented
- [ ] Final architecture diagram prepared
- [ ] Final report prepared
- [ ] GitHub repository organized

---

# 17. Important scope statement

This project is an **RTL/digital VLSI hardware design project**. The supplied source alone does not prove physical semiconductor fabrication, silicon tape-out, physical layout, or measured silicon power.

Those claims should only be made after the corresponding implementation and measurement steps are actually completed.

---

# 18. Final project statement

**AES-128 Hardware Cryptographic Engine using Verilog HDL**

A modular RTL implementation of AES-128 supporting hardware encryption and decryption, followed by functional verification and VLSI-oriented synthesis analysis. The project is intended to demonstrate digital hardware design, hardware security, verification, timing analysis, area/utilization analysis and power-aware optimization.
