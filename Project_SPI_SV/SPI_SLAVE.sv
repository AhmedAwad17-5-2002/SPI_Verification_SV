module SIP_SLAVE (interface_spi.spi_slave S1);
 
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
always@(posedge S1.clk or negedge S1.rst_n) begin
  if(~S1.rst_n) begin
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
    if(~S1.SS_n) 
      ns=CHK_CMD;
    else 
      ns=IDLE;
  end

  CHK_CMD:
    if(~S1.SS_n) begin
      if(S1.MOSI && ~rd_flag) begin
         ns=READ_ADD;
         //rd_flag=1;
        end
        else if(S1.MOSI && rd_flag) begin
         ns=READ_DATA;
         //rd_flag=0;
        end
        else if(~S1.MOSI) begin
         ns=WRITE;
        end
    end
    else if(S1.SS_n) begin
      ns=IDLE;
    end

  READ_DATA:
    if(S1.SS_n) begin
      ns=IDLE;
    end
    else begin
      ns=READ_DATA;
    end

  READ_ADD:
    if(S1.SS_n) begin
      ns=IDLE;
    end
    else begin
      ns=READ_ADD;
    end
    
  WRITE:
     if(S1.SS_n) begin
      ns=IDLE;
    end
    else begin
      ns=WRITE;
    end

    endcase
end
  
// output logic
always@ (posedge S1.clk or negedge S1.rst_n) begin
  if(~S1.rst_n) begin
    rd_flag <= 0;
  end
  if(counter_enable) begin         //
    S1.rx_data<={S1.rx_data[8:0], S1.MOSI};
  end
  
  if(cs==READ_ADD && counter_done) begin
    rd_flag<=1;
  end
  else if (cs==READ_DATA && counter_done)begin
    rd_flag<=0;
  end
   
  if(S1.MISO_CountEn) begin
    S1.MISO<= S1.tx_data[MISO_CountOut];
  end

end

// counters logic
always@(posedge S1.clk or negedge S1.rst_n) begin
  if(~S1.rst_n) begin
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
    /*if (S1.MISO_CountDone) begin
      S1.MISO_CountOut<=7;
    end*/
  end  
end

assign counter_enable=(cs != IDLE && cs!=CHK_CMD && ~counter_done)?1:0;
assign counter_done = (state_countout==4'b1010 )?1:0;
assign MISO_CountEn=(S1.tx_valid && cs == 3'b001 && ns != IDLE)?1:0;
//assign S1.MISO_CountDone = (S1.MISO_CountOut== 0)?1:0;

assign rx_valid=(counter_done)?1:0;
endmodule
