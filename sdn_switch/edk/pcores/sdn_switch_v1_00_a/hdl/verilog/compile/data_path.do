onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -height 15 /user_logic/clk
add wave -noupdate -format Logic -height 15 /user_logic/reset
add wave -noupdate -divider {Packet-IN FIFO}
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/test_cpu_dp_data_in
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/test_cpu_dp_ctrl_in
add wave -noupdate -format Literal -height 15 /user_logic/dp_ctrl_in
add wave -noupdate -format Literal -height 15 /user_logic/input_queue_sel
add wave -noupdate -format Logic -height 15 /user_logic/push_to_switch
add wave -noupdate -format Logic -height 15 /user_logic/dp_in_empty
add wave -noupdate -format Logic -height 15 /user_logic/dp_in_full
add wave -noupdate -format Literal -height 15 /user_logic/dp_data_in
add wave -noupdate -format Literal -height 15 /user_logic/dp_ctrl_in
add wave -noupdate -format Logic -height 15 /user_logic/dp_in_rd_en
add wave -noupdate -divider {Openflow Ingress}
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/in_data_0
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/in_ctrl_0
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/in_wr_0
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/in_rdy_0
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/in_wr_1
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/in_wr_2
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/in_wr_3
add wave -noupdate -divider {Input Arb Output}
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/vlan_rm_in_ctrl
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/vlan_rm_in_data
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/vlan_rm_in_wr
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/vlan_rm_in_rdy
add wave -noupdate -divider {VLAN_RM Output}
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/op_lut_in_ctrl
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/op_lut_in_data
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/op_lut_in_wr
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/op_lut_in_rdy
add wave -noupdate -divider {LUT Output}
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/vlan_add_in_ctrl
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/vlan_add_in_data
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/vlan_add_in_wr
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/vlan_add_in_rdy
add wave -noupdate -divider {Out Data}
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/out_data_0
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/out_ctrl_0
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/out_wr_0
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/out_rdy_0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 443
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {10605 ns}
