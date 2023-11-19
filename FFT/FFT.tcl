add_force rst {1 0ns} {0 1ps} {1 100ns}
add_force clk {0 0ns} {1 50ns} -repeat_every 100ns
#add_force s_clk {0 0ns} {1 500ns} -repeat_every 4us
add_force aen 0
add_force md_trdy 1
add_force sd_tval 0
add_force sd_tlast 0
add_force sc_tval 0

add_force sc_tdata -radix dec 0

add_force delta_1 -radix dec 8  
add_force delta_2 -radix dec 240

run 100us

add_force aen 1
add_force sd_tval 1
run 102300ns
add_force sd_tlast 1
run 100ns
add_force aen 0
add_force sd_tval 0
add_force sd_tlast 0
run 300us