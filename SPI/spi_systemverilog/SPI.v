module SPI (clk,rst_n,MOSI,MISO,SS_n,rx_data,rx_valid,tx_data,tx_valid);
parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
parameter READ_ADDRESS=3'b011;
parameter READ_DATA=3'b100;
input MOSI,SS_n,clk,rst_n;
 output  rx_valid;
output reg [9:0] rx_data;
input [7:0] tx_data;
input tx_valid;
reg  rd_address_first;

output reg MISO;

reg[3:0] count_1;
reg [3:0]count_2;
reg [3:0] count_3;
(* fsm_encoding = "one_hot" *)
reg [2:0] ns,cs;

always@(cs,MOSI,SS_n)
begin
case (cs)
    IDLE:begin
        if(!SS_n)
        ns=CHK_CMD;
        else
        ns= IDLE;

    end

    CHK_CMD:begin
        if(SS_n==0)
        begin
        if(MOSI==0)
        ns=WRITE;
        else
        if(rd_address_first==0)
        begin
        ns=READ_ADDRESS;
        
        end
        else
        begin
        ns=READ_DATA;
       
        end
       

        end
        else
        ns= IDLE;



    end

    WRITE:begin
        if(SS_n)
        ns= IDLE;
        else
        begin
        if(count_1 <10)
        ns= WRITE;
        
        end

    end

    READ_ADDRESS:begin
       
        if(SS_n)
        ns=IDLE;
        else
        begin
            if(count_2 < 10)
            ns=READ_ADDRESS;
    end 
    end
    READ_DATA: begin
        
         if(SS_n)
        ns=IDLE;
        else
        begin
            if(count_3 < 8)
            ns=READ_DATA;
    end 
    end

    default: ns= IDLE;
endcase    
end

always@(posedge clk or negedge rst_n)
begin
  if(!rst_n)
   cs<=IDLE; 
else
cs<= ns;

end

always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
begin
  rx_data<=0;
  // rx_valid<=0;
  count_1<=0;
   count_2<=0;
  rd_address_first<=0;
  count_3<=0;
/* MISO<=0;*/
    
end
else
case(cs)
IDLE:begin
  /*rx_valid<=0;*/
  count_1<=0;
 count_2<=0;
  count_3<=0;  
end
 
CHK_CMD:begin
    // rx_valid<=0;
    count_1<=0;
   count_2<=0;
    count_3<=0;
    
end

WRITE: begin
    if(count_1<10)
    begin
        rx_data<={rx_data[8:0],MOSI};
        count_1<=count_1+1;
    end
       /* else
        rx_valid<=1;*/

    end


READ_ADDRESS: begin
 rd_address_first<=1;
    if(count_2<10)
    begin
        rx_data<={rx_data[8:0],MOSI };
       count_2<=count_2+1;
    end
    /*    else
        rx_valid<=1;*/

    end
    READ_DATA: begin
    rd_address_first<=0;
    if(count_2<10)
    begin
        rx_data<={rx_data[8:0],MOSI };
       count_2<=count_2+1;
    end
        else
        begin
       /* rx_valid<=1;*/
        if(count_3 < 8 )
        begin
            if(tx_valid==1)
            begin
            MISO <= tx_data[7-count_3];
            count_3<=count_3+1;
            end

        end
        end    
    
    end
    default:begin
  /* rx_valid<=0;*/
  count_1<=0;
 count_2<=0;
  count_3<=7;  
end 
    endcase
end

assign rx_valid= ((count_2==10 || count_1==10) && cs!=IDLE)? 1:0;

endmodule
