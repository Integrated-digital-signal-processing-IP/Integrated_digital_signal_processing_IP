module addr12_gen
(
    input           clk     ,
    input           s_clk   ,
    input           rst     ,
    input   [19:0]  f_set   ,

    output  [11:0]  addr      
);

    reg		[11:0]	addro_r;
	reg	 			pl0;
	reg				pl1;
	reg  	[28:0]	cnt_bas;
	wire 	[28:0]	cnt_in;
	wire 	[28:0]	cnt_df;

	wire 	[23:0]	f_din;

	assign f_din = f_set * 16;		// 1 ~ 1MHz

	//two registers to detect rsing clock
	always @ (posedge clk, negedge rst) begin
		if (!rst) begin
			pl0 <= 0;
			pl1 <= 0;
		end 
		else begin
			pl0 <= s_clk;
			pl1 <= pl0;
		end
	end

	assign cnt_df = cnt_bas + f_din;
	
	always @ (posedge clk, negedge rst) begin
		if (!rst) begin
			cnt_bas <= 0;
		end
		else if ((pl0 & ~pl1) == 1) begin
			if (cnt_df < 29'd320000000)
				cnt_bas <= cnt_df;
			else
				cnt_bas <= cnt_df - 29'd320000000;
		end
	end

	assign cnt_in = (cnt_bas / 29'd78125);

	always @ (posedge clk, negedge rst) begin
		if (!rst)
			addro_r <= 12'd0;
		else if ((pl0 & ~pl1) == 1'b1)			//rising clock
			addro_r <= cnt_in[11:0];
	end

	assign addro = addro_r;

endmodule