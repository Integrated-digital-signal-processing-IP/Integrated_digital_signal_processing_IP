module func_gen
(
    input                   clk         ,
    input                   rst         ,
    input                   s_clk       ,   // Sampling clock frequency : 2MHz 

    input           [19:0]  f_set       ,   // 1 ~ 1MHz
    input           [19:0]  f_s_set     ,   // sin wave frequency
    input           [19:0]  f_c_set     ,   // cos wave frequency
    input           [2:0]   w_set       ,   // sin, cos, sin+sin, sin+cos, cos+cos
    input                   a_set       ,   // amplitude, 1V, 2V 

    output  signed  [11:0]  wave        
);

    reg     signed  [11:0]  wave_r;
    wire            [11:0]  addr12_w;
    wire            [10:0]  addr11_w;

endmodule