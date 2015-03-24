//----------------------------------------------------------------------------
// fsl_switch_intf - module
//----------------------------------------------------------------------------
// IMPORTANT:
// DO NOT MODIFY THIS FILE EXCEPT IN THE DESIGNATED SECTIONS.
//
// SEARCH FOR --USER TO DETERMINE WHERE CHANGES ARE ALLOWED.
//
// TYPICALLY, THE ONLY ACCEPTABLE CHANGES INVOLVE ADDING NEW
// PORTS AND GENERICS THAT GET PASSED THROUGH TO THE INSTANTIATION
// OF THE USER_LOGIC ENTITY.
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
// Filename:          fsl_switch_intf
// Version:           1.00.a
// Description:       Example FSL core (Verilog).
// Date:              Thu Mar 19 20:57:34 2015 (by Create and Import Peripheral Wizard)
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

////////////////////////////////////////////////////////////////////////////////
//
//
// Definition of Ports
// FSL_Clk             : Synchronous clock
// FSL_Rst           : System reset, should always come from FSL bus
// FSL_S_Clk       : Slave asynchronous clock
// FSL_S_Read      : Read signal, requiring next available input to be read
// FSL_S_Data      : Input data
// FSL_S_Control   : Control Bit, indicating the input data are control word
// FSL_S_Exists    : Data Exist Bit, indicating data exist in the input FSL bus
//
////////////////////////////////////////////////////////////////////////////////

//----------------------------------------
// Module Section
//----------------------------------------
module fsl_switch_intf 
	(
		// ADD USER PORTS BELOW THIS LINE 
		// -- USER ports added here
		//Chipscope 
		debug_data, 
		debug_trig,
		
		in_rdy,
		out_wr,
		out_data,
		out_ctrl,
		// ADD USER PORTS ABOVE THIS LINE 

		// DO NOT EDIT BELOW THIS LINE ////////////////////
		// Bus protocol ports, do not add or delete. 
		FSL_Clk,
		FSL_Rst,
		FSL_S_Clk,
		FSL_S_Read,
		FSL_S_Data,
		FSL_S_Control,
		FSL_S_Exists
		// DO NOT EDIT ABOVE THIS LINE ////////////////////
	);


// ADD USER PARAMETERS BELOW THIS LINE 
// --USER parameters added here
parameter                                 DATA_WIDTH    = 64; 
parameter                                 CTRL_WIDTH    = 8;
parameter                                 BACK_PRESS_EN = 0;
// ADD USER PARAMETERS ABOVE THIS LINE


// ADD USER PORTS BELOW THIS LINE 
// -- USER ports added here 
input                                        in_rdy;
output reg                                   out_wr;
output reg  [DATA_WIDTH-1:0]                 out_data;
output reg  [CTRL_WIDTH-1:0]                 out_ctrl;
// ADD USER PORTS ABOVE THIS LINE 

input                                     FSL_Clk;
input                                     FSL_Rst;
input                                     FSL_S_Clk;
output                                    FSL_S_Read;
input      [0 : 31]                       FSL_S_Data;
input                                     FSL_S_Control;
input                                     FSL_S_Exists;

output    [242:0]                         debug_data;
output    [3:0]                           debug_trig;


//----------------------------------------
// Implementation Section
//----------------------------------------
// In this section, we povide an example implementation of MODULE fsl_switch_intf
// that read all inputs, and add each input to the contents of register 'sum' which
// acts as an accumulator
//
// You will need to modify this example for
// MODULE fsl_switch_intf to implement your coprocessor

   // Total number of input data.
   localparam NUMBER_OF_INPUT_WORDS  = 3;

   // Define the states of state machine
   localparam Idle  = 3'b10;
   localparam Read_Inputs = 3'b01;
   reg [0:1] state;

   // Accumulator to hold sum of inputs read at any point in time
   //reg [0:31] sum;
   reg [0:NUMBER_OF_INPUT_WORDS*32 -1]  sw_acc;
   // Counters to store the number inputs read
   reg [0:NUMBER_OF_INPUT_WORDS - 1] nr_of_reads;
   wire                              switch_rdy;
   reg [31:0]                        debug_count;

   // CAUTION:
   // The sequence in which data are read in should be
   // consistent with the sequence they are written in the
   // driver's fsl_switch_intf.c file

   assign FSL_S_Read  = (state == Read_Inputs) ? FSL_S_Exists : 0;
   assign switch_rdy  = (in_rdy & BACK_PRESS_EN) || !BACK_PRESS_EN;

   always @(posedge FSL_Clk) 
   begin  // process The_SW_accelerator
      if (FSL_Rst)               // Synchronous reset (active high)
        begin
           // CAUTION: make sure your reset polarity is consistent with the
           // system reset polarity
           state        <= Idle;
           nr_of_reads  <= 0;
           sw_acc       <= 'h0;
        end
      else
        case (state)
          Idle:begin 
            if ((FSL_S_Exists == 1) & switch_rdy)
            begin
              state       <= Read_Inputs;
              nr_of_reads <= NUMBER_OF_INPUT_WORDS - 1;
              sw_acc      <= 'h0;
            end
	    out_wr        <= 1'b0;
          end
          Read_Inputs:begin 
            if (FSL_S_Exists == 1) 
            begin
              // Coprocessor function (Adding) happens here
              //sum         <= sum + FSL_S_Data;
	      sw_acc        <= (sw_acc << 32) | FSL_S_Data;

              if (nr_of_reads == 0)
                begin
                  state        <= Idle;
		  out_wr       <= 1'b1;
                end
              else
                nr_of_reads <= nr_of_reads - 1;
            end
	  end  
        endcase
   end

   always @(*) begin 
     out_data = sw_acc[32:95]; 
     out_ctrl = sw_acc[24:31];
   end
   
   always @(posedge FSL_Clk)begin
     if(FSL_Rst) begin
       debug_count <= 'h0;
     end
     else begin
       if(|out_ctrl & out_wr)
        debug_count <= debug_count + 1;
     end
   end

assign debug_data  = {
                      switch_rdy,
                      debug_count, 
                      state,
		      nr_of_reads,
		      sw_acc,
                      in_rdy,
                      out_wr, 
                      out_ctrl,
                      out_data,  
                      FSL_S_Exists,
                      FSL_S_Read,
                      FSL_S_Control,
		      FSL_S_Data};


assign  debug_trig = { 
                      out_wr,
                      in_rdy,
                      FSL_S_Read,
                      FSL_S_Exists};
endmodule
