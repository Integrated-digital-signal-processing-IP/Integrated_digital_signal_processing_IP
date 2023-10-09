module addr11_gen
(
    input           clk     ,
    input           s_clk   ,
    input           rst     ,
	input			en		,
    input   [18:0]  f_set   ,

    output  [10:0]  addr      
);

	reg	 			pl0;
	reg				pl1;
    reg		[10:0]	addr_r;
	reg  	[24:0]	cnt_bas;
	wire 	[24:0]	cnt_in;
	wire 	[24:0]	cnt_df;

	wire 	[23:0]	f_din;

	assign f_din = f_set * 32;		// 1 ~ 50KHz

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
			if (en) begin
				if (cnt_df < 25'd32000000)
					cnt_bas <= cnt_df;
				else
					cnt_bas <= cnt_df - 25'd32000000;
			end
		end
	end

	assign cnt_in = (cnt_bas / 25'd15625);

	always @ (posedge clk, negedge rst) begin
		if (!rst)
			addr_r <= 11'd0;
		else if ((pl0 & ~pl1) == 1'b1) begin		//rising clock
			if (en) begin
				addr_r <= cnt_in[10:0];
			end
		end
	end

	assign addr = addr_r;

endmodule