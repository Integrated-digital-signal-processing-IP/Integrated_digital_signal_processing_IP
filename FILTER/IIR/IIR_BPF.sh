#!/bin/bash

topModule="tb_IIR_BPF"
subModule="usin_rom.v IIR_BPF.v addr_gen.v func_gen.v tb_IIR_BPF.v"
iverilog -s $topModule -o IIR_BPF $subModule
vvp ./IIR_BPF