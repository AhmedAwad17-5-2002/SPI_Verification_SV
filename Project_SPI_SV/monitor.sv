import shared_pkg::*;
import FIFO_transaction_pkg::*;
import FIFO_scoreboard_package::*;
import FIFO_coverage_pkg::*;
module monitor(FIFO_IF.MONITOR FIFO_if);
	FIFO_transaction FIFO_transac = new();
	FIFO_scoreboard FIFO_score = new();
	FIFO_coverage FIFO_cover = new();
	initial begin
		forever begin
			FIFO_transac.data_in = FIFO_if.data_in;
			FIFO_transac.rst_n = FIFO_if.rst_n;
			FIFO_transac.wr_en = FIFO_if.wr_en;
			FIFO_transac.rd_en = FIFO_if.rd_en;
			
			#4;

			FIFO_transac.data_out = FIFO_if.data_out;
			FIFO_transac.full = FIFO_if.full;
			FIFO_transac.empty = FIFO_if.empty;
			FIFO_transac.almostfull = FIFO_if.almostfull;
			FIFO_transac.almostempty = FIFO_if.almostempty;
			FIFO_transac.overflow = FIFO_if.overflow;
			FIFO_transac.underflow = FIFO_if.underflow;
			FIFO_transac.wr_ack = FIFO_if.wr_ack;
			fork
				begin
					FIFO_cover.sample_data(FIFO_transac);
				end

				begin
					FIFO_score.check_data(FIFO_transac);
				end
			join
			if(test_finished) begin
				correct_count = FIFO_score.correct_count;
				error_count = FIFO_score.error_count;
				$display("%t: At the end of the test the error count is %d, and the correct count is %d",$time,error_count,correct_count);
				$stop;
			end
		end
	end

endmodule