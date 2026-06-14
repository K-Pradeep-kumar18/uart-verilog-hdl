module uart_tx (

    input clk,
    input reset,
    input baud_tick,

    input [7:0] data_in,
    input data_valid,

    output reg tx,
    output reg tx_done
);

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [1:0] state;
reg [7:0] shift_reg;
reg [2:0] bit_index;

always @(posedge clk or posedge reset)
begin

    if (reset)
    begin
        state <= IDLE;

        tx <= 1'b1;
        tx_done <= 0;

        shift_reg <= 0;
        bit_index <= 0;
    end

    else
    begin

        tx_done <= 0;

        if (baud_tick)
        begin

            case(state)

                IDLE:
                begin
                    tx <= 1'b1;

                    if (data_valid)
                    begin
                        shift_reg <= data_in;
                        bit_index <= 0;
                        state <= START;
                    end
                end

                START:
                begin
                    tx <= 1'b0;
                    state <= DATA;
                end

                DATA:
                begin

                    tx <= shift_reg[0];

                    shift_reg <= shift_reg >> 1;

                    if (bit_index == 7)
                        state <= STOP;
                    else
                        bit_index <= bit_index + 1;

                end

                STOP:
                begin
                    tx <= 1'b1;
                    tx_done <= 1'b1;
                    state <= IDLE;
                end

            endcase

        end

    end

end

endmodule