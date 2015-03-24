//Top level register module.. A bus connects all the openflow switches on the FPGA. 
//If the register access is intended for this module, then it is either written to or read from the register in/out FIFOs

module openflow_switch_reg
 #(
    parameter TIMEOUT = 127,
    parameter TIMEOUT_RESULT = 'h dead_0000,
    parameter SWITCH_ID = 0
 ) 
 (
  //CPU Signals Input 
  input  [`SWITCH_REG_WRITE_BUS_WIDTH-1:0]      cpu_in_reg_wr_data_bus,
  input  [`SWITCH_REG_CTRL_WIDTH-1:0]           cpu_in_reg_ctrl,
  input                                         cpu_in_reg_vld,             //Indicates that input is valid                           
  input  [`SWITCH_REG_READ_BUS_WIDTH-1:0]       cpu_in_reg_rd_data_bus,
  input                                         cpu_in_reg_ack,             //Indicates that output is valid 
  
  //CPU Signals Output
  output  reg [`SWITCH_REG_WRITE_BUS_WIDTH-1:0] cpu_out_reg_wr_data_bus,
  output  reg [`SWITCH_REG_CTRL_WIDTH-1:0]      cpu_out_reg_ctrl,
  output  reg                                   cpu_out_reg_vld,                           
  output  reg [`SWITCH_REG_READ_BUS_WIDTH-1:0]  cpu_out_reg_rd_data_bus,
  output  reg                                   cpu_out_reg_ack,
  
  //Switch Side
  output  reg [`SWITCH_REG_WRITE_BUS_WIDTH-1:0] switch_reg_wr_data_bus,
  output  reg [`SWITCH_REG_CTRL_WIDTH-1:0]      switch_reg_ctrl,
  output  reg                                   switch_reg_vld,                           
  input   [`SWITCH_REG_READ_BUS_WIDTH-1:0]      switch_reg_rd_data_bus,
  input                                         switch_reg_ack,
 
  input                                         clk,
  input                                         reset

 );

parameter WAIT       = 2'd0;
parameter PROCESSING = 2'd1;
parameter DONE       = 2'd2;

reg   [1:0] state; 
reg   [7:0] count;
wire        switch_hit;

assign switch_hit = (cpu_in_reg_ctrl[`SWITCH_REG_CTRL_ID_POS] == SWITCH_ID);

always @(posedge clk) begin
  if(reset) begin
    state                  <= WAIT;
    count                  <= 'h0;
    switch_reg_wr_data_bus <= 'h0;
    switch_reg_vld         <= 'h0;
    switch_reg_ctrl        <= 'h0;
  end
  else begin
    case(state) 
      WAIT :begin
              if(cpu_in_reg_vld & switch_hit) begin
	        if(cpu_in_reg_ctrl[`SWITCH_REG_CTRL_RD_WR_L_POS]) begin //Go to processing if read
	          state <= PROCESSING;
		  count <= TIMEOUT;
		end
		switch_reg_wr_data_bus <= cpu_in_reg_wr_data_bus;
		switch_reg_vld         <= 1'b1;
		switch_reg_ctrl        <= cpu_in_reg_ctrl;
	      end
	      else begin
		switch_reg_vld         <= 1'b0;
	      end
            end
      PROCESSING :begin
		    if(switch_reg_ack || count == 'd0) begin
		      state <= DONE;
		    end
		    switch_reg_vld <= 1'b0;
		    count          <= count - 'h1;
                  end
      DONE: begin
	      state <= WAIT;
            end
    endcase
  end
end

always @(posedge clk) begin
  if(reset) begin
    cpu_out_reg_vld         <= 1'b0;
    cpu_out_reg_ack         <= 1'b0;
    cpu_out_reg_rd_data_bus <= 'h0;
    cpu_out_reg_wr_data_bus <= 'h0;
    cpu_out_reg_ctrl        <= 'h0;
  end
  else begin
    if(state == WAIT & (cpu_in_reg_vld | cpu_in_reg_ack) & !switch_hit)begin
      cpu_out_reg_wr_data_bus <= cpu_in_reg_wr_data_bus;
      cpu_out_reg_ctrl        <= cpu_in_reg_ctrl;
      cpu_out_reg_vld         <= cpu_in_reg_vld;
      cpu_out_reg_rd_data_bus <= cpu_in_reg_rd_data_bus;
      cpu_out_reg_ack         <= cpu_in_reg_ack; 
    end
    else if(state == PROCESSING & (switch_reg_ack || count == 'h0)) begin
      cpu_out_reg_wr_data_bus <= switch_reg_wr_data_bus;
      cpu_out_reg_ctrl        <= switch_reg_ctrl;
      cpu_out_reg_vld         <= 1'b0;
      cpu_out_reg_ack         <= 1'b1;
      if(switch_reg_ack)
        cpu_out_reg_rd_data_bus <= switch_reg_rd_data_bus;
      else
        cpu_out_reg_rd_data_bus <= TIMEOUT_RESULT;
    end
    else begin
      cpu_out_reg_vld         <= 1'b0;
      cpu_out_reg_ack         <= 1'b0;
      cpu_out_reg_rd_data_bus <= 'h0;
      cpu_out_reg_wr_data_bus <= 'h0;
      cpu_out_reg_ctrl        <= 'h0;
    end
  end
 
end

endmodule




