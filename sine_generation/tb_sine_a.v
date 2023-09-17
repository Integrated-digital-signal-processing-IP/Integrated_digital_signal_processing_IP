`timescale 1ns/100ps
module tb_sine_a;

    localparam SIM_TIME = 2500000;

    reg             rst;
    reg             clk;
    reg     [11:0]  delta;

    wire    [11:0]  sind;   

    //sine_a module instant
    sine_a sine_a
    (
        .rst(rst)       ,
        .clk(clk)       ,
        .delta(delta)   ,

        .sind(sind)
    );

    //clock generate
    always #25 clk = ~clk;

    //set initial values
    initial begin
        rst = 1'b1;
        clk = 1'b0;
        delta = 12'd1;

        #10
        rst = 1'b0;
        #10
        rst = 1'b1;

        #1000000
        delta = 12'd2;
    end

    //creat dump file
    initial begin
        $dumpfile("sine_a.vcd");
		$dumpvars(0, tb_sine_a);

        #(SIM_TIME);
        $finish;
    end

endmodule