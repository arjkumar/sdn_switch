
// -- Common Functions
`define LOG2_FUNC \
function integer log2; \
      input integer number; \
      begin \
         log2=0; \
         while(2**log2<number) begin \
            log2=log2+1; \
         end \
      end \
endfunction



`define CEILDIV_FUNC \
function integer ceildiv; \
      input integer num; \
      input integer divisor; \
      begin \
         if (num <= divisor) \
           ceildiv = 1; \
         else begin \
            ceildiv = num / divisor; \
            if (ceildiv * divisor < num) \
              ceildiv = ceildiv + 1; \
         end \
      end \
endfunction

// Clock

`define FAST_CLOCK_PERIOD                         8



// CPCI--Virtex data bus width -- Register Width
`define CPCI_NF2_DATA_WIDTH                       32


// CPCI--Virtex data bus width
`define CPCI_NF2_DATA_WIDTH                       32

// // CPCI--Virtex address bus width. This is byte addresses even though bottom bits are zero.
 `define CPCI_NF2_ADDR_WIDTH                       27


// CPCI debug bus width
`define CPCI_DEBUG_DATA_WIDTH                     29

// SRAM address width
`define SRAM_ADDR_WIDTH                           19

// SRAM data width
`define SRAM_DATA_WIDTH                           36







//Tag Address widths for all switches


// Block Address widths for all switches
`define SRAM_BLOCK_ADDR                      1'h1
`define UDP_BLOCK_ADDR                       1'h1
`define OPENFLOW_LOOKUP_BLOCK_ADDR           17'h00000
`define IN_ARB_BLOCK_ADDR                    17'h00001
`define WDT_BLOCK_ADDR                       17'h00004
`define OQ_BLOCK_ADDR                        17'h00002



//Module Tags 


//TAG Address widths
`define IN_ARB_BLOCK_ADDR_WIDTH                    17
`define IN_ARB_REG_ADDR_WIDTH                      6

`define WDT_BLOCK_ADDR_WIDTH                       17
`define WDT_REG_ADDR_WIDTH                         6

`define OPENFLOW_LOOKUP_BLOCK_ADDR_WIDTH           17
`define OPENFLOW_LOOKUP_REG_ADDR_WIDTH             6

`define SRAM_BLOCK_ADDR_WIDTH                      1
`define SRAM_REG_ADDR_WIDTH                        22

`define UDP_BLOCK_ADDR_WIDTH                       1
`define UDP_REG_ADDR_WIDTH                         23


`define OQ_BLOCK_ADDR_WIDTH                        17
`define OQ_REG_ADDR_WIDTH                          6

//--IOQ Defines
 `define IO_QUEUE_STAGE_NUM   8'hff

 `define IOQ_BYTE_LEN_POS     0
 `define IOQ_SRC_PORT_POS     16
 `define IOQ_WORD_LEN_POS     32
 `define IOQ_DST_PORT_POS     48


//-- Input Arbiter 
// Description: Round-robin input arbiter
`define IN_ARB_NUM_PKTS_SENT       6'h0
`define IN_ARB_LAST_PKT_WORD_0_HI  6'h1
`define IN_ARB_LAST_PKT_WORD_0_LO  6'h2
`define IN_ARB_LAST_PKT_CTRL_0     6'h3
`define IN_ARB_LAST_PKT_WORD_1_HI  6'h4
`define IN_ARB_LAST_PKT_WORD_1_LO  6'h5
`define IN_ARB_LAST_PKT_CTRL_1     6'h6
`define IN_ARB_STATE               6'h7


//-- VLAN 
`define VLAN_CTRL_WORD                            8'h42
`define VLAN_ETHERTYPE                            16'h8100


//Switch Register
`define SWITCH_REG_WRITE_DATA_RD_WR_L_POS   0
`define SWITCH_REG_WRITE_DATA_ADDR_POS     `CPCI_NF2_ADDR_WIDTH : 1   
`define SWITCH_REG_WRITE_DATA_POS          `CPCI_NF2_DATA_WIDTH + `CPCI_NF2_ADDR_WIDTH : `CPCI_NF2_ADDR_WIDTH +1  

`define SWITCH_REG_WRITE_BUS_WIDTH          `CPCI_NF2_DATA_WIDTH + `CPCI_NF2_ADDR_WIDTH + 1
`define SWITCH_REG_READ_BUS_WIDTH           `CPCI_NF2_DATA_WIDTH     

`define SWITCH_REG_CTRL_STATUS_POS          0
`define SWITCH_REG_CTRL_STATUS_WIDTH        1
`define SWITCH_REG_CTRL_RD_WR_L_WIDTH       1
`define SWITCH_REG_CTRL_RD_WR_L_POS         1
`define SWITCH_REG_CTRL_ID_WIDTH            5 
`define SWITCH_REG_CTRL_ID_POS              6:2 
`define SWITCH_REG_CTRL_WIDTH               7 

