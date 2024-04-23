////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_IF.DUT F1);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8; 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge F1.clk or negedge F1.rst_n) begin
	if (!F1.rst_n) begin
		wr_ptr <= 0;
		F1.overflow <= 0;
		F1.wr_ack <= 0;
	end
	else if (F1.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= F1.data_in;
		F1.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		F1.wr_ack <= 0; 
		if (F1.full && F1.wr_en) // && instead of &
			F1.overflow <= 1;
		else
			F1.overflow <= 0;
	end
end

always @(posedge F1.clk or negedge F1.rst_n) begin
	if (!F1.rst_n) begin
		rd_ptr <= 0;
		F1.data_out <= 0;
		F1.underflow <= 0;
	end
	else if (F1.rd_en && count != 0) begin
		F1.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else begin
		if(F1.rd_en && F1.empty)
			F1.underflow <= 1;
		else
			F1.underflow <= 0;
	end
end

always @(posedge F1.clk or negedge F1.rst_n) begin
	if (!F1.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({F1.wr_en, F1.rd_en} == 2'b10) && !F1.full) 
			count <= count + 1;
		else if ( ({F1.wr_en, F1.rd_en} == 2'b01) && !F1.empty)
			count <= count - 1;
		else if(({F1.wr_en, F1.rd_en} == 2'b11) && F1.full)
            count <= count - 1;
        else if(({F1.wr_en, F1.rd_en} == 2'b11) && F1.empty)
            count <= count + 1;
	end
end

assign F1.full = (count == FIFO_DEPTH)? 1 : 0;
assign F1.empty = (count == 0)? 1 : 0;
assign F1.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; // FIFO_DEPTH-1 instead of FIFO_DEPTH-2
assign F1.almostempty = (count == 1)? 1 : 0;
//************************************************************************
// ASSERTIONS
property prop_1;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (count== FIFO_DEPTH)|-> (F1.full==1);
endproperty

property prop_2;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (count== 0)|-> (F1.empty==1);
endproperty	

property prop_3;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (count== 1)|-> (F1.almostempty==1);
endproperty	

property prop_4;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (count== FIFO_DEPTH-1)|-> (F1.almostfull==1);
endproperty	

	property prop_5;
		@(posedge F1.clk) disable iff (F1.rst_n==0) (F1.wr_en==1 && count<FIFO_DEPTH)|=> wr_ptr==($past(wr_ptr)+3'b001) && (F1.wr_ack==1);
endproperty

	property prop_6;
		@(posedge F1.clk) disable iff (F1.rst_n==0) (F1.rd_en==1 && count!=0)|=> rd_ptr==$past(rd_ptr)+3'b001;
endproperty
	property prop_7;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (F1.rd_en==0 && F1.wr_en==1  && F1.full)|=> $stable(count);
endproperty

	property prop_8;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (F1.rd_en==1 && F1.wr_en==0  && F1.empty)|=> $stable(count);
endproperty


property prop_9;
		@(posedge F1.clk) disable iff (F1.rst_n==0) (({F1.wr_en, F1.rd_en} == 2'b10) && !F1.full)|=> count==$past(count)+4'b0001;
endproperty

property prop_10;
		@(posedge F1.clk) disable iff (F1.rst_n==0) (({F1.rd_en, F1.wr_en} == 2'b10) && !F1.empty)|=> count==$past(count)-4'b0001;
endproperty	

property prop_11;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (F1.wr_en==1 && F1.full==1)|=> F1.overflow==1;
endproperty	

	property prop_12;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (F1.rd_en==1 && F1.empty==1)|=> F1.underflow==1;
endproperty

	property prop_13;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (F1.rd_en==1 && F1.wr_en==1 && F1.full)|=> ($stable(wr_ptr)&&rd_ptr==$past(rd_ptr))+3'b001;
endproperty
	
	property prop_14;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (F1.rd_en==1 && F1.wr_en==1 && F1.empty)|=> ($stable(rd_ptr)&&wr_ptr==$past(wr_ptr))+3'b001;
endproperty

		property prop_15;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (F1.rd_en==1 && F1.wr_en==1 && !F1.empty &&!F1.full)|=> $stable(count);
endproperty

			property prop_16;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (F1.rd_en==0 && F1.wr_en==1  && F1.almostfull)|=>  count==FIFO_DEPTH;
endproperty
		property prop_17;
	@(posedge F1.clk) disable iff (F1.rst_n==0) (F1.rd_en==1 && F1.wr_en==0  && F1.almostempty)|=>  count==0;
endproperty


A_prop_1:assert property(prop_1);
A_prop_2:assert property(prop_2);
A_prop_3:assert property(prop_3);
A_prop_4:assert property(prop_4);
A_prop_5:assert property(prop_5);
A_prop_6:assert property(prop_6);
A_prop_7:assert property(prop_7);
A_prop_8:assert property(prop_8);
A_prop_9:assert property(prop_9);
A_prop_10:assert property(prop_10);
A_prop_11:assert property(prop_11);
A_prop_12:assert property(prop_12);
A_prop_13:assert property(prop_13);
A_prop_14:assert property(prop_14);
A_prop_15:assert property(prop_15);
A_prop_16:assert property(prop_16);
A_prop_17:assert property(prop_17);


cvr_prop_1:cover property(prop_1);
cvr_prop_2:cover property(prop_2);
cvr_prop_3:cover property(prop_3);
cvr_prop_4:cover property(prop_4);
cvr_prop_5:cover property(prop_5);
cvr_prop_6:cover property(prop_6);
cvr_prop_7:cover property(prop_7);
cvr_prop_8:cover property(prop_8);
cvr_prop_9:cover property(prop_9);
cvr_prop_10:cover property(prop_10);
cvr_prop_11:cover property(prop_11);
cvr_prop_12:cover property(prop_12);
cvr_prop_13:cover property(prop_13);
cvr_prop_14:cover property(prop_14);
cvr_prop_15:cover property(prop_15);
cvr_prop_16:cover property(prop_16);
cvr_prop_17:cover property(prop_17);

endmodule