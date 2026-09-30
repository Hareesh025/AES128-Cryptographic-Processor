# AES-128 Cryptographic Processor

## RTL Design and VLSI Analysis of an AES-128 Hardware Cryptographic Engine

This project presents a hardware implementation of the **Advanced Encryption Standard (AES-128)** using Verilog RTL. The design supports both **128-bit encryption and decryption** and was developed and analyzed using **AMD/Xilinx Vivado**.

The project covers RTL design, functional verification, FPGA synthesis, implementation, static timing analysis, resource utilization, and power estimation.

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

## Architecture

The top-level FPGA wrapper is:

```text
aes128_fpga_top.v
