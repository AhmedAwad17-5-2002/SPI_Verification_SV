module SPI_Wrapper(interface_spi.spi_wrapper S2);
wire [9:0] rxdata;
wire [7:0] txdata;
wire rx_valid,tx_valid;

//instantiation of spi slave and ram
SPI_RAM #(256,8) R (rxdata, txdata, rx_valid, tx_valid , clk, rst_n);
SIP_SLAVE  S (MOSI,MISO,SS_n,clk,rst_n,rxdata,rx_valid, txdata, tx_valid);
endmodule
