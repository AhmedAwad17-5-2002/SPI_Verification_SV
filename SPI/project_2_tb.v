module project_2_tb();
reg MOSI,SS_n,clk,rst_n;
wire MISO;
integer i;
integer j;
SPI_Wrapper SPI_Wr(MISO, MOSI,SS_n,rst_n,clk);
initial begin
	for(i=0;i<256;i=i+1) begin
		SPI_Wr.R.memory[i]=i; 
	end
	clk = 0;
	forever begin
		#1 clk = ~clk;
	end
end
initial begin
	for(j=0;j<2;j=j+1) begin
		$display("start rst_n case = ",$time);
		rst_n = 0;
		MOSI = 1;
		SS_n=1;
		#10;
		$display("end rst_n case = ",$time);
		rst_n = 1;
		#20;
		MOSI=0;
		#20;
		MOSI=1;
		SS_n=0;
		#2;
		MOSI=0;
		#2;
		MOSI=0;
		#4;
		repeat(8) begin
			MOSI=$random;
			#2;
		end  
		SS_n=1;
		#10;
		MOSI=0;
		SS_n=0;
		#6;
		MOSI=1;
		#2;
		repeat(8) begin
			MOSI=$random;
			#2;
		end
		SS_n=1;
		#20;
		SS_n=0;
		#2;
		MOSI=1;
		#4;
		MOSI=0;
		#2;
		repeat(8) begin
			MOSI=$random;
			#2;
		end
		SS_n=1;
		#10;
		SS_n=0;
		#2;
		MOSI=1;
		#6;
		repeat(8) begin
			MOSI=$random;
			#2;
		end
		#18;
		SS_n=1;
		#20;
	end
	rst_n=0;
	#6;
	rst_n=1;
	SS_n=0;
	#2;
	SS_n=1;
	#20;
	SS_n=0;
	#2;
	MOSI=0;
	#6;
	repeat(6) begin
		MOSI=$random;
		#2;
	end
	SS_n=1;
	#4;
	SS_n=0;
	#2;
	MOSI=0;
	#4;
	MOSI=1;
	#2;
	repeat(6) begin
		MOSI=$random;
		#2;
	end
	SS_n=1;
	#4;
	SS_n=0;
	#2;
	MOSI=1;
	#4;
	MOSI=0;
	#2;
	repeat(6) begin
		MOSI=$random;
		#2;
	end
	SS_n=1;
	#4;
	SS_n=0;
	#2;
	MOSI=1;
	#6;
	repeat(6) begin
		MOSI=$random;
		#2;
	end
	SS_n=1;
	#4;
	for(i=0;i<1000;i=i+1) begin
		SS_n=0;
		#2;
		MOSI=1;
		#4;
		MOSI=0;
		#2;
		repeat(8) begin
			MOSI=$random;
			#2;
		end
		SS_n=1;
		#20;
		SS_n=0;
		#2;
		MOSI=1;
		#6;
		repeat(8) begin
			MOSI=$random;
			#6;
		end
		SS_n=1;
		#20;
		SS_n=0;
		#2;
		MOSI=0;
		#6;
		repeat(8) begin
			MOSI=$random;
			#2;
		end
		SS_n=1;
		#20;
		SS_n=0;
		#2;
		MOSI=0;
		#4;
		MOSI=1;
		#2;
		repeat(8) begin
			MOSI=$random;
			#2;
		end
		SS_n=1;
		#20;
	end

	$stop;
end
endmodule