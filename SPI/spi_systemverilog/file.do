quit -sim
vlib work
vlog SPI_coverage.sv SPI_tb.sv SPI_SLAVE.v SPI_RAM.v  Assertion_spi.sv SPI_Wrapper.v SPI.v RAM_pr2.v Master.v +cover -covercells
vsim -voptargs=+acc work.SPI_tb -cover
add wave *
coverage save SPI_tb.ucdb -onexit -du SIP_SLAVE -du SPI_RAM
run -all
quit -sim 
vcover report SPI_tb.ucdb -all -annotate -details -output testing.txt