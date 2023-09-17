#!/bin/bash

topModule="tb_sine_a"
subModule="sine_a.v usin_rom.v tb_sine_a.v"
iverilog -s $topModule -o sine_a $subModule
vvp ./sine_a