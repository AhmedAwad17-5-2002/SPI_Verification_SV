interface interface_spi (clk);
	parameter MEM_DEPTH=256;
     parameter ADDR_SIZE=8;
	input logic clk;
	logic MOSI, SS_n,rst_n;
logic MISO;
 logic tx_valid;
logic [7:0] tx_data;
logic [9:0] din;
logic [ADDR_SIZE-1:0] dout;
logic rx_valid;
 logic [9:0] rx_data; 
	
	modport spi_slave (input clk, MOSI, SS_n, rst_n,tx_valid ,rx_data ,output MISO,rx_valid,tx_data);
	modport spi_ram (input clk,rst_n,din,rx_valid,output dout,tx_valid);
	modport spi_wrapper (input clk,MOSI,SS_n,rst_n,output MISO);
	modport MONITOR(input MOSI, SS_n,clk,rst_n,MISO,tx_valid,tx_data,din,dout);
	modport TEST(output clk,MOSI,SS_n,rst_n,input MISO);
endinterface 
