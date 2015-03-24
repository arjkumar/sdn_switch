//----------------------------------------------------------------------------
// user_logic.vhd - module
//----------------------------------------------------------------------------
//
// ***************************************************************************
// ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
// **                                                                       **
// ** Xilinx, Inc.                                                          **
// ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
// ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
// ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
// ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
// ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
// ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
// ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
// ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
// ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
// ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
// ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
// ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
// ** FOR A PARTICULAR PURPOSE.                                             **
// **                                                                       **
// ***************************************************************************
//
//----------------------------------------------------------------------------
// Filename:          user_logic.vhd
// Version:           1.00.a
// Description:       User logic module.
// Date:              Mon Mar  2 23:38:57 2015 (by Create and Import Peripheral Wizard)
// Verilog Standard:  Verilog-2001
//----------------------------------------------------------------------------
// Naming Conventions:
//   active low signals:                    "*_n"
//   clock signals:                         "clk", "clk_div#", "clk_#x"
//   reset signals:                         "rst", "rst_n"
//   generics:                              "C_*"
//   user defined types:                    "*_TYPE"
//   state machine next state:              "*_ns"
//   state machine current state:           "*_cs"
//   combinatorial signals:                 "*_com"
//   pipelined or register delay signals:   "*_d#"
//   counter signals:                       "*cnt*"
//   clock enable signals:                  "*_ce"
//   internal version of output port:       "*_i"
//   device pins:                           "*_pin"
//   ports:                                 "- Names begin with Uppercase"
//   processes:                             "*_PROCESS"
//   component instantiations:              "<ENTITY_>I_<#|FUNC>"
//----------------------------------------------------------------------------

module user_logic
(
  // -- ADD USER PORTS BELOW THIS LINE ---------------
  // --USER ports added here 
  // -- ADD USER PORTS ABOVE THIS LINE ---------------

  // -- DO NOT EDIT BELOW THIS LINE ------------------
  // -- Bus protocol ports, do not add to or delete 
  Bus2IP_Clk,                     // Bus to IP clock
  Bus2IP_Reset,                   // Bus to IP reset
  Bus2IP_Data,                    // Bus to IP data bus
  Bus2IP_BE,                      // Bus to IP byte enables
  Bus2IP_RdCE,                    // Bus to IP read chip enable
  Bus2IP_WrCE,                    // Bus to IP write chip enable
  IP2Bus_Data,                    // IP to Bus data bus
  IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
  IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
  IP2Bus_Error                    // IP to Bus error response
  // -- DO NOT EDIT ABOVE THIS LINE ------------------
); // user_logic

// -- ADD USER PARAMETERS BELOW THIS LINE ------------
// --USER parameters added here 
parameter DATA_WIDTH            = 64; 
parameter CTRL_WIDTH            = 8;
parameter UDP_REG_SRC_WIDTH     = 2;
parameter IN_ARB_STAGE_NUM      = 2; 
parameter NUM_QUEUES            = 4;
parameter       NUM_IQ_BITS     = 2;


parameter CPU_FLAG_WAIT         = 2'd0; 
parameter READ_THE_PACKET       = 2'd1; 
parameter SRAM_BLOCK_ADDR = 32'h1000000;

// -- ADD USER PARAMETERS ABOVE THIS LINE ------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol parameters, do not add to or delete
parameter C_SLV_DWIDTH                   = 32;
parameter C_NUM_REG                      = 32;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

