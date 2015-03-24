onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -height 15 /user_logic/reset
add wave -noupdate -format Logic -height 15 /user_logic/clk
add wave -noupdate -format Logic -height 15 /user_logic/test_cpu_reg_rd_wr_L
add wave -noupdate -format Literal -height 15 /user_logic/test_cpu_reg_addr
add wave -noupdate -format Literal -height 15 /user_logic/test_cpu_reg_wr_data
add wave -noupdate -format Logic -height 15 /user_logic/test_cpu_reg_fifo_wr_en
add wave -noupdate -format Logic -height 15 /user_logic/reg_fifo_empty
add wave -noupdate -format Logic -height 15 /user_logic/reg_fifo_rd_en
add wave -noupdate -format Logic -height 15 /user_logic/reg_rd_wr_L
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/reg_addr
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/reg_rd_data
add wave -noupdate -format Logic -height 15 /user_logic/reg_rd_vld
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/reg_wr_data
add wave -noupdate -divider IN_ARB_REGS
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_req_in
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_ack_in
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_rd_wr_L_in
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_addr_in
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_data_in
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_src_in
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_req_out
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_ack_out
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_rd_wr_L_out
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_addr_out
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_data_out
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_src_out
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/eop
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/clk
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reset
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/addr
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/reg_addr
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/tag_addr
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/addr_good
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/tag_hit
add wave -noupdate -format Logic -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/in_pkt
add wave -noupdate -format Literal -height 15 /user_logic/user_data_path/input_arbiter/in_arb_regs/eop_cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16470000 ps} 0}
configure wave -namecolwidth 564
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
WaveRestoreZoom {16162097 ps} {18107945 ps}
