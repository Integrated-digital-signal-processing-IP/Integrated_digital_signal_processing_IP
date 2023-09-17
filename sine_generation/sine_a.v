module sine_a
(

input	wire			rst		,
input	wire			clk		,
input	wire	[11:0]	delta	,
//----------------------
output	wire	[11:0]	sind
);

wire 		rstb	;
reg [11:0]	addr	;

always@(negedge rst, posedge clk)
begin
	if (rst == 0)
		addr <= 0;
	else
		addr <= addr + delta;
end

assign rstb = ~ rst;

usin_rom u_usin_rom
(
.rsta		( rstb		)	,
.clka		( clk		)	,
.addra		( addr 		)	,
.douta		( sind		)
);

endmodule