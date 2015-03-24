
  module egress_demux 
    #(parameter DATA_WIDTH = 64,
      parameter CTRL_WIDTH=DATA_WIDTH/8,
      parameter UDP_REG_SRC_WIDTH = 2,
      parameter NUM_OUTPUT_QUEUES = 8)

   (// --- data path interface
    output reg     [DATA_WIDTH-1:0]    out_data_0,
    output reg     [CTRL_WIDTH-1:0]    out_ctrl_0,
    input                              out_rdy_0,
    output reg                         out_wr_0,

    output reg     [DATA_WIDTH-1:0]    out_data_1,
    output reg     [CTRL_WIDTH-1:0]    out_ctrl_1,
    input                              out_rdy_1,
    output reg                         out_wr_1,

    output reg     [DATA_WIDTH-1:0]    out_data_2,
    output reg     [CTRL_WIDTH-1:0]    out_ctrl_2,
    input                              out_rdy_2,
    output reg                         out_wr_2,

    output reg     [DATA_WIDTH-1:0]    out_data_3,
    output reg     [CTRL_WIDTH-1:0]    out_ctrl_3,
    input                              out_rdy_3,
    output reg                         out_wr_3,

    // --- Interface to the previous module
    input  [DATA_WIDTH-1:0]            in_data,
    input  [CTRL_WIDTH-1:0]            in_ctrl,
    output reg                         in_rdy,
    input                              in_wr,

    // --- Register interface
    input                              reg_req_in,
    input                              reg_ack_in,
    input                              reg_rd_wr_L_in,
    input  [`UDP_REG_ADDR_WIDTH-1:0]   reg_addr_in,
    input  [`CPCI_NF2_DATA_WIDTH-1:0]  reg_data_in,
    input  [UDP_REG_SRC_WIDTH-1:0]     reg_src_in,

    output                             reg_req_out,
    output                             reg_ack_out,
    output                             reg_rd_wr_L_out,
    output  [`UDP_REG_ADDR_WIDTH-1:0]  reg_addr_out,
    output  [`CPCI_NF2_DATA_WIDTH-1:0] reg_data_out,
    output  [UDP_REG_SRC_WIDTH-1:0]    reg_src_out,


    // --- Misc
    input                              clk,
    input                              reset);

   `LOG2_FUNC

   //------------- Internal Parameters ---------------
   parameter NUM_OQ_WIDTH       = log2(NUM_OUTPUT_QUEUES);
   parameter MAX_PKT            = 2048;   // allow for 2K bytes
   parameter PKT_BYTE_CNT_WIDTH = log2(MAX_PKT);
   parameter PKT_WORD_CNT_WIDTH = log2(MAX_PKT/CTRL_WIDTH);

   parameter WAIT_FOR_SOP       = 0;
   parameter WAIT_TILL_EOP      = 1;

   reg [NUM_OUTPUT_QUEUES-1:0]  op_port,op_port_nxt; 
   reg                          pkt_vld,pkt_vld_nxt;
   
   wire                         op_rdy_0, op_rdy_1, op_rdy_2, op_rdy_3, op_rdy;
   reg                          pkt_dropped;
   reg [NUM_OUTPUT_QUEUES-1:0]  pkt_in;
   reg                          input_state,input_state_nxt;
   
   assign op_rdy_0 = ((op_port[0] & out_rdy_0) | (!op_port[0]));
   assign op_rdy_1 = ((op_port[1] & out_rdy_1) | (!op_port[1])); 
   assign op_rdy_2 = ((op_port[2] & out_rdy_2) | (!op_port[2])); 
   assign op_rdy_3 = ((op_port[3] & out_rdy_0) | (!op_port[3]));
   assign op_rdy   = op_rdy_0 & op_rdy_1 & op_rdy_2 & op_rdy_3;
   
   //-- SM - Looks for IO Queue word which indicates SOP
   always @(*) begin
     op_port_nxt     = op_port;
     input_state_nxt = input_state;
     pkt_vld_nxt     = pkt_vld;
     in_rdy          = 1'b0;
     pkt_dropped     = 1'b0; 
     pkt_in          = {NUM_OUTPUT_QUEUES{1'b0}};
     case(input_state)
       WAIT_FOR_SOP : begin 
                        in_rdy = 1'b1;
			if( (in_ctrl == `IO_QUEUE_STAGE_NUM) & in_wr) begin
			   op_port_nxt     = in_data[`IOQ_DST_PORT_POS + NUM_OUTPUT_QUEUES - 1:`IOQ_DST_PORT_POS];
			   input_state_nxt = WAIT_TILL_EOP;
			   pkt_vld_nxt     = 1'b1;
			   pkt_in          = in_data[`IOQ_DST_PORT_POS + NUM_OUTPUT_QUEUES - 1:`IOQ_DST_PORT_POS];
			   pkt_dropped     = !(|in_data[`IOQ_DST_PORT_POS + NUM_OUTPUT_QUEUES - 1:`IOQ_DST_PORT_POS]);
		        end
                      end
       WAIT_TILL_EOP: begin 
                        in_rdy = op_rdy;
                        if((|in_ctrl) & in_wr) begin
			   pkt_vld_nxt     = 1'b0; 
			   input_state_nxt = WAIT_FOR_SOP;
			end
                      end
     endcase
   end
  
   always@(*) begin
     out_data_0 = {DATA_WIDTH{1'b0}};
     out_ctrl_0 = {CTRL_WIDTH{1'b0}};
     out_wr_0   = 1'b0;
     out_data_1 = {DATA_WIDTH{1'b0}};
     out_ctrl_1 = {CTRL_WIDTH{1'b0}};
     out_wr_1   = 1'b0;
     out_data_2 = {DATA_WIDTH{1'b0}};
     out_ctrl_2 = {CTRL_WIDTH{1'b0}};
     out_wr_2   = 1'b0;
     out_data_3 = {DATA_WIDTH{1'b0}};
     out_ctrl_3 = {CTRL_WIDTH{1'b0}};
     out_wr_3   = 1'b0;
     if(pkt_vld) begin
       if(op_port[0])begin
         out_data_0 = in_data;
	 out_ctrl_0 = in_ctrl;
	 out_wr_0   = in_wr;
       end
       if(op_port[1])begin
         out_data_1 = in_data;
	 out_ctrl_1 = in_ctrl;
	 out_wr_1   = in_wr;
       end
       if(op_port[2])begin
         out_data_2 = in_data;
	 out_ctrl_2 = in_ctrl;
	 out_wr_2   = in_wr;
       end
       if(op_port[3])begin
         out_data_3 = in_data;
	 out_ctrl_3 = in_ctrl;
	 out_wr_3   = in_wr;
       end
     end
   end



   always@(posedge clk) begin
     if(reset) begin 
       op_port     <= {NUM_OUTPUT_QUEUES{1'b0}}; 
       input_state <= WAIT_FOR_SOP; 
       pkt_vld     <= 1'b0;
     end
     else begin
       op_port     <= op_port_nxt; 
       input_state <= input_state_nxt; 
       pkt_vld     <= pkt_vld_nxt;
     end
   end



 generic_regs
     #(.UDP_REG_SRC_WIDTH (UDP_REG_SRC_WIDTH),
       .TAG (`OQ_BLOCK_ADDR),
       .REG_ADDR_WIDTH (`OQ_REG_ADDR_WIDTH), //TO_DO compare this with output queue file in the lib and check the sizes
       //.NUM_COUNTERS (3*NUM_OUTPUT_QUEUES),
       .NUM_COUNTERS (1+NUM_OUTPUT_QUEUES),
       .COUNTER_INPUT_WIDTH (1))
   generic_regs_b
     (
      .reg_req_in        (reg_req_in),
      .reg_ack_in        (reg_ack_in),
      .reg_rd_wr_L_in    (reg_rd_wr_L_in),
      .reg_addr_in       (reg_addr_in),
      .reg_data_in       (reg_data_in),
      .reg_src_in        (reg_src_in),

      .reg_req_out       (reg_req_out),
      .reg_ack_out       (reg_ack_out),
      .reg_rd_wr_L_out   (reg_rd_wr_L_out),
      .reg_addr_out      (reg_addr_out),
      .reg_data_out      (reg_data_out),
      .reg_src_out       (reg_src_out),

      // --- counters interface
      .counter_updates   ({pkt_dropped,pkt_in}
                          ),
      .counter_decrement ({(NUM_OUTPUT_QUEUES+1){1'b0}}),

      // --- SW regs interface
      .software_regs     (),

      // --- HW regs interface
      .hardware_regs     (),

      .clk               (clk),
      .reset             (reset));


endmodule    

