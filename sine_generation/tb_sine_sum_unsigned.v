`timescale 1ns/100ps
module tb_sine_sum_unsigned;

    localparam SIM_TIME = 2500000;

    reg             rst;
    reg             clk;
    reg     [11:0]  delta_a;
    reg     [11:0]  delta_b;

    wire    [12:0]  sind_sum;   

    //sine sum unsigned module instant
    sine_sum_unsigned sine_sum_unsigned
    (
        .rst(rst)           ,
        .clk(clk)           ,
        .delta_a(delta_a)   ,
        .delta_b(delta_b)   ,

        .sind_sum(sind_sum)
    );

    //clock generate
    always #25 clk = ~clk;

    //set initial values
    initial begin
        rst = 1'b1;
        clk = 1'b0;
        delta_a = 12'd1;
        delta_b = 12'd2;

        #10
        rst = 1'b0;
        #10
        rst = 1'b1;

    end

    //creat dump file
    initial begin
        $dumpfile("sine_sum_unsigned.vcd");
		$dumpvars(0, tb_sine_sum_unsigned);

        #(SIM_TIME);
        $finish;
    end

endmodule