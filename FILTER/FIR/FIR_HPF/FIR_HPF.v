module FIR_HPF
(
input	wire				rst 	,
input	wire				clk		,
input	wire				f_s		,
input		signed	[11:0]	din		,
output	reg signed	[11:0]	dout
);

reg		pl0,pl1	;

reg signed [11:0]	
		sr00,sr01,sr02,sr03,sr04,sr05,sr06,sr07,sr08,sr09,
		sr10,sr11,sr12,sr13,sr14,sr15,sr16,sr17,sr18,sr19,
		sr20,sr21,sr22,sr23,sr24,sr25,sr26,sr27,sr28,sr29,
		sr30;

reg	signed [12:0]
		sm00,sm01,sm02,sm03,sm04,sm05,sm06,sm07,
		sm08,sm09,sm10,sm11,sm12,sm13,sm14,sm15;

wire signed [11:0]
		cf00,cf01,cf02,cf03,cf04,cf05,cf06,cf07,
		cf08,cf09,cf10,cf11,cf12,cf13,cf14,cf15;

reg	signed [24:0]
		ml00,ml01,ml02,ml03,ml04,ml05,ml06,ml07,
		ml08,ml09,ml10,ml11,ml12,ml13,ml14,ml15;

reg	signed [28:0]	sum;

wire signed [24:0]	sum_a;
wire signed [18:0]	sum_b;
wire signed [16:0]	sum_c;
wire signed [8:0]	sum_d;
wire signed [25:0]	sum_e;
wire signed [21:0]	sum_f;
wire signed [28:0]	sum_adj;

wire signed [6:0]	sum_g;

/****************************************/
/* 		Main Function Starts Here		*/
/****************************************/

/****************************************************/
/*		Adding Registers for Multiplying Results	*/
/****************************************************/

always@ (negedge rst, posedge clk )
begin
	if (rst == 0)
		dout <= 0;
	else if (pl0 & ~pl1) 
		if ((sum_g == 0) | (sum_g == -1))
			dout <= sum_adj[22:11];
		else if (sum_g[6] == 0)
			dout <= 2047;
		else
			dout <= -2048;
end

assign sum_g = sum_adj[28:22];

/* Adjust Output Level */

assign sum_adj = (
				   sum
				 + sum_a
				 + sum_b
				 + sum_c
				 + sum_d
				 )
				 -
				 (
				   sum_e
				 + sum_f
				 )
				 ;

assign sum_a = sum[28:4];
assign sum_b = sum[28:10];
assign sum_c = sum[28:12];
assign sum_d = sum[28:20];
assign sum_e = sum[28:3];
assign sum_f = sum[28:7];

/****************************************************/
/*		Adding Registers for Multiplying Results	*/
/****************************************************/

always@ (negedge rst, posedge clk )
begin
	if (rst == 0)
		sum <= 0;
	else if (pl0 & ~pl1) 
		sum <= 	ml00 + ml01 + ml02 + ml03 + 
				ml04 + ml05 + ml06 + ml07 + 
				ml08 + ml09 + ml10 + ml11 + 
				ml12 + ml13 + ml14 + ml15 ;
end

/************************************************/
/*		Coefficient Multiplying Register		*/
/************************************************/

always@ (negedge rst, posedge clk )
begin
	if (rst == 0)
		begin	
			ml00 <= 0;
			ml01 <= 0;	
			ml02 <= 0;	
			ml03 <= 0;	
			ml04 <= 0;	
			ml05 <= 0;	
			ml06 <= 0;	
			ml07 <= 0;	
			ml08 <= 0;	
			ml09 <= 0;	
			ml10 <= 0;
			ml11 <= 0;
			ml12 <= 0;
			ml13 <= 0;
			ml14 <= 0;
			ml15 <= 0;
		end
	else if (pl0 & ~pl1) 
		begin	
			ml00 <= sm00 * cf00;	
			ml01 <= sm01 * cf01;	
			ml02 <= sm02 * cf02;	
			ml03 <= sm03 * cf03;	
			ml04 <= sm04 * cf04;	
			ml05 <= sm05 * cf05;	
			ml06 <= sm06 * cf06;	
			ml07 <= sm07 * cf07;	
			ml08 <= sm08 * cf08;	
			ml09 <= sm09 * cf09;	
			ml10 <= sm10 * cf10;
			ml11 <= sm11 * cf11;
			ml12 <= sm12 * cf12;
			ml13 <= sm13 * cf13;
			ml14 <= sm14 * cf14;
			ml15 <= sm15 * cf15;
		end
end

/****************************************/
/*		Assign Coefficient Values		*/
/****************************************/
/*
-- HPF Type A
-- Equiripple Type
-- Fs 		: 20kHz
-- Fstop	: 300Hz
-- Astop	: 60 dB
-- Fpass	: 1500Hz
-- Apass	: 2.9 dB
*/
assign cf00 = -61		;
assign cf01 = +60		;
assign cf02 = +46		;
assign cf03 = +38		;
assign cf04 = +30		;
assign cf05 = +19		;
assign cf06 = +1		;
assign cf07 = -23		;
assign cf08 = -53		;
assign cf09 = -88		;
assign cf10 = -126		;
assign cf11 = -162		;
assign cf12 = -195		;
assign cf13 = -221		;
assign cf14 = -238		;
assign cf15 = +1955	;

