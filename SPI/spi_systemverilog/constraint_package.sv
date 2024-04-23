package constraint_package;
	typedef enum logic [2:0] {IDLE=0,CHK=7,WRITE=4,READ_ADD=3,READ_DATA=1} e_CS;
	
	class constranint_class;
		rand logic MOSI,SS_n,rst_n;
	    e_CS  cs;
	    bit  WRITE_SIG;
		rand logic [9:0] din;
		constraint c1 {
			rst_n dist {1:=98,0:=2};
		}
		constraint c2 {
			SS_n dist {1:=98,0:=2};
		}
		constraint c3 {
			SS_n dist {0:=98,1:=2};
		}
		constraint c5 {
		if(WRITE_SIG==0)
			MOSI dist {1:=50,0:=50};
		if(WRITE_SIG == 1)
			MOSI == 0;
		}
		/*
		constraint c5 {
			MOSI dist {1:=95,0:=5};
		}
		constraint c6 {
			MOSI dist {1:=5,0:=95};
		}
		constraint c7 {
			MOSI == 0;
		}
		constraint c8 {
			MOSI == 1;
		}*/
		constraint c4 {

			if(cs==WRITE && WRITE_SIG==0) 
				din[9:8]==2'b00;
			else if(cs==WRITE && WRITE_SIG==1) {
				din[9]==0;
				din[8]==1;
			}
			else if(cs==READ_ADD) {
				din[9]==1;
				din[8]==0;
			}
			else if(cs==READ_DATA) {
				din[9]==1;
				din[8]==1;
			}
		}


	endclass
endpackage