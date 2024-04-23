package FIFO_transaction_pkg;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
class FIFO_transaction;
logic [FIFO_WIDTH-1:0] data_in;
rand logic rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;
int WE_EN_DIST=70;
int RD_EN_DIST=30;

constraint reset { rst_n dist{0:=5,1:=95};
		
	}	

constraint write_enable { wr_en dist{1:=WE_EN_DIST,0:=100-WE_EN_DIST};
		
	}	

constraint read_enable { rd_en dist{1:=RD_EN_DIST,0:=100-RD_EN_DIST};
	}


endclass 
	
endpackage