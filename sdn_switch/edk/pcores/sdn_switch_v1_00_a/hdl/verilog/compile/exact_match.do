onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/clk
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/reset
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/flow_entry
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/flow_entry_vld
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/pkt_size
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_match_rdy
add wave -noupdate -divider {Match Arbiter Intf}
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_hit
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_miss
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_data
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_data_vld
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_wins
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_loses
add wave -noupdate -divider SRAM
add wave -noupdate -format Literal -height 15 -radix decimal /user_logic/user_data_path/output_port_lookup/exact_match/wr_0_addr
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/wr_0_req
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/wr_0_ack
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/output_port_lookup/exact_match/wr_0_data
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/rd_0_ack
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/output_port_lookup/exact_match/rd_0_data
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/rd_0_vld
add wave -noupdate -format Literal -height 15 -radix decimal /user_logic/user_data_path/output_port_lookup/exact_match/rd_0_addr
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/rd_0_req
add wave -noupdate -divider {Header Hash}
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/output_port_lookup/exact_match/dout_flow_entry
add wave -noupdate -format Literal -height 15 -radix decimal /user_logic/user_data_path/output_port_lookup/exact_match/flow_index_0
add wave -noupdate -format Literal -height 15 -radix decimal /user_logic/user_data_path/output_port_lookup/exact_match/flow_index_1
add wave -noupdate -format Literal -height 15 -radix decimal /user_logic/user_data_path/output_port_lookup/exact_match/cycle_num
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/flow_0_index_0_match
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/flow_0_index_1_match
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/flow_1_index_0_match
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/flow_1_index_1_match
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/flow_0_hdr
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/flow_1_hdr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 589
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
WaveRestoreZoom {0 ps} {589 ps}
