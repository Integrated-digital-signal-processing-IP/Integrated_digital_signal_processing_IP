#!/bin/bash

topModule="tb_func_gen"
subModule="addr_gen.v usin_rom.v func_gen.v tb_func_gen.v"
iverilog -s $topModule -o func_gen $subModule
vvp ./func_gen