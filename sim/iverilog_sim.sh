#!/bin/bash
# Icarus Verilog compilation and simulation script
# Run: chmod +x iverilog_sim.sh && ./iverilog_sim.sh

iverilog -o aes128_tb.vvp \
    ../rtl/aes_sbox.v \
    ../rtl/aes_inv_sbox.v \
    ../rtl/sub_bytes.v \
    ../rtl/inv_sub_bytes.v \
    ../rtl/shift_rows.v \
    ../rtl/inv_shift_rows.v \
    ../rtl/mix_columns.v \
    ../rtl/inv_mix_columns.v \
    ../rtl/key_expand.v \
    ../rtl/aes128_encrypt.v \
    ../rtl/aes128_decrypt.v \
    ../rtl/aes128_top.v \
    ../tb/aes128_tb.v

if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    vvp aes128_tb.vvp
else
    echo "Compilation failed!"
    exit 1
fi