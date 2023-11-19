module tb_FFT
(
    input			rst			,
    input			clk			,
    input			aen			,
    input			md_trdy		, 
    input			sd_tval		,
    input			sd_tlast	, 
    input			sc_tval		,
    input	[15:0]	sc_tdata	,

    input	[15:0]	delta_1     ,	
    input   [15:0]  delta_2
);

    wire 		    M_AXIS_DATA_tready;
    wire 		    S_AXIS_DATA_tlast;
    wire 		    S_AXIS_DATA_tvalid;
    wire 		    S_AXIS_CONFIG_tvalid;
    wire    [15:0]	S_AXIS_CONFIG_tdata;
    wire    [31:0]	S_AXIS_DATA_tdata;

    //---------------------

    wire 		    M_AXIS_DATA_tlast;
    wire 		    M_AXIS_DATA_tvalid;
    wire 		    S_AXIS_CONFIG_tready;
    wire 		    S_AXIS_DATA_tready;

    wire    [31:0]	M_AXIS_DATA_tdata;

    //---------------------

    reg     [11:0]	di_cnt, do_cnt;
    reg			    di_en;
    wire		    di_last;
    //---------------------

    assign M_AXIS_DATA_tready = md_trdy;    // Always High
    assign S_AXIS_DATA_tvalid = sd_tval;    // High when Data is Come in.
    assign S_AXIS_DATA_tlast = sd_tlast;    // High when the last data is come in, 1 clock period
    assign S_AXIS_CONFIG_tvalid = sc_tval;  

    wire    [31:0] dout;
    wire 		    do_last;
    wire		    do_en;

    FFT FFT_U0
    (
        // INPUT       
        .clk	    (clk				),	// Clock
        .di_last	(di_last			),	// 1bit
        .di_en		(di_en				),	// 1bit
        .din		(S_AXIS_DATA_tdata	),	// 32bit Data [Imagenary, Real]
        
        // OUTPUT
        .dout		(dout				),	// 32bit Data
        .do_last	(do_last			),	
        .do_en		(do_en				)
    );

    wire [15:0]	img_do,real_do;

    assign img_do = dout[31:16];
    assign real_do = dout[15:0];

    //---------------------

    always @ (posedge clk, negedge rst) begin
        if (!rst) begin
            di_cnt <= 0;
        end
        else if (di_en) begin
            if (di_cnt < 1023)
                    di_cnt <= di_cnt + 1;
            else
                di_cnt <= 0;
        end
        else begin
                di_cnt <= 0;
        end
==
    end

    assign di_last = (di_cnt == 1023) ? 1 : 0;

    always @ (posedge clk, negedge rst) begin
        if (!rst)
            di_en <= 0;
        else
            di_en <= sd_tval;
    end

    always @ (posedge clk, negedge rst) begin   
        if (!rst) begin
            do_cnt <= 0;
        end
        else if (do_en) begin
            if (do_cnt < 1023)
                do_cnt <= do_cnt + 1;
            else
                do_cnt <= 0;
        end
        else begin
            do_cnt <= 0;
        end
    end


    //-- Test Pattern Generation

    wire [15:0]	img_d,real_d;

    reg  [11:0]	addr_1;
    reg  [11:0]	addr_2;
    wire [11:0]	usind_1;
    wire [11:0]	usind_2;
    wire signed [11:0] ssind_1;
    wire signed [11:0] ssind_2;
    wire signed [12:0] ssind;

    assign ssind_1 = {~usind_1[11],usind_1[10:0]};
    assign ssind_2 = {~usind_2[11],usind_2[10:0]};
    assign ssind = ssind_1 + ssind_2;
    assign img_d = 0;
    assign real_d = {ssind[12:1],4'h0};
    assign S_AXIS_DATA_tdata = {img_d, real_d};
    assign S_AXIS_CONFIG_tdata = sc_tdata;
    
    always@(negedge rst, posedge clk)
    begin
        if (rst == 0)
            addr_2 <= 1024;
        else if (aen == 1)
            addr_2 <= addr_2 + delta_2;
    end

    always@(negedge rst, posedge clk)
    begin
        if (rst == 0)
            addr_1 <= 1024;
        else if (aen == 1)
            addr_1 <= addr_1 + delta_1;
    end
    
    assign rstb = ~rst;

    //sin_rom_12_sp u_sine_rom
    usin_rom u_sine_rom_1
    (
    .rst	(rstb	),
    .clk	(clk	),
    .addr	(addr_1	),
    .douta	(usind_1	)
    );

    usin_rom u_sine_rom_2
    (
    .rst	(rstb	),
    .clk	(clk	),
    .addr	(addr_2	),
    .douta	(usind_2	)
    );
        
       
endmodule