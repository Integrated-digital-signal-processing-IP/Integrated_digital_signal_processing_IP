module clk_40k_gen
(
    input           clk     ,
    input           rst     ,

    output          clk_40k 
);

    reg             clk_40k_r;
    reg     [13:0]  cnt;

    always @ (posedge clk, negedge rst) begin
        if (!rst) begin
            clk_40k_r <= 1'b0;
            cnt <= 14'd0;
        end
        else if (cnt < 14'd124) begin
            cnt <= cnt + 14'd1;
        end
        else if (cnt == 14'd124) begin
            cnt <= cnt + 14'd1;
            clk_40k_r <= 1'b1;
        end
        else if (cnt < 14'd249) begin
            cnt <= cnt + 14'd1;
        end
        else if (cnt == 14'd249) begin
            clk_40k_r <= 1'b0;
            cnt <= 14'd0;
        end
    end

    assign clk_40k = clk_40k_r;

endmodule