//
// Dual-Port RAM with Synchronous Read (Read Through)
//
module v_rams_11 (clk, we, a, dpra, di, spo, dpo);
parameter DWIDTH = 15; 
parameter AWIDTH = 6; 
parameter DEPTH  = 64;

input clk;
input we;
input [AWIDTH-1:0] a; 
input [AWIDTH-1:0] dpra;
input [DWIDTH-1:0] di;
output[DWIDTH-1:0] spo; 
output[DWIDTH-1:0] dpo; 


reg [DWIDTH-1:0] ram [DEPTH-1:0];
reg [AWIDTH-1:0] read_a; 
reg [AWIDTH-1:0] read_dpra; 


always@(posedge clk) begin
  if(we) 
    ram[a] <= di; 
  read_a    <= a; 
  read_dpra <= dpra;
end

assign spo = ram[read_a]; 
assign dpo = ram[read_dpra];


//synthesis translate_off
 // `ifdef INIT_RAM
  integer j; 
  initial begin
    for(j=0; j < DEPTH ; j = j+1) begin
      ram[j] = 0;
    end
  end
 // `endif
//synthesis translate_on

endmodule

