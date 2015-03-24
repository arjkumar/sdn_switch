module top(); 
parameter DATA_WIDTH = 64; 
parameter CTRL_WIDTH = 8; 
parameter NUM_QUEUES = 4; 
parameter UDP_REG_SRC_WIDTH = 2;
parameter IN_ARB_STAGE_NUM = 2; 

reg clk; 
reg reset; 
reg        FSL_S_Exists; 
reg        FSL_S_Control; 
reg [0:31] FSL_S_Data;
wire       FSL_S_Read;

wire [DATA_WIDTH-1:0]             out_data [NUM_QUEUES-1:0];
wire [CTRL_WIDTH-1:0]             out_ctrl [NUM_QUEUES-1:0];
wire [NUM_QUEUES-1:0]             out_wr;
wire [NUM_QUEUES-1:0]             out_rdy;

wire [DATA_WIDTH-1:0]            in_data[3:0]; 
wire [CTRL_WIDTH-1:0]            in_ctrl[3:0];
wire [3:0]                       in_wr;
wire [3:0]                       in_rdy;


initial begin
  clk = 1'b0; 
  forever clk = #10 ~clk; 
end

initial begin 
  reset = 1'b1; 
  #100; 
  reset = 1'b0;
  #100000; 
  $finish;
end

always @(posedge clk) begin 
  if(reset) begin 
    FSL_S_Exists <= 1'b0;
  end
  else begin 
    FSL_S_Data   <= 'hDEAD_BEEF;
    FSL_S_Exists <= 1'b1;
    FSL_S_Control <= 1'b0;
  end
end

always @(posedge clk) begin
end

fsl_switch_intf 
  fsl_switch_intf_i(
	// ADD USER PORTS BELOW THIS LINE 
	// -- USER ports added here
	//Chipscope 
	.debug_data(), 
	.debug_trig(),
	
	.in_rdy(in_rdy[0]),
	.out_wr(in_wr[0]),
	.out_data(in_data[0]),
	.out_ctrl(in_ctrl[0]),
	// ADD USER PORTS ABOVE THIS LINE 

	// DO NOT EDIT BELOW THIS LINE ////////////////////
	// Bus protocol ports, do not add or delete. 
	.FSL_Clk(clk),
	.FSL_Rst(reset),
	.FSL_S_Clk(),
	.FSL_S_Read(FSL_S_Read),
	.FSL_S_Data(FSL_S_Data),
	.FSL_S_Control(FSL_S_Control),
	.FSL_S_Exists(FSL_S_Exists)
	// DO NOT EDIT ABOVE THIS LINE ////////////////////
	);

 sdn_switch 
     #(.DATA_WIDTH(DATA_WIDTH),
       .CTRL_WIDTH(CTRL_WIDTH),
       .UDP_REG_SRC_WIDTH (UDP_REG_SRC_WIDTH),
       .NUM_OUTPUT_QUEUES(NUM_QUEUES),
       .NUM_INPUT_QUEUES(NUM_QUEUES),
       .SWITCH_ID(0)) user_data_path_1
       (.in_data_0 (in_data[0]),
        .in_ctrl_0 (in_ctrl[0]),
        .in_wr_0 (in_wr[0]),
        .in_rdy_0 (in_rdy[0]),

        .in_data_1 (),
        .in_ctrl_1 (),
        .in_wr_1 (),
        .in_rdy_1 (),

        .in_data_2 (),
        .in_ctrl_2 (),
        .in_wr_2 (),
        .in_rdy_2 (),

        .in_data_3 (),
        .in_ctrl_3 (),
        .in_wr_3 (),
        .in_rdy_3 (),

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

        .cpu_in_reg_wr_data_bus(),
        .cpu_in_reg_ctrl(),
        .cpu_in_reg_vld(),        
        .cpu_in_reg_rd_data_bus(),
        .cpu_in_reg_ack(),        
                               
        .cpu_out_reg_wr_data_bus(),
        .cpu_out_reg_ctrl(),
        .cpu_out_reg_vld(),       
        .cpu_out_reg_rd_data_bus(),
        .cpu_out_reg_ack(),

	.sram_reset_done(),
	.debug_output(), 
	.debug_trig(),

        // misc
        .reset (reset),
        .clk (clk));
endmodule

