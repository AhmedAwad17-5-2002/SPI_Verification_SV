import shared_pkg::*;
import FIFO_transaction_pkg::*;
module FIFO_tb(FIFO_IF.TEST FIFO_if);
	FIFO_transaction FIFO_trans = new();
	initial begin
		FIFO_if.rst_n = 0;
		//@(negedge FIFO_if.clk);
		#4;
		for (int i = 0; i < 100000; i++) begin
			assert(FIFO_trans.randomize());
			FIFO_if.data_in = $random;
			FIFO_if.rst_n = FIFO_trans.rst_n;
			FIFO_if.wr_en = FIFO_trans.wr_en;
			FIFO_if.rd_en = FIFO_trans.rd_en;
			//@(negedge FIFO_if.clk);
			#4;
		end
		test_finished = 1;
	end
endmodule
