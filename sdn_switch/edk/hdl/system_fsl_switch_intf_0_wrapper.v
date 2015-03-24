//-----------------------------------------------------------------------------
// system_fsl_switch_intf_0_wrapper.v
//-----------------------------------------------------------------------------

module system_fsl_switch_intf_0_wrapper
  (
    debug_data,
    debug_trig,
    in_rdy,
    out_wr,
    out_data,
    out_ctrl,
    FSL_Clk,
    FSL_Rst,
    FSL_S_Clk,
    FSL_S_Read,
    FSL_S_Data,
    FSL_S_Control,
    FSL_S_Exists
  );
  output [242:0] debug_data;
  output [3:0] debug_trig;
  input in_rdy;
  output out_wr;
  output [63:0] out_data;
  output [7:0] out_ctrl;
  input FSL_Clk;
  input FSL_Rst;
  input FSL_S_Clk;
  output FSL_S_Read;
  input [0:31] FSL_S_Data;
  input FSL_S_Control;
  input FSL_S_Exists;

  fsl_switch_intf
    fsl_switch_intf_0 (
      .debug_data ( debug_data ),
      .debug_trig ( debug_trig ),
      .in_rdy ( in_rdy ),
      .out_wr ( out_wr ),
      .out_data ( out_data ),
      .out_ctrl ( out_ctrl ),
      .FSL_Clk ( FSL_Clk ),
      .FSL_Rst ( FSL_Rst ),
      .FSL_S_Clk ( FSL_S_Clk ),
      .FSL_S_Read ( FSL_S_Read ),
      .FSL_S_Data ( FSL_S_Data ),
      .FSL_S_Control ( FSL_S_Control ),
      .FSL_S_Exists ( FSL_S_Exists )
    );

endmodule

