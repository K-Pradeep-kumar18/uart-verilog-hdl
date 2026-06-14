`timescale 1ns/1ps

module tb_uart_tx;

reg clk;
reg reset;

reg baud_tick;

reg [7:0] data_in;
reg data_valid;

wire tx;
wire tx_done;

uart_tx uut (
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .data_in(data_in),
    .data_valid(data_valid),
    .tx(tx),
    .tx_done(tx_done)
);

initial
begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial
begin

    $dumpfile("tx_dump.vcd");
    $dumpvars(0, tb_uart_tx);

    reset = 1;
    baud_tick = 0;

    data_in = 8'b10101010;
    data_valid = 0;

    #100;
    reset = 0;

    #50;

    data_valid = 1;

    #20;
    data_valid = 0;

    repeat(12)
    begin
        #100;
        baud_tick = 1;

        #20;
        baud_tick = 0;
    end

    #500;

    $finish;

end

endmodule