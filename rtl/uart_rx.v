module uart_rx #(
    parameter CLKS_PER_BIT = 104
)(
    input clk,
    input rst,
    input rx,

    output reg [7:0] data_out,
    output reg rx_done
);

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0] state;

reg [13:0] clk_count;
reg [2:0] bit_index;
reg [7:0] rx_shift;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state      <= IDLE;
        clk_count  <= 0;
        bit_index  <= 0;
        rx_shift   <= 0;
        data_out   <= 0;
        rx_done    <= 0;
    end

    else begin

        rx_done <= 0;

        case(state)

            // -------------------------------------------------
            IDLE:
            begin
                clk_count <= 0;
                bit_index <= 0;

                if (rx == 0)
                    state <= START;
                else
                    state <= IDLE;
            end

            // -------------------------------------------------
            START:
            begin
                if (clk_count == (CLKS_PER_BIT-1)/2) begin

                    if (rx == 0) begin
                        clk_count <= 0;
                        state <= DATA;
                    end
                    else begin
                        state <= IDLE;
                    end

                end
                else begin
                    clk_count <= clk_count + 1;
                    state <= START;
                end
            end

            // -------------------------------------------------
            DATA:
            begin
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                    state <= DATA;
                end
                else begin

                    clk_count <= 0;

                    rx_shift[bit_index] <= rx;

                    if (bit_index < 7) begin
                        bit_index <= bit_index + 1;
                        state <= DATA;
                    end
                    else begin
                        bit_index <= 0;
                        state <= STOP;
                    end
                end
            end

            // -------------------------------------------------
            STOP:
            begin
                if (clk_count < CLKS_PER_BIT-1) begin
                    clk_count <= clk_count + 1;
                    state <= STOP;
                end
                else begin

                    data_out <= rx_shift;
                    rx_done <= 1;

                    clk_count <= 0;
                    state <= IDLE;
                end
            end

            // -------------------------------------------------
            default:
                state <= IDLE;

        endcase
    end
end

endmodule