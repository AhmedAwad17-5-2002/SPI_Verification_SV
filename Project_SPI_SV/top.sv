module top();
	bit clk;
	always #2 clk = ~clk;
	FIFO_IF 	   inter  (clk);
	FIFO           DUT    (inter);
	FIFO_tb        tb     (inter);
	monitor   monitor(inter);
endmodule