// -- ADD USER PORTS BELOW THIS LINE -----------------
// --USER ports added here 
// -- ADD USER PORTS ABOVE THIS LINE -----------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol ports, do not add to or delete
input                                     Bus2IP_Clk;
input                                     Bus2IP_Reset;
input      [0 : C_SLV_DWIDTH-1]           Bus2IP_Data;
input      [0 : C_SLV_DWIDTH/8-1]         Bus2IP_BE;
input      [0 : C_NUM_REG-1]              Bus2IP_RdCE;
input      [0 : C_NUM_REG-1]              Bus2IP_WrCE;
output     [0 : C_SLV_DWIDTH-1]           IP2Bus_Data;
output                                    IP2Bus_RdAck;
output                                    IP2Bus_WrAck;
output                                    IP2Bus_Error;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------

  // --USER nets declarations added here, as needed for user logic


  wire                                      clk;
  wire                                      reset;

  // -- Slave Wires
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg4_w;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg6_w;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg7_w;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg13_w;
  wire       [0 : C_SLV_DWIDTH-1]           slv_reg17_w;
  wire       [0 : C_SLV_DWIDTH-1]           slv_reg18_w;
  wire       [0 : C_SLV_DWIDTH-1]           slv_reg19_w;
  wire       [0 : C_SLV_DWIDTH-1]           slv_reg20_w;

  //-- Input/Output Connectivity wires
  
  wire [DATA_WIDTH-1:0]                     in_data [NUM_QUEUES-1:0];
  wire [CTRL_WIDTH-1:0]                     in_ctrl [NUM_QUEUES-1:0];
  wire [NUM_QUEUES-1:0]                     in_wr;
  wire [NUM_QUEUES-1:0]                     in_rdy;
  
  wire [DATA_WIDTH-1:0]                     out_data [NUM_QUEUES-1:0];
  wire [CTRL_WIDTH-1:0]                     out_ctrl [NUM_QUEUES-1:0];
  wire [NUM_QUEUES-1:0]                     out_wr;
  reg  [NUM_QUEUES-1:0]                     out_rdy;
  wire [DATA_WIDTH-1:0]                     out_data_0,out_data_1,out_data_2,out_data_3; //Addn wires added for xst work around
  wire [CTRL_WIDTH-1:0]                     out_ctrl_0,out_ctrl_1,out_ctrl_2,out_ctrl_3; //xst doesnt support passing 2d array in the sensitivity list
                                                                                         // of always @(*)
  
  wire                                      reg_fifo_empty;
  wire                                      reg_fifo_rd_en;
  wire                                      reg_rd_wr_L;
  wire [`CPCI_NF2_ADDR_WIDTH-1:0]           reg_addr;
  wire [`CPCI_NF2_DATA_WIDTH-1:0]           reg_rd_data;
  wire[`CPCI_NF2_DATA_WIDTH-1:0]            reg_wr_data;
  wire                                      reg_rd_vld;

  //-- Register Read FIFO
  wire  [`CPCI_NF2_DATA_WIDTH-1:0]          cpu_reg_rd_data;
  reg                                       cpu_reg_rd_en;
  wire                                      cpu_reg_rd_empty;
  wire                                      cpu_reg_read_fifo_full;
  reg                                       cpu_reg_fifo_rd_en_ld_reg;

  //--  Register Write FIFO
  reg                                       cpu_reg_rd_wr_L;
  reg  [`CPCI_NF2_ADDR_WIDTH-1:0]           cpu_reg_addr;
  reg  [`CPCI_NF2_DATA_WIDTH-1:0]           cpu_reg_wr_data;
  reg                                       cpu_reg_fifo_wr_en;
  reg                                       cpu_reg_fifo_wr_en_ld_reg;
  wire                                      cpu_reg_write_fifo_full;
  wire                                      cpu_reg_write_fifo_nearly_full;

  //--  Packet-IN FIFO
  reg          [NUM_IQ_BITS-1:0]            input_queue_sel;
  reg          [DATA_WIDTH-1:0]             cpu_dp_data_in;
  reg          [CTRL_WIDTH-1:0]             cpu_dp_ctrl_in;
  reg                                       cpu_dp_in_wr_en;
  wire                                      cpu_dp_in_empty;
  wire                                      cpu_dp_in_full;
  reg                                       cpu_dp_in_wr_en_ld_reg;
  reg                                       push_to_switch;
  reg                                       push_to_switch_ld_reg;
  wire                                      dp_in_empty,dp_in_full;
  
  
  wire         [DATA_WIDTH-1:0]             dp_data_in;
  wire         [CTRL_WIDTH-1:0]             dp_ctrl_in;
  reg                                       dp_in_rd_en;
  reg                                       dp_in_rd_en_d;
  //reg     [1:0]                             push_state,push_state_nxt; 

  //--  Packet-OUT FIFO
  reg          [NUM_IQ_BITS-1:0]            output_queue_sel;
  
  reg          [DATA_WIDTH-1:0]             dp_data_out;
  reg          [CTRL_WIDTH-1:0]             dp_ctrl_out;
  reg                                       dp_out_wr_en;
  wire                                      dp_out_full, dp_out_empty;
  
  reg          [DATA_WIDTH-1:0]             cpu_dp_data_out;
  wire         [DATA_WIDTH-1:0]             cpu_dp_data_out_w;
  reg          [CTRL_WIDTH-1:0]             cpu_dp_ctrl_out;
  wire         [CTRL_WIDTH-1:0]             cpu_dp_ctrl_out_w;
  reg                                       cpu_dp_out_wr_en;
  wire                                      pop_from_switch;
  reg                                       pop_from_switch_ld_reg;
  reg                                       cpu_dp_out_rd_en;



  // Nets for user logic slave model s/w accessible register example
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg0;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg1;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg2;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg3;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg4;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg5;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg6;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg7;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg8;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg9;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg10;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg11;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg12;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg13;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg14;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg15;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg16;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg17;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg18;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg19;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg20;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg21;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg22;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg23;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg24;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg25;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg26;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg27;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg28;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg29;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg30;
  reg        [0 : C_SLV_DWIDTH-1]           slv_reg31;
  wire       [0 : 31]                       slv_reg_write_sel;
  wire       [0 : 31]                       slv_reg_read_sel;
  reg        [0 : C_SLV_DWIDTH-1]           slv_ip2bus_data;
  wire                                      slv_read_ack;
  wire                                      slv_write_ack;
  integer                                   byte_index, bit_index;

  // --USER logic implementation added here

  // ------------------------------------------------------
  // Example code to read/write user logic slave model s/w accessible registers
  // 
  // Note:
  // The example code presented here is to show you one way of reading/writing
  // software accessible registers implemented in the user logic slave model.
  // Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  // to one software accessible register by the top level template. For example,
  // if you have four 32 bit software accessible registers in the user logic,
  // you are basically operating on the following memory mapped registers:
  // 
  //    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  //                     "1000"   C_BASEADDR + 0x0
  //                     "0100"   C_BASEADDR + 0x4
  //                     "0010"   C_BASEADDR + 0x8
  //                     "0001"   C_BASEADDR + 0xC
  // 
  // ------------------------------------------------------

  assign
    slv_reg_write_sel = Bus2IP_WrCE[0:31],
    slv_reg_read_sel  = Bus2IP_RdCE[0:31],
    slv_write_ack     = Bus2IP_WrCE[0] || Bus2IP_WrCE[1] || Bus2IP_WrCE[2] || Bus2IP_WrCE[3] || Bus2IP_WrCE[4] || Bus2IP_WrCE[5] || Bus2IP_WrCE[6] || Bus2IP_WrCE[7] || Bus2IP_WrCE[8] || Bus2IP_WrCE[9] || Bus2IP_WrCE[10] || Bus2IP_WrCE[11] || Bus2IP_WrCE[12] || Bus2IP_WrCE[13] || Bus2IP_WrCE[14] || Bus2IP_WrCE[15] || Bus2IP_WrCE[16] || Bus2IP_WrCE[17] || Bus2IP_WrCE[18] || Bus2IP_WrCE[19] || Bus2IP_WrCE[20] || Bus2IP_WrCE[21] || Bus2IP_WrCE[22] || Bus2IP_WrCE[23] || Bus2IP_WrCE[24] || Bus2IP_WrCE[25] || Bus2IP_WrCE[26] || Bus2IP_WrCE[27] || Bus2IP_WrCE[28] || Bus2IP_WrCE[29] || Bus2IP_WrCE[30] || Bus2IP_WrCE[31],
    slv_read_ack      = Bus2IP_RdCE[0] || Bus2IP_RdCE[1] || Bus2IP_RdCE[2] || Bus2IP_RdCE[3] || Bus2IP_RdCE[4] || Bus2IP_RdCE[5] || Bus2IP_RdCE[6] || Bus2IP_RdCE[7] || Bus2IP_RdCE[8] || Bus2IP_RdCE[9] || Bus2IP_RdCE[10] || Bus2IP_RdCE[11] || Bus2IP_RdCE[12] || Bus2IP_RdCE[13] || Bus2IP_RdCE[14] || Bus2IP_RdCE[15] || Bus2IP_RdCE[16] || Bus2IP_RdCE[17] || Bus2IP_RdCE[18] || Bus2IP_RdCE[19] || Bus2IP_RdCE[20] || Bus2IP_RdCE[21] || Bus2IP_RdCE[22] || Bus2IP_RdCE[23] || Bus2IP_RdCE[24] || Bus2IP_RdCE[25] || Bus2IP_RdCE[26] || Bus2IP_RdCE[27] || Bus2IP_RdCE[28] || Bus2IP_RdCE[29] || Bus2IP_RdCE[30] || Bus2IP_RdCE[31];

  // implement slave model register(s)
  always @( posedge Bus2IP_Clk )
    begin: SLAVE_REG_WRITE_PROC

      if ( Bus2IP_Reset == 1 )
        begin
          slv_reg0 <= 0;
          slv_reg1 <= 0;
          slv_reg2 <= 0;
          slv_reg3 <= 0;
          slv_reg4 <= 0;
          slv_reg5 <= 0;
          slv_reg6 <= 0;
          slv_reg7 <= 0;
          slv_reg8 <= 0;
          slv_reg9 <= 0;
          slv_reg10 <= 0;
          slv_reg11 <= 0;
          slv_reg12 <= 0;
          slv_reg13 <= 0;
          slv_reg14 <= 0;
          slv_reg15 <= 0;
          slv_reg16 <= 0;
          slv_reg17 <= 0;
          slv_reg18 <= 0;
          slv_reg19 <= 0;
          slv_reg20 <= 0;
          slv_reg21 <= 0;
          slv_reg22 <= 0;
          slv_reg23 <= 0;
          slv_reg24 <= 0;
          slv_reg25 <= 0;
          slv_reg26 <= 0;
          slv_reg27 <= 0;
          slv_reg28 <= 0;
          slv_reg29 <= 0;
          slv_reg30 <= 0;
          slv_reg31 <= 0;
        end
      else
        case ( slv_reg_write_sel )
          32'b10000000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg0[bit_index] <= Bus2IP_Data[bit_index];
          32'b01000000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg1[bit_index] <= Bus2IP_Data[bit_index];
          32'b00100000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg2[bit_index] <= Bus2IP_Data[bit_index];
          32'b00010000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg3[bit_index] <= Bus2IP_Data[bit_index];
          32'b00001000000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg4[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000100000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg5[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000010000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg6[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000001000000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg7[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000100000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg8[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000010000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg9[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000001000000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg10[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000100000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg11[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000010000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg12[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000001000000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg13[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000100000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg14[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000010000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg15[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000001000000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg16[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000100000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg17[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000010000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg18[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000001000000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg19[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000100000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg20[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000010000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg21[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000001000000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg22[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000100000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg23[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000010000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg24[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000001000000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg25[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000000100000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg26[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000000010000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg27[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000000001000 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg28[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000000000100 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg29[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000000000010 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg30[bit_index] <= Bus2IP_Data[bit_index];
          32'b00000000000000000000000000000001 :
            for ( byte_index = 0; byte_index <= (C_SLV_DWIDTH/8)-1; byte_index = byte_index+1 )
              if ( Bus2IP_BE[byte_index] == 1 )
                for ( bit_index = byte_index*8; bit_index <= byte_index*8+7; bit_index = bit_index+1 )
                  slv_reg31[bit_index] <= Bus2IP_Data[bit_index];
          default : ;
        endcase

    end // SLAVE_REG_WRITE_PROC

  // implement slave model register read mux
  always @( slv_reg_read_sel or slv_reg0 or slv_reg1 or slv_reg2 or slv_reg3 or slv_reg4 or slv_reg5 or slv_reg6 or slv_reg7 or slv_reg8 or slv_reg9 or slv_reg10 or slv_reg11 or slv_reg12 or slv_reg13 or slv_reg14 or slv_reg15 or slv_reg16 or slv_reg17 or slv_reg18 or slv_reg19 or slv_reg20 or slv_reg21 or slv_reg22 or slv_reg23 or slv_reg24 or slv_reg25 or slv_reg26 or slv_reg27 or slv_reg28 or slv_reg29 or slv_reg30 or slv_reg31 )
    begin: SLAVE_REG_READ_PROC

      case ( slv_reg_read_sel )
        32'b10000000000000000000000000000000 : slv_ip2bus_data <= slv_reg0;
        32'b01000000000000000000000000000000 : slv_ip2bus_data <= slv_reg1;
        32'b00100000000000000000000000000000 : slv_ip2bus_data <= slv_reg2;
        32'b00010000000000000000000000000000 : slv_ip2bus_data <= slv_reg3;
        32'b00001000000000000000000000000000 : slv_ip2bus_data <= slv_reg4_w;
        32'b00000100000000000000000000000000 : slv_ip2bus_data <= slv_reg5;
        32'b00000010000000000000000000000000 : slv_ip2bus_data <= slv_reg6_w;
        32'b00000001000000000000000000000000 : slv_ip2bus_data <= slv_reg7_w;
        32'b00000000100000000000000000000000 : slv_ip2bus_data <= slv_reg8;
        32'b00000000010000000000000000000000 : slv_ip2bus_data <= slv_reg9;
        32'b00000000001000000000000000000000 : slv_ip2bus_data <= slv_reg10;
        32'b00000000000100000000000000000000 : slv_ip2bus_data <= slv_reg11;
        32'b00000000000010000000000000000000 : slv_ip2bus_data <= slv_reg12;
        32'b00000000000001000000000000000000 : slv_ip2bus_data <= slv_reg13_w;
        32'b00000000000000100000000000000000 : slv_ip2bus_data <= slv_reg14;
        32'b00000000000000010000000000000000 : slv_ip2bus_data <= slv_reg15;
        32'b00000000000000001000000000000000 : slv_ip2bus_data <= slv_reg16;
        32'b00000000000000000100000000000000 : slv_ip2bus_data <= slv_reg17;
        32'b00000000000000000010000000000000 : slv_ip2bus_data <= slv_reg18;
        32'b00000000000000000001000000000000 : slv_ip2bus_data <= slv_reg19;
        32'b00000000000000000000100000000000 : slv_ip2bus_data <= slv_reg20_w;
        32'b00000000000000000000010000000000 : slv_ip2bus_data <= slv_reg21;
        32'b00000000000000000000001000000000 : slv_ip2bus_data <= slv_reg22;
        32'b00000000000000000000000100000000 : slv_ip2bus_data <= slv_reg23;
        32'b00000000000000000000000010000000 : slv_ip2bus_data <= slv_reg24;
        32'b00000000000000000000000001000000 : slv_ip2bus_data <= slv_reg25;
        32'b00000000000000000000000000100000 : slv_ip2bus_data <= slv_reg26;
        32'b00000000000000000000000000010000 : slv_ip2bus_data <= slv_reg27;
        32'b00000000000000000000000000001000 : slv_ip2bus_data <= slv_reg28;
        32'b00000000000000000000000000000100 : slv_ip2bus_data <= slv_reg29;
        32'b00000000000000000000000000000010 : slv_ip2bus_data <= slv_reg30;
        32'b00000000000000000000000000000001 : slv_ip2bus_data <= slv_reg31;
        default : slv_ip2bus_data <= 0;
      endcase

    end // SLAVE_REG_READ_PROC

  // ------------------------------------------------------------
  // Example code to drive IP to Bus signals
  // ------------------------------------------------------------

  assign IP2Bus_Data    = slv_ip2bus_data;
  assign IP2Bus_WrAck   = slv_write_ack;
  assign IP2Bus_RdAck   = slv_read_ack;
  assign IP2Bus_Error   = 0;

