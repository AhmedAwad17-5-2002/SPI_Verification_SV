module memory (din,addr_wr,addr_rd,wr_en,rd_en,blk_select,dout,clk,rst);
parameter MEM_WIDTH=16;
parameter MEM_DEPTH=1024;
parameter ADDR_SIZE =10;
input[MEM_WIDTH-1:0] din;
input [ADDR_SIZE-1:0]addr_wr;
input [ADDR_SIZE-1:0]addr_rd;
input clk,rst,rd_en,blk_select,wr_en;
output reg [MEM_WIDTH-1:0]dout;
reg[MEM_WIDTH-1:0] mem [MEM_DEPTH-1:0];
always @(posedge clk,negedge rst)
begin
    if(!rst)
dout<=0;
else if(blk_select)

begin
if(rd_en)
dout<= mem[addr_rd];
else if(wr_en)
mem[addr_wr]<=din;
end
end
endmodule
