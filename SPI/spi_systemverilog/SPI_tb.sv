import constraint_package::*;
import coverage_package::*;


module SPI_tb();
	logic MOSI, SS_n,clk,rst_n;
	logic MISO,MISO_ref;
	int error_count,correct_count,count;
	bit WRITE_sig;
	logic [9:0] din_r;
	parameter IDLE=3'b000;
	parameter READ_DATA=3'b001;
	parameter READ_ADD=3'b011;
	parameter CHK_CMD=3'b111;
	parameter WRITE=3'b100;
	//bit WRITE_addr,READ_addr,WRITE,READ;

	SPI_Wrapper SPI(MISO, MOSI,SS_n,rst_n,clk);
	Master golden_model(SS_n,MOSI,MISO_ref,clk,rst_n);

bind SPI_Wrapper assertion A (SS_n,MOSI,SPI.S.rx_valid,SPI.S.tx_valid,rst_n,clk,SPI.S.cs,SPI.S.ns,SPI.S.rd_flag,SPI.S.MISO_CountOut,SPI.S.state_countout,SPI.S.counter_enable,SPI.S.counter_done,SPI.S.MISO_CountEn); 
	constranint_class C = new();
	coverage_class CG = new();

	initial begin
		clk = 0;
		forever
		#1 clk = ~clk;
	end
	initial begin
		forever begin
			@(negedge clk);
			CG.SS_n = SS_n;
			CG.MOSI = MOSI;
			CG.rst_n = rst_n;
			CG.MISO = MISO;
			CG.rx_data = SPI.S.rx_data;
			CG.tx_data = SPI.S.tx_data;
			CG.cg.sample();
		end
	end

	initial begin
		/*for (int i = 0; i < 1000000; i++) begin
				if (SS_n == 0) begin
					C.constraint_mode(0);
					C.c1.constraint_mode(1);
					C.c3.constraint_mode(1);
					if (SPI.S.cs == WRITE && WRITE_sig ==0) begin
						C.c2.constraint_mode(1);

						count = count+1;
						if(count > 2) begin
							C.c2.constraint_mode(0);
							C.c4.constraint_mode(1);
						end
						if(count == 10) begin
							WRITE_sig = 1;
						end
						assert(C.randomize());

					end
					else if (SPI.S.cs == WRITE && WRITE_sig ==1) begin
						C.c2.constraint_mode(1);
						count = count+1;
						if(count ==2 ) begin
							C.c2.constraint_mode(0);
							C.c8.constraint_mode(1);
						end
						if(count > 2) begin
							C.c2.constraint_mode(0);
							C.c8.constraint_mode(0);
							C.c4.constraint_mode(1);
						end
						if(count == 10) begin
							WRITE_sig = 0;
						end
						assert(C.randomize());
					end
					if (SPI.S.cs == READ_ADD) begin
						C.c8.constraint_mode(1);
						count = count+1;
						if(count == 2 ) begin
							C.c8.constraint_mode(0);
							C.c2.constraint_mode(1);
						end
						if(count > 2) begin
							C.c8.constraint_mode(0);
							C.c2.constraint_mode(0);
							C.c4.constraint_mode(1);
						end
						assert(C.randomize());
					end
					if (SPI.S.cs == READ_DATA) begin
						C.c8.constraint_mode(1);
						count = count+1;
						if(count > 2) begin
							C.c8.constraint_mode(0);
							C.c4.constraint_mode(1);
						end
					end
					assert(C.randomize());
				end
				else begin
					C.constraint_mode(1);
					C.c8.constraint_mode(0);
					C.c2.constraint_mode(0);
					count = 0;
					assert(C.randomize());
				end
				MOSI = C.MOSI;
				SS_n = C.SS_n;
				rst_n = C.rst_n;
				check_data();
			end*/
			C.WRITE_SIG = 0;
			for(int i=0;i<30000;i=i+1) begin  
                    C.constraint_mode(0); 
                    C.rand_mode(1);
				    C.din.rand_mode(0);
                    C.c5.constraint_mode(1);
                    C.c1.constraint_mode(1);
                   //C.c2.constraint_mode(1);
                    C.c3.constraint_mode(1);
                    assert(C.randomize());
                    rst_n=C.rst_n;
                    SS_n=C.SS_n;
                    MOSI=C.MOSI;
                    @(negedge clk);
                    C.cs=e_CS'(SPI.S.cs);

                    if(SPI.S.cs!=IDLE && SPI.S.cs!=CHK_CMD) begin
				    C.constraint_mode(0);
					C.c4.constraint_mode(1);
					C.rand_mode(0);
				    C.din.rand_mode(1);
				    assert(C.randomize());
				    din_r = C.din;

				    for(int j=9;j>=0;j=j-1) begin
				    	MOSI=C.din[j];
				    	@(negedge clk);
				    end
				    if(SPI.S.cs==READ_DATA) begin
				    	for (int i = 0; i < 9; i++) begin
				    		check_data();
				    	end
				    end
				    if(SPI.S.cs==WRITE)
				    	C.WRITE_SIG= ~ C.WRITE_SIG;
				    C.constraint_mode(0);
				    C.c2.constraint_mode(1);
				   	C.SS_n.rand_mode(1);
				    assert(C.randomize());
				    SS_n = C.SS_n;
				    @(negedge clk);


          end

			end
		
		$display("error_count = %0d and correct_count = %0d",error_count,correct_count);
		$stop;
	end

	task check_data();
		@(negedge clk);
		if(MISO_ref !== MISO) begin
			error_count = error_count + 1;
			$display("ERROR AT %0t",$time);
		end
		else
		correct_count = correct_count + 1;		
	endtask	
endmodule