// Test Bench 
reg test_clk,test_reset;


  reg                                       test_cpu_reg_rd_wr_L;
  reg  [`CPCI_NF2_ADDR_WIDTH-1:0]           test_cpu_reg_addr;
  reg  [`CPCI_NF2_DATA_WIDTH-1:0]           test_cpu_reg_wr_data;
  reg                                       test_cpu_reg_fifo_wr_en;
  
  reg          [DATA_WIDTH-1:0]             test_cpu_dp_data_in;
  reg          [CTRL_WIDTH-1:0]             test_cpu_dp_ctrl_in;
  reg                                       test_cpu_dp_in_wr_en;
  reg                                       test_push;
  reg          [DATA_WIDTH-1:0]             pkt_in [10:0];
  reg          [CTRL_WIDTH-1:0]             ctrl_in[10:0];
  reg          [31:0]                       pkt_length;
  
  reg  [`CPCI_NF2_DATA_WIDTH-1:0]           header[7:0];
  reg  [`CPCI_NF2_DATA_WIDTH-1:0]           action[9:0];
  reg          [NUM_IQ_BITS-1:0]            test_input_queue_sel;
  
 

initial begin
  test_clk   = 1'b0; 
  forever test_clk =#10 ~test_clk;
end

initial begin
  test_reset = 1'b1;
  test_cpu_reg_fifo_wr_en = 1'b0;
  test_push               = 1'b0;
  test_cpu_dp_in_wr_en    = 1'b0;
  test_input_queue_sel    = 0;
  #100
  test_reset = 1'b0;
  //#500000;
  //$finish;
