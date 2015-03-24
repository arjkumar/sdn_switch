module reg_grp(
  
  //Signals from CPU Openflow reg master
  input        [`SWITCH_REG_WRITE_BUS_WIDTH-1:0] switch_reg_wr_data_bus,
  input        [`SWITCH_REG_CTRL_WIDTH-1:0]      switch_reg_ctrl,
  input                                          switch_reg_vld,                           
  output reg [`SWITCH_REG_READ_BUS_WIDTH-1:0]    switch_reg_rd_data_bus,
  output reg                                     switch_reg_ack,
 
 //-- Register interface
  output                                         reg_fifo_empty,
  input                                          reg_fifo_rd_en,
  output                                         reg_rd_wr_L,
  output [`CPCI_NF2_ADDR_WIDTH-1:0]              reg_addr,
  input [`CPCI_NF2_DATA_WIDTH-1:0]               reg_rd_data,
  output [`CPCI_NF2_DATA_WIDTH-1:0]              reg_wr_data,
  input                                          reg_rd_vld,

  input                                          clk,
  input                                          reset
 );
  
  parameter  IDLE            = 2'd0;
  parameter  SEND_DATA       = 2'd1;
  parameter  SEND_ERROR_DATA = 2'd2;
  //-- Register Read FIFO
  wire  [`CPCI_NF2_DATA_WIDTH-1:0]          reg_rd_fifo_rd_data;
  wire                                      reg_rd_fifo_rd_en;
  wire                                      reg_rd_fifo_empty;
  wire                                      reg_rd_fifo_full;
  wire                                      reg_rd_fifo_nearly_full;                  

  //--  Register Write FIFO
  reg                                       reg_wr_fifo_rd_wr_L;
  reg  [`CPCI_NF2_ADDR_WIDTH-1:0]           reg_wr_fifo_addr;
  reg  [`CPCI_NF2_DATA_WIDTH-1:0]           reg_wr_fifo_data;
  reg                                       reg_wr_fifo_wr_en;
  wire                                      reg_wr_fifo_full;
  wire                                      reg_wr_fifo_nearly_full;


  reg   [1:0]      state;

//Handling Write FIFO 
always @(*) begin
  reg_wr_fifo_rd_wr_L = switch_reg_wr_data_bus[`SWITCH_REG_WRITE_DATA_RD_WR_L_POS];
  reg_wr_fifo_addr    = switch_reg_wr_data_bus[`SWITCH_REG_WRITE_DATA_ADDR_POS];
  reg_wr_fifo_data    = switch_reg_wr_data_bus[`SWITCH_REG_WRITE_DATA_POS];
  reg_wr_fifo_wr_en   = switch_reg_vld & 
                        !switch_reg_ctrl[`SWITCH_REG_CTRL_STATUS_POS] & 
			!switch_reg_ctrl[`SWITCH_REG_CTRL_RD_WR_L_POS]; //Check if reg access is not a status update
end



assign reg_rd_fifo_rd_en = (state == IDLE) && 
                           switch_reg_vld && 
			   switch_reg_ctrl[`SWITCH_REG_CTRL_RD_WR_L_POS] && 
			   !reg_rd_fifo_empty;

always @(posedge clk)begin
  if(reset) begin
    switch_reg_rd_data_bus <= 'h0;
    switch_reg_ack         <= 'h0; 
    state                  <= IDLE;
  end
  else begin
    case(state)
      IDLE : begin
               if(switch_reg_vld & switch_reg_ctrl[`SWITCH_REG_CTRL_RD_WR_L_POS])begin
                 if(switch_reg_ctrl[`SWITCH_REG_CTRL_STATUS_POS]) begin
                          switch_reg_rd_data_bus <= {{`CPCI_NF2_DATA_WIDTH-6{1'b0}},
	          	                            reg_rd_fifo_nearly_full,
	          				    reg_rd_fifo_full,
	          				    reg_rd_fifo_empty,
	          				    reg_wr_fifo_nearly_full,
	          				    reg_wr_fifo_full,
	          				    reg_fifo_empty};
	                  switch_reg_ack         <= 1'b1; 
	         end
		 else if(!reg_rd_fifo_empty) begin
		     state             <= SEND_DATA;
		 end
		 else begin
		   state <= SEND_ERROR_DATA;
		 end
               end
	       else begin
		 switch_reg_ack    <= 1'b0;
	       end
             end
	SEND_DATA: begin 
	             switch_reg_rd_data_bus <= reg_rd_fifo_rd_data; 
		     switch_reg_ack         <= 1'b1;
		     state                  <= IDLE;
	           end
 	default : begin
	            switch_reg_rd_data_bus <= 'hDEAD_DEAD;
		    switch_reg_ack         <= 1'b1;
		    state                  <= IDLE;
	          end
    endcase	     
  end
end  

//--Reg Write FIFO
   small_fifo
     #(.WIDTH(1 + `CPCI_NF2_ADDR_WIDTH + `CPCI_NF2_DATA_WIDTH), .MAX_DEPTH_BITS(10))
    reg_write_fifo 
       (.din           ({reg_wr_fifo_rd_wr_L,reg_wr_fifo_addr,reg_wr_fifo_data}),  // Data in
        .wr_en         (reg_wr_fifo_wr_en),                                        // Write enable
        .rd_en         (reg_fifo_rd_en),       //From Input                                       // Read the next word
        .dout          ({reg_rd_wr_L,reg_addr,reg_wr_data}),
        .full          (reg_wr_fifo_full),
        .prog_full     (),
        .nearly_full   (reg_wr_fifo_nearly_full),
        .empty         (reg_fifo_empty),                  //to output
        .reset         (reset),
        .clk           (clk)
        );
  
  
  //--Reg Read FIFO
    small_fifo
       #(.WIDTH(`CPCI_NF2_DATA_WIDTH), .MAX_DEPTH_BITS(10))
      reg_read_fifo 
         (.din           (reg_rd_data),                // Data in
          .wr_en         (reg_rd_vld),                 // Write enable
          .rd_en         (reg_rd_fifo_rd_en),           // Read the next word
          .dout          (reg_rd_fifo_rd_data),
          .full          (reg_rd_fifo_full),
          .prog_full     (),
          .nearly_full   (reg_rd_fifo_nearly_full),
          .empty         (reg_rd_fifo_empty),
          .reset         (reset),
          .clk           (clk)
          );
  


endmodule