/*
-- LPF Type A
-- Equiripple Type
-- Fs 		: 20kHz
-- Fpass	: 300Hz
-- Apass	: 1.25 dB
-- Fstop	: 1500Hz
-- Astop	: 60 dB
*/
/*
assign cf00 = 35	;
assign cf01 = 58	;
assign cf02 = 103	;
assign cf03 = 164	;
assign cf04 = 245	;
assign cf05 = 345	;
assign cf06 = 463	;
assign cf07 = 596	;
assign cf08 = 741	;
assign cf09 = 891	;
assign cf10 = 1040	;
assign cf11 = 1181	;
assign cf12 = 1304	;
assign cf13 = 1404	;
assign cf14 = 1474	;
assign cf15 = 1511	;
*/
/****************************************/
/* 		Pre - Adding Registers			*/
/****************************************/

always@ (negedge rst, posedge clk )
begin
	if (rst == 0)
		begin	
			sm00 <= 0;
			sm01 <= 0;	
			sm02 <= 0;	
			sm03 <= 0;	
			sm04 <= 0;	
			sm05 <= 0;	
			sm06 <= 0;	
			sm07 <= 0;	
			sm08 <= 0;	
			sm09 <= 0;	
			sm10 <= 0;
			sm11 <= 0;
			sm12 <= 0;
			sm13 <= 0;
			sm14 <= 0;
			sm15 <= 0;
		end
	else if (pl0 & ~pl1) 
		begin	
			sm00 <= sr00 + sr30;
			sm01 <= sr01 + sr29;
			sm02 <= sr02 + sr28;
			sm03 <= sr03 + sr27;
			sm04 <= sr04 + sr26;
			sm05 <= sr05 + sr25;
			sm06 <= sr06 + sr24;
			sm07 <= sr07 + sr23;
			sm08 <= sr08 + sr22;
			sm09 <= sr09 + sr21;
			sm10 <= sr10 + sr20;
			sm11 <= sr11 + sr19;
			sm12 <= sr12 + sr18;
			sm13 <= sr13 + sr17;
			sm14 <= sr14 + sr16;
			sm15 <= sr15 ;      
		end
end

/*		Shift Regesters		*/

always@ (negedge rst, posedge clk )
begin
	if (rst == 0)
		begin	
			sr00 <= 0;
			sr01 <= 0;	
			sr02 <= 0;	
			sr03 <= 0;	
			sr04 <= 0;	
			sr05 <= 0;	
			sr06 <= 0;	
			sr07 <= 0;	
			sr08 <= 0;	
			sr09 <= 0;	
			sr10 <= 0;
			sr11 <= 0;
			sr12 <= 0;
			sr13 <= 0;
			sr14 <= 0;
			sr15 <= 0;
			sr16 <= 0;
			sr17 <= 0;
			sr18 <= 0;
			sr19 <= 0;
			sr20 <= 0;
			sr21 <= 0;
			sr22 <= 0;
			sr23 <= 0;
			sr24 <= 0;
			sr25 <= 0;
			sr26 <= 0;
			sr27 <= 0;
			sr28 <= 0;
			sr29 <= 0;
			sr30 <= 0;
		//	sr31 <= 0;
		end
	else if (pl0 & ~pl1) 
		begin	
			sr00 <= din;	
			sr01 <= sr00;	
			sr02 <= sr01;	
			sr03 <= sr02;	
			sr04 <= sr03;	
			sr05 <= sr04;	
			sr06 <= sr05;	
			sr07 <= sr06;	
			sr08 <= sr07;	
			sr09 <= sr08;	
			sr10 <= sr09;
			sr11 <= sr10;
			sr12 <= sr11;
			sr13 <= sr12;
			sr14 <= sr13;
			sr15 <= sr14;
			sr16 <= sr15;
			sr17 <= sr16;
			sr18 <= sr17;
			sr19 <= sr18;
			sr20 <= sr19;
			sr21 <= sr20;
			sr22 <= sr21;
			sr23 <= sr22;
			sr24 <= sr23;
			sr25 <= sr24;
			sr26 <= sr25;
			sr27 <= sr26;
			sr28 <= sr27;
			sr29 <= sr28;
			sr30 <= sr29;
		//	sr31 <= sr30;
		end
end

/* 	Series of D-F/F for Detecting Edge of PLS20K input	*/
		
always@ (negedge rst, posedge clk )
begin
	if (rst == 0)
		begin
			pl0 <= 0;
			pl1 <= 0;
		end
	else
		begin
			pl0 <= f_s;
			pl1 <= pl0;
		end
end	

endmodule