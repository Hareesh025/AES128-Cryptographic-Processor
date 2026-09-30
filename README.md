# AES-128 Cryptographic Processor

## RTL Design and VLSI Analysis of an AES-128 Hardware Cryptographic Engine

This project presents a hardware implementation of the **Advanced Encryption Standard (AES-128)** using Verilog RTL. The design supports both **128-bit encryption and decryption** and was developed and analyzed using **AMD/Xilinx Vivado**.

The project focuses on RTL design, functional verification, FPGA synthesis, timing analysis, resource utilization, and power estimation.

---

## Project Overview

AES-128 is a symmetric-key cryptographic algorithm that operates on:

- 128-bit plaintext/ciphertext
- 128-bit encryption key
- 10 AES transformation rounds

The processor implements the major AES transformations required for encryption and decryption.

### Main AES Operations

**Encryption:**
- AddRoundKey
- SubBytes
- ShiftRows
- MixColumns
- AddRoundKey

**Decryption:**
- AddRoundKey
- InvShiftRows
- InvSubBytes
- InvMixColumns
- AddRoundKey

---

## Architecture

The top-level FPGA wrapper is:

`aes128_fpga_top.v`

The main AES processing core is:

`aes128_top.v`

The design contains dedicated RTL modules for:

- AES encryption
- AES decryption
- S-Box
- Inverse S-Box
- SubBytes
- ShiftRows
- MixColumns
- Key Expansion
- Inverse transformations

---

## Project Architecture

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
                 +----------+----------+
                 |                     |
                 v                     v
        +----------------+    +----------------+
        | AES Encryption |    | AES Decryption |
        +----------------+    +----------------+
                 |                     |
                 +----------+----------+
                            |
                            v
                     128-bit Data Out
