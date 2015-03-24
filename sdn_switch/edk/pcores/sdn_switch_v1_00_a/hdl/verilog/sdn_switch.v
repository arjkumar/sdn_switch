module sdn_switch 
  #(parameter DATA_WIDTH = 64,
    parameter CTRL_WIDTH=DATA_WIDTH/8,
    parameter UDP_REG_SRC_WIDTH = 2,
    parameter NUM_OUTPUT_QUEUES = 4,
    parameter NUM_INPUT_QUEUES = 4,
    parameter SRAM_DATA_WIDTH = DATA_WIDTH+CTRL_WIDTH,
    parameter SRAM_ADDR_WIDTH = 9,
    parameter SWITCH_ID       = 0)
   (
   //================Output Interface====================================  //TO_DO : Presently Temporary
    //output     [DATA_WIDTH-1:0]        out_data ,
    //output     [CTRL_WIDTH-1:0]        out_ctrl,
    //output                             out_wr,
    //input                              out_rdy,

    output  [DATA_WIDTH-1:0]           out_data_0,
    output  [CTRL_WIDTH-1:0]           out_ctrl_0,
    output                             out_wr_0,
    input                              out_rdy_0,

    output  [DATA_WIDTH-1:0]           out_data_1,
    output  [CTRL_WIDTH-1:0]           out_ctrl_1,
    output                             out_wr_1,
    input                              out_rdy_1,

    output  [DATA_WIDTH-1:0]           out_data_2,
    output  [CTRL_WIDTH-1:0]           out_ctrl_2,
    output                             out_wr_2,
    input                              out_rdy_2,

    output  [DATA_WIDTH-1:0]           out_data_3,
    output  [CTRL_WIDTH-1:0]           out_ctrl_3,
    output                             out_wr_3,
    input                              out_rdy_3,

 
   //================Input Interface====================================
     input  [DATA_WIDTH-1:0]            in_data_0,
     input  [CTRL_WIDTH-1:0]            in_ctrl_0,
     input                              in_wr_0,
     output                             in_rdy_0,

     input  [DATA_WIDTH-1:0]            in_data_1,
     input  [CTRL_WIDTH-1:0]            in_ctrl_1,
     input                              in_wr_1,
     output                             in_rdy_1,

     input  [DATA_WIDTH-1:0]            in_data_2,
     input  [CTRL_WIDTH-1:0]            in_ctrl_2,
     input                              in_wr_2,
     output                             in_rdy_2,

     input  [DATA_WIDTH-1:0]            in_data_3,
     input  [CTRL_WIDTH-1:0]            in_ctrl_3,
     input                              in_wr_3,
     output                             in_rdy_3,

     //CPU Signals Input 
     input  [`SWITCH_REG_WRITE_BUS_WIDTH-1:0]  cpu_in_reg_wr_data_bus,
     input  [`SWITCH_REG_CTRL_WIDTH-1:0]       cpu_in_reg_ctrl,
     input                                     cpu_in_reg_vld,             //Indicates that input is valid                           
     input  [`SWITCH_REG_READ_BUS_WIDTH-1:0]   cpu_in_reg_rd_data_bus,
     input                                     cpu_in_reg_ack,             //Indicates that output is valid 
     
     //CPU Signals Output
     output  [`SWITCH_REG_WRITE_BUS_WIDTH-1:0] cpu_out_reg_wr_data_bus,
     output  [`SWITCH_REG_CTRL_WIDTH-1:0]      cpu_out_reg_ctrl,
     output                                    cpu_out_reg_vld,                           
     output  [`SWITCH_REG_READ_BUS_WIDTH-1:0]  cpu_out_reg_rd_data_bus,
     output                                    cpu_out_reg_ack,
    
    //Chipscope
     output [148 -1:0]                         debug_output,
     output [4-1:0]                            debug_trig,  
     output [148 -1:0]                         debug_output_op,
     output [4-1:0]                            debug_trig_op, 
     output [202-1:0]                          debug_cpu_out,
     output [4-1:0]                            debug_cpu_trig0,
     output [4-1:0]                            debug_cpu_trig1,

    //SRAM Reset Done 
     input                              sram_reset_done_in,
     output  reg                        sram_reset_done_out,
    // misc
     input                              reset,
     input                              clk);

  //--Parameters 
   localparam NUM_IQ_BITS = 2 ; // log2(NUM_INPUT_QUEUES);
   
   localparam                       IN_ARB_STAGE_NUM = 2;
   localparam                       OP_LUT_STAGE_NUM = 4;

  //-------- Input arbiter wires/regs -------
   wire                             in_arb_in_reg_req;
   wire                             in_arb_in_reg_ack;
   wire                             in_arb_in_reg_rd_wr_L;
   wire [`UDP_REG_ADDR_WIDTH-1:0]   in_arb_in_reg_addr;
   wire [`CPCI_NF2_DATA_WIDTH-1:0]  in_arb_in_reg_data;
   wire [UDP_REG_SRC_WIDTH-1:0]     in_arb_in_reg_src;




  //------- VLAN remover wires/regs ------
   wire [CTRL_WIDTH-1:0]            vlan_rm_in_ctrl;
   wire [DATA_WIDTH-1:0]            vlan_rm_in_data;
   wire                             vlan_rm_in_wr;
   wire                             vlan_rm_in_rdy;


   //------- output port lut wires/regs ------
   wire [CTRL_WIDTH-1:0]            op_lut_in_ctrl;
   wire [DATA_WIDTH-1:0]            op_lut_in_data;
   wire                             op_lut_in_wr;
   wire                             op_lut_in_rdy;

   wire                             op_lut_in_reg_req;
   wire                             op_lut_in_reg_ack;
   wire                             op_lut_in_reg_rd_wr_L;
   wire [`UDP_REG_ADDR_WIDTH-1:0]   op_lut_in_reg_addr;
   wire [`CPCI_NF2_DATA_WIDTH-1:0]  op_lut_in_reg_data;
   wire [UDP_REG_SRC_WIDTH-1:0]     op_lut_in_reg_src;


  //------- VLAN adder wires/regs ------
   wire [CTRL_WIDTH-1:0]            vlan_add_in_ctrl;
   wire [DATA_WIDTH-1:0]            vlan_add_in_data;
   wire                             vlan_add_in_wr;
   wire                             vlan_add_in_rdy;

   //------- watchdog timer wires/regs ------
   wire                             wdt_in_reg_req;
   wire                             wdt_in_reg_ack;
   wire                             wdt_in_reg_rd_wr_L;
   wire [`UDP_REG_ADDR_WIDTH-1:0]   wdt_in_reg_addr;
   wire [`CPCI_NF2_DATA_WIDTH-1:0]  wdt_in_reg_data;
   wire [UDP_REG_SRC_WIDTH-1:0]     wdt_in_reg_src;

   wire                             table_flush_internal;

   //-------- UDP register master wires/regs -------
   wire                             udp_reg_req_in;
   wire                             udp_reg_ack_in;
   wire                             udp_reg_rd_wr_L_in;
   wire [`UDP_REG_ADDR_WIDTH-1:0]   udp_reg_addr_in;
   wire [`CPCI_NF2_DATA_WIDTH-1:0]  udp_reg_data_in;
   wire [UDP_REG_SRC_WIDTH-1:0]     udp_reg_src_in;


   //-------- NF2_REG_GRP wires/regs -------
   wire                                sram_reg_req;
   wire                                sram_reg_rd_wr_L;
   wire                                sram_reg_ack;
   wire [`SRAM_REG_ADDR_WIDTH-1:0]     sram_reg_addr;
   wire [`CPCI_NF2_DATA_WIDTH-1:0]     sram_reg_wr_data;
   wire [`CPCI_NF2_DATA_WIDTH-1:0]     sram_reg_rd_data;

   wire                                udp_reg_req;
   wire                                udp_reg_rd_wr_L;
   wire                                udp_reg_ack;
   wire [`UDP_REG_ADDR_WIDTH-1:0]      udp_reg_addr;
   wire [`CPCI_NF2_DATA_WIDTH-1:0]     udp_reg_wr_data;
   wire [`CPCI_NF2_DATA_WIDTH-1:0]     udp_reg_rd_data;


  // interface to SRAM
   wire   [SRAM_ADDR_WIDTH-1:0]       wr_0_addr;
   wire                               wr_0_req;
   wire                               wr_0_ack;
   wire   [SRAM_DATA_WIDTH-1:0]       wr_0_data;

   wire                               rd_0_ack;
   wire   [SRAM_DATA_WIDTH-1:0]       rd_0_data;
   wire                               rd_0_vld;
   wire   [SRAM_ADDR_WIDTH-1:0]       rd_0_addr;
   wire                               rd_0_req;

   wire                               table_flush;

  //------- output queues wires/regs ------
   wire [CTRL_WIDTH-1:0]            egress_demux_in_ctrl;
   wire [DATA_WIDTH-1:0]            egress_demux_in_data;
   wire                             egress_demux_in_wr;
   wire                             egress_demux_in_rdy;

   wire                             egress_demux_in_reg_req;
   wire                             egress_demux_in_reg_ack;
   wire                             egress_demux_in_reg_rd_wr_L;
   wire [`UDP_REG_ADDR_WIDTH-1:0]   egress_demux_in_reg_addr;
   wire [`CPCI_NF2_DATA_WIDTH-1:0]  egress_demux_in_reg_data;
   wire [UDP_REG_SRC_WIDTH-1:0]     egress_demux_in_reg_src;

