add_force rst {1 0ns} {0 1ps} {1 1000ns}
add_force clk {0 0ns} {1 250ns} -repeat_every 500ns
add_force fun_gen_f_s {0 0ns} {1 500ns} -repeat_every 1000ns
add_force fir_f_s {0 0ns} {1 25us} -repeat_every 50us
add_force iif_f_s {0 0ns} {1 12.5us} -repeat_every 25us

add_force mode_set -radix dec 1
add_force f_set -radix dec 200
add_force w_set -radix dec 0
add_force a_set -radix dec 5
run 20ms

add_force mode_set -radix dec 2
add_force f_set -radix dec 1800
add_force w_set -radix dec 1
add_force a_set -radix dec 4
run 20ms

add_force mode_set -radix dec 4
add_force f_set -radix dec 1000
add_force w_set -radix dec 0
add_force a_set -radix dec 5
run 20ms

