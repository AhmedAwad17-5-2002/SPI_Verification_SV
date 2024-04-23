package FIFO_coverage_pkg;
	import FIFO_transaction_pkg::*;
	
	class FIFO_coverage ;
		FIFO_transaction F_cvg_txn=new();
        function void sample_data(FIFO_transaction F_txn);
        	F_cvg_txn = F_txn;
            cg.sample();
        endfunction : sample_data

        covergroup cg();
           WR : coverpoint F_cvg_txn.wr_en{
             bins ZERO={0};
             bins ONE={1};
           }
           RD : coverpoint F_cvg_txn.rd_en{
             bins ZERO={0};
             bins ONE={1};
           }
           F  : coverpoint F_cvg_txn.full{
             bins ZERO={0};
             bins ONE={1};
           }
           E  : coverpoint F_cvg_txn.empty{
             bins ZERO={0};
             bins ONE={1};
           }
           A_F: coverpoint F_cvg_txn.almostfull{
             bins ZERO={0};
             bins ONE={1};
           }
           A_E: coverpoint F_cvg_txn.almostempty{
             bins ZERO={0};
             bins ONE={1};
           }
           AK : coverpoint F_cvg_txn.wr_ack{
             bins ZERO={0};
             bins ONE={1};
           }
           OVER_F: coverpoint F_cvg_txn.overflow{
             bins ZERO={0};
             bins ONE={1};
           }
           UNDER_F: coverpoint F_cvg_txn.underflow{
             bins ZERO={0};
             bins ONE={1};
           }
 
           CROSS_COV : cross WR,RD,F,E,A_F,A_E,AK,OVER_F,UNDER_F {


             bins A1 = binsof(WR.ZERO) && binsof(RD.ZERO);
             bins A2 = binsof(WR.ONE) && binsof(RD.ONE);
             bins A3 = binsof(WR.ONE) && binsof(RD.ZERO);
             bins A4 = binsof(WR.ZERO) && binsof(RD.ONE);



             bins B1 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(AK.ZERO); 
             bins B2 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(F.ZERO);
             bins B3 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(E.ZERO) ;
             bins B4 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(OVER_F.ZERO);
             bins B5 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(UNDER_F.ZERO);
             bins B6 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(A_F.ZERO);
             bins B7 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(A_E.ZERO);



             bins C1 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(AK.ONE); 
            // bins C2 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(F.ONE);
             bins C3 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(E.ONE) ;
             bins C4 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(OVER_F.ONE);
             bins C5 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(UNDER_F.ONE);
             bins C6 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(A_F.ONE);
             bins C7 = binsof(WR.ONE) && binsof(RD.ONE)   && binsof(A_E.ONE);



             bins D1 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(AK.ZERO); 
             bins D2 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(F.ZERO);
             bins D3 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(E.ZERO) ;
             bins D4 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(OVER_F.ZERO);
             bins D5 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(UNDER_F.ZERO);
             bins D6 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(A_F.ZERO);
             bins D7 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(A_E.ZERO);



             //bins E1 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(AK.ONE); 
             bins E2 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(F.ONE);
             bins E3 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(E.ONE) ;
             //bins E4 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(OVER_F.ONE);
            // bins E5 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(UNDER_F.ONE);
             bins E6 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(A_F.ONE);
             bins E7 =  binsof(WR.ZERO) && binsof(RD.ZERO)  && binsof(A_E.ONE);



             bins F1 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(AK.ZERO); 
             bins F2 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(F.ZERO);
             bins F3 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(E.ZERO) ;
             bins F4 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(OVER_F.ZERO);
             bins F5 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(UNDER_F.ZERO);
             bins F6 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(A_F.ZERO);
             bins F7 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(A_E.ZERO);



             bins G1 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(AK.ONE); 
             bins G2 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(F.ONE);
             bins G3 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(E.ONE) ;
             bins G4 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(OVER_F.ONE);
            // bins G5 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(UNDER_F.ONE);
             bins G6 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(A_F.ONE);
             bins G7 = binsof(WR.ONE) && binsof(RD.ZERO)  && binsof(A_E.ONE);



             bins H1 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(AK.ZERO); 
             bins H2 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(F.ZERO);
             bins H3 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(E.ZERO) ;
             bins H4 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(OVER_F.ZERO);
             bins H5 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(UNDER_F.ZERO);
             bins H6 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(A_F.ZERO);
             bins H7 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(A_E.ZERO);



            // bins I1 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(AK.ONE); 
             //bins I2 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(F.ONE);
             bins I3 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(E.ONE) ;
            /* bins I4 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(OVER_F.ONE);*/
             bins I5 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(UNDER_F.ONE);
             bins I6 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(A_F.ONE);
             bins I7 = binsof(WR.ZERO) && binsof(RD.ONE)  && binsof(A_E.ONE);

             

             option.cross_auto_bin_max=0;
           }

        endgroup : cg
        function new();
          cg = new();
        endfunction
	endclass : FIFO_coverage
endpackage