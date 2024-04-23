package constraint_package;
	class constranint_class;
		logic MOSI, SS_n,rst_n;
		constraint c1 {
			rst_n dist {1:=98,0:=2};
		}
		constraint c2 {
			SS_n dist {1:=99,0:=1};
		}
		constraint c3 {
			SS_n dist {0:=99,1:=1};
		}
		constraint c4 {
			MOSI dist {1:=50,0:=50};
		}
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
		}

	endclass
endpackage