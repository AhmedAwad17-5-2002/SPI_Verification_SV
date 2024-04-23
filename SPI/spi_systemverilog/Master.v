module Master(SS_n,MOSI,MISO,clk,rst_n);
input MOSI,SS_n,clk,rst_n;
 output MISO;
 wire rx_valid;
wire [9:0] rx_data;
wire [7:0] tx_data;
wire tx_valid;
 SPI   s1 (clk,rst_n,MOSI,MISO,SS_n,rx_data,rx_valid,tx_data,tx_valid);
RAM_pr2  R1(clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
endmodule
