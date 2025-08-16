onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /UART_RX_TB/clk
add wave -noupdate /UART_RX_TB/rst_n
add wave -noupdate /UART_RX_TB/RX_IN
add wave -noupdate /UART_RX_TB/PAR_EN
add wave -noupdate /UART_RX_TB/PAR_TYP
add wave -noupdate /UART_RX_TB/prescale
add wave -noupdate /UART_RX_TB/P_DATA
add wave -noupdate /UART_RX_TB/par_err
add wave -noupdate /UART_RX_TB/stp_err
add wave -noupdate /UART_RX_TB/data_valid
add wave -noupdate /UART_RX_TB/par_en
add wave -noupdate /UART_RX_TB/par_typ
add wave -noupdate /UART_RX_TB/DUT/u_fsm/bit_cnt
add wave -noupdate /UART_RX_TB/DUT/u_fsm/edge_cnt
add wave -noupdate /UART_RX_TB/DUT/u_fsm/current_state
add wave -noupdate /UART_RX_TB/DUT/u_fsm/next_state
add wave -noupdate /UART_RX_TB/DUT/u_deserializer/deser_en
add wave -noupdate /UART_RX_TB/DUT/u_deserializer/sampled_bit
add wave -noupdate /UART_RX_TB/DUT/u_fsm/par_chk_en
add wave -noupdate /UART_RX_TB/DUT/u_parity_check/parity_bit
add wave -noupdate /UART_RX_TB/DUT/u_start_check/strt_glitch
add wave -noupdate /UART_RX_TB/DUT/u_fsm/strt_chk_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2822280000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {2822279600 ps} {2822280600 ps}
