`timescale 1ns/1ps
module tb_IIR_BPF;

    localparam SIM_TIME = 240000000;     // Simulation time

    reg                     pl0, pl1;

    reg                     clk;        // clock
    reg	                    rst;        // asynchonus reset
    reg                     s_clk;      // func_gen sampling clock
    reg                     f_s;        // Low pass filter sampling clock

    reg             [18:0]  f_set_a;    // wave_a freq
    reg                     w_set_a;    // wave_a type (sin or cos)
    reg             [2:0]   a_set_a;    // wave_a amplitude

    wire	        [11:0]	uwave_a;    // func_gen_a output wave (unsigned)
    wire    signed	[11:0]	swave_a;    // signed wave_a

    reg	            [15:0]	di_iir;     // FIR LPF input
    wire	        [15:0]	do_iir_bpf; // FIR LPF output


    // Function generator A instant
    func_gen func_gen_a
    (   
        // INPUT
        .clk(clk)               ,
        .s_clk(s_clk)           ,
        .rst(rst)               ,
        .f_set(f_set_a)         ,
        .w_set(w_set_a)         ,
        .a_set(a_set_a)         ,

        // OUTPUT
        .wave(swave_a)       
    );  

    // FIR high pass filter instant
    IIR_BPF IIR_BPF
    (   
        //INPUT 
        .clk(clk)               ,
        .rst(rst)               ,
        .f_s(f_s)               ,
        .din(di_iir)            ,

        // OUTPUT
        .dout(do_iir_bpf)
    );
    
    
    // Clock generate
    always #250     clk = ~clk;           // 100MHz
    always #1000    s_clk = ~s_clk;       // 1MHz
    always #12500   f_s = ~f_s;             // 20kHz

    always @ (posedge clk, negedge rst) begin
        if (rst == 0) begin
            begin
                pl0 <= 0;
                pl1 <= 0;
                di_iir <= 0;
            end
        end 
        else begin 
            begin
                pl0 <= f_s;
                pl1 <= pl0;
                if (pl1 & ~pl0)
                    di_iir <= {swave_a, 4'd0};
            end
        end
    end

    // Set initial values
    initial begin
        rst = 1'b1;
        clk = 1'b0;
        s_clk = 1'b0;
        f_s = 1'b0;
        
        f_set_a = 19'd400;
        w_set_a = 1'b0;         // sin
        a_set_a = 3'd5;         // 2V   

        #10
        rst = 1'b0;
        #10
        rst = 1'b1;

        #85500000
        f_set_a = 19'd1020;

        #80000000
        f_set_a = 19'd1800;
    end

    //creat dump file
    initial begin
        $dumpfile("IIR_BPF.vcd");
        $dumpvars(0, tb_IIR_BPF);

        #(SIM_TIME);
        $finish;
    end

endmodule