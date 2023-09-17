module sine_a
(
	input			rst		,
	input			clk		,
	input	[11:0]	delta	,

	output	[11:0]	sind
);

	reg 	[11:0]	addr;

	always@(posedge clk, negedge rst)
	begin
		if (!rst)
			addr <= 12'b0;
		else
			addr <= addr + delta;
	end


	usin_rom u_usin_rom
	(
	.rst		( rst		)	,
	.clk		( clk		)	,
	.addr		( addr 		)	,
	.dout		( sind		)
	);

endmodule