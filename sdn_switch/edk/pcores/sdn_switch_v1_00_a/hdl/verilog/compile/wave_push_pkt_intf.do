onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -height 15 /user_logic/clk
add wave -noupdate -format Logic -height 15 /user_logic/reset
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/test_cpu_dp_data_in
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/test_cpu_dp_ctrl_in
add wave -noupdate -format Logic -height 15 /user_logic/test_cpu_dp_in_wr_en
add wave -noupdate -format Logic -height 15 /user_logic/dp_in_rd_en
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/dp_data_in
add wave -noupdate -format Logic -height 15 /user_logic/dp_in_full
add wave -noupdate -format Logic -height 15 /user_logic/dp_in_empty
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/in_data
add wave -noupdate -format Literal -height 15 -expand /user_logic/in_wr
add wave -noupdate -format Logic -height 15 /user_logic/push_to_switch
add wave -noupdate -format Literal -height 15 /user_logic/input_queue_sel
add wave -noupdate -format Literal -height 15 /user_logic/in_rdy
add wave -noupdate -format Literal -height 15 -radix hexadecimal /user_logic/in_ctrl
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7389753 ps} 0}
configure wave -namecolwidth 299
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
WaveRestoreZoom {7306897 ps} {7472609 ps}
