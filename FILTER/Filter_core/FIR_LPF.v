module FIR_LPF
(
    input                   clk     ,
    input                   rst     ,
	input					en		,
    input                   f_s     ,
    input   signed [11:0]   din     ,

    output  signed [11:0]   dout
);

    reg                     pl0;
    reg                     pl1;
    reg     signed  [11:0]  SR00,SR01,SR02,SR03,SR04,SR05,SR06,SR07,SR08,SR09,  // Shift register
							SR10,SR11,SR12,SR13,SR14,SR15,SR16,SR17,SR18,SR19,
							SR20,SR21,SR22,SR23,SR24,SR25,SR26,SR27,SR28,SR29,
							SR30,SR31;
                                 
    reg     signed  [12:0]  SM00,SM01,SM02,SM03,SM04,SM05,SM06,SM07,            // Shared multiplier
							SM08,SM09,SM10,SM11,SM12,SM13,SM14,SM15;    

    wire    signed  [11:0]  CF00,CF01,CF02,CF03,CF04,CF05,CF06,CF07,            // Coefficient
							CF08,CF09,CF10,CF11,CF12,CF13,CF14,CF15;   

    reg     signed  [24:0]  CM00,CM01,CM02,CM03,CM04,CM05,CM06,CM07,            // Coefficient multiplier
							CM08,CM09,CM10,CM11,CM12,CM13,CM14,CM15;     
    
    reg     signed  [28:0]  SUM;            // 29bit total sum result   
    reg     signed  [11:0]  ESUM;           // Extract 12bit SUM from 29bit SUM    
    wire    signed  [11:0]  SUM_ADJ;        // Adjusted SUM
    wire    signed  [10:0]  LSUM;           // Lower bit of 29bit SUM[11:1]  

    reg     signed  [11:0]  dout_r;

    integer                 i,j,k;

    /**********************************/
    /*        Shift registers         */
    /**********************************/

    always @ (posedge clk, negedge rst) begin
        if (!rst) begin   
            SR00 <= 0;	SR01 <= 0;	SR02 <= 0;	SR03 <= 0;	
			SR04 <= 0;	SR05 <= 0;	SR06 <= 0;	SR07 <= 0;	
			SR08 <= 0;	SR09 <= 0;	SR10 <= 0;	SR11 <= 0;
			SR12 <= 0;	SR13 <= 0;	SR14 <= 0;	SR15 <= 0;
			SR16 <= 0;	SR17 <= 0;	SR18 <= 0;	SR19 <= 0;
			SR20 <= 0;	SR21 <= 0;	SR22 <= 0;	SR23 <= 0;
			SR24 <= 0;	SR25 <= 0;	SR26 <= 0;	SR27 <= 0;
			SR28 <= 0;	SR29 <= 0;	SR30 <= 0;	SR31 <= 0;
        end
        else if (en) begin
			if (pl0 & ~pl1) begin
				SR00 <= din;	SR01 <= SR00;	SR02 <= SR01;	SR03 <= SR02;	
				SR04 <= SR03;	SR05 <= SR04;	SR06 <= SR05;	SR07 <= SR06;	
				SR08 <= SR07;	SR09 <= SR08;	SR10 <= SR09;	SR11 <= SR10;
				SR12 <= SR11;	SR13 <= SR12;	SR14 <= SR13;	SR15 <= SR14;
				SR16 <= SR15;	SR17 <= SR16;	SR18 <= SR17;	SR19 <= SR18;
				SR20 <= SR19;	SR21 <= SR20;	SR22 <= SR21;	SR23 <= SR22;
				SR24 <= SR23;	SR25 <= SR24;	SR26 <= SR25;	SR27 <= SR26;
				SR28 <= SR27;	SR29 <= SR28;	SR30 <= SR29;	SR31 <= SR30;
			end
        end 
    end

    /**********************************/
    /*           Pre-adder            */
    /**********************************/

    always @ (posedge clk, negedge rst) begin
        if (!rst) begin   
            SM00 <= 0;	SM01 <= 0;	SM02 <= 0;	SM03 <= 0;	
			SM04 <= 0;	SM05 <= 0;	SM06 <= 0;	SM07 <= 0;	
			SM08 <= 0;	SM09 <= 0;	SM10 <= 0;	SM11 <= 0;
			SM12 <= 0;	SM13 <= 0;	SM14 <= 0;	SM15 <= 0;
        end
        else if (en) begin
			if (pl0 & ~pl1) begin
				SM00 <= SR00 + SR31;	SM01 <= SR01 + SR30;	
				SM02 <= SR02 + SR29;	SM03 <= SR03 + SR28;	
				SM04 <= SR04 + SR27;	SM05 <= SR05 + SR26;	
				SM06 <= SR06 + SR25;	SM07 <= SR07 + SR24;	
				SM08 <= SR08 + SR23;	SM09 <= SR09 + SR22;	
				SM10 <= SR10 + SR21;	SM11 <= SR11 + SR20;
				SM12 <= SR12 + SR19;	SM13 <= SR13 + SR18;
				SM14 <= SR14 + SR17;	SM15 <= SR15 + SR16;
			end
        end
    end

    /**********************************/
    /*   Coef. multiplying registers  */
    /**********************************/

    always @ (posedge clk, negedge rst) begin
        if (!rst) begin   
            CM00 <= 0;	CM01 <= 0;	CM02 <= 0;	CM03 <= 0;	
			CM04 <= 0;	CM05 <= 0;	CM06 <= 0;	CM07 <= 0;	
			CM08 <= 0;	CM09 <= 0;	CM10 <= 0;	CM11 <= 0;
			CM12 <= 0;	CM13 <= 0;	CM14 <= 0;	CM15 <= 0;
        end
        else if (en) begin  
			if (pl0 & ~pl1) begin
				CM00 <= SM00 * CF00;	CM01 <= SM01 * CF01;	
				CM02 <= SM02 * CF02;	CM03 <= SM03 * CF03;	
				CM04 <= SM04 * CF04;	CM05 <= SM05 * CF05;	
				CM06 <= SM06 * CF06;	CM07 <= SM07 * CF07;	
				CM08 <= SM08 * CF08;	CM09 <= SM09 * CF09;	
				CM10 <= SM10 * CF10;	CM11 <= SM11 * CF11;
				CM12 <= SM12 * CF12;	CM13 <= SM13 * CF13;
				CM14 <= SM14 * CF14;	CM15 <= SM15 * CF15;
			end
        end
    end

    /**********************************/
    /*          Post-adder            */
    /**********************************/
    
    always @ (posedge clk, negedge rst) begin
		if (!rst) begin
			SUM <= 29'd0;
		end
		else if (en) begin
			if (pl0 & ~pl1) begin
				SUM <=  CM00 + CM01 + CM02 + CM03 + 
						CM04 + CM05 + CM06 + CM07 + 
						CM08 + CM09 + CM10 + CM11 + 
						CM12 + CM13 + CM14 + CM15 ;
			end
		end
	end


    /**********************************/
    /*          Output adjust         */
    /**********************************/

    always @ (posedge clk, negedge rst) begin
		if (!rst) begin
			ESUM <= 12'd0;
		end
		else if (en) begin 
			if (pl0 & ~pl1) begin
				if ((SUM[28:26] == 0) | (SUM[28:26] == 7))
					ESUM <= SUM[26:15];
				else if (SUM[28] == 0)
					ESUM <= 2047;
				else
					ESUM <= -2048;
			end
		end
	end

    assign LSUM = ESUM[11:1];
    assign SUM_ADJ = ESUM + LSUM;

    /**********************************/
    /*           Final output         */
    /**********************************/

    always @ (posedge clk, negedge rst) begin
		if (!rst)
			dout_r <= 12'd0;
		else if (pl0 & ~pl1) 
			dout_r <= SUM_ADJ;
	end

    assign dout = dout_r;
    
    /**********************************/
    /*   Low pass filter Coefficient  */
    /**********************************/

    /*
    -- Low pass filter
	-- Equiripple Type
	-- Fs 		: 20kHz
	-- Fpass	: 300Hz
	-- Fstop	: 1500Hz
	*/

    /*
	// 1st coefficient 
	assign CF00 = 49	;	assign CF01 = 59	;
	assign CF02 = 120	;	assign CF03 = 223	;
	assign CF04 = 312	;	assign CF05 = 447	;
	assign CF06 = 607	;	assign CF07 = 788	;
	assign CF08 = 984	;	assign CF09 = 1188	;
	assign CF10 = 1390	;	assign CF11 = 1580	;
	assign CF12 = 1747	;	assign CF13 = 1883	;
	assign CF14 = 1978	;	assign CF15 = 2027	;


	/*
	// 2nd coefficient
	assign CF00 = 39	;	assign CF01 = 59	;
	assign CF02 = 100	;	assign CF03 = 157	;
	assign CF04 = 252	;	assign CF05 = 367	;
	assign CF06 = 457	;	assign CF07 = 608	;
	assign CF08 = 764	;	assign CF09 = 910	;
	assign CF10 = 1100	;	assign CF11 = 1280	;
	assign CF12 = 1407	;	assign CF13 = 1454	;
	assign CF14 = 1574	;	assign CF15 = 1627	;
	*/

	/*
	// 3rd coefficient
	assign CF00 = 35	;	assign CF01 = 61	;
	assign CF02 = 133	;	assign CF03 = 184	;
	assign CF04 = 275	;	assign CF05 = 405	;
	assign CF06 = 493	;	assign CF07 = 626	;
	assign CF08 = 771	;	assign CF09 = 911	;
	assign CF10 = 1140	;	assign CF11 = 1201	;
	assign CF12 = 1354	;	assign CF13 = 1464	;
	assign CF14 = 1514	;	assign CF15 = 1581	;
	*/

	/*
	// 4th coefficient
	assign CF00 = 35	;	assign CF01 = 58	;
	assign CF02 = 113	;	assign CF03 = 164	;
	assign CF04 = 265	;	assign CF05 = 345	;
	assign CF06 = 473	;	assign CF07 = 610	;
	assign CF08 = 751	;	assign CF09 = 900	;
	assign CF10 = 1060	;	assign CF11 = 1191	;
	assign CF12 = 1324	;	assign CF13 = 1424	;
	assign CF14 = 1489	;	assign CF15 = 1531	;
	*/

	
	// Final Coefficient
	assign CF00 = 35	;	assign CF01 = 58	;
	assign CF02 = 103	;	assign CF03 = 164	;
	assign CF04 = 245	;	assign CF05 = 345	;
	assign CF06 = 463	;	assign CF07 = 596	;
	assign CF08 = 741	;	assign CF09 = 891	;
	assign CF10 = 1040	;	assign CF11 = 1181	;
	assign CF12 = 1304	;	assign CF13 = 1404	;
	assign CF14 = 1474	;	assign CF15 = 1511	;



    /**********************************/
    /*  Detect rising edge of f_s  */
    /**********************************/

    always @ (posedge clk, negedge rst) begin
		if (!rst) begin
			pl0 <= 0;
			pl1 <= 0;
		end
		else begin
			pl0 <= f_s;
			pl1 <= pl0;
		end
	end	

endmodule 

