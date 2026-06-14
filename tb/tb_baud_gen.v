`timescale 1ns/1ps

module tb_baud_gen;

reg clk;
reg reset;

wire baud_tick;
wire sample_tick;

baud_gen uut (
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .sample_tick(sample_tick)
);

initial
begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial
begin

    $dumpfile("uart_dump.vcd");
    $dumpvars(0, tb_baud_gen);

    reset = 1;

    #100;

    reset = 0;

    #200000;

    $finish;

end

endmodule