end

initial begin
  #500;
   pkt_in[0] = 'h00248C0179080024;
   pkt_in[1] = 'h8C01790681002008;
   pkt_in[2] = 'h08004520003C16DB;
   pkt_in[3] = 'h00003F06CC8AD5E9;
   pkt_in[4] = 'hAB0A5EB6B88C0557;
   pkt_in[5] = 'h901F9030937175F5;
   pkt_in[6] = 'hDBBAA0121628EFE6;
   pkt_in[7] = 'h0000020405960402;
   pkt_in[8] = 'h080A59709A082DDE;
   pkt_in[9] = 'h7D72010303060000;
   
   ctrl_in[0] = 0;
   ctrl_in[1] = 0;
   ctrl_in[2] = 0;
   ctrl_in[3] = 0;
   ctrl_in[4] = 0;
   ctrl_in[5] = 0;
   ctrl_in[6] = 0;
   ctrl_in[7] = 0;
   ctrl_in[8] = 0;
   ctrl_in[9] = 4;

    header[7] = 'h80200820;
    header[6] = 'h0000248c;
    header[5] = 'h01790600;
    header[4] = 'h248c0179;
    header[3] = 'h080800d5;
    header[2] = 'he9ab0a5e;
    header[1] = 'hb6b88c06;
    header[0] = 'h0557901f;
    
    //Action
    action[9] = 0;
    action[8] = 0;
    action[7] = 0;
    action[6] = 0;
    action[5] = 0;
    action[4] = 0;
    action[3] = 0;
    action[2] = 0;
    action[1] = 0;
    action[0] = 'hF;

    access_reg(160);
    wait(reg_fifo_empty === 1);
    #5000;
    push_packet(10);
    #1000;
    access_udp_reg('h2000100,8);
    wait(reg_fifo_empty == 1);
    #10000; 

    $finish;
end

task access_udp_reg; 
  input [`CPCI_NF2_DATA_WIDTH-1:0] start_addr; 
  input [31:0]                     number_of_registers; 
  integer i;
  begin
    for(i=0;i<number_of_registers;i=i+1) begin
      write_to_reg(start_addr + (4 * i), 0 , 1);
    end
  end
endtask
	
task access_reg;
  input [`CPCI_NF2_ADDR_WIDTH-1:0] start_idx;
  integer i;
  reg [`CPCI_NF2_ADDR_WIDTH-1:0] start_addr;
  reg [`CPCI_NF2_ADDR_WIDTH-1:0] sram_addr;
  begin
    start_addr = start_idx * 2;
    for(i=0;i<8;i=i+1) begin
      sram_addr = ((start_addr + i) * 4);
      sram_addr = sram_addr | SRAM_BLOCK_ADDR;
      $display("SRAM_ADDR[%0d] = %0X",i,sram_addr);
      write_to_reg(sram_addr,header[i],0);
    end
    for(i=0;i<10;i=i+1) begin
      sram_addr = ((start_addr + 10 + i) * 4) | SRAM_BLOCK_ADDR;
      write_to_reg(sram_addr,action[i],0);
    end
  end
endtask
  

task write_to_reg;
  input [`CPCI_NF2_ADDR_WIDTH-1:0] addr;
  input [`CPCI_NF2_DATA_WIDTH-1:0] data;
  input                            rd_wr_L;
  begin
    test_cpu_reg_wr_data = data; 
    test_cpu_reg_rd_wr_L = rd_wr_L; 
    test_cpu_reg_addr    = addr;
    wait(!cpu_reg_write_fifo_nearly_full);
    @(posedge clk); 
    test_cpu_reg_fifo_wr_en = 1'b1;	
    @(posedge clk); 
    test_cpu_reg_fifo_wr_en = 1'b0;	
  end
endtask

task push_packet;
  input [31:0] pkt_length;
  integer i;
  begin
     for(i=0;i<pkt_length;i=i+1) begin
       @(posedge clk);
       test_cpu_dp_data_in = pkt_in[i];
       test_cpu_dp_ctrl_in = ctrl_in[i];
       test_cpu_dp_in_wr_en = 1'b1;
     end
       @(posedge clk);
       test_cpu_dp_in_wr_en = 1'b0;
       @(posedge clk);
       test_push = 1'b1;
  end
endtask 
//Openflow Switch starts here

assign clk   = test_clk; //Bus2IP_Clk;
assign reset = test_reset; //slv_reg0[31];  

//-- Load Pulse generation
// Slv_reg4/7 are toggled by software whenever sw wants to access write and read fifo
// The ld_reg is used to generate a pulse(cpu_reg_fifo_wr_en/rd_en)
// which acts as write or read enable for the register fifos
  always@(posedge clk) begin
    if(reset) begin
      //Register
      cpu_reg_fifo_wr_en_ld_reg <= 1'b0;
      cpu_reg_fifo_rd_en_ld_reg <= 1'b0;
      
      //Packet-In FIFO
      cpu_dp_in_wr_en_ld_reg    <= 1'b0;
      push_to_switch_ld_reg     <= 1'b0;

      //Packet _Out FIFO
      pop_from_switch_ld_reg    <= 1'b0;
    end
    else begin
      cpu_reg_fifo_wr_en_ld_reg <= slv_reg5[31];
      cpu_reg_fifo_rd_en_ld_reg <= slv_reg8[31];
      cpu_dp_in_wr_en_ld_reg    <= slv_reg14[31];
      push_to_switch_ld_reg     <= slv_reg15[31]; 
      pop_from_switch_ld_reg    <= slv_reg21[31]; 
    end
  end

//CPU -- Reg Write/Read FIFO Connections
  always @(*) begin
    //Reg Write FIFO access
    cpu_reg_wr_data    = slv_reg1;
    cpu_reg_addr       = slv_reg2[ 32 -`CPCI_NF2_ADDR_WIDTH: 31];
    cpu_reg_rd_wr_L    = slv_reg3[31];
    slv_reg4_w         = {30'd0,cpu_reg_write_fifo_full,reg_fifo_empty};
    cpu_reg_fifo_wr_en = slv_reg5[31] ^ cpu_reg_fifo_wr_en_ld_reg;
    
    //Reg Read FIFO access
    slv_reg6_w         = cpu_reg_rd_data;
    slv_reg7_w         = {30'd0,cpu_reg_read_fifo_full,cpu_reg_rd_empty};
    cpu_reg_rd_en      = slv_reg8[31] ^ cpu_reg_fifo_rd_en_ld_reg;
  end

//--Reg Write FIFO
   small_fifo
     #(.WIDTH(1 + `CPCI_NF2_ADDR_WIDTH + `CPCI_NF2_DATA_WIDTH), .MAX_DEPTH_BITS(4))
    reg_write_fifo 
       (
        //.din           ({cpu_reg_rd_wr_L,cpu_reg_addr,cpu_reg_wr_data}),  // Data in
        //.wr_en         (cpu_reg_fifo_wr_en),             // Write enable
        .din           ({test_cpu_reg_rd_wr_L,test_cpu_reg_addr,test_cpu_reg_wr_data}),  // Data in
        .wr_en         (test_cpu_reg_fifo_wr_en),             // Write enable
        .rd_en         (reg_fifo_rd_en),    // Read the next word
        .dout          ({reg_rd_wr_L,reg_addr,reg_wr_data}),
        .full          (cpu_reg_write_fifo_full),
        .prog_full     (),
        .nearly_full   (cpu_reg_write_fifo_nearly_full),
        .empty         (reg_fifo_empty),
        .reset         (reset),
        .clk           (clk)
        );


//--Reg Read FIFO

  small_fifo
     #(.WIDTH(`CPCI_NF2_DATA_WIDTH), .MAX_DEPTH_BITS(3))
    reg_read_fifo 
       (.din           (reg_rd_data),             // Data in
        .wr_en         (reg_rd_vld),              // Write enable
        .rd_en         (cpu_reg_rd_en),           // Read the next word
        .dout          (cpu_reg_rd_data),
        .full          (cpu_reg_read_fifo_full),
        .prog_full     (),
        .nearly_full   (),
        .empty         (cpu_reg_rd_empty),
        .reset         (reset),
        .clk           (clk)
        );

