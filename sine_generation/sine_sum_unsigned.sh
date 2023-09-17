#!/bin/bash

topModule="tb_sine_sum_unsigned"
subModule="sine_a.v usin_rom.v sine_sum_unsigned.v tb_sine_sum_unsigned.v"
iverilog -s $topModule -o sine_a $subModule
vvp ./sine_a