//Chipscope 
//assign debug_output = {in_rdy_3,in_rdy_2,in_rdy_1,in_rdy_0,in_wr_0,in_ctrl_0,in_data_0}; 

assign debug_trig = {in_rdy_2,in_rdy_0,
                            in_wr_2,in_wr_0};

assign debug_output =     {in_rdy_2,in_rdy_0,
                            in_wr_2,in_wr_0,
                            in_ctrl_2,in_ctrl_0,
                            in_data_2,in_data_0};

assign debug_output_op   = {out_rdy_2,out_rdy_0,
                            out_wr_2,out_wr_0,
                            out_ctrl_2,out_ctrl_0,
                            out_data_2,out_data_0};
assign debug_trig_op =  {out_rdy_2,out_rdy_0,
                            out_wr_2,out_wr_0};

assign debug_cpu_out  = {cpu_out_reg_ack,cpu_out_reg_rd_data_bus,cpu_out_reg_vld,cpu_out_reg_ctrl,cpu_out_reg_wr_data_bus, 
                         cpu_in_reg_ack,cpu_in_reg_rd_data_bus,cpu_in_reg_vld,cpu_in_reg_ctrl,cpu_in_reg_wr_data_bus};

assign debug_cpu_trig0 = {cpu_out_reg_ack,cpu_out_reg_vld,cpu_in_reg_ack,cpu_in_reg_vld};
assign debug_cpu_trig1 = {cpu_out_reg_ack,cpu_out_reg_vld,cpu_in_reg_ack,cpu_in_reg_vld};

  input_arbiter #(
		// Parameters
		.DATA_WIDTH	(DATA_WIDTH),
		.CTRL_WIDTH	(CTRL_WIDTH),
		.UDP_REG_SRC_WIDTH(UDP_REG_SRC_WIDTH),
		.STAGE_NUMBER	(IN_ARB_STAGE_NUM))
		input_arbiter
			     (
			     // Outputs
			     .out_data		(vlan_rm_in_data),
			     .out_ctrl		(vlan_rm_in_ctrl),
			     .out_wr		(vlan_rm_in_wr),
			     .in_rdy_0		(in_rdy_0),
			     .in_rdy_1		(in_rdy_1),
			     .in_rdy_2		(in_rdy_2),
			     .in_rdy_3		(in_rdy_3),
                             .reg_req_out       (wdt_in_reg_req),
                             .reg_ack_out       (wdt_in_reg_ack),
                             .reg_rd_wr_L_out   (wdt_in_reg_rd_wr_L),
                             .reg_addr_out      (wdt_in_reg_addr),
                             .reg_data_out      (wdt_in_reg_data),
                             .reg_src_out       (wdt_in_reg_src),
			     // Inputs
			     .out_rdy		(vlan_rm_in_rdy),
			     .in_data_0		(in_data_0),
			     .in_ctrl_0		(in_ctrl_0),
			     .in_wr_0		(in_wr_0),
			     .in_data_1		(in_data_1),
			     .in_ctrl_1		(in_ctrl_1),
			     .in_wr_1		(in_wr_1),
			     .in_data_2		(in_data_2),
			     .in_ctrl_2		(in_ctrl_2),
			     .in_wr_2		(in_wr_2),
			     .in_data_3		(in_data_3),
			     .in_ctrl_3		(in_ctrl_3),
			     .in_wr_3		(in_wr_3),
                             .reg_req_in        (in_arb_in_reg_req),
                             .reg_ack_in        (in_arb_in_reg_ack),
                             .reg_rd_wr_L_in    (in_arb_in_reg_rd_wr_L),
                             .reg_addr_in       (in_arb_in_reg_addr),
                             .reg_data_in       (in_arb_in_reg_data),
                             .reg_src_in        (in_arb_in_reg_src),
			     .reset		(reset),
			     .clk		(clk)); 

   watchdog
     #(.UDP_REG_SRC_WIDTH  (UDP_REG_SRC_WIDTH)
       ) watchdog

   (// --- Register interface
    .reg_req_in       (wdt_in_reg_req),
    .reg_ack_in       (wdt_in_reg_ack),
    .reg_rd_wr_L_in   (wdt_in_reg_rd_wr_L),
    .reg_addr_in      (wdt_in_reg_addr),
    .reg_data_in      (wdt_in_reg_data),
    .reg_src_in       (wdt_in_reg_src),

    .reg_req_out      (op_lut_in_reg_req),
    .reg_ack_out      (op_lut_in_reg_ack),
    .reg_rd_wr_L_out  (op_lut_in_reg_rd_wr_L),
    .reg_addr_out     (op_lut_in_reg_addr),
    .reg_data_out     (op_lut_in_reg_data),
    .reg_src_out      (op_lut_in_reg_src),

    // --- interface to SRAM/output_port_lookup
    .table_flush      (table_flush_internal),

    // --- Misc

    .clk            (clk),
    .reset          (reset));


  vlan_remover
     #(.DATA_WIDTH(DATA_WIDTH),
       .CTRL_WIDTH(CTRL_WIDTH))
       vlan_remover
         (// --- Interface to previous module
          .in_data            (vlan_rm_in_data),
          .in_ctrl            (vlan_rm_in_ctrl),
          .in_wr              (vlan_rm_in_wr),
          .in_rdy             (vlan_rm_in_rdy),

          // --- Interface to next module
          .out_data           (op_lut_in_data),
          .out_ctrl           (op_lut_in_ctrl),
          .out_wr             (op_lut_in_wr),
          .out_rdy            (op_lut_in_rdy),

          // --- Misc
          .reset              (reset),
          .clk                (clk)
          );

  //synthesis translate_off
  always @(*) begin
    if(op_lut_in_wr & !reset)
     $display("VLAN_REMOVE Output-> Data:%0H\tCtrl:%0H\tWR=%0d\tRDY=%0H",op_lut_in_data,op_lut_in_ctrl,op_lut_in_wr,op_lut_in_rdy);
  
    if(vlan_add_in_wr & !reset)
     $display("OP_LUT Output-> Data:%0H\tCtrl:%0H\tWR=%0d\tRDY=%0H",vlan_add_in_data,vlan_add_in_ctrl,vlan_add_in_wr,vlan_add_in_rdy);
  
    if(egress_demux_in_wr & !reset)
     $display("VLAN_ADD Output-> Data:%0H\tCtrl:%0H\tWR=%0d\tRDY=%0H",egress_demux_in_data,egress_demux_in_ctrl,egress_demux_in_wr,egress_demux_in_rdy);
  end
  //synthesis translate_on
  
  output_port_lookup
     #(.DATA_WIDTH(DATA_WIDTH),
       .CTRL_WIDTH(CTRL_WIDTH),
       .UDP_REG_SRC_WIDTH (UDP_REG_SRC_WIDTH),
       .NUM_OUTPUT_QUEUES(NUM_OUTPUT_QUEUES),
       .NUM_IQ_BITS(NUM_IQ_BITS),
       .SRAM_ADDR_WIDTH(SRAM_ADDR_WIDTH))
   output_port_lookup
    (// --- Interface to next module
     .out_data          (vlan_add_in_data),
     .out_ctrl          (vlan_add_in_ctrl),
     .out_wr            (vlan_add_in_wr),
     .out_rdy           (vlan_add_in_rdy),

     // --- Interface to previous module
     .in_data           (op_lut_in_data),
     .in_ctrl           (op_lut_in_ctrl),
     .in_wr             (op_lut_in_wr),
     .in_rdy            (op_lut_in_rdy),

     // --- Register interface
     .reg_req_in        (op_lut_in_reg_req),
     .reg_ack_in        (op_lut_in_reg_ack),
     .reg_rd_wr_L_in    (op_lut_in_reg_rd_wr_L),
     .reg_addr_in       (op_lut_in_reg_addr),
     .reg_data_in       (op_lut_in_reg_data),
     .reg_src_in        (op_lut_in_reg_src),

     .reg_req_out       (egress_demux_in_reg_req),
     .reg_ack_out       (egress_demux_in_reg_ack),
     .reg_rd_wr_L_out   (egress_demux_in_reg_rd_wr_L),
     .reg_addr_out      (egress_demux_in_reg_addr),
     .reg_data_out      (egress_demux_in_reg_data),
     .reg_src_out       (egress_demux_in_reg_src),

     //// --- watchdog interface
     //.table_flush       (table_flush_internal),

     // --- SRAM interface
     .rd_0_ack          (rd_0_ack),
     .rd_0_data         (rd_0_data),
     .rd_0_vld          (rd_0_vld),
     .rd_0_addr         (rd_0_addr),
     .rd_0_req          (rd_0_req),
     .wr_0_addr         (wr_0_addr),
     .wr_0_req          (wr_0_req),
     .wr_0_ack          (wr_0_ack),
     .wr_0_data         (wr_0_data),

     //.rd_0_ack          (),
     //.rd_0_data         (),
     //.rd_0_vld          (),
     //.rd_0_addr         (),
     //.rd_0_req          (),
     //.wr_0_addr         (),
     //.wr_0_req          (),
     //.wr_0_ack          (),
     //.wr_0_data         (),


     // --- Misc
     .clk               (clk),
     .reset             (reset));


   vlan_adder
     #(.DATA_WIDTH(DATA_WIDTH),
       .CTRL_WIDTH(CTRL_WIDTH))
       vlan_adder
         (// --- Interface to previous module
          .in_data            (vlan_add_in_data),
          .in_ctrl            (vlan_add_in_ctrl),
          .in_wr              (vlan_add_in_wr),
          .in_rdy             (vlan_add_in_rdy),

          // --- Interface to next module
           .out_data           (egress_demux_in_data),
           .out_ctrl           (egress_demux_in_ctrl),
           .out_wr             (egress_demux_in_wr),
           .out_rdy            (egress_demux_in_rdy),
          //.out_data           (out_data),
          //.out_ctrl           (out_ctrl),
          //.out_wr             (out_wr),
          //.out_rdy            (out_rdy),

          // --- Misc
          .reset              (reset),
          .clk                (clk)
          );



 egress_demux 
     #(.DATA_WIDTH(DATA_WIDTH),
       .CTRL_WIDTH(CTRL_WIDTH),
       .UDP_REG_SRC_WIDTH (UDP_REG_SRC_WIDTH),
       .NUM_OUTPUT_QUEUES(NUM_OUTPUT_QUEUES)
       ) 
  egress_demux 
     (// --- data path interface
    .out_data_0       (out_data_0),
    .out_ctrl_0       (out_ctrl_0),
    .out_wr_0         (out_wr_0),
    .out_rdy_0        (out_rdy_0),

    .out_data_1       (out_data_1),
    .out_ctrl_1       (out_ctrl_1),
    .out_wr_1         (out_wr_1),
    .out_rdy_1        (out_rdy_1),

    .out_data_2       (out_data_2),
    .out_ctrl_2       (out_ctrl_2),
    .out_wr_2         (out_wr_2),
    .out_rdy_2        (out_rdy_2),

    .out_data_3       (out_data_3),
    .out_ctrl_3       (out_ctrl_3),
    .out_wr_3         (out_wr_3),
    .out_rdy_3        (out_rdy_3),

     // --- Interface to the previous module
    .in_data          (egress_demux_in_data),
    .in_ctrl          (egress_demux_in_ctrl),
    .in_rdy           (egress_demux_in_rdy),
    .in_wr            (egress_demux_in_wr),

      // --- Register interface
    .reg_req_in       (egress_demux_in_reg_req),
    .reg_ack_in       (egress_demux_in_reg_ack),
    .reg_rd_wr_L_in   (egress_demux_in_reg_rd_wr_L),
    .reg_addr_in      (egress_demux_in_reg_addr),
    .reg_data_in      (egress_demux_in_reg_data),
    .reg_src_in       (egress_demux_in_reg_src),

    .reg_req_out      (udp_reg_req_in),
    .reg_ack_out      (udp_reg_ack_in),
    .reg_rd_wr_L_out  (udp_reg_rd_wr_L_in),
    .reg_addr_out     (udp_reg_addr_in),
    .reg_data_out     (udp_reg_data_in),
    .reg_src_out      (udp_reg_src_in),

      // --- Misc
    .clk              (clk),
    .reset            (reset));




   //--------------------------------------------------
   //
   // --- User data path register master
   //
   //     Takes the register accesses from core,
   //     sends them around the User Data Path module
   //     ring and then returns the replies back
   //     to the core
   //
   //--------------------------------------------------

   udp_reg_master #(
      .UDP_REG_SRC_WIDTH (UDP_REG_SRC_WIDTH)
   ) udp_reg_master (
      // Core register interface signals
      .core_reg_req                          (udp_reg_req),
      .core_reg_ack                          (udp_reg_ack),
      .core_reg_rd_wr_L                      (udp_reg_rd_wr_L),
      .core_reg_addr                         (udp_reg_addr),
      .core_reg_rd_data                      (udp_reg_rd_data),
      .core_reg_wr_data                      (udp_reg_wr_data),

      // UDP register interface signals (output)
      .reg_req_out                           (in_arb_in_reg_req),
      .reg_ack_out                           (in_arb_in_reg_ack),
      .reg_rd_wr_L_out                       (in_arb_in_reg_rd_wr_L),
      .reg_addr_out                          (in_arb_in_reg_addr),
      .reg_data_out                          (in_arb_in_reg_data),
      .reg_src_out                           (in_arb_in_reg_src),

      // UDP register interface signals (input)
      .reg_req_in                            (udp_reg_req_in),
      .reg_ack_in                            (udp_reg_ack_in),
      .reg_rd_wr_L_in                        (udp_reg_rd_wr_L_in),
      .reg_addr_in                           (udp_reg_addr_in),
      .reg_data_in                           (udp_reg_data_in),
      .reg_src_in                            (udp_reg_src_in),

      //
      .clk                                   (clk),
      .reset                                 (reset)
   );
  

   //-------------------------------------------------
   //
   // register address decoder, register bus mux and demux
   //
   //-----------------------------------------------
    //-- openflow_switch_reg <--> reg_grp intf
     wire   [`SWITCH_REG_WRITE_BUS_WIDTH-1:0] switch_reg_wr_data_bus;
     wire   [`SWITCH_REG_CTRL_WIDTH-1:0]      switch_reg_ctrl;
     wire                                     switch_reg_vld;                           
     wire [`SWITCH_REG_READ_BUS_WIDTH-1:0]    switch_reg_rd_data_bus;
     wire                                     switch_reg_ack;
    
    //-- reg_grp <-> nf2_reg_grp intf
     wire                              reg_fifo_empty;
     wire                              reg_fifo_rd_en;
     wire                              reg_rd_wr_L;
     wire [`CPCI_NF2_ADDR_WIDTH-1:0]   reg_addr;
     wire  [`CPCI_NF2_DATA_WIDTH-1:0]  reg_rd_data;
     wire [`CPCI_NF2_DATA_WIDTH-1:0]   reg_wr_data;
     wire                              reg_rd_vld;


   //Reg master- Checks if the reg transaction on the bus is destined for this module
   openflow_switch_reg #(
      .SWITCH_ID(SWITCH_ID))
      switch_reg_master(
     .cpu_in_reg_wr_data_bus(cpu_in_reg_wr_data_bus),
     .cpu_in_reg_ctrl(cpu_in_reg_ctrl),
     .cpu_in_reg_vld(cpu_in_reg_vld),        
     .cpu_in_reg_rd_data_bus(cpu_in_reg_rd_data_bus),
     .cpu_in_reg_ack(cpu_in_reg_ack),        
                            
     .cpu_out_reg_wr_data_bus(cpu_out_reg_wr_data_bus),
     .cpu_out_reg_ctrl(cpu_out_reg_ctrl),
     .cpu_out_reg_vld(cpu_out_reg_vld),       
     .cpu_out_reg_rd_data_bus(cpu_out_reg_rd_data_bus),
     .cpu_out_reg_ack(cpu_out_reg_ack),
                            
     .switch_reg_wr_data_bus(switch_reg_wr_data_bus),
     .switch_reg_ctrl(switch_reg_ctrl),
     .switch_reg_vld(switch_reg_vld),        
     .switch_reg_rd_data_bus(switch_reg_rd_data_bus),
     .switch_reg_ack(switch_reg_ack), 

     .reset(reset), 
     .clk(clk));


   //Contains reg write and reg read fifo
   reg_grp reg_grp_i(
      .switch_reg_wr_data_bus(switch_reg_wr_data_bus),
      .switch_reg_ctrl(switch_reg_ctrl),
      .switch_reg_vld(switch_reg_vld),         
      .switch_reg_rd_data_bus(switch_reg_rd_data_bus),
      .switch_reg_ack(switch_reg_ack),
      
      .reg_fifo_empty(reg_fifo_empty),
      .reg_fifo_rd_en(reg_fifo_rd_en),
      .reg_rd_wr_L(reg_rd_wr_L),
      .reg_addr(reg_addr),
      .reg_rd_data(reg_rd_data),
      .reg_wr_data(reg_wr_data),
      .reg_rd_vld(reg_rd_vld),

      .clk(clk),
      .reset(reset));