//--------------------------------------------------------
// Logic to Write a packet in to one of the switch queues
//--------------------------------------------------------



  always @(*) begin
    input_queue_sel = test_input_queue_sel;//slv_reg9[32-NUM_IQ_BITS:31]; 
    cpu_dp_data_in  = {slv_reg11,slv_reg10};
    cpu_dp_ctrl_in  = slv_reg12[32-CTRL_WIDTH:31];
    slv_reg13_w     = {30'd0,dp_in_full,dp_in_empty};
    cpu_dp_in_wr_en = slv_reg14[31] ^ cpu_dp_in_wr_en_ld_reg;
    //push_to_switch  = slv_reg15[31] ^ push_to_switch_ld_reg;
    push_to_switch  = test_push; //slv_reg15[31];
  end


  assign in_data[0] = dp_data_in; assign in_ctrl[0] = dp_ctrl_in;
  assign in_data[1] = dp_data_in; assign in_ctrl[1] = dp_ctrl_in;
  assign in_data[2] = dp_data_in; assign in_ctrl[2] = dp_ctrl_in;
  assign in_data[3] = dp_data_in; assign in_ctrl[3] = dp_ctrl_in;
  
  assign in_wr[0]   = dp_in_rd_en_d & (input_queue_sel == 0);
  assign in_wr[1]   = dp_in_rd_en_d & (input_queue_sel == 1);
  assign in_wr[2]   = dp_in_rd_en_d & (input_queue_sel == 2);
  assign in_wr[3]   = dp_in_rd_en_d & (input_queue_sel == 3);

  always@(*) begin
    dp_in_rd_en  = 1'b0;
    case(input_queue_sel)
      2'd0:begin
             dp_in_rd_en = !dp_in_empty & push_to_switch & in_rdy[0];
           end
      2'd1:begin
             dp_in_rd_en = !dp_in_empty & push_to_switch & in_rdy[1];
           end
      2'd2:begin
             dp_in_rd_en = !dp_in_empty & push_to_switch & in_rdy[2];
           end
      2'd3:begin
             dp_in_rd_en = !dp_in_empty & push_to_switch & in_rdy[3];
           end
    endcase
  end


  always @(posedge clk) begin
    dp_in_rd_en_d <= dp_in_rd_en;
  end


//-- DATA WRITE FIFO
   //fallthrough_small_fifo
   small_fifo
     #(.WIDTH(DATA_WIDTH+CTRL_WIDTH),.MAX_DEPTH_BITS(4))
    data_write_fifo 
       (
        //.din           ({cpu_dp_data_in,cpu_dp_ctrl_in}),
        //.wr_en         (cpu_dp_in_wr_en),
        .din           ({test_cpu_dp_data_in,test_cpu_dp_ctrl_in}),
        .wr_en         (test_cpu_dp_in_wr_en),
        .rd_en         (dp_in_rd_en),
        .dout          ({dp_data_in,dp_ctrl_in}),
        .full          (dp_in_full),
        .prog_full     (),
        .nearly_full   (),
        .empty         (dp_in_empty),
        .reset         (reset),
        .clk           (clk)
        );



//--------------------------------------------------------
// Logic to Read a packet from one of the switch queues
//--------------------------------------------------------

assign pop_from_switch = slv_reg21[31] ^ pop_from_switch_ld_reg; 
assign slv_reg17_w     = cpu_dp_data_out[31:0];
assign slv_reg18_w     = cpu_dp_data_out[63:32];
assign slv_reg19_w     = {{32-CTRL_WIDTH{1'b0}},cpu_dp_ctrl_out};
assign slv_reg20_w     = {30'd0,dp_out_full,dp_out_empty};

//Reads the top line from Packet out fifo
//and writes to cpu registers
  always @(posedge clk) begin
    if(reset) begin
      cpu_dp_data_out <= {DATA_WIDTH{1'b0}};
      cpu_dp_ctrl_out <= {CTRL_WIDTH{1'b0}};
      cpu_dp_out_rd_en<= 1'b0; 
    end
    else begin
      cpu_dp_out_rd_en <= pop_from_switch & !dp_out_empty; 
      if(pop_from_switch) begin
        if(!dp_out_empty) begin
          cpu_dp_data_out <= cpu_dp_data_out_w;
  	  cpu_dp_ctrl_out <= cpu_dp_ctrl_out_w;
        end
        else begin
          cpu_dp_data_out <= 'hDEAD_BEEF;
          cpu_dp_ctrl_out <= 'h0;
        end
      end
    end
  end


 assign out_data_0 = out_data[0];
 assign out_data_1 = out_data[1];
 assign out_data_2 = out_data[2];
 assign out_data_3 = out_data[3];
 assign out_ctrl_0 = out_ctrl[0]; 
 assign out_ctrl_1 = out_ctrl[1]; 
 assign out_ctrl_2 = out_ctrl[2]; 
 assign out_ctrl_3 = out_ctrl[3]; 
  
  always@(*) begin
    dp_data_out  = {DATA_WIDTH{1'b0}};
    dp_ctrl_out  = {CTRL_WIDTH{1'b0}};
    dp_out_wr_en = 1'b0;
    out_rdy      = 4'hF;
    case(output_queue_sel)
      2'd0 :begin
              out_rdy[0]   = !dp_out_full;
              dp_data_out  = out_data_0;
	      dp_ctrl_out  = out_ctrl_0; 
	      dp_out_wr_en = out_wr[0];
            end
      2'd1 :begin
              out_rdy[1]   = !dp_out_full;
              dp_data_out  = out_data_1;
	      dp_ctrl_out  = out_ctrl_1; 
	      dp_out_wr_en = out_wr[1];
            end
      2'd2 :begin
              out_rdy[2]   = !dp_out_full;
              dp_data_out  = out_data_2;
	      dp_ctrl_out  = out_ctrl_2; 
	      dp_out_wr_en = out_wr[2];
            end
      2'd3 :begin
              out_rdy[3]   = !dp_out_full;
              dp_data_out  = out_data_3;
	      dp_ctrl_out  = out_ctrl_3; 
	      dp_out_wr_en = out_wr[3];
            end
    endcase
  end

//-- DATA READ FIFO 
 fallthrough_small_fifo
     #(.WIDTH(DATA_WIDTH+CTRL_WIDTH),.MAX_DEPTH_BITS(4))
    data_read_fifo 
       (.din           ({dp_data_out,dp_ctrl_out}),
        .wr_en         (dp_out_wr_en),
        .rd_en         (cpu_dp_out_rd_en),
        .dout          ({cpu_dp_data_out_w,cpu_dp_ctrl_out_w}),
        .full          (dp_out_full),
        .prog_full     (),
        .nearly_full   (),
        .empty         (dp_out_empty),
        .reset         (reset),
        .clk           (clk)
        );


 openflow_switch 
     #(.DATA_WIDTH(DATA_WIDTH),
       .CTRL_WIDTH(CTRL_WIDTH),
       .UDP_REG_SRC_WIDTH (UDP_REG_SRC_WIDTH),
       .NUM_OUTPUT_QUEUES(NUM_QUEUES),
       .NUM_INPUT_QUEUES(NUM_QUEUES)) user_data_path
       (.in_data_0 (in_data[0]),
        .in_ctrl_0 (in_ctrl[0]),
        .in_wr_0 (in_wr[0]),
        .in_rdy_0 (in_rdy[0]),

        .in_data_1 (in_data[1]),
        .in_ctrl_1 (in_ctrl[1]),
        .in_wr_1 (in_wr[1]),
        .in_rdy_1 (in_rdy[1]),

        .in_data_2 (in_data[2]),
        .in_ctrl_2 (in_ctrl[2]),
        .in_wr_2 (in_wr[2]),
        .in_rdy_2 (in_rdy[2]),

        .in_data_3 (in_data[3]),
        .in_ctrl_3 (in_ctrl[3]),
        .in_wr_3 (in_wr[3]),
        .in_rdy_3 (in_rdy[3]),

        // interface to MAC, CPU tx queues
	.out_data_0 (out_data[0]),
        .out_ctrl_0 (out_ctrl[0]),
        .out_wr_0 (out_wr[0]),
        .out_rdy_0 (out_rdy[0]),

        .out_data_1 (out_data[1]),
        .out_ctrl_1 (out_ctrl[1]),
        .out_wr_1 (out_wr[1]),
        .out_rdy_1 (out_rdy[1]),

        .out_data_2 (out_data[2]),
        .out_ctrl_2 (out_ctrl[2]),
        .out_wr_2 (out_wr[2]),
        .out_rdy_2 (out_rdy[2]),

        .out_data_3 (out_data[3]),
        .out_ctrl_3 (out_ctrl[3]),
        .out_wr_3 (out_wr[3]),
        .out_rdy_3 (out_rdy[3]),

        // register interface
        .reg_fifo_empty          (reg_fifo_empty),
	.reg_fifo_rd_en          (reg_fifo_rd_en),
        .reg_rd_wr_L             (reg_rd_wr_L),
        .reg_addr                (reg_addr),
        .reg_rd_data             (reg_rd_data),
        .reg_wr_data             (reg_wr_data),
        .reg_rd_vld              (reg_rd_vld),

        // misc
        .reset (reset),
        .clk (clk));




endmodule


//----------------------- SLV REG TABLE ------------------------
// Register Write
//slv_reg1 =  cpu_reg_wr_data 
//slv_reg2 =  cpu_reg_addr 
//slv_reg3 =  cpu_reg_rd_wr_L
//slv_reg4 =  cpu_reg_write_fifo_full/Empty
//slv_reg5 =  cpu_reg_write_fifo_toggle
//
//Register Read
//slv_reg6 =  cpu_rd_data                 //Read
//slv_reg7 =  cpu_rd_fifo_full/empty      //Read 
//slv_reg8 =  cpu_reg_rd_fifo_toggle    

// Packet-IN FIFO
//slv_reg9  = input_queue_sel;
//slv_reg10 = data_in[31:0]; 
//slv_reg11 = data_in[63:32];
//slv_reg12 = ctrl_in[7:0]
//slv_reg13 = data_in_fifo(full/empty);
//slv_reg14 = data_fifo_toggle(write);
//slv_reg15 = push_to_switch;

// Packet-Out FIFO
//slv_reg16 - output_queue_sel;
//slv_reg17 - data_out[31:0] 
//slv_reg18 - data_out[63:0]
//slv_reg19 - ctrl_out[7:0]
//slv_reg20 - data_out_fifo (full/empty)
//slv_reg21 - pop_from_switch
//---------------

