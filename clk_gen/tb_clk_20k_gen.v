`timescale 1ns/1ps

module tb_clk_20k_gen;

    localparam  SIM_TIME= 10000000;
    
    reg         clk;
    reg         rst;

    wire        clk_20k;

    clk_20k_gen clk_20k_gen
    (
        .clk(clk)           ,
        .rst(rst)           ,

        .clk_20k(clk_20k)    
    );

    always #50 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b1;

        #10
        rst = 1'b0;
        #10
        rst = 1'b1;
    end

    initial begin
        $dumpfile("clk_20k_gen.vcd");
        $dumpvars(0, tb_clk_20k_gen);

        #(SIM_TIME);
        $finish;
    end

endmodule