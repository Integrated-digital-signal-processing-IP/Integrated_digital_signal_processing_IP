module clk_20k_gen
(
    input           clk     ,
    input           rst     ,

    output          clk_20k 
);

    reg             clk_20k_r;
    reg     [13:0]   cnt;

    always @ (posedge clk, negedge rst) begin
        if (!rst) begin
            clk_20k_r <= 1'b0;
            cnt <= 14'd0;
        end
        else if (cnt < 14'd249) begin
            cnt <= cnt + 14'd1;
        end
        else if (cnt == 14'd249) begin
            cnt <= cnt + 14'd1;
            clk_20k_r <= 1'b1;
        end
        else if (cnt < 14'd499) begin
            cnt <= cnt + 14'd1;
        end
        else if (cnt == 14'd499) begin
            clk_20k_r <= 1'b0;
            cnt <= 14'd0;
        end
    end

    assign clk_20k = clk_20k_r;

endmodule