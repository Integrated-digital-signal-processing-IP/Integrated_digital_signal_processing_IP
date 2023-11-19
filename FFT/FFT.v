module FFT
(
    input 			clk			,
    input 			di_last		,	// S_AXIS_DATA_tlast		
    input 			di_en		,	// S_AXIS_DATA_tvalid		
    input   [31:0]	din			,	// S_AXIS_DATA_tdata		
                                        
    output 			do_last		,	// M_AXIS_DATA_tlast		
    output 			do_en		,	// M_AXIS_DATA_tvalid	  
    output [31:0]	dout			// M_AXIS_DATA_tdata
);

    wire    [31:0]  M_AXIS_DATA_tdata;
    wire            M_AXIS_DATA_tlast;
    wire            M_AXIS_DATA_tready;
    wire            M_AXIS_DATA_tvalid;

    wire    [15:0]  S_AXIS_CONFIG_tdata;
    wire            S_AXIS_CONFIG_tready;
    wire            S_AXIS_CONFIG_tvalid;

    wire    [31:0]  S_AXIS_DATA_tdata;
    wire            S_AXIS_DATA_tlast;
    wire            S_AXIS_DATA_tready;
    wire            S_AXIS_DATA_tvalid;

    assign M_AXIS_DATA_tready = 1;          // Always High
    assign S_AXIS_CONFIG_tvalid = 0;        // Always Low
    assign S_AXIS_DATA_tlast = di_last;     // Input
    assign S_AXIS_DATA_tvalid = di_en;      // Input
    assign S_AXIS_CONFIG_tdata = 0;         // Always Zero   
    assign S_AXIS_DATA_tdata = din;         // Input

    assign do_last = M_AXIS_DATA_tlast;
    assign do_en = M_AXIS_DATA_tvalid;
    assign dout = M_AXIS_DATA_tdata;

    fft_1024 fft_1024_U0
    (
        // INPUT      
        .aclk_0						(clk					),
        .M_AXIS_DATA_0_tready		(M_AXIS_DATA_tready		),
        .S_AXIS_DATA_0_tvalid		(S_AXIS_DATA_tvalid		),
        .S_AXIS_DATA_0_tlast		(S_AXIS_DATA_tlast		),
        .S_AXIS_CONFIG_0_tvalid		(S_AXIS_CONFIG_tvalid	),
        .S_AXIS_DATA_0_tdata		(S_AXIS_DATA_tdata		),
        .S_AXIS_CONFIG_0_tdata		(S_AXIS_CONFIG_tdata	),

        // OUTPUT
        .M_AXIS_DATA_0_tdata		(M_AXIS_DATA_tdata		),
        .M_AXIS_DATA_0_tlast		(M_AXIS_DATA_tlast		),
        .M_AXIS_DATA_0_tvalid		(M_AXIS_DATA_tvalid		),
        .S_AXIS_CONFIG_0_tready		(S_AXIS_CONFIG_tready	),
        .S_AXIS_DATA_0_tready		(S_AXIS_DATA_tready		)
    );
   
endmodule
