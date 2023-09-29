module func_gen
(
    input                   clk         ,
    input                   rst         ,
    input                   s_clk       ,   // Sampling clock frequency : 2MHz 

    input           [19:0]  f_set       ,   // 1 ~ 1MHz
    input           [19:0]  f_s_set     ,   // sin wave frequency
    input           [19:0]  f_c_set     ,   // cos wave frequency
    input           [2:0]   w_set       ,   // wave type : sin, cos, sin+sin, sin+cos, cos+cos
    input                   a_set       ,   // amplitude : 1V, 2V 

    output  signed  [11:0]  wave        
);

    /****************************************/
    /*   w_set   |         wave type        */
    /* ------------------------------------ */
    /*    000    |            sin           */
    /*    001    |            cos           */
    /*    010    |         sin + sin        */
    /*    011    |         sin + cos        */    
    /*    100    |         cos + cos        */        
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
    wire            [19:0]  freq_11_w;
    wire            [19:0]  freq_12_w;
    wire                    usin11_rom_en;
    wire                    usin12_rom_en;
    wire            [11:0]  1V_wave;
    wire            [11:0]  2V_wave;
   

    // Set sine pattern ROM enable singal (11bit, 12bit)
    assign  usin11_rom_en = a_set ? 1'b0 : 1'b1;
    assign  usin12_rom_en = a_set ? 1'b1 : 1'b0;

    // Set output wave 
    assign wave = a_set ? (2V_wave - 12'd2048) : (1V_wave - 11'd1024);

    always @ (*) begin
        case (w_set)
            3'b000  :  begin 
                
            end
            3'b001  : 
            3'b010  : 
            3'b011  : 
            3'b100  : 
            default : 
        endcase
    end

    // 11bit Address generator (1V, 0~2047)
    addr11_gen addr11_gen
    (   
        //INPUT
        .clk(clk)                       ,
        .s_clk(s_clk)                   ,
        .rst(rst)                       ,
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
        .en(usin11_rom_en)              ,
        .addr(addr11_w)                 ,  

        //OUTPUT
        .dout(1V_wave)
    );

    // 12bit Sine pattern ROM 
    usin11_rom usin11_rom
    (   
        //INPUT
        .clk(clk)                       ,
        .rst(rst)                       ,
        .en(usin12_rom_en)              ,
        .addr(addr12_w)                 ,         

        //OUTPUT
        .dout(2V_wave)
    );
endmodule