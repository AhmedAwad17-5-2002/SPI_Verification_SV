module RAM_pr2(clk,rst_n,din,rx_valid,dout,tx_valid);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;
input [9:0] din;
input rx_valid,clk,rst_n;
output reg[7:0] dout;
output reg tx_valid;
reg [ADDR_SIZE-1:0] wr_address,rd_address;
reg [ADDR_SIZE-1:0] mem_1 [MEM_DEPTH-1:0];

always @(posedge clk) begin
    if(!rst_n)
    begin
    dout<=0;
    tx_valid<=0;
    end
    else
    begin
    if(rx_valid==1)
    begin
    case (din[9:8])
    2'b00: begin
      wr_address<= din[7:0];
      tx_valid<=0;  
    end
    
    2'b01: begin
        mem_1[wr_address]<= din[7:0];
        tx_valid<=0;
    end
    2'b10:begin
         rd_address<= din[7:0];
         tx_valid<=0;
    end
    2'b11: begin
        dout<= mem_1[rd_address];
        tx_valid<=1;
    end
     default: wr_address<= din[7:0];
    endcase
    end
end
end 
endmodule
