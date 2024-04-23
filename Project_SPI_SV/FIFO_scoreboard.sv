package FIFO_scoreboard_package;
	import FIFO_transaction_pkg::*;
	class  FIFO_scoreboard;
		int error_count,correct_count;
		logic [FIFO_WIDTH-1:0] data_out_ref;
		logic full_ref,almostfull_ref,empty_ref,almostempty_ref,overflow_ref,underflow_ref,wr_ack_ref;
		localparam max_address = $clog2(FIFO_DEPTH);

		logic [max_address-1:0] wr_ptr,rd_ptr;
		logic [max_address:0] count;
		logic [FIFO_WIDTH-1:0] FIFO_ref [FIFO_DEPTH-1:0];
		function void reference_model(FIFO_transaction FIFO_check);
			/*if (!FIFO_tran.rst_n) begin
				wr_ptr = 0;
				rd_ptr = 0;
				count  = 0;
				empty_ref = 1;
			end
			else begin
				full_ref = (count == FIFO_DEPTH)?1:0;
				empty_ref = (count == 0)?1:0;
				almostfull_ref = (count == FIFO_DEPTH-1)?1:0;
				almostempty_ref = (count == 1)?1:0;
				wr_ack_ref = (FIFO_tran.wr_en && !full_ref)?1:0;
				overflow_ref = (FIFO_tran.wr_en && full_ref)?1:0;
				underflow_ref = (FIFO_tran.rd_en && empty_ref)?1:0;
				if(FIFO_tran.wr_en && !full_ref) begin
					FIFO_ref[wr_ptr] = FIFO_tran.data_in;
					wr_ptr = wr_ptr + 1;
					count = count + 1;
				end
				if(FIFO_tran.rd_en && !empty_ref) begin
					data_out_ref = FIFO_ref[rd_ptr];
					rd_ptr = rd_ptr + 1;
					count = count - 1;
				end
				full_ref = (count == FIFO_DEPTH)?1:0;
				empty_ref = (count == 0)?1:0;
				almostfull_ref = (count == FIFO_DEPTH-1)?1:0;
				almostempty_ref = (count == 1)?1:0;*/
				fork

        // Process (1) --> Write operation
        begin

          if (!FIFO_check.rst_n) begin
            wr_ptr = 0;
            wr_ack_ref = 0;
            overflow_ref = 0;
          end
          else if (FIFO_check.wr_en && count < FIFO_DEPTH) begin
            FIFO_ref[wr_ptr] = FIFO_check.data_in;
            wr_ack_ref = 1;
            wr_ptr = wr_ptr + 1;
          end
          else begin 
            wr_ack_ref = 0; 
            if (full_ref & FIFO_check.wr_en)
              overflow_ref = 1;
            else
              overflow_ref = 0;
          end
          
        end

        // Process (2) --> Read operation
        begin
          if (!FIFO_check.rst_n) begin
            rd_ptr = 0;
            underflow_ref = 0;
            data_out_ref = 0;
          end
          else if (FIFO_check.rd_en && count != 0) begin
            data_out_ref = FIFO_ref[rd_ptr];
            rd_ptr = rd_ptr + 1;
          end
          else begin
            if(empty_ref && FIFO_check.rd_en)
              underflow_ref = 1;
            else
              underflow_ref = 0;
          end
        end

        // Process (3) --> Count operation
        begin
          if (!FIFO_check.rst_n) begin
            count = 0;
          end
          else begin
            if  ( ({FIFO_check.wr_en, FIFO_check.rd_en} == 2'b10) && !full_ref) 
              count = count + 1;
            else if ( ({FIFO_check.wr_en, FIFO_check.rd_en} == 2'b01) && !empty_ref)
              count = count - 1;
            else if(({FIFO_check.wr_en, FIFO_check.rd_en} == 2'b11) && full_ref)
              count = count - 1;
            else if(({FIFO_check.wr_en, FIFO_check.rd_en} == 2'b11) && empty_ref)
              count = count + 1;
          end
        end

      join

      full_ref = (count == FIFO_DEPTH)? 1 : 0;
      empty_ref = (count == 0)? 1 : 0;
      almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0; 
      almostempty_ref = (count == 1)? 1 : 0;
		endfunction
		function void check_data(FIFO_transaction FIFO_tr);
			reference_model(FIFO_tr);
			if(data_out_ref !== FIFO_tr.data_out) begin
				$display("%t:ERROR data_out not equal data_out_ref",$time);
				error_count = error_count + 1;
			end
			else
				correct_count = correct_count + 1;
			if(full_ref !== FIFO_tr.full) begin
				$display("%t:ERROR full not equal full_ref",$time);
				error_count = error_count + 1;
			end
			else
				correct_count = correct_count + 1;
			if(almostfull_ref !== FIFO_tr.almostfull) begin
				$display("%t:ERROR almostfull not equal almostfull_ref",$time);
				error_count = error_count + 1;
			end
			else
				correct_count = correct_count + 1;
			if(empty_ref !== FIFO_tr.empty) begin
				$display("%t:ERROR empty not equal empty_ref",$time);
				error_count = error_count + 1;
				$display("empty_ref = %0d,empty = %0d",empty_ref ,FIFO_tr.empty);
			end
			else
				correct_count = correct_count + 1;

			if(almostempty_ref !== FIFO_tr.almostempty) begin
				$display("%t:ERROR almostempty not equal almostempty_ref",$time);
				error_count = error_count + 1;
			end
			else
				correct_count = correct_count + 1;
			if(overflow_ref !== FIFO_tr.overflow) begin
				$display("%t:ERROR overflow not equal overflow_ref",$time);
				error_count = error_count + 1;
			end
			else
				correct_count = correct_count + 1;
			if(underflow_ref !== FIFO_tr.underflow) begin
				$display("%t:ERROR underflow not equal underflow_ref",$time);
				error_count = error_count + 1;
			end
			else
				correct_count = correct_count + 1;
			if(wr_ack_ref !== FIFO_tr.wr_ack) begin
				$display("%t:ERROR wr_ack not equal wr_ack_ref",$time);
				error_count = error_count + 1;
			end
			else
				correct_count = correct_count + 1;

		endfunction
	endclass
endpackage