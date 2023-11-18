module FILTER_CORE
(
    input                   clk         ,
    input                   rst         ,
    input                   fun_gen_f_s ,       // 1MHz , #500  
    input                   fir_f_s     ,       // 20kHz, #25000
    input                   iir_f_s     ,       // 40kHz, #12500

    input           [2:0]   mode_sel    ,       // 00 : LPF, 01 : HPF, 10 : BPF, 11 : FFT   -> sw0~3
    input           [18:0]  f_set       ,       // 0~50kHz
    input                   w_set       ,       // 0 : sin, 1 : cos
    input           [2:0]   a_set       ,       // 000 : 1V, 001 : 2V, 010 : 4V, 011 : 5V, 100 : 10V, 101 : 20V

    output  signed  [15:0]  dout
);
    reg     signed  [15:0]  dout_r;

    wire    signed  [11:0]  wave_o;

    wire    signed  [11:0]  lpf_wave_o;
    wire    signed  [11:0]  hpf_wave_o;
    wire    signed  [15:0]  bpf_wave_o;

    wire    signed  [11:0]  fir_wave_i;
    wire     signed  [15:0]  iir_wave_i;

    assign fir_wave_i = wave_o;
    assign iir_wave_i = {wave_o, 4'b0};

    func_gen FUNC_GEN_U0
    (
        .clk(clk)           ,
        .rst(rst)           ,
        .s_clk(fun_gen_f_s) ,
        
        .f_set(f_set)       ,
        .w_set(w_set)       ,
        .a_set(a_set)       ,

        .wave(wave_o)
    );

    FIR_LPF FIR_LPF_U0
    (   
        //INPUT
        .clk(clk)           ,
        .rst(rst)           ,
        .en(mode_sel[0])    ,
        .f_s(fir_f_s)       ,
        .din(fir_wave_i)    ,

        //OUTPUT
        .dout(lpf_wave_o)
    );

    FIR_HPF FIR_HPF_U0
    (
        //INPUT
        .clk(clk)           ,
        .rst(rst)           ,
        .en(mode_sel[1])    ,
        .f_s(fir_f_s)       ,
        .din(fir_wave_i)    ,

        //OUTPUT
        .dout(hpf_wave_o)
    );

    /******************************************************/

    IIR_BPF IIR_BPF_U0
    (
        //INPUT
        .clk(clk)           ,
        .rst(rst)           ,
        .en(mode_sel[2])    ,
        .f_s(iir_f_s)       ,
        .din(iir_wave_i)    ,

        //OUTPUT
        .dout(bpf_wave_o)
    );

    assign dout =   (mode_sel == 3'd1) ? {lpf_wave_o, 4'b0} :
                    (mode_sel == 3'd2) ? {hpf_wave_o, 4'b0} :
                    (mode_sel == 3'd4) ? bpf_wave_o         :
                    16'dx;

endmodule