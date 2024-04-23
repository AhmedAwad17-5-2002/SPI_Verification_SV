package coverage_package;
	class coverage_class;
		logic MOSI,SS_n,rst_n,MISO;
		logic [7:0] rx_data,tx_data;
		covergroup cg();
			MISO_coverage:coverpoint MISO{
			bins ZERO = {0};
			bins ONE  = {1};
			bins WRITE_adderss = (0 => 0 => 0);
			bins WRITE_data = (0 => 0 => 1);
			bins READ_adderss = (1 => 1 => 0);
			bins READ_data = (1 => 1 => 1);
			}
			SS_n_coverage:coverpoint SS_n{
			bins ZERO = {0};
			bins ONE  = {1};
			bins ONE_to_ZERO = (1 => 0);
			bins ZERO_to_ONE  = (0 => 1);
			}
			rst_n_coverage:coverpoint rst_n{
			bins ZERO = {0};
			bins ONE  = {1};
			}
			MOSI_coverage:coverpoint MOSI{
			bins ZERO = {0};
			bins ONE  = {1};
			}
			rx_data_coverage:coverpoint rx_data;
			tx_data_coverage:coverpoint tx_data;
			cross_1:cross SS_n_coverage,rst_n_coverage {
			bins bin1 = binsof(SS_n_coverage.ONE) && binsof(rst_n_coverage.ZERO);
			bins bin2 = binsof(SS_n_coverage.ONE_to_ZERO) && binsof(rst_n_coverage.ZERO);
			bins bin3 = binsof(SS_n_coverage.ONE_to_ZERO) && binsof(rst_n_coverage.ONE);
			option.cross_auto_bin_max = 0;
			}
			cross_2:cross MISO_coverage,SS_n_coverage{
			bins bin1 = binsof(MISO_coverage.WRITE_adderss) && binsof(SS_n_coverage.ZERO);
			bins bin2 = binsof(MISO_coverage.WRITE_data) && binsof(SS_n_coverage.ZERO);
			bins bin3 = binsof(MISO_coverage.READ_adderss) && binsof(SS_n_coverage.ZERO);
			bins bin4 = binsof(MISO_coverage.READ_data) && binsof(SS_n_coverage.ZERO);
			option.cross_auto_bin_max = 0;
			}
		endgroup
		function new();
			cg= new();
		endfunction
	endclass
endpackage