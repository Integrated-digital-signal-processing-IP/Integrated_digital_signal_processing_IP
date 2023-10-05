module func_gen
(
    input                   clk         ,
    input                   s_clk       ,   // Sampling clock frequency : 2MHz 
    input                   rst         ,

    input           [19:0]  f_set       ,   // 1 ~ 1MHz
    //input           [19:0]  f_s_set     ,   // sin wave frequency
    //input           [19:0]  f_c_set     ,   // cos wave frequency
    input                   w_set       ,   // wave type : sin, cos (sin+sin, sin+cos, cos+cos)
    input                   a_set       ,   // amplitude : 1V, 2V 

    output  signed  [11:0]  wave        
);

    /****************************************/
    /*   w_set   |         wave type        */
    /* ------------------------------------ */
    /*    000    |            sin           */
    /*    001    |            cos           */
    /*  x 010    |         sin + sin        */
    /*  x 011    |         sin + cos        */    
    /*  x 100    |         cos + cos        */        
    /****************************************/    

    /****************************************/
    /*   a_set   |         Amplitude        */
    /* ------------------------------------ */
    /*     0     |             1V           */
    /*     1     |             2V           */
    /****************************************/

    wire            [11:0]  addr12_w;
    wire            [10:0]  addr11_w;
    wire    signed  [11:0]  addr12_w_i;
    wire    signed  [10:0]  addr11_w_i;
    //wire            [19:0]  freq_11_w;
    //wire            [19:0]  freq_12_w;
    wire                    addr11_gen_en;
    wire                    addr12_gen_en;

    //wire            [11:0]  c_addr12;
    //wire            [10:0]  c_addr11;
    wire            [11:0]  wave_1V;
    wire            [11:0]  wave_2V;
   
    // Make cos wave address
    //assign  c_addr12 = addr12_w + 12'd1024;
    //assign  c_addr11 = addr11_w + 11'd512;

    // Make final wave address
    assign  addr11_w_i = w_set ? (addr11_w + 11'd512) : addr11_w;
    assign  addr12_w_i = w_set ? (addr12_w + 12'd1024) : addr12_w;

    // Set sine pattern ROM enable singal (11bit, 12bit)
    assign  addr11_gen_en = a_set ? 1'b0 : 1'b1;
    assign  addr12_gen_en = a_set ? 1'b1 : 1'b0;

    // Set output wave 
    assign  wave = a_set ? (wave_2V - 12'd2048) : (wave_1V - 11'd1024);

    // 11bit Address generator (1V, 0~2047)
    addr11_gen addr11_gen
    (   
        //INPUT
        .clk(clk)                       ,
        .s_clk(s_clk)                   ,
        .rst(rst)                       ,
        .en(addr11_gen_en)              ,
        .f_set(f_set)                   ,

        //OUTPUT
        .addr(addr11_w)                     
    );

    // 12bit Address generator (2V, 0~4095)
    addr12_gen addr12_gen
    (
        //INPUT
        .clk(clk)                       ,
        .s_clk(s_clk)                   ,
        .rst(rst)                       ,
        .en(addr12_gen_en)              ,
        .f_set(f_set)                   ,

        //OUTPUT
        .addr(addr12_w)   
    );

    // 11bit Sine pattern ROM 
    usin11_rom usin11_rom
    (   
        //INPUT
        .clk(clk)                       ,
        .rst(rst)                       ,
        .addr(addr11_w_i)               ,  

        //OUTPUT
        .dout(wave_1V)
    );

    // 12bit Sine pattern ROM 
    usin12_rom usin12_rom
    (   
        //INPUT
        .clk(clk)                       ,
        .rst(rst)                       ,
        .addr(addr12_w_i)               ,         

        //OUTPUT
        .dout(wave_2V)
    );

endmodule