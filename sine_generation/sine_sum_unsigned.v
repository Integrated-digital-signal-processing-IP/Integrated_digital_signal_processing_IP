module sine_sum_unsigned
(
	input			rst		,
	input			clk		,
	input	[11:0]	delta_a	, 
	input	[11:0]	delta_b	,

	output	[12:0]	sind_sum
);
	
	reg		[12:0]	sind_sum_r;
	wire 	[11:0]	sind_a;
	wire	[11:0]	sind_b;

	//calculate sind_sum
	always@(posedge clk, negedge rst)
	begin
		if (!rst)
			sind_sum_r <= 0;
		else
			sind_sum_r <= sind_a + sind_b;
	end

	//sine wave1 instant
	sine_a u_sine_a_0
	(	
		//input
		.rst(rst)			,
		.clk(clk)			,
		.delta(delta_a)		,

		//output
		.sind(sind_a)
	);

	//sine wave2 instant
	sine_a u_sine_a_1
	(	
		//input
		.rst(rst)			,
		.clk(clk)			,
		.delta(delta_b)		,

		//output
		.sind(sind_b)
	);

	//wire output
	assign sind_sum = sind_sum_r;

endmodule