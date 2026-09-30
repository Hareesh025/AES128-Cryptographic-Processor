# Quartus Prime Synthesis Script for AES-128
# Run in Quartus Prime Tcl Console: source quartus_synth.tcl

# Project settings
set project_name "aes128_project"
set top_module "aes128_top"
set device "5CSEMA5F31C6"  # Cyclone V example

# Create project
project_new -overwrite $project_name

# Set device
set_global_assignment -name DEVICE $device
set_global_assignment -name TOP_LEVEL_ENTITY $top_module

# Add RTL files
set_global_assignment -name VERILOG_FILE ../../rtl/aes_sbox.v
set_global_assignment -name VERILOG_FILE ../../rtl/aes_inv_sbox.v
set_global_assignment -name VERILOG_FILE ../../rtl/sub_bytes.v
set_global_assignment -name VERILOG_FILE ../../rtl/inv_sub_bytes.v
set_global_assignment -name VERILOG_FILE ../../rtl/shift_rows.v
set_global_assignment -name VERILOG_FILE ../../rtl/inv_shift_rows.v
set_global_assignment -name VERILOG_FILE ../../rtl/mix_columns.v
set_global_assignment -name VERILOG_FILE ../../rtl/inv_mix_columns.v
set_global_assignment -name VERILOG_FILE ../../rtl/key_expand.v
set_global_assignment -name VERILOG_FILE ../../rtl/aes128_encrypt.v
set_global_assignment -name VERILOG_FILE ../../rtl/aes128_decrypt.v
set_global_assignment -name VERILOG_FILE ../../rtl/aes128_top.v

# Add SDC constraints
set_global_assignment -name SDC_FILE ../../synth/constraints/aes128_top.sdc

# Clock constraint (100 MHz)
create_clock -name clk -period 10.000 [get_ports clk]

# Input/output delays
set_input_delay -clock clk -max 2.0 [get_ports data_in\[*\]] 
set_input_delay -clock clk -max 2.0 [get_ports key\[*\]] 
set_input_delay -clock clk -max 1.0 [get_ports start] 
set_input_delay -clock clk -max 1.0 [get_ports mode] 
set_input_delay -clock clk -max 1.0 [get_ports rst] 

set_output_delay -clock clk -max 3.0 [get_ports data_out\[*\]] 
set_output_delay -clock clk -max 2.0 [get_ports done] 

# Synthesis settings
set_global_assignment -name OPTIMIZATION_MODE "BALANCED"
set_global_assignment -name SYNTHESIS_EFFORT "FAST"
set_global_assignment -name ADV_NETLIST_OPT_ALLOWED "ALWAYS"
set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC "ON"
set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION "ON"
set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING "ON"

# Run synthesis
execute_flow -compile

# Generate reports
set report_dir "../../results/"

# Area report
execute_module -tool map -command "report_utilization -panel_name \"Flow Summary\" -file $report_dir/area/quartus_utilization.rpt"

# Timing report
execute_module -tool sta -command "report_timing -npaths 10 -file $report_dir/timing/quartus_timing.rpt"
execute_module -tool sta -command "report_timing -npaths 1 -detail path -file $report_dir/timing/quartus_critical_path.rpt"

# Power report (if PowerPlay available)
execute_module -tool asm -command "report_power -file $report_dir/power/quartus_power.rpt"

# Export netlist
execute_module -tool asm -command "write_verilog $report_dir/aes128_quartus_netlist.v"

puts "Quartus synthesis completed!"
puts "Reports in $report_dir"

project_close