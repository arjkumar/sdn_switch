//
// Single-Port BRAM with Byte-wide Write Enable
// 4x9-bit write
// Read-First mode
// Single-process description
// Compact description of the write with a generate-for statement
// Column width and number of columns easily configurable
//
// Download: ftp://ftp.xilinx.com/pub/documentation/misc/xstug_examples.zip
// File: HDL_Coding_Techniques/rams/bytewrite_ram_1b.v
//
module v_bytewrite_ram_1b (clk, we, rd_addr,wr_addr, di, do);
  parameter SIZE = 1024;
  parameter ADDR_WIDTH = 10;
  parameter COL_WIDTH = 9;
  parameter NB_COL = 4;
  input                             clk;
  input [NB_COL-1:0]                we;
  input [ADDR_WIDTH-1:0]            rd_addr;
  input [ADDR_WIDTH-1:0]            wr_addr;
  input [NB_COL*COL_WIDTH-1:0]      di;
  output [NB_COL*COL_WIDTH-1:0]     do;
 
  //synthesis translate_off
  //Initialization code for simulation
  `ifdef INIT_RAM
  integer j;
  integer file_d;
  reg     [71:0] ram_data; 

  function [71:0] ram_shuffle; 
   input[71:0] ram_data; 
   integer     i;
   begin
     ram_shuffle[71:63] ={ram_data[71],ram_data[63:56]}; 
     ram_shuffle[62:54] ={ram_data[70],ram_data[55:48]}; 
     ram_shuffle[53:45] ={ram_data[69],ram_data[47:40]}; 
     ram_shuffle[44:36] ={ram_data[68],ram_data[39:32]}; 
     ram_shuffle[35:27] ={ram_data[67],ram_data[31:24]}; 
     ram_shuffle[26:18] ={ram_data[66],ram_data[23:16]}; 
     ram_shuffle[17:9]  ={ram_data[65],ram_data[15:8]}; 
     ram_shuffle[8:0]   ={ram_data[64],ram_data[7:0]};   
   end
  endfunction
  
  initial begin
    //$display("Initializing RAM %m: SIZE-%0d DEPTH-%0d",NB_COL*COL_WIDTH,SIZE);
    //for(j=0; j<SIZE; j=j+1) begin
    //  RAM[j] = 0;
    //end
     
   //b6b88c060557901f
   //080800d5e9ab0a5e
   //01790600248c0179
   //80002008200000248c
     //Openflow_Entry
   //  RAM[160] = ram_shuffle(72'hb6b88c060557901f); 
   //  RAM[161] = ram_shuffle(72'h080800d5e9ab0a5e); 
   //  RAM[162] = ram_shuffle(72'h01790600248c0179); 
   //  RAM[163] = ram_shuffle(72'h802008200000248c);
   //  //Openflow_Action
   //  RAM[164] = 0; 
   //  RAM[165] = ram_shuffle(72'hF); 
   //  RAM[166] = 0; 
   //  RAM[167] = 0; 
   //  RAM[168] = 0; 
    
    #9000;
    //file_d = $fopen("mem.txt","w");
    //for(j=0; j<SIZE; j=j+1) begin
    //  $fwrite(file_d,"RAM[%0d]=%0H\n",j,RAM[j]);
    //end
     

    
  end
  `endif
  //synthesis translate_on


  generate 
    genvar i;
    for(i=0;i < NB_COL ; i = i + 1) begin : SRAM 
      v_rams_11     #(.DWIDTH(COL_WIDTH),
                      .AWIDTH(ADDR_WIDTH),
		      .DEPTH(SIZE) 
                      ) sram( 
		      .clk(clk),
		      .we(we[i]),
		      .a(wr_addr),
		      .dpra(rd_addr),
		      .di(di[(i+1)*COL_WIDTH-1:i*COL_WIDTH]),
		      .spo(),
		      .dpo((do[(i+1)*COL_WIDTH-1:i*COL_WIDTH])));
    
    end
  endgenerate

endmodule

