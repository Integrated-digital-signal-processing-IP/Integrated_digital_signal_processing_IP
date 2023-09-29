#!/bin/bash

topModule="tb_func_gen"
subModule="addr11_gen.v addr12_gen.v usin11_rom.v usin12_rom.v func_gen.v tb_func_gen.v"
iverilog -s $topModule -o func_gen $subModule
vvp ./func_gen