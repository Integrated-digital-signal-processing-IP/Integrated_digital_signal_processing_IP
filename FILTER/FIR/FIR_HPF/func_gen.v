module func_gen
(
    input                   clk         ,
    input                   s_clk       ,   // Sampling clock frequency : 2MHz 
    input                   rst         ,

    input           [18:0]  f_set       ,   // 1 ~ 50KHz
    //input           [19:0]  f_s_set     ,   // sin wave frequency
    //input           [19:0]  f_c_set     ,   // cos wave frequency
    input                   w_set       ,   // wave type : sin, cos (sin+sin, sin+cos, cos+cos)
    input           [2:0]   a_set       ,   // amplitude : 1V, 2V 

    output  signed  [11:0]  wave        
);

    /****************************************/
    /*   w_set   |         wave type        */
    /* ------------------------------------ */
    /*     0     |            sin           */
    /*     1     |            cos           */      
    /****************************************/    

    /****************************************/
    /*   a_set   |         Amplitude        */
    /* ------------------------------------ */
    /*    000    |             1V           */
    /*    001    |             2V           */
    /*    010    |             4V           */
    /*    011    |             5V           */
    /*    100    |             10V          */
    /*    101    |             20V          */
    /****************************************/

    wire            [11:0]  addr_w;
    wire    signed  [11:0]  addr_w_i;

    wire            [11:0]  uwave_w;
    wire    signed  [11:0]  swave_w;
    reg     signed  [11:0]  wave_r;


    // Make final wave address
    assign  addr_w_i = w_set ? (addr_w + 12'd1024) : addr_w;
    assign  swave_w = uwave_w - 12'd2048;

    // Set amplitude of wave by a_set
    always @ (*) begin

        wave_r = 12'd0;

        case(a_set)
            3'b000  : wave_r = swave_w / 20;    // 1V
            3'b001  : wave_r = swave_w / 10;    // 2V
            3'b010  : wave_r = swave_w / 5;     // 4V
            3'b011  : wave_r = swave_w / 4;     // 5V
            3'b100  : wave_r = swave_w / 2;     // 10V
            3'b101  : wave_r = swave_w;         // 20V
            default : wave_r = 12'd0;
        endcase
    end

    // 12bit Address generator (2V, 0~4095)
    addr_gen addr_gen
    (
        //INPUT
        .clk(clk)                       ,
        .s_clk(s_clk)                   ,
        .rst(rst)                       ,
        .f_set(f_set)                   ,

        //OUTPUT
        .addr(addr_w)   
    );

    // 12bit Sine pattern ROM 
    usin_rom usin_rom
    (   
        //INPUT
        .clk(clk)                       ,
        .rst(rst)                       ,
        .addr(addr_w_i)                 ,         

        //OUTPUT
        .dout(uwave_w)
    );

    assign wave = wave_r;

endmodule