module SIP_SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid, tx_data, tx_valid);
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0] tx_data;
output reg MISO;
output rx_valid;
output reg [9:0] rx_data; 


//states
parameter IDLE=3'b000;
parameter READ_DATA=3'b001;
parameter READ_ADD=3'b011;
parameter CHK_CMD=3'b111;
parameter WRITE=3'b100;

reg [2:0] cs,ns;
reg rd_flag; // to check if READ_ADD state has been executed or not (high if executed)
reg [3:0] state_countout;
reg[2:0] MISO_CountOut;
wire counter_enable; // to count 10 clock cycles while recieving data
wire counter_done; // flag sent by the counter, high when 10 cycles are completed
wire MISO_CountEn; 
wire MISO_CountDone;


//state logic
always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    cs<= IDLE;
  end
  else begin
    cs<=ns;
  end
end  


//next state logic
always@(*) begin
  case(cs)
  IDLE: begin 
    if(~SS_n) 
      ns=CHK_CMD;
    else 
      ns=IDLE;
  end

  CHK_CMD:
    if(~SS_n) begin
      if(MOSI && ~rd_flag) begin
         ns=READ_ADD;
         //rd_flag=1;
        end
        else if(MOSI && rd_flag) begin
         ns=READ_DATA;
         //rd_flag=0;
        end
        else if(~MOSI) begin
         ns=WRITE;
        end
    end
    else if(SS_n) begin
      ns=IDLE;
    end

  READ_DATA:
    if(SS_n) begin
      ns=IDLE;
    end
    else begin
      ns=READ_DATA;
    end

  READ_ADD:
    if(SS_n) begin
      ns=IDLE;
    end
    else begin
      ns=READ_ADD;
    end
    
  WRITE:
     if(SS_n) begin
      ns=IDLE;
    end
    else begin
      ns=WRITE;
    end

    endcase
end
  
// output logic
always@ (posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    rd_flag <= 0;
  end
  if(counter_enable) begin         //
    rx_data<={rx_data[8:0], MOSI};
  end
  
  if(cs==READ_ADD && counter_done) begin
    rd_flag<=1;
  end
  else if (cs==READ_DATA && counter_done)begin
    rd_flag<=0;
  end
   
  if(MISO_CountEn) begin
    MISO<= tx_data[MISO_CountOut];
  end

end

// counters logic
always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    state_countout<=0;
    MISO_CountOut<=7; // counter_down, to send MSB firstly to master
  end
  else begin
    if(ns == IDLE) begin // else if
      state_countout<=0;
    end
    else if(counter_enable) begin
      state_countout<=state_countout+1;
    end

    if(MISO_CountEn) begin
      MISO_CountOut<=MISO_CountOut-1;
    end
    /*if (MISO_CountDone) begin
      MISO_CountOut<=7;
    end*/
  end  
end

assign counter_enable=(cs != IDLE && cs!=CHK_CMD && ~counter_done)?1:0;
assign counter_done = (state_countout==4'b1010 )?1:0;
assign MISO_CountEn=(tx_valid && cs == 3'b001 && ns != IDLE)?1:0;
//assign MISO_CountDone = (MISO_CountOut== 0)?1:0;

assign rx_valid=(counter_done)? 1:0;
endmodule
