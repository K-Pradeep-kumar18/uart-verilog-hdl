`timescale 1ns/1ps

module tb_uart_rx;

parameter CLKS_PER_BIT = 104;

reg clk;
reg rst;
reg rx;

wire [7:0] data_out;
wire rx_done;

uart_rx #(
    .CLKS_PER_BIT(CLKS_PER_BIT)
) uut (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .data_out(data_out),
    .rx_done(rx_done)
);

// Clock generation
always #5 clk = ~clk;

// Task to send UART byte
task uart_write_byte;

    input [7:0] data;

    integer i;

    begin

        // Start bit
        rx = 0;
        #(CLKS_PER_BIT * 10);

        // Data bits
        for(i=0; i<8; i=i+1) begin
            rx = data[i];
            #(CLKS_PER_BIT * 10);
        end

        // Stop bit
        rx = 1;
        #(CLKS_PER_BIT * 10);

    end

endtask

initial begin

    $dumpfile("rx_dump.vcd");
    $dumpvars(0, tb_uart_rx);

    clk = 0;
    rst = 1;
    rx  = 1;

    #20;
    rst = 0;

    // Send test byte
    uart_write_byte(8'hA5);

    #5000;

    $finish;

end

endmodule