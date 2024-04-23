module SPI_RAM (din, dout ,rx_valid, tx_valid , clk, rst_n);
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;
input clk, rst_n, rx_valid;
input [9:0] din;
output  reg tx_valid;
output reg [ADDR_SIZE-1:0] dout; 


reg [ADDR_SIZE-1:0] write_address, read_address; //buses to hold write or read addresses 
reg [ADDR_SIZE-1:0] memory [MEM_DEPTH-1:0]; 

always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
		dout<=0;
		tx_valid<=0;
	end
	else if (rx_valid) begin
		case ( din [9:8])
		  2'b00: begin
		    write_address<= din[ADDR_SIZE-1:0];
          end 
		  2'b01: begin
		    memory[write_address] <= din [ADDR_SIZE-1:0]; 
          end
		  2'b10: begin
		    read_address<= din [ADDR_SIZE-1:0];
          end
		  2'b11: begin
		    dout<= memory[read_address];
		    tx_valid<=1;
          end

		endcase        
	end
end
endmodule
