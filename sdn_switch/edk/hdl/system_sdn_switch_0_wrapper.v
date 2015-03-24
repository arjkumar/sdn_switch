//-----------------------------------------------------------------------------
// system_sdn_switch_0_wrapper.v
//-----------------------------------------------------------------------------

module system_sdn_switch_0_wrapper
  (
    debug_output,
    debug_trig,
    debug_output_op,
    debug_trig_op,
    out_data_0,
    out_ctrl_0,
    out_wr_0,
    out_rdy_0,
    out_data_1,
    out_ctrl_1,
    out_wr_1,
    out_rdy_1,
    out_data_2,
    out_ctrl_2,
    out_wr_2,
    out_rdy_2,
    out_data_3,
    out_ctrl_3,
    out_wr_3,
    out_rdy_3,
    in_data_0,
    in_ctrl_0,
    in_wr_0,
    in_rdy_0,
    in_data_1,
    in_ctrl_1,
    in_wr_1,
    in_rdy_1,
    in_data_2,
    in_ctrl_2,
    in_wr_2,
    in_rdy_2,
    in_data_3,
    in_ctrl_3,
    in_wr_3,
    in_rdy_3,
    cpu_in_reg_wr_data_bus,
    cpu_in_reg_ctrl,
    cpu_in_reg_vld,
    cpu_in_reg_rd_data_bus,
    cpu_in_reg_ack,
    cpu_out_reg_wr_data_bus,
    cpu_out_reg_ctrl,
    cpu_out_reg_vld,
    cpu_out_reg_rd_data_bus,
    cpu_out_reg_ack,
    sram_reset_done_in,
    sram_reset_done_out,
    reset,
    clk
  );
  output [147:0] debug_output;
  output [3:0] debug_trig;
  output [147:0] debug_output_op;
  output [3:0] debug_trig_op;
  output [63:0] out_data_0;
  output [7:0] out_ctrl_0;
  output out_wr_0;
  input out_rdy_0;
  output [63:0] out_data_1;
  output [7:0] out_ctrl_1;
  output out_wr_1;
  input out_rdy_1;
  output [63:0] out_data_2;
  output [7:0] out_ctrl_2;
  output out_wr_2;
  input out_rdy_2;
  output [63:0] out_data_3;
  output [7:0] out_ctrl_3;
  output out_wr_3;
  input out_rdy_3;
  input [63:0] in_data_0;
  input [7:0] in_ctrl_0;
  input in_wr_0;
  output in_rdy_0;
  input [63:0] in_data_1;
  input [7:0] in_ctrl_1;
  input in_wr_1;
  output in_rdy_1;
  input [63:0] in_data_2;
  input [7:0] in_ctrl_2;
  input in_wr_2;
  output in_rdy_2;
  input [63:0] in_data_3;
  input [7:0] in_ctrl_3;
  input in_wr_3;
  output in_rdy_3;
  input [59:0] cpu_in_reg_wr_data_bus;
  input [6:0] cpu_in_reg_ctrl;
  input cpu_in_reg_vld;
  input [31:0] cpu_in_reg_rd_data_bus;
  input cpu_in_reg_ack;
  output [59:0] cpu_out_reg_wr_data_bus;
  output [6:0] cpu_out_reg_ctrl;
  output cpu_out_reg_vld;
  output [31:0] cpu_out_reg_rd_data_bus;
  output cpu_out_reg_ack;
  input sram_reset_done_in;
  output sram_reset_done_out;
  input reset;
  input clk;

  sdn_switch
    #(
      .DATA_WIDTH ( 'h00000040 ),
      .CTRL_WIDTH ( 'h00000008 ),
      .UDP_REG_SRC_WIDTH ( 'h00000002 ),
      .NUM_OUTPUT_QUEUES ( 'h00000004 ),
      .NUM_INPUT_QUEUES ( 'h00000004 ),
      .SRAM_DATA_WIDTH ( 'h00000048 ),
      .SRAM_ADDR_WIDTH ( 'h00000009 ),
      .SWITCH_ID ( 'h00000000 )
    )
    sdn_switch_0 (
      .debug_output ( debug_output ),
      .debug_trig ( debug_trig ),
      .debug_output_op ( debug_output_op ),
      .debug_trig_op ( debug_trig_op ),
      .out_data_0 ( out_data_0 ),
      .out_ctrl_0 ( out_ctrl_0 ),
      .out_wr_0 ( out_wr_0 ),
      .out_rdy_0 ( out_rdy_0 ),
      .out_data_1 ( out_data_1 ),
      .out_ctrl_1 ( out_ctrl_1 ),
      .out_wr_1 ( out_wr_1 ),
      .out_rdy_1 ( out_rdy_1 ),
      .out_data_2 ( out_data_2 ),
      .out_ctrl_2 ( out_ctrl_2 ),
      .out_wr_2 ( out_wr_2 ),
      .out_rdy_2 ( out_rdy_2 ),
      .out_data_3 ( out_data_3 ),
      .out_ctrl_3 ( out_ctrl_3 ),
      .out_wr_3 ( out_wr_3 ),
      .out_rdy_3 ( out_rdy_3 ),
      .in_data_0 ( in_data_0 ),
      .in_ctrl_0 ( in_ctrl_0 ),
      .in_wr_0 ( in_wr_0 ),
      .in_rdy_0 ( in_rdy_0 ),
      .in_data_1 ( in_data_1 ),
      .in_ctrl_1 ( in_ctrl_1 ),
      .in_wr_1 ( in_wr_1 ),
      .in_rdy_1 ( in_rdy_1 ),
      .in_data_2 ( in_data_2 ),
      .in_ctrl_2 ( in_ctrl_2 ),
      .in_wr_2 ( in_wr_2 ),
      .in_rdy_2 ( in_rdy_2 ),
      .in_data_3 ( in_data_3 ),
      .in_ctrl_3 ( in_ctrl_3 ),
      .in_wr_3 ( in_wr_3 ),
      .in_rdy_3 ( in_rdy_3 ),
      .cpu_in_reg_wr_data_bus ( cpu_in_reg_wr_data_bus ),
      .cpu_in_reg_ctrl ( cpu_in_reg_ctrl ),
      .cpu_in_reg_vld ( cpu_in_reg_vld ),
      .cpu_in_reg_rd_data_bus ( cpu_in_reg_rd_data_bus ),
      .cpu_in_reg_ack ( cpu_in_reg_ack ),
      .cpu_out_reg_wr_data_bus ( cpu_out_reg_wr_data_bus ),
      .cpu_out_reg_ctrl ( cpu_out_reg_ctrl ),
      .cpu_out_reg_vld ( cpu_out_reg_vld ),
      .cpu_out_reg_rd_data_bus ( cpu_out_reg_rd_data_bus ),
      .cpu_out_reg_ack ( cpu_out_reg_ack ),
      .sram_reset_done_in ( sram_reset_done_in ),
      .sram_reset_done_out ( sram_reset_done_out ),
      .reset ( reset ),
      .clk ( clk )
    );

endmodule

