module IIR_BPF
(
    input	                clk		,		// 10MHz
    input	                rst		,
    input					en		,
    input	                f_s		,		// 40kHz
    input	signed	[15:0]	din	   	,

    output  signed	[15:0]	dout   
);

    reg		                pls0;
    reg                     pls1;

    reg	    signed	[39:0]	sr0,sr1,sr2,sr3	;
    reg	    signed	[39:0]	sum_a, dma_sum	;

    wire    signed	[66:0]	ma_sum	;
    wire    signed	[66:0]	cma1,cma2,cma3,cma4	;

    wire    signed	[58:0]	cmb0,cmb1,cmb2,cmb3,cmb4;
    wire    signed	[58:0]	mb_sum,sum_b;

    wire    signed	[66:0]	scms;
    reg	    signed	[63:0]	scm	;

    wire    signed [26:0]	ca1,ca2,ca3,ca4	;	
    wire    signed [26:0]	cb0,cb1,cb2,cb3,cb4	;

    reg	    signed	[19:0]	do;
    wire    signed	[19:0]	do_adj;
    wire    signed	[18:0]	doa	;
    wire    signed	[17:0]	dob	;
    wire    signed	[15:0]	doc	;
    wire    signed	[10:0]	dod	;

    reg     signed  [15:0]  dout_r;

    /*----- 	Data Output Set 	-----*/  

    always @ (posedge clk, negedge rst) begin
        if (!rst)
            dout_r <= 0;
        else if (pls0 & ~pls1)
            dout_r <= do_adj[19:4];
    end

    assign do_adj = (do + doa + dob + dod);

    assign doa = do[19:1];
    assign dob = do[19:2];
    assign doc = do[19:4];
    assign dod = do[19:9];

    always @ (posedge clk, negedge rst) begin
        if (!rst)begin
            do <= 0;
        end
        else if (pls1 & ~pls0) begin
            if (en) begin
                if ((mb_sum[58:36] == 0) | (mb_sum[58:36] == 23'h7fffff))
                    do <= mb_sum[36:17];
                else if (mb_sum[58] == 0)
                    do <= 20'h7ffff;
                else
                    do <= 20'h80000;
            end	
        end	
    end				

    assign dout = dout_r;
    
    /*----- 	Numerator Calculation <B> 	-----*/  

    assign cmb0 = sum_a * cb0;
    assign cmb1 = sr0 * cb1;
    assign cmb2 = sr1 * cb2;
    assign cmb3 = sr2 * cb3;
    assign cmb4 = sr3 * cb4;

    assign mb_sum = (cmb0 + cmb2 + cmb4) - (cmb1 + cmb3);

    /*----- 	Denominator Calculation <A> 	-----*/  

    assign cma1 = sr0 * ca1;
    assign cma2 = sr1 * ca2;
    assign cma3 = sr2 * ca3;
    assign cma4 = sr3 * ca4;

    assign ma_sum = (cma4 + cma2) - (cma1 + cma3);

    always @ (posedge clk, negedge rst) begin
        if (!rst)
            dma_sum <= 0;
        else if ((ma_sum[66:59] == 0) | (ma_sum[66:59] == 8'hff))
            dma_sum <= ma_sum[59:20];
        else if (ma_sum[66] == 0)
            dma_sum <= 40'h7fffffffff;
        else
            dma_sum <= 40'h8000000000;
    end				

    always @ (posedge clk, negedge rst) begin
        if (!rst)
            sum_a <= 0;
        else if (pls0 & ~pls1)
            sum_a <= din - dma_sum;
    end				

    /*----- 	Shift Registers 	-----*/  

    always @ (posedge clk, negedge rst) begin
        if (rst == 0) begin
            sr0 <= 0;
            sr1 <= 0;
            sr2 <= 0;
            sr3 <= 0;
        end
        else if (pls1 & ~pls0) begin
            sr0 <= sum_a;
            sr1 <= sr0;
            sr2 <= sr1;
            sr3 <= sr2;
        end
    end				

    //---- BPF1020 <40KHz Sampling> [952 ~ 1088]		  			  

    assign ca1 = 27'd4097318;
    assign ca2 = 27'd6056125;	  
    assign ca3 = 27'd4012163;
    assign ca4 = 27'd1005448; 	  
                            
    assign cb0 = 27'd32703;		  
    assign cb1 = 27'd128222;
    assign cb2 = 27'd191058;	  
    assign cb3 = 27'd128222; 
    assign cb4 = 27'd32703; 

    /*----- 	Series of D-F/F  	-----*/  

    always @ (posedge clk, negedge rst) begin
        if (!rst) begin
            pls0 <= 0;
            pls1 <= 0;
        end else begin
            pls0 <= f_s;
            pls1 <= pls0;
        end	
    end				


endmodule