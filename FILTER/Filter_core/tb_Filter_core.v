`timescale 1ns/1ps

module tb_Filter_core;

    localparam SIM_TIME = 24000000;

    reg                     clk;
    reg                     rst;
    reg                     fun_gen_f_s;
    reg                     fir_f_s;
    reg                     iir_f_s;

    reg             [2:0]   mode_sel;
    reg             [18:0]  f_set;
    reg                     w_set;
    reg             [2:0]   a_set;

    wire    signed  [15:0]  dout;

    FILTER_CORE FILTER_CORE
    (
        //INPUT
        .clk(clk)                           ,
        .rst(rst)                           ,
        .fun_gen_f_s(fun_gen_f_s)           ,
        .fir_f_s(fir_f_s)                   ,
        .iir_f_s(iir_f_s)                   ,
        
        .mode_sel(mode_sel)                 ,
        .f_set(f_set)                       ,
        .w_set(w_set)                       ,
        .a_set(a_set)                       ,                 

        //OUTPUT
        .dout(dout)
    );

    /* clock generate */
    always #250     clk = ~clk;
    always #500     fun_gen_f_s = ~fun_gen_f_s;
    always #25000   fir_f_s = ~fir_f_s;
    always #12500   iir_f_s = ~iir_f_s;

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        fun_gen_f_s = 1'b0;
        fir_f_s = 1'b0;
        iir_f_s = 1'b0;
        
        #10
        rst = 1'b0;
        #10
        rst = 1'b1;

        /* LPF : 200Hz, sin, 20V */
        mode_sel = 3'b001;
        f_set = 19'd200;
        w_set = 1'b0;
        a_set = 3'b101;

        #8000000
        /* HPF : 1800Hz, cos, 10V */
        mode_sel = 3'b010;
        f_set = 19'd2000;
        w_set = 1'b0;
        a_set = 3'b101;

        #8000000
        /* BPF : 1000Hz, sin, 20V */
        mode_sel = 3'b100;
        f_set = 19'd1020;
        w_set = 1'b0;
        a_set = 3'b101;
    end

    //creat dump file
    initial begin
        $dumpfile("Filter_core.vcd");
        $dumpvars(0, tb_Filter_core);

        #(SIM_TIME);
        $finish;
    end

endmodule