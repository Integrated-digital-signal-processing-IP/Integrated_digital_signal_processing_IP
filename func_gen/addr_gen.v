module addr_gen
(
    input           clk     ,
    input           s_clk   ,
    input           rst     ,
    input   [18:0]  f_set   ,

    output  [11:0]  addr      
);

	reg	 			pl0;
	reg				pl1;
    reg		[11:0]	addr_r;
	reg  	[25:0]	cnt_bas;
	wire 	[25:0]	cnt_in;
	wire 	[25:0]	cnt_df;

	wire 	[24:0]	f_din;

	assign f_din = f_set * 64;		// 1 ~ 50KHz

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
			if (cnt_df < 26'd64000000)
				cnt_bas <= cnt_df;
			else
				cnt_bas <= cnt_df - 26'd64000000;
		end
	end

	assign cnt_in = (cnt_bas / 26'd15625);

	always @ (posedge clk, negedge rst) begin
			if (!rst)
				addr_r <= 12'd0;
			else if ((pl0 & ~pl1) == 1'b1) begin		//rising clock
				addr_r <= cnt_in[11:0];

			end
	end

	assign addr = addr_r;

endmodule