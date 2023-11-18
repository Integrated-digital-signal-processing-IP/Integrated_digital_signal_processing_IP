#!/bin/bash

topModule="tb_Filter_core"
subModule="usin_rom.v IIR_BPF.v addr_gen.v func_gen.v FIR_LPF.v FIR_HPF.v Filter_core.v tb_Filter_core.v"
iverilog -s $topModule -o Filter_core $subModule
vvp ./Filter_core