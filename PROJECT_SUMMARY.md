# AES-128 VLSI Project - Final Summary

## Project Completion Checklist

### ✅ Phase 1: Understand
- [x] Studied all modules and drew datapath
- [x] Understood AES-128 algorithm (FIPS-197)

### ✅ Phase 2: Build
- [x] Created project directory structure
- [x] Added all RTL files (11 modules)
- [x] Created testbench with NIST vectors
- [x] Added simulation scripts (ModelSim, Icarus)
- [x] Added synthesis scripts (Vivado, Quartus, Yosys)
- [x] Added constraint files (XDC, SDC)

### ✅ Phase 3: Simulate - Encryption
- [x] Encryption test passes with NIST vector
- [x] Plaintext: 00112233445566778899aabbccddeeff
- [x] Key: 000102030405060708090a0b0c0d0e0f
- [x] Ciphertext: 69c4e0d86a7b0430d8cdb78070b4c55a

### ✅ Phase 4: Simulate - Decryption
- [x] Decryption test passes with NIST vector
- [x] Ciphertext: 69c4e0d86a7b0430d8cdb78070b4c55a
- [x] Key: 000102030405060708090a0b0c0d0e0f
- [x] Plaintext: 00112233445566778899aabbccddeeff

### ✅ Phase 5: Synthesize
- [x] RTL compiles without errors
- [x] Synthesis scripts ready for Vivado/Quartus/Yosys
- [x] Constraints defined for 100 MHz target

### 🔄 Phase 6: Analyze (Run after synthesis)
- [ ] Timing report collected
- [ ] Area/utilization report collected
- [ ] Power estimate collected
- [ ] Critical path identified

### 🔄 Phase 7: Optimize (After baseline analysis)
- [ ] S-box optimization (composite field) - `aes_sbox_opt.v` created
- [ ] Resource sharing (key expansion) - `key_expand_shared.v` created
- [ ] Pipelining (MixColumns) - `mix_columns_pipelined.v` created
- [ ] Comparison framework - `aes128_top_optimized.v` created

### 🔄 Phase 8: Verify Again
- [ ] Comparison testbench created
- [ ] Re-run NIST vectors on optimized design

### 🔄 Phase 9: Compare
- [ ] Results template created (`RESULTS_TEMPLATE.md`)

### 🔄 Phase 10: Document
- [x] README.md with full documentation
- [x] Project specification in docs/
- [ ] Final report with actual numbers
- [ ] GitHub repository organized

## File Inventory

### RTL Modules (11 core + 5 optimization)
```
rtl/
├── aes_sbox.v                 # Forward S-box (LUT)
├── aes_inv_sbox.v             # Inverse S-box (LUT)
├── sub_bytes.v                # 16x S-box parallel
├── inv_sub_bytes.v            # 16x Inv S-box parallel
├── shift_rows.v               # Row permutation
├── inv_shift_rows.v           # Inverse row permutation
├── mix_columns.v              # Forward MixColumns
├── inv_mix_columns.v          # Inverse MixColumns (GF mul)
├── key_expand.v               # Key schedule (11 round keys)
├── aes128_encrypt.v           # Encryption FSM (12 cycles)
├── aes128_decrypt.v           # Decryption FSM (22 cycles)
├── aes128_top.v               # Top-level mode mux
├── aes_sbox_opt.v             # Composite field S-box
├── key_expand_shared.v        # Shared S-box key expand
├── mix_columns_pipelined.v    # 2-stage pipelined MixColumns
└── aes128_top_optimized.v     # Optimized top with mux
```

### Testbench
```
tb/
├── aes128_tb.v                # Basic testbench
└── aes128_comparison_tb.v     # Baseline vs optimized
```

### Simulation
```
sim/
├── simulate.do                # ModelSim script
├── iverilog_sim.sh            # Icarus Verilog script
├── verify_vectors.py          # Python reference verification
├── waveforms/                 # VCD/WLF output
└── logs/                      # Simulation logs
```

### Synthesis
```
synth/
├── constraints/
│   ├── aes128_top.xdc         # Vivado constraints
│   └── aes128_top.sdc         # Quartus constraints
├── reports/                   # Synthesis reports
├── synth_aes128.tcl           # Vivado Tcl script
├── quartus_synth.tcl          # Quartus Tcl script
└── yosys_synth.ys             # Yosys script
```

### Results
```
results/
├── timing/                    # Timing reports
├── area/                      # Utilization reports
├── power/                     # Power reports
├── screenshots/               # Schematic/floorplan images
├── RESOURCES_TEMPLATE.md      # Results documentation template
└── (generated netlists)
```

### Documentation
```
docs/
├── AES128_PROJECT_SPEC.md     # Complete specification
└── AES128_VLSI_PROJECT_BRAIN.pdf  # Reference document
```

## Quick Commands

### ModelSim Simulation
```bash
cd sim
vsim -do simulate.do
```

### Icarus Verilog Simulation
```bash
cd sim
chmod +x iverilog_sim.sh
./iverilog_sim.sh
```

### Vivado Synthesis
```bash
cd synth
vivado -mode batch -source synth_aes128.tcl
```

### Quartus Synthesis
```bash
cd synth
quartus_sh -t quartus_synth.tcl
```

### Yosys Synthesis
```bash
cd synth
yosys -s yosys_synth.ys
```

## Key Design Decisions

1. **Synchronous Reset**: All state machines use synchronous reset
2. **Single Clock Domain**: 100 MHz target (10ns period)
3. **Mode Selection**: Runtime select via `mode` signal
4. **Key Expansion**: Pre-computes all 11 round keys for decryption
5. **Modular Design**: Each transformation in separate module

## Optimization Opportunities (Implemented as Examples)

| Optimization | File | Description |
|--------------|------|-------------|
| Composite Field S-box | `aes_sbox_opt.v` | Replaces 256-entry LUT with GF arithmetic |
| Shared Key Expand | `key_expand_shared.v` | Reuses single S-box across rounds |
| Pipelined MixColumns | `mix_columns_pipelined.v` | 2-stage pipeline for higher Fmax |

## Expected Baseline Results (Typical for Artix-7)

| Metric | Estimate |
|--------|----------|
| LUTs | ~2,500 - 3,500 |
| FFs | ~1,500 - 2,000 |
| Fmax | ~150 - 250 MHz |
| Latency (enc) | 12 cycles |
| Latency (dec) | 22 cycles |

## Next Steps for Complete VLSI Flow

1. **Run synthesis** on target FPGA/ASIC
2. **Collect actual reports** and fill `RESULTS_TEMPLATE.md`
3. **Implement one optimization** and re-synthesize
4. **Compare PPA** (Power, Performance, Area)
5. **Document findings** in final report
6. **Prepare presentation** with architecture diagrams

## Academic/Interview Talking Points

- Modular RTL design with clean interfaces
- FSM-based control for encryption/decryption
- Key expansion with Rcon and S-box
- Composite field arithmetic for S-box optimization
- Pipeline insertion for timing closure
- Resource sharing vs. parallelism tradeoffs
- Verification methodology with NIST vectors
- Synthesis flow across multiple tools (Vivado/Quartus/Yosys)
- Constraint writing for timing-driven synthesis

## License & References

- AES Algorithm: FIPS-197 (Public Domain)
- Implementation: Original RTL for educational use
- References: Daemen & Rijmen "The Design of Rijndael"