module tb_func_gen;

    localparam SIM_TIME = 100000;

    reg                     clk;
    reg                     s_clk;
    reg                     rst;

    reg             [19:0]  f_set;
    reg                     w_set;
    reg                     a_set;

    wire    signed  [11:0]  wave;

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
    always #5 clk = ~clk;           // 100MHz
    always #25 s_clk = ~s_clk;      // 20MHz

    //set initial values
    initial begin
        clk = 1'b0;
        s_clk = 1'b0;
        rst = 1'b1;
        
        f_set = 20'd100000;         // 100KHz
        w_set = 1'b0;               // sine wave
        a_set = 1'b1;               // 2V (0~4095)     

        #10
        rst = 1'b0;
        #10
        rst = 1'b1;

        #50000;
        f_set = 20'd1000000;        // 1MHz
        w_set = 1'b1;               // cos wave
        a_set = 1'b0;               // 1V (0~4095)     
    end

    //creat dump file
    initial begin
        $dumpfile("func_gen.vcd");
		$dumpvars(0, tb_func_gen);

        #(SIM_TIME);
        $finish;
    end

endmodule