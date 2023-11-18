#!/bin/bash

topModule="tb_clk_20k_gen"
subModule="clk_20k_gen.v tb_clk_20k_gen.v"
iverilog -s $topModule -o clk_20k_gen $subModule
vvp ./clk_20k_gen