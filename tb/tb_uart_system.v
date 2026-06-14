`timescale 1ns/1ps

module tb_uart_system;

parameter CLKS_PER_BIT = 5208;
parameter BYTE_WAIT    = 15_000_000;

reg clk;
reg rst;

wire baud_tick;

reg [7:0] data_in;
reg       data_valid;

wire       tx;
wire       tx_done;
wire [7:0] data_out;
wire       rx_done;

// ------------------------------------------------
// Clock: 50MHz
// ------------------------------------------------
initial clk = 0;
always #10 clk = ~clk;

// ------------------------------------------------
// Baud Generator
// ------------------------------------------------
baud_gen #(
    .BAUD_DIV(CLKS_PER_BIT)
) uut_baud (
    .clk(clk),
    .reset(rst),
    .baud_tick(baud_tick)
);

// ------------------------------------------------
// UART TX
// ------------------------------------------------
uart_tx uut_tx (
    .clk(clk),
    .reset(rst),
    .baud_tick(baud_tick),
    .data_in(data_in),
    .data_valid(data_valid),
    .tx(tx),
    .tx_done(tx_done)
);

// ------------------------------------------------
// UART RX (loopback: tx → rx)
// ------------------------------------------------
uart_rx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
) uut_rx (
    .clk(clk),
    .rst(rst),
    .rx(tx),
    .data_out(data_out),
    .rx_done(rx_done)
);

// ------------------------------------------------
// Monitor
// ------------------------------------------------
always @(posedge clk) begin
    if (tx_done)
        $display("TX DONE at time %0t", $time);
    if (rx_done)
        $display("RX DONE at time %0t | data_out = 0x%0h", $time, data_out);
end

// ------------------------------------------------
// Task: send one byte safely
// Holds data_valid HIGH until baud_tick seen by TX
// ------------------------------------------------
task send_byte;
    input [7:0] byte_val;
    begin
        // load data
        data_in    = byte_val;
        data_valid = 1;

        // wait until TX leaves IDLE (baud_tick caught the data_valid)
        @(posedge tx_done);

        // now safe to deassert
        data_valid = 0;

        // wait for RX to finish receiving
        @(posedge rx_done);

        // small gap between bytes
        #50000;
    end
endtask

// ------------------------------------------------
// Test Sequence
// ------------------------------------------------
initial begin

    $dumpfile("uart_system_dump.vcd");
    $dumpvars(0, tb_uart_system);

    rst        = 1;
    data_in    = 8'h00;
    data_valid = 0;

    #200;
    rst = 0;
    #200;

    // Send Byte 1
    $display("Sending 0xA5 ...");
    send_byte(8'hA5);

    // Send Byte 2
    $display("Sending 0x3C ...");
    send_byte(8'h3C);

    $display("Simulation complete.");
    $finish;

end

endmodule