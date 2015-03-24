onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -height 15 /top/clk
add wave -noupdate -format Logic -height 15 /top/reset
add wave -noupdate -format Logic -height 15 /top/FSL_S_Exists
add wave -noupdate -format Logic -height 15 /top/FSL_S_Control
add wave -noupdate -format Literal -height 15 -radix hexadecimal /top/FSL_S_Data
add wave -noupdate -format Logic -height 15 /top/FSL_S_Read
add wave -noupdate -format Literal -height 15 -radix hexadecimal {/top/in_data[0]}
add wave -noupdate -format Literal -height 15 {/top/in_ctrl[0]}
add wave -noupdate -format Logic -height 15 {/top/in_wr[0]}
add wave -noupdate -format Logic -height 15 {/top/in_rdy[0]}
add wave -noupdate -format Literal -height 15 -radix hexadecimal /top/fsl_switch_intf_i/sw_acc
add wave -noupdate -format Literal -height 15 -radix unsigned /top/fsl_switch_intf_i/nr_of_reads
add wave -noupdate -format Logic -height 15 /top/fsl_switch_intf_i/switch_rdy
add wave -noupdate -format Literal -height 15 -radix unsigned /top/fsl_switch_intf_i/debug_count
add wave -noupdate -format Literal -height 15 -radix hexadecimal /top/fsl_switch_intf_i/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {209712 ps} 0}
configure wave -namecolwidth 306
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
WaveRestoreZoom {0 ps} {482176 ps}
