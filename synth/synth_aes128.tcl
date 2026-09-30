# Vivado Synthesis and Implementation Script for AES-128
# Run in Vivado Tcl Console: source synth_aes128.tcl

# Create project
create_project aes128_project ./vivado_project -part xc7a100tcsg324-1

# Add RTL sources
add_files {
    ../../rtl/aes_sbox.v
    ../../rtl/aes_inv_sbox.v
    ../../rtl/sub_bytes.v
    ../../rtl/inv_sub_bytes.v
    ../../rtl/shift_rows.v
    ../../rtl/inv_shift_rows.v
    ../../rtl/mix_columns.v
    ../../rtl/inv_mix_columns.v
    ../../rtl/key_expand.v
    ../../rtl/aes128_encrypt.v
    ../../rtl/aes128_decrypt.v
    ../../rtl/aes128_top.v
}

# Set top module
set_property top aes128_top [current_fileset]

# Add constraints
add_files -fileset constrs_1 ../../synth/constraints/aes128_top.xdc

# Run synthesis
launch_runs synth_1 -jobs 4
wait_on_run synth_1

# Open synthesized design
open_run synth_1 -name netlist

# Generate synthesis reports
report_utilization -file ../../results/area/utilization_baseline.rpt
report_timing_summary -file ../../results/timing/timing_baseline.rpt
report_power -file ../../results/power/power_baseline.rpt

# Get critical path
report_timing -max_paths 10 -file ../../results/timing/critical_path_baseline.rpt

# Implementation
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

# Open implemented design
open_run impl_1

# Generate post-implementation reports
report_utilization -file ../../results/area/utilization_impl.rpt
report_timing_summary -file ../../results/timing/timing_impl.rpt
report_power -file ../../results/power/power_impl.rpt

# Export results
write_checkpoint -force ../../results/aes128_impl.dcp
write_verilog -force ../../results/aes128_netlist.v

puts "Synthesis and implementation completed!"
puts "Reports available in ../../results/"