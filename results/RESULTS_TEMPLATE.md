# AES-128 VLSI Project - Results Documentation

## Baseline Synthesis Results

### Tool Information
- **Synthesis Tool**: [Vivado 2023.2 / Quartus Prime 22.1 / Yosys 0.18]
- **Target Device**: [Xilinx Artix-7 xc7a100tcsg324-1 / Intel Cyclone V / ASIC 28nm]
- **Date**: [YYYY-MM-DD]
- **Clock Constraint**: 10.000 ns (100 MHz)

### Timing Analysis

| Metric | Value |
|--------|-------|
| Worst Negative Slack (WNS) | [___] ns |
| Total Negative Slack (TNS) | [___] ns |
| Number of Failing Paths | [___] |
| Maximum Frequency (Fmax) | [___] MHz |
| Critical Path | [Module/Instance names] |

**Critical Path Details:**
```
[Copy from timing report]
```

### Area / Utilization Analysis

#### FPGA (Xilinx 7-series example)
| Resource | Used | Available | Utilization |
|----------|------|-----------|-------------|
| LUTs | [___] | [___] | [___]% |
| LUTRAM | [___] | [___] | [___]% |
| FFs | [___] | [___] | [___]% |
| BRAMs | [___] | [___] | [___]% |
| DSPs | [___] | [___] | [___]% |
| IO | [___] | [___] | [___]% |
| BUFG | [___] | [___] | [___]% |

#### ASIC (Example)
| Metric | Value |
|--------|-------|
| Total Cell Area | [___] μm² |
| Combinational Area | [___] μm² |
| Sequential Area | [___] μm² |
| Gate Count (NAND2 equiv) | [___] |
| Standard Cell Count | [___] |

### Power Estimation

| Component | Dynamic (mW) | Static (mW) | Total (mW) |
|-----------|--------------|-------------|------------|
| Clocks | [___] | [___] | [___] |
| Logic | [___] | [___] | [___] |
| Memory | [___] | [___] | [___] |
| I/O | [___] | [___] | [___] |
| **Total** | [___] | [___] | [___] |

**Conditions**: Vcc = [___]V, Temp = [___]°C, Activity = [___]%

### Latency and Throughput

| Operation | Cycles | Latency @ 100MHz | Throughput |
|-----------|--------|------------------|------------|
| Encryption | [___] | [___] ns | [___] Mbps |
| Decryption | [___] | [___] ns | [___] Mbps |

---

## Optimized Synthesis Results (After Optimization)

### Optimization Applied
**Description**: [e.g., "S-box composite field implementation", "Pipelined MixColumns", "Shared SubBytes/InvSubBytes"]

### Timing Analysis (Optimized)

| Metric | Baseline | Optimized | Change |
|--------|----------|-----------|--------|
| WNS | [___] | [___] | [___] |
| Fmax | [___] | [___] | [___] |

### Area (Optimized)

| Resource | Baseline | Optimized | Change |
|----------|----------|-----------|--------|
| LUTs | [___] | [___] | [___]% |
| FFs | [___] | [___] | [___]% |
| BRAMs | [___] | [___] | [___]% |
| DSPs | [___] | [___] | [___]% |

### Power (Optimized)

| Component | Baseline | Optimized | Change |
|-----------|----------|-----------|--------|
| Dynamic | [___] | [___] | [___]% |
| Static | [___] | [___] | [___]% |
| Total | [___] | [___] | [___]% |

---

## Summary Table (Final Report)

| Metric | Baseline | Optimized | Unit |
|--------|----------|-----------|------|
| LUT / Cell Area | TBD | TBD | - |
| Flip-flops | TBD | TBD | - |
| Maximum Frequency | TBD | TBD | MHz |
| Critical Path | TBD | TBD | - |
| Dynamic Power | TBD | TBD | mW |
| Static Power | TBD | TBD | mW |
| Latency (encrypt) | TBD | TBD | cycles |
| Latency (decrypt) | TBD | TBD | cycles |
| Throughput | TBD | TBD | Mbps |

---

## Verification Results

- [ ] Encryption test passes (NIST vector)
- [ ] Decryption test passes (NIST vector)
- [ ] Waveforms captured
- [ ] RTL hierarchy verified
- [ ] No latches inferred
- [ ] No timing violations at target frequency
- [ ] Reset behavior verified
- [ ] Mode switching verified

---

## Screenshots Checklist

- [ ] RTL Schematic (elaborated)
- [ ] Synthesized Schematic
- [ ] Encryption Waveform (full operation)
- [ ] Decryption Waveform (full operation)
- [ ] Critical Path Schematic
- [ ] Floorplan / Placement View
- [ ] Timing Summary Report
- [ ] Utilization Report
- [ ] Power Report

---

## Notes

[Add any observations, issues encountered, or lessons learned]