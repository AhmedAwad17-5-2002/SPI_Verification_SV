module SPI_RAM (interface_spi.spi_ram S3);
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;

reg [ADDR_SIZE-1:0] write_address, read_address; //buses to hold write or read addresses 
reg [ADDR_SIZE-1:0] memory [MEM_DEPTH-1:0]; 

always @(posedge S3.clk or negedge S3.rst_n) begin
	if (~S3.rst_n) begin
		S3.dout<=0;
		S3.tx_valid<=0;
	end
	else if (S3.rx_valid) begin
		case ( S3.din [9:8])
		  2'b00: begin
		    write_address<= S3.din[ADDR_SIZE-1:0];
		    S3.tx_valid<=0;
          end 
		  2'b01: begin
		    memory[write_address] <= S3.din [ADDR_SIZE-1:0]; 
		    S3.tx_valid<=0;
          end
		  2'b10: begin
		    read_address<= S3.din [ADDR_SIZE-1:0];
		    S3.tx_valid<=0;
          end
		  2'b11: begin
		    S3.dout<= memory[read_address];
		    S3.tx_valid<=1;
          end

		endcase        
	end
end
endmodule

