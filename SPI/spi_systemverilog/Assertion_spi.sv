module assertion(SS_n,MOSI,rx_valid,tx_valid,rst_n,clk,cs,ns,rd_flag,MISO_countout,state_countout,counter_enable,counter_done,MISO_CountEn);

parameter IDLE=3'b000;
parameter READ_DATA=3'b001;
parameter READ_ADD=3'b011;
parameter CHK_CMD=3'b111;
parameter WRITE=3'b100;

input SS_n,MOSI,rst_n,clk;
 input logic [2:0] cs,ns;
 input logic rd_flag; // to check if READ_ADD state has been executed or not (high if executed)
 input logic [3:0] state_countout;
 input logic[2:0] MISO_countout;
input logic counter_enable; // to count 10 clock cycles while recieving data
input logic counter_done; // flag sent by the counter, high when 10 cycles are completed
input logic MISO_CountEn; 
input logic rx_valid;
input logic tx_valid;

 /*input logic [4:0] count_once;
 input logic read_once;*/
property prop_1;
@(posedge clk) (SS_n==1) |=> cs==IDLE;  
endproperty
	
property prop_2;
		@(posedge clk) disable iff(!rst_n) (SS_n==0 && cs==CHK_CMD && MOSI==0) |=>  cs==WRITE;
	endproperty
property prop_3;
		@(posedge clk) disable iff(!rst_n) (SS_n==0 && cs==CHK_CMD && !rd_flag && MOSI==1) |=>  cs==READ_ADD;
	endproperty	

property prop_4;
		@(posedge clk) disable iff(!rst_n) (SS_n==0 && cs==CHK_CMD && rd_flag && MOSI==1) |=>  cs==READ_DATA;
	endproperty

property prop_5;
	@(posedge clk) disable iff(!rst_n) (SS_n==0 && ns==CHK_CMD ) |=>  cs==CHK_CMD;
	endproperty
		


property prop_6;
	@(posedge clk) disable iff(!rst_n) (cs==WRITE && SS_n==0 && counter_enable==1 ) |=> state_countout==$past(state_countout)+4'b0001;
endproperty

property prop_7;
	@(posedge clk) disable iff(!rst_n) (cs==READ_DATA && SS_n==0 && MISO_CountEn==1 ) |=> MISO_countout==$past(MISO_countout)-3'b001;
endproperty

property prop_8;
	@(posedge clk) disable iff(!rst_n) (rx_valid==1 && cs==READ_DATA) |=> tx_valid==1;
endproperty

property prop_9;
	@(posedge clk) disable iff(!rst_n) (state_countout==10 && ns!=IDLE) |=> rx_valid==1;
endproperty



	always_comb
begin
if(!rst_n)
assert final(cs==IDLE);
end

sv_prop1:assert property(prop_1);
sv_prop2:assert property(prop_2);
sv_prop3:assert property(prop_3);
sv_prop4:assert property(prop_4);
sv_prop5:assert property(prop_5);
sv_prop6:assert property(prop_6);
sv_prop7:assert property(prop_7);
sv_prop8:assert property(prop_8);
sv_prop9:assert property(prop_9);

cvr_prop1:assert property(prop_1);
cvr_prop2:assert property(prop_2);
cvr_prop3:assert property(prop_3);
cvr_prop4:assert property(prop_4);
cvr_prop5:assert property(prop_5);
cvr_prop6:assert property(prop_6);
cvr_prop7:assert property(prop_7);
cvr_prop8:assert property(prop_8);
cvr_prop9:assert property(prop_9);
endmodule
