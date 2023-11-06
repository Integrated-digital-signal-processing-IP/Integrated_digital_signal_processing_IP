`timescale 1ns/1ps
module tb_func_gen;

    localparam SIM_TIME = 3000000;

    reg                     clk;
    reg                     s_clk;
    reg                     rst;

    reg             [18:0]  f_set;
    reg                     w_set;
    reg             [2:0]   a_set;

    wire    signed  [15:0]  wave;

    // function generator instant
    func_gen func_gen
    (   
        //INPUT
        .clk(clk)               ,
        .s_clk(s_clk)           ,
        .rst(rst)               ,

        .f_set(f_set)           ,
        .w_set(w_set)           ,
        .a_set(a_set)           ,

        //OUTPUT
        .wave(wave)         
    );

    // clock generate
    always #50 clk = ~clk;          //  10MHz
    always #500 s_clk = ~s_clk;     //  1MHz

    //set initial values
    initial begin
        clk = 1'b0;
        s_clk = 1'b0;
        rst = 1'b1;
        
        f_set = 19'd10000;          // 100KHz
        w_set = 1'b0;               // sine wave
        a_set = 3'd0;               // 2V (0~4095)     

        #10
        rst = 1'b0;
        #10
        rst = 1'b1;

        #500000;
        f_set = 19'd48000;          // 50MHz
        w_set = 1'b1;               // cos wave
        a_set = 3'd1;               // 1V (0~4095)     

        #500000;
        f_set = 19'd48000;          // 50MHz
        w_set = 1'b1;               // cos wave
        a_set = 3'd2;               // 1V (0~4095)   

        #500000;
        f_set = 19'd48000;          // 50MHz
        w_set = 1'b1;               // cos wave
        a_set = 3'd3;               // 1V (0~4095)   

        #500000;
        f_set = 19'd48000;          // 50MHz
        w_set = 1'b1;               // cos wave
        a_set = 3'd4;               // 1V (0~4095)  

        #500000;
        f_set = 19'd48000;          // 50MHz
        w_set = 1'b1;               // cos wave
        a_set = 3'd5;               // 1V (0~4095)  
    end

    //creat dump file
    initial begin
        $dumpfile("func_gen.vcd");
		$dumpvars(0, tb_func_gen);

        #(SIM_TIME);
        $finish;
    end

endmodule