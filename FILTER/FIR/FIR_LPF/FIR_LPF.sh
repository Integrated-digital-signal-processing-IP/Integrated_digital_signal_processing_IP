#!/bin/bash

topModule="tb_FIR_LPF"
subModule="usin_rom.v FIR_LPF.v clk_20k_gen.v addr_gen.v func_gen.v tb_FIR_LPF.v"
iverilog -s $topModule -o FIR_LPF $subModule
vvp ./FIR_LPF