onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/clk
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/reset
add wave -noupdate -divider {Input Output Signals}
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/output_port_lookup/in_data
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/output_port_lookup/in_ctrl
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/in_wr
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/in_rdy
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/output_port_lookup/out_data
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/output_port_lookup/out_ctrl
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/out_wr
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/out_rdy
add wave -noupdate -divider {Input FIFO}
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/output_port_lookup/input_fifo/din
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/input_fifo/wr_en
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/input_fifo/rd_en
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/output_port_lookup/input_fifo/dout
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/input_fifo/full
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/input_fifo/empty
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/input_fifo/fifo_rd_en
add wave -noupdate -divider OPL_PROCESSOR
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/output_port_lookup/opl_processor/in_fifo_ctrl
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/output_port_lookup/opl_processor/in_fifo_data
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/opl_processor/in_fifo_rd_en
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/opl_processor/in_fifo_empty
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/output_port_lookup/opl_processor/out_data
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/output_port_lookup/opl_processor/out_ctrl
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/opl_processor/out_wr
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/opl_processor/out_rdy
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/output_port_lookup/opl_processor/result_fifo_dout
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/opl_processor/result_fifo_rd_en
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/opl_processor/result_fifo_empty
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/output_port_lookup/opl_processor/pkts_dropped
add wave -noupdate -divider {Exact Match}
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/flow_entry
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/flow_entry_vld
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_match_rdy
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_hit
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_miss
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/user_data_path/output_port_lookup/exact_match/exact_data
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_data_vld
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_wins
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/output_port_lookup/exact_match/exact_loses
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/sram_arbiter/do_reset
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/sram_arbiter/sram_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1668202 ps} 0}
configure wave -namecolwidth 539
configure wave -valuecolwidth 146
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
WaveRestoreZoom {1336795 ps} {1999609 ps}
