//////////////////////////////////////////////////////////////////////////////
// Module: add_header.v
// Project: OpenFlow Switch
// Description: Addtion of an extra word at the beginning of the packet. Header
// information is encoded as follows - 
// Bits    Purpose
// 15:0    Packet length in bytes   -- Not Used in this project; Since pkt is not stored
// 31:16   Source port (binary encoding)
// 47:32   Packet length in words   -- Not Used in this project
//
///////////////////////////////////////////////////////////////////////////////
//Fix - 3/12/15 : FIX1

  module add_header
    #(parameter DATA_WIDTH = 64,
      parameter CTRL_WIDTH = DATA_WIDTH/8,
      parameter PORT_NUMBER = 0 
    )
  (
    //--- Input datapath interface 
    input  [DATA_WIDTH-1:0]            in_data,
    input  [CTRL_WIDTH-1:0]            in_ctrl,
    input                              in_wr,
    output reg                         in_rdy,

    //--- Output datapath interface 
    output reg[DATA_WIDTH-1:0]         out_data,
    output reg [CTRL_WIDTH-1:0]        out_ctrl,
    output reg                         out_wr,
    input                              out_rdy,

    //-- Misc
    input                              clk,
    input                              reset
  );

   parameter                            WAIT_FOR_FIRST_WORD = 0; 
   parameter                            WRITE_SRC_PORT      = 1;
   parameter                            WAIT_TILL_EOP       = 2;
   parameter                            WRITE_EOP           = 3;

 //--Registers : Track and hold the first line

   reg                                                in_pkt;
   wire                                               first_word;

   reg  [DATA_WIDTH-1:0]                              out_data_nxt;
   reg  [CTRL_WIDTH-1:0]                              out_ctrl_nxt;
   reg                                                out_wr_nxt;

   wire [`IOQ_WORD_LEN_POS - `IOQ_SRC_PORT_POS-1:0] port_number = PORT_NUMBER;


   reg [3:0]                                          state;
   reg [3:0]                                          state_nxt;
   reg [DATA_WIDTH-1:0]                               in_data_d; 
   reg [CTRL_WIDTH-1:0]                               in_ctrl_d; 
   reg                                                in_wr_d;

 //-- WRITE_EOP State is the wait state to get the addtional word out.
 //   Do not read any input data in that state. Therefore, in_rdy is not asserted in the prev cycle
   //assign in_rdy    = out_rdy & ((state == WRITE_EOP) & out_rdy) & !((state == WAIT_TILL_EOP) & |(in_ctrl)) ;
   always @(*) begin
     in_rdy = 1'b0;
     if(out_rdy) begin
       case(state) 
         WAIT_TILL_EOP: begin
	   if(!(|(in_ctrl))& in_wr) //FIX1: added in_wr to this condition
	     in_rdy = 1'b1;
         end
	 WRITE_SRC_PORT: begin
	   in_rdy = 1'b0;
	 end
         default : begin
	   in_rdy = 1'b1;
         end
       endcase
     end
   end
 
 
 //-- Track first word

   //assign first_word = !in_pkt && !(|in_ctrl);
   assign first_word = !in_pkt && !(|in_ctrl) & in_wr;

   always @(posedge clk)
   begin
      if (reset) begin
         in_pkt <= 0;
      end
      else begin
         if (first_word && in_wr)
            in_pkt <= 1'b1;
         else if (in_pkt && |in_ctrl && in_wr)
            in_pkt <= 1'b0;
      end
   end
   

   // -- State Machine to insert port information
   // The first word is the port information. After that data is take from _d registers
   // When the EOP data is encountered, no input data is read to accomodate to send additional 
   // word (which was used to send port information). There is one cycle overhead per packet
   always @(*)
   begin
     if(reset) begin
       state_nxt     = state;
       out_data_nxt  = {DATA_WIDTH{1'b0}};
       out_ctrl_nxt  = {CTRL_WIDTH{1'b0}};
       out_wr_nxt    = 1'b0;
     end
     else begin
       out_data_nxt  = {DATA_WIDTH{1'b0}};
       out_ctrl_nxt  = {CTRL_WIDTH{1'b0}};
       out_wr_nxt    = 1'b0;
       state_nxt     = state; 
       case(state) 
         WAIT_FOR_FIRST_WORD : begin
	   if(first_word) begin
	     if(out_rdy) begin
	       out_data_nxt = {{(DATA_WIDTH - `IOQ_WORD_LEN_POS){1'b0}}, port_number,{(`IOQ_SRC_PORT_POS){1'b0}}}; 
	       //$display("@HW : PortNumber = %d | Data=%0H",port_number,out_data_nxt);
	       out_ctrl_nxt = `IO_QUEUE_STAGE_NUM;
	       out_wr_nxt   = 1'b1;
	       state_nxt    = WAIT_TILL_EOP;
	     end
	     else begin
	      state_nxt  = WRITE_SRC_PORT;
	     end
	   end  
	 end

	  WRITE_SRC_PORT: begin
	    if(out_rdy)  begin
	      out_data_nxt = {{DATA_WIDTH - `IOQ_WORD_LEN_POS{1'b0}}, port_number,{(`IOQ_SRC_PORT_POS - 1){1'b0}}}; 
	      out_ctrl_nxt = `IO_QUEUE_STAGE_NUM;
	      out_wr_nxt   = 1'b1;
	      state_nxt    = WAIT_TILL_EOP;
	    end
	  end

	  WAIT_TILL_EOP : begin
	    if(out_rdy & |(in_ctrl) & in_wr) begin
	      state_nxt = WRITE_EOP; 
	    end
	    out_data_nxt = in_data_d; 
	    out_ctrl_nxt = in_ctrl_d; 
	    //out_wr_nxt   = 1'b1;
	    out_wr_nxt   = out_rdy;
	  end

	  WRITE_EOP : begin
	    if(out_rdy & in_wr_d) begin
	      out_data_nxt = in_data_d; 
	      out_ctrl_nxt = in_ctrl_d; 
	      out_wr_nxt   = 1'b1;
	      state_nxt    = WAIT_FOR_FIRST_WORD;
	    end
	  end
	 endcase
       end
     end

     always @(posedge clk) begin
       if(reset) begin
         in_data_d <= {DATA_WIDTH{1'b0}};
	 in_ctrl_d <= {CTRL_WIDTH{1'b0}};
	 in_wr_d   <= 1'b0;

         out_data  <= {DATA_WIDTH{1'b0}};
	 out_ctrl  <= {CTRL_WIDTH{1'b0}};
	 out_wr    <= 1'b0;

	 state     <= WAIT_FOR_FIRST_WORD;
       end
       else begin
         if(out_rdy & state != WRITE_EOP) begin
	   in_data_d <= in_data; 
	   in_ctrl_d <= in_ctrl; 
	   in_wr_d   <= in_wr;
	 end
         
	 state     <= state_nxt;
	 out_data  <= out_data_nxt; 
	 out_ctrl  <= out_ctrl_nxt;
	 out_wr    <= out_wr_nxt;
       end
     end



endmodule



