vlib work
vlog -f list.txt
vsim -voptargs=+acc work.UART_RX_TB
add wave *
add wave -position insertpoint  \
sim:/UART_RX_TB/DUT/u_fsm/bit_cnt \
sim:/UART_RX_TB/DUT/u_fsm/edge_cnt \
sim:/UART_RX_TB/DUT/u_fsm/current_state \
sim:/UART_RX_TB/DUT/u_fsm/next_state
add wave -position insertpoint  \
sim:/UART_RX_TB/DUT/u_deserializer/deser_en \
sim:/UART_RX_TB/DUT/u_deserializer/sampled_bit
add wave -position insertpoint  \
sim:/UART_RX_TB/DUT/u_fsm/par_chk_en
add wave -position insertpoint  \
sim:/UART_RX_TB/DUT/u_parity_check/parity_bit
add wave -position insertpoint  \
sim:/UART_RX_TB/DUT/u_start_check/strt_glitch
add wave -position insertpoint  \
sim:/UART_RX_TB/DUT/u_fsm/strt_chk_en

run -all