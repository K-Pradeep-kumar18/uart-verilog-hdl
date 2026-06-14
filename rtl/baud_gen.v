module baud_gen #(
    parameter BAUD_DIV = 5208
)(
    input  clk,
    input  reset,
    output reg baud_tick
);

reg [12:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter   <= 0;
        baud_tick <= 0;
    end
    else begin
        if (counter == BAUD_DIV - 1) begin
            counter   <= 0;
            baud_tick <= 1;
        end
        else begin
            counter   <= counter + 1;
            baud_tick <= 0;
        end
    end
end

endmodule
