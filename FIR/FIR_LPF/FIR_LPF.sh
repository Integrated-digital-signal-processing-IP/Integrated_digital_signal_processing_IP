#!/bin/bash

topModule="tb_FIR_LPF"
subModule="usin11_rom.v usin12_rom.v FIR_LPF.v addr11_gen.v addr12_gen.v func_gen.v tb_FIR_LPF.v"
iverilog -s $topModule -o FIR_LPF $subModule
vvp ./FIR_LPF