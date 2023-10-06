module FIR_LPF
(
    input                   clk     ,
    input                   rst     ,
    input                   pls20k  ,
    input   signed [11:0]   din     ,

    output  signed [11:0]   dout
);

    reg                     pl0;
    reg                     pl1;
    reg     signed  [11:0]  SR  [0:31];     // Shift register
    reg     signed  [12:0]  SM  [0:15];     // Shared multiplier
    reg     signed  [11:0]  CF  [0:15];     // Coefficient
    reg     signed  [24:0]  CM  [0:15];     // Coefficient multiplier
    
    reg     signed  [28:0]  SUM;            // 29bit total sum result
    reg     signed  [11:0]  ESUM;           // Extract 12bit SUM from 29bit SUM
    reg     signed  [10:0]  LSUM;           // Lower bit of 29bit SUM[11:1]     
    reg     signed  [11:0]  SUM_ADJ;        // Adjusted SUM

    wire                    rising_pls20k;  // Detect rising edge of pls20k
    integer                 i,j,k;

    /**********************************/
    /*        Shift registers         */
    /**********************************/

    always @ (posedge clk, negedge rst) begin
        if (!rst) begin   
            for (i = 0; i < 32; i = i + 1)
                SR[i] <= 12'd0;
        end
        else (rising_pls20k) begin
            SR[0]  <= din;      SR[1]  <= SR[0];    SR[2]  <= SR[1];    SR[3]  <= SR[2]; 
            SR[4]  <= SR[3];    SR[5]  <= SR[4];    SR[6]  <= SR[5];    SR[7]  <= SR[6];
            SR[8]  <= SR[7];    SR[9]  <= SR[8];    SR[10] <= SR[9];    SR[11] <= SR[10];
            SR[12] <= SR[11];   SR[13] <= SR[12];   SR[14] <= SR[13];   SR[15] <= SR[14];
            SR[16] <= SR[15];   SR[17] <= SR[16];   SR[18] <= SR[17];   SR[19] <= SR[18];
            SR[20] <= SR[19];   SR[21] <= SR[20];   SR[22] <= SR[21];   SR[23] <= SR[22];
            SR[24] <= SR[23];   SR[25] <= SR[24];   SR[26] <= SR[25];   SR[27] <= SR[26];
            SR[28] <= SR[27];   SR[29] <= SR[28];   SR[30] <= SR[29];   SR[31] <= SR[30];
        end 
    end

    /**********************************/
    /*           Pre-adder            */
    /**********************************/

    always @ (posedge clk, negedge rst) begin
        if (!rst) begin   
            for (j = 0; j < 16; j = j+ 1)
                SM[j] <= 13'd0;
        end
        else if (rising_pls20k) begin
            SM[0]  <= SR[0]  + SR[31];    SM[1]  <= SR[1]  + SR[30];    
            SM[2]  <= SR[2]  + SR[29];    SM[3]  <= SR[3]  + SR[28];  
            SM[4]  <= SR[4]  + SR[27];    SM[5]  <= SR[5]  + SR[26];  
            SM[6]  <= SR[6]  + SR[25];    SM[7]  <= SR[7]  + SR[24];  
            SM[8]  <= SR[8]  + SR[23];    SM[9]  <= SR[9]  + SR[22];  
            SM[10] <= SR[10] + SR[21];    SM[11] <= SR[11] + SR[20];  
            SM[12] <= SR[12] + SR[19];    SM[13] <= SR[13] + SR[18];  
            SM[14] <= SR[14] + SR[17];    SM[15] <= SR[15] + SR[16];  
        end
    end

    /**********************************/
    /*   Coef. multiplying registers  */
    /**********************************/

    always @ (posedge clk, negedge rst) begin
        if (!rst) begin   
            for (k = 0; k < 16; k = k + 1)
                CM[k] <= 25'd0;
        end
        else if (rising_pls20k) begin   
            CM[0]  <= SM[0]  + SM[0];       CM[1]  <= SM[1]  + SM[1];    
            CM[2]  <= SM[2]  + SM[2];       CM[3]  <= SM[3]  + SM[3];  
            CM[4]  <= SM[4]  + SM[4];       CM[5]  <= SM[5]  + SM[5];  
            CM[6]  <= SM[6]  + SM[6];       CM[7]  <= SM[7]  + SM[7];  
            CM[8]  <= SM[8]  + SM[8];       CM[9]  <= SM[9]  + SM[9];  
            CM[10] <= SM[10] + SM[10];      CM[11] <= SM[11] + SM[11];  
            CM[12] <= SM[12] + SM[12];      CM[13] <= SM[13] + SM[13];  
            CM[14] <= SM[14] + SM[14];      CM[15] <= SM[15] + SM[15]; 
        end
    end

    /**********************************/
    /*          Post-adder            */
    /**********************************/
    
    always @ (posedge clk, negedge rst) begin
		if (!rst) begin
			SUM <= 29'D0;
		end
		else if (pl0 & ~pl1) begin 
			SUM <= CM[0]  + CM[1]  + CM[2]  + CM[3]  + 
				   CM[4]  + CM[5]  + CM[6]  + CM[7]  + 
				   CM[8]  + CM[9]  + CM[10] + CM[11] + 
				   CM[12] + CM[13] + CM[14] + CM[15] ;
		end
	end


    /**********************************/
    /*          Output adjust         */
    /**********************************/

    always @ (posedge clk, negedge rst) begin
		if (!rst) begin
			ESUM <= 12'd0;
		end
		else if (rising_pls20k) begin 
			if ((SUM[28:26] == 0) | (SUM[28:26] == 7))
				ESUM <= SUM[26:15];
			else if (SUM[28] == 0)
				ESUM <= 2047;
			else
				ESUM <= -2048;
		end
	end

    assign LSUM = ESUM[11:1];
    assign SUM_ADJ = ESUM + LSUM;

    /**********************************/
    /*           Final output         */
    /**********************************/

    always @ (posedge clk, negedge rst) begin
		if (!rst)
			dout <= 12'd0;
		else if (rising_pls20k) 
			dout <= SUM_ADJ;
	end

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
	assign cf00 = 49	;	assign cf01 = 59	;
	assign cf02 = 120	;	assign cf03 = 223	;
	assign cf04 = 312	;	assign cf05 = 447	;
	assign cf06 = 607	;	assign cf07 = 788	;
	assign cf08 = 984	;	assign cf09 = 1188	;
	assign cf10 = 1390	;	assign cf11 = 1580	;
	assign cf12 = 1747	;	assign cf13 = 1883	;
	assign cf14 = 1978	;	assign cf15 = 2027	;


	/*
	// 2nd coefficient
	assign cf00 = 39	;	assign cf01 = 59	;
	assign cf02 = 100	;	assign cf03 = 157	;
	assign cf04 = 252	;	assign cf05 = 367	;
	assign cf06 = 457	;	assign cf07 = 608	;
	assign cf08 = 764	;	assign cf09 = 910	;
	assign cf10 = 1100	;	assign cf11 = 1280	;
	assign cf12 = 1407	;	assign cf13 = 1454	;
	assign cf14 = 1574	;	assign cf15 = 1627	;
	*/

	/*
	// 3rd coefficient
	assign cf00 = 35	;	assign cf01 = 61	;
	assign cf02 = 133	;	assign cf03 = 184	;
	assign cf04 = 275	;	assign cf05 = 405	;
	assign cf06 = 493	;	assign cf07 = 626	;
	assign cf08 = 771	;	assign cf09 = 911	;
	assign cf10 = 1140	;	assign cf11 = 1201	;
	assign cf12 = 1354	;	assign cf13 = 1464	;
	assign cf14 = 1514	;	assign cf15 = 1581	;
	*/

	/*
	// 4th coefficient
	assign cf00 = 35	;	assign cf01 = 58	;
	assign cf02 = 113	;	assign cf03 = 164	;
	assign cf04 = 265	;	assign cf05 = 345	;
	assign cf06 = 473	;	assign cf07 = 610	;
	assign cf08 = 751	;	assign cf09 = 900	;
	assign cf10 = 1060	;	assign cf11 = 1191	;
	assign cf12 = 1324	;	assign cf13 = 1424	;
	assign cf14 = 1489	;	assign cf15 = 1531	;
	*/

	
	// Final Coefficient
	assign cf00 = 35	;	assign cf01 = 58	;
	assign cf02 = 103	;	assign cf03 = 164	;
	assign cf04 = 245	;	assign cf05 = 345	;
	assign cf06 = 463	;	assign cf07 = 596	;
	assign cf08 = 741	;	assign cf09 = 891	;
	assign cf10 = 1040	;	assign cf11 = 1181	;
	assign cf12 = 1304	;	assign cf13 = 1404	;
	assign cf14 = 1474	;	assign cf15 = 1511	;



    /**********************************/
    /*  Detect rising edge of pls20k  */
    /**********************************/

    always @ (posedge clk, negedge rst) begin
		if (!rst) begin
			pl0 <= 0;
			pl1 <= 0;
		end
		else begin
			pl0 <= pls20k;
			pl1 <= pl0;
		end
	end	

    assign rising_pls20k = pl0 & ~pl1;

endmodule 