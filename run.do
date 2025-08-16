vlib work
vlog -f list.txt
vsim -voptargs=+acc work.UART_RX_TB
do wave.do
run -all