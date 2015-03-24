///////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
  module output_port_lookup
    #(parameter DATA_WIDTH = 64,
      parameter CTRL_WIDTH=DATA_WIDTH/8,
      parameter UDP_REG_SRC_WIDTH = 2,
      parameter IO_QUEUE_STAGE_NUM = `IO_QUEUE_STAGE_NUM,
      parameter NUM_OUTPUT_QUEUES = 8,
      parameter NUM_IQ_BITS = 3,
      parameter STAGE_NUM = 4,
      parameter SRAM_ADDR_WIDTH = 19,
      parameter CPU_QUEUE_NUM = 0)

   (// --- data path interface
    output     [DATA_WIDTH-1:0]        out_data,
    output     [CTRL_WIDTH-1:0]        out_ctrl,
    output                             out_wr,
    input                              out_rdy,

    input  [DATA_WIDTH-1:0]            in_data,
    input  [CTRL_WIDTH-1:0]            in_ctrl,
    input                              in_wr,
    output                             in_rdy,

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

    // --- SRAM Interface
    output [SRAM_ADDR_WIDTH-1:0]       wr_0_addr,
    output                             wr_0_req,
    input                              wr_0_ack,
    output [DATA_WIDTH+CTRL_WIDTH-1:0] wr_0_data,

    input                              rd_0_ack,
    input  [DATA_WIDTH+CTRL_WIDTH-1:0] rd_0_data,
    input                              rd_0_vld,
    output [SRAM_ADDR_WIDTH-1:0]       rd_0_addr,
    output                             rd_0_req,

    //// --- Watchdog Timer Interface
    //input                              table_flush,

    // --- Misc
    input                              clk,
    input                              reset);

   `LOG2_FUNC
   `CEILDIV_FUNC

   //-------------------- Internal Parameters ------------------------
   localparam PKT_SIZE_WIDTH = 12;

   
   //------------------------ Wires/Regs -----------------------------

   wire [`OPENFLOW_ACTION_WIDTH-1:0]                          exact_data;

   wire [CTRL_WIDTH-1:0]                                      in_fifo_ctrl;
   wire [DATA_WIDTH-1:0]                                      in_fifo_data;


   wire [`OPENFLOW_ENTRY_WIDTH-1:0]                           flow_entry;
   wire [`OPENFLOW_ENTRY_SRC_PORT_WIDTH-1:0]                  flow_entry_src_port;
   wire [PKT_SIZE_WIDTH-1:0]                                  pkt_size;
   wire                                                       flow_entry_vld;
   wire                                                       exact_match_rdy;
   wire                                                       exact_hit; 
   wire                                                       exact_miss; 
   wire                                                       exact_data_vld;
   wire                                                       exact_wins; 
   wire                                                       exact_loses;
   
   reg                                                        wildcard_data_vld;
   reg                                                        wildcard_data_vld_nxt;
   reg   [1:0]                                                wildcard_data_vld_reg;
   reg   [1:0]                                                wildcard_data_vld_reg_nxt;


   reg [31:0]                                                 s_counter;
   reg [27:0]                                                 ns_counter;


   wire [`OPENFLOW_ACTION_WIDTH+`OPENFLOW_ENTRY_SRC_PORT_WIDTH-1:0] result_fifo_din;
   wire [`OPENFLOW_ACTION_WIDTH+`OPENFLOW_ENTRY_SRC_PORT_WIDTH-1:0] result_fifo_dout;
   wire                                                             result_fifo_wr_en;
   wire                                                             result_fifo_rd_en;
   wire                                                             result_fifo_nearly_full; 
   wire                                                             result_fifo_empty;
   wire [NUM_OUTPUT_QUEUES-1:0]                               pkts_dropped;


   wire                                                       in_fifo_rd_en, 
                                                              in_fifo_nearly_full,
							      in_fifo_empty;





 //------------------------- Modules -------------------------------

   /* each pkt can have up to:
    * - 18 bytes of Eth header including VLAN
    * - 15*4 = 60 bytes IP header including max number of options
    * - at least 4 bytes of tcp/udp header
    * total = 82 bytes approx 4 bits (8 bytes x 2^4 = 128 bytes)
    */
   fallthrough_small_fifo #(.WIDTH(CTRL_WIDTH+DATA_WIDTH), .MAX_DEPTH_BITS(4))
      input_fifo
        (.din           ({in_ctrl, in_data}),  // Data in
         .wr_en         (in_wr),             // Write enable
         .rd_en         (in_fifo_rd_en),    // Read the next word
         .dout          ({in_fifo_ctrl, in_fifo_data}),
         .prog_full     (),
         .full          (),
         .nearly_full   (in_fifo_nearly_full),
         .empty         (in_fifo_empty),
         .reset         (reset),
         .clk           (clk)
         );



