# ModelSim/QuestaSim Simulation Script for AES-128
# Run in ModelSim: do simulate.do

# Create work library
vlib work

# Compile RTL files
vlog -work work \
    ../../rtl/aes_sbox.v \
    ../../rtl/aes_inv_sbox.v \
    ../../rtl/sub_bytes.v \
    ../../rtl/inv_sub_bytes.v \
    ../../rtl/shift_rows.v \
    ../../rtl/inv_shift_rows.v \
    ../../rtl/mix_columns.v \
    ../../rtl/inv_mix_columns.v \
    ../../rtl/key_expand.v \
    ../../rtl/aes128_encrypt.v \
    ../../rtl/aes128_decrypt.v \
    ../../rtl/aes128_top.v

# Compile testbench
vlog -work work ../../tb/aes128_tb.v

# Run simulation
vsim -voptargs="+acc" work.aes128_tb

# Add waves
add wave -position insertpoint sim:/aes128_tb/clk
add wave -position insertpoint sim:/aes128_tb/rst
add wave -position insertpoint sim:/aes128_tb/start
add wave -position insertpoint sim:/aes128_tb/mode
add wave -position insertpoint sim:/aes128_tb/data_in
add wave -position insertpoint sim:/aes128_tb/key
add wave -position insertpoint sim:/aes128_tb/data_out
add wave -position insertpoint sim:/aes128_tb/done

# Run simulation
run -all

# Save waveform
write wave ../../sim/waveforms/aes128_tb.wlf

quit -f