nf2_reg_grp nf2_reg_grp_u
     (// interface to reg FIFOs
      .fifo_empty             (reg_fifo_empty),
      .fifo_rd_en             (reg_fifo_rd_en),
      .bus_rd_wr_L            (reg_rd_wr_L),
      .bus_addr               (reg_addr),
      .bus_wr_data            (reg_wr_data),
      .bus_rd_data            (reg_rd_data),
      .bus_rd_vld             (reg_rd_vld),

      // interface to SRAM
      .sram_reg_req           (sram_reg_req),
      .sram_reg_rd_wr_L       (sram_reg_rd_wr_L),
      .sram_reg_addr          (sram_reg_addr),
      .sram_reg_wr_data       (sram_reg_wr_data),
      .sram_reg_rd_data       (sram_reg_rd_data),
      .sram_reg_ack           (sram_reg_ack),

      // interface to user data path
      .udp_reg_req            (udp_reg_req),
      .udp_reg_rd_wr_L        (udp_reg_rd_wr_L),
      .udp_reg_addr           (udp_reg_addr),
      .udp_reg_wr_data        (udp_reg_wr_data),
      .udp_reg_rd_data        (udp_reg_rd_data),
      .udp_reg_ack            (udp_reg_ack),

      // misc
      .clk                    (clk),
      .reset                  (reset)

      );



   //--------------------------------------------------
   //
   // --- SRAM CONTROLLERS
   // note: register access is unimplemented yet
   //--------------------------------------------------

   wire [SRAM_ADDR_WIDTH-1:0]       sram_addr;
   wire [DATA_WIDTH+CTRL_WIDTH-1:0] sram_wr_data;
   wire [DATA_WIDTH+CTRL_WIDTH-1:0] sram_rd_data;
   wire                             sram_tri_en;
   wire [CTRL_WIDTH-1:0]            sram_bw;
   wire                             sram_we;
   wire                             sram_reset_done; 
   
   always @(posedge clk) 
   begin
     sram_reset_done_out <= sram_reset_done_in & sram_reset_done;
   end
      
 sram_arbiter
        #(.SRAM_DATA_WIDTH(DATA_WIDTH+CTRL_WIDTH),
	  .SRAM_ADDR_WIDTH(SRAM_ADDR_WIDTH))
      sram_arbiter
        (// --- Requesters   (read and/or write)
         .wr_0_req           (wr_0_req),
         .wr_0_addr          (wr_0_addr),
         .wr_0_data          (wr_0_data),
         .wr_0_ack           (wr_0_ack),

         .rd_0_req           (rd_0_req),
         .rd_0_addr          (rd_0_addr),
         .rd_0_data          (rd_0_data),
         .rd_0_ack           (rd_0_ack),
         .rd_0_vld           (rd_0_vld),

         .table_flush        (table_flush),

         // --- sram access
         .sram_addr          (sram_addr),
         .sram_wr_data       (sram_wr_data),
         .sram_rd_data       (sram_rd_data),
         .sram_we            (sram_we),
         .sram_bw            (sram_bw),
         .sram_tri_en        (sram_tri_en),

         // --- register interface
         .sram_reg_req       (sram_reg_req),
         .sram_reg_rd_wr_L   (sram_reg_rd_wr_L),
         .sram_reg_addr      (sram_reg_addr),
         .sram_reg_wr_data   (sram_reg_wr_data),
         .sram_reg_rd_data   (sram_reg_rd_data),
         .sram_reg_ack       (sram_reg_ack),

	 // --- SW Flag 
	 .sram_reset_done    (sram_reset_done),

         // --- Misc
         .reset              (reset),
         .clk                (clk)
         );

   //--------------------------------------------------
   //
   // --- SRAM
   // Two cycle delat is introduced for access to match 
   // the cypress CY7C1370D SRAM latency

   reg  [7:0]                                   we_d,we_2d; 
   reg  [SRAM_ADDR_WIDTH-1:0]                   sram_addr_d,sram_addr_2d; 
   wire [7:0]                                   we; 
   
   assign we = !sram_we ? ~sram_bw : 8'd0;
   
   always @(posedge clk) begin
      sram_addr_d  <= sram_addr; 
      sram_addr_2d <= sram_addr_d; 
      we_d         <= we;
      we_2d        <= we_d;
   end
   
   
   v_bytewrite_ram_1b 
     #(.SIZE(512),
       .ADDR_WIDTH(SRAM_ADDR_WIDTH),
       .COL_WIDTH(9),
       .NB_COL(8))
     sram  
      (.clk(clk), 
       .we(we_2d), 
       .rd_addr(sram_addr_d), 
       .wr_addr(sram_addr_2d), 
       .di(sram_wr_data), 
       .do(sram_rd_data));
   

   assign table_flush = table_flush_internal;


endmodule

