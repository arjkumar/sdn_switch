onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/clk}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/reset}
add wave -noupdate -format Literal -height 15 -radix unsigned {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/depth}
add wave -noupdate -format Literal -height 15 -radix unsigned {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/wr_ptr}
add wave -noupdate -format Literal -height 15 -radix unsigned {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/rd_ptr}
add wave -noupdate -format Literal -height 15 -radix hexadecimal {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/queue}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/empty}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/prog_full}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/nearly_full}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/full}
add wave -noupdate -format Literal -height 15 -radix hexadecimal {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/dout}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/rd_en}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/wr_en}
add wave -noupdate -format Literal -height 15 -radix hexadecimal {/user_logic/user_data_path/input_arbiter/in_arb_queues[0]/in_arb_fifo/din}
add wave -noupdate -divider {Add Header}
add wave -noupdate -format Literal -height 15 -radix hexadecimal {/user_logic/user_data_path/input_arbiter/port_number_insertion[0]/add_header/in_data}
add wave -noupdate -format Literal -height 15 -radix hexadecimal {/user_logic/user_data_path/input_arbiter/port_number_insertion[0]/add_header/in_ctrl}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/port_number_insertion[0]/add_header/in_wr}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/port_number_insertion[0]/add_header/in_rdy}
add wave -noupdate -format Literal -height 15 -radix hexadecimal {/user_logic/user_data_path/input_arbiter/port_number_insertion[0]/add_header/out_data}
add wave -noupdate -format Literal -height 15 -radix hexadecimal {/user_logic/user_data_path/input_arbiter/port_number_insertion[0]/add_header/out_ctrl}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/port_number_insertion[0]/add_header/out_wr}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/port_number_insertion[0]/add_header/out_rdy}
add wave -noupdate -format Literal -height 15 -radix hexadecimal {/user_logic/user_data_path/input_arbiter/in_data[0]}
add wave -noupdate -format Literal -height 15 -radix hexadecimal {/user_logic/user_data_path/input_arbiter/in_ctrl[0]}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/in_wr[0]}
add wave -noupdate -format Logic -height 15 {/user_logic/user_data_path/input_arbiter/rd_en[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7390681 ps} 0}
configure wave -namecolwidth 580
configure wave -valuecolwidth 135
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
WaveRestoreZoom {6064350 ps} {8715614 ps}