header_parser
     #(.DATA_WIDTH                  (DATA_WIDTH),
       .CTRL_WIDTH                  (CTRL_WIDTH),
       .PKT_SIZE_WIDTH              (PKT_SIZE_WIDTH),
       .ADDITIONAL_WORD_SIZE        (`OPENFLOW_ENTRY_VLAN_ID_WIDTH),
       .ADDITIONAL_WORD_POS         (`OPENFLOW_ENTRY_VLAN_ID_POS),
       .ADDITIONAL_WORD_BITMASK     (16'hEFFF),  // --- PCP:3bits VID:12bits
       .ADDITIONAL_WORD_CTRL        (`VLAN_CTRL_WORD),
       .ADDITIONAL_WORD_DEFAULT     (16'hFFFF),
       .FLOW_ENTRY_SIZE             (`OPENFLOW_ENTRY_WIDTH))
       header_parser
         ( // --- Interface to the previous stage
           .in_data                   (in_data),
           .in_ctrl                   (in_ctrl),
           .in_wr                     (in_wr),

           // --- Interface to matchers
           .flow_entry                (flow_entry),
           .flow_entry_src_port       (flow_entry_src_port),
           .pkt_size                  (pkt_size),
           .flow_entry_vld            (flow_entry_vld),

           // --- Misc
           .reset                     (reset),
           .clk                       (clk));


  

  exact_match
     #(.NUM_OUTPUT_QUEUES (NUM_OUTPUT_QUEUES),
       .PKT_SIZE_WIDTH (PKT_SIZE_WIDTH),
       .SRAM_ADDR_WIDTH (SRAM_ADDR_WIDTH),
       .DATA_WIDTH (DATA_WIDTH),
       .CTRL_WIDTH (CTRL_WIDTH)
       ) exact_match
       ( // --- Interface to flow entry collector
         .flow_entry        (flow_entry),
         .flow_entry_vld    (flow_entry_vld),
         .exact_match_rdy   (exact_match_rdy),
         .pkt_size          (pkt_size),

         // --- Interface to arbiter
         .exact_hit         (exact_hit),
         .exact_miss        (exact_miss),
         .exact_data        (exact_data),
         .exact_data_vld    (exact_data_vld),
         .exact_wins        (exact_wins),
         .exact_loses       (exact_loses),

         // --- Interface to SRAM
         .rd_0_ack          (rd_0_ack),
         .rd_0_data         (rd_0_data),
         .rd_0_vld          (rd_0_vld),
         .rd_0_addr         (rd_0_addr),
         .rd_0_req          (rd_0_req),
         .wr_0_addr         (wr_0_addr),
         .wr_0_req          (wr_0_req),
         .wr_0_ack          (wr_0_ack),
         .wr_0_data         (wr_0_data),

         .openflow_timer    (s_counter),

         .clk               (clk),
         .reset             (reset));


 match_arbiter
     #(.ACTION_WIDTH (`OPENFLOW_ACTION_WIDTH))
       match_arbiter
     (   .wildcard_hit          (1'b0),
         .wildcard_miss         (1'b1),
         .wildcard_data         ({`OPENFLOW_ACTION_WIDTH{1'b0}}),
         .wildcard_data_vld     (wildcard_data_vld),

         .exact_hit             (exact_hit),
         .exact_miss            (exact_miss),
         .exact_data            (exact_data),
         .exact_data_vld        (exact_data_vld),

         .flow_entry_src_port   (flow_entry_src_port),
         .flow_entry_vld        (flow_entry_vld),

         .result_fifo_wr_en     (result_fifo_wr_en),
         .result_fifo_din       (result_fifo_din),

         .wildcard_wins         (),
         .exact_wins            (exact_wins),
         .wildcard_loses        (),
         .exact_loses           (exact_loses),

         .reset                 (reset),
         .clk                   (clk));

 
 //-- Wildcard Logic
							      
 always @(posedge clk) begin
   if(reset) begin
     wildcard_data_vld_reg <= 2'd0;
     wildcard_data_vld     <= 1'd0;
   end
   else begin
     wildcard_data_vld_reg <= wildcard_data_vld_reg_nxt;
     wildcard_data_vld     <= wildcard_data_vld_nxt;
   end
 end


 always @(*) begin
   wildcard_data_vld_reg_nxt = wildcard_data_vld_reg;
   wildcard_data_vld_nxt     = 1'b0;
   case(wildcard_data_vld_reg) 
    2'd0:begin
           if(flow_entry_vld) 
	     wildcard_data_vld_reg_nxt = wildcard_data_vld_reg_nxt + 1;
         end
    2'd1:begin
	   wildcard_data_vld_reg_nxt  = wildcard_data_vld_reg_nxt + 1;
         end
    2'd2:begin
	   wildcard_data_vld_reg_nxt  = wildcard_data_vld_reg_nxt + 1;
         end
    2'd3:begin
	   wildcard_data_vld_reg_nxt  = wildcard_data_vld_reg_nxt + 1;
           wildcard_data_vld_nxt      = 1'b1; 
	 end
   endcase	 
 end
 

 small_fifo
     #(.WIDTH(`OPENFLOW_ACTION_WIDTH+`OPENFLOW_ENTRY_SRC_PORT_WIDTH),
       .MAX_DEPTH_BITS(1))
      result_fifo
        (.din           (result_fifo_din),     // Data in
         .wr_en         (result_fifo_wr_en),   // Write enable
         .rd_en         (result_fifo_rd_en),   // Read the next word
         .dout          (result_fifo_dout),
         .full          (),
	 .prog_full     (),
         .nearly_full   (result_fifo_nearly_full),
         .empty         (result_fifo_empty),
         .reset         (reset),
         .clk           (clk)
         );
 

   opl_processor
     #(.NUM_OUTPUT_QUEUES(NUM_OUTPUT_QUEUES))
     opl_processor
       (// --- interface to results fifo
        .result_fifo_dout    (result_fifo_dout),
        .result_fifo_rd_en   (result_fifo_rd_en),
        .result_fifo_empty   (result_fifo_empty),

        // --- interface to input fifo
        .in_fifo_ctrl        (in_fifo_ctrl),
        .in_fifo_data        (in_fifo_data),
        .in_fifo_rd_en       (in_fifo_rd_en),
        .in_fifo_empty       (in_fifo_empty),

        // --- interface to output
        .out_wr              (out_wr),
        .out_rdy             (out_rdy),
        .out_data            (out_data),
        .out_ctrl            (out_ctrl),

        // --- interface to registers
        .pkts_dropped        (pkts_dropped), // bus[NUM_OUTPUT_QUEUES-1:0]

        // --- Misc
        .clk                 (clk),
        .reset               (reset));



  generic_regs
     #(.UDP_REG_SRC_WIDTH (UDP_REG_SRC_WIDTH),
       .TAG (`OPENFLOW_LOOKUP_BLOCK_ADDR),
       .REG_ADDR_WIDTH (`OPENFLOW_LOOKUP_REG_ADDR_WIDTH),
       //.NUM_COUNTERS (2*2                               // hits and misses for both tables
       //               + NUM_OUTPUT_QUEUES               // num dropped per port
       //               ),
       .NUM_COUNTERS (2*1                               // hits and misses for both tables
                      + NUM_OUTPUT_QUEUES               // num dropped per port
                      ),
       .NUM_SOFTWARE_REGS (2),
       .NUM_HARDWARE_REGS (2),
       .COUNTER_INPUT_WIDTH (1)
       )
   generic_regs
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
      .counter_updates   ({pkts_dropped,
                           exact_wins,
                           exact_miss}
                           //wildcard_wins,
                           //wildcard_miss}
                          ),
      .counter_decrement ({(2+NUM_OUTPUT_QUEUES){1'b0}}),

      // --- SW regs interface
      .software_regs     (),

      // --- HW regs interface
      .hardware_regs     ({32'h0,
                           s_counter}),

      .clk               (clk),
      .reset             (reset));

 //--------------------------- Logic ------------------------------
   assign in_rdy = !in_fifo_nearly_full && exact_match_rdy ; //&& wildcard_match_rdy && exact_match_rdy;

   // timer
   always @(posedge clk) begin
      if(reset) begin
         ns_counter <= 0;
         s_counter  <= 0;
      end
      else begin
         if(ns_counter == (1_000_000_000/`FAST_CLOCK_PERIOD - 1'b1)) begin
            s_counter  <= s_counter + 1'b1;
            ns_counter <= 0;
         end
         else begin
            ns_counter <= ns_counter + 1'b1;
         end
      end // else: !if(reset)
   end // always @ (posedge clk)


// synthesis translate_off

always @(posedge clk) begin
  if(flow_entry_vld) begin
    $display("\n\n<=========================>\n@%0t Packet Header:",$time);
    $display("DST_PORT-->%0h",flow_entry[`OPENFLOW_ENTRY_TRANSP_DST_POS + `OPENFLOW_ENTRY_TRANSP_DST_WIDTH-1: `OPENFLOW_ENTRY_TRANSP_DST_POS]);
    $display("SRC_PORT-->%0h",flow_entry[`OPENFLOW_ENTRY_TRANSP_SRC_WIDTH + `OPENFLOW_ENTRY_TRANSP_SRC_POS-1: `OPENFLOW_ENTRY_TRANSP_SRC_POS]);
    $display("IP-->%0h",flow_entry[`OPENFLOW_ENTRY_IP_PROTO_WIDTH + `OPENFLOW_ENTRY_IP_PROTO_POS -1   : `OPENFLOW_ENTRY_IP_PROTO_POS]);
    $display("DST_IP-->%0h",flow_entry[`OPENFLOW_ENTRY_IP_DST_WIDTH + `OPENFLOW_ENTRY_IP_DST_POS -1       : `OPENFLOW_ENTRY_IP_DST_POS]);
    $display("SRC_IP-->%0h",flow_entry[`OPENFLOW_ENTRY_IP_SRC_WIDTH + `OPENFLOW_ENTRY_IP_SRC_POS - 1      : `OPENFLOW_ENTRY_IP_SRC_POS]);
    $display("ETH_TYPE-->%0h",flow_entry[`OPENFLOW_ENTRY_ETH_TYPE_WIDTH + `OPENFLOW_ENTRY_ETH_TYPE_POS - 1  : `OPENFLOW_ENTRY_ETH_TYPE_POS]);
    $display("DST_ETH-->%0h",flow_entry[`OPENFLOW_ENTRY_ETH_DST_WIDTH + `OPENFLOW_ENTRY_ETH_DST_POS - 1    : `OPENFLOW_ENTRY_ETH_DST_POS ]);
    $display("SRC_ETH-->%0h",flow_entry[`OPENFLOW_ENTRY_ETH_SRC_WIDTH + `OPENFLOW_ENTRY_ETH_SRC_POS - 1    : `OPENFLOW_ENTRY_ETH_SRC_POS]); 
    $display("ENTRY_PORT-->%0h",flow_entry[`OPENFLOW_ENTRY_SRC_PORT_WIDTH + `OPENFLOW_ENTRY_SRC_PORT_POS - 1  : `OPENFLOW_ENTRY_SRC_PORT_POS ]);
    $display("IP_TOS-->%0h",flow_entry[`OPENFLOW_ENTRY_IP_TOS_WIDTH + `OPENFLOW_ENTRY_IP_TOS_POS - 1      : `OPENFLOW_ENTRY_IP_TOS_POS ]);
    $display("VLAN-->%0h",flow_entry[`OPENFLOW_ENTRY_VLAN_ID_WIDTH + `OPENFLOW_ENTRY_VLAN_ID_POS - 1    : `OPENFLOW_ENTRY_VLAN_ID_POS ]);
  end
end

// synthesis translate_on


endmodule


