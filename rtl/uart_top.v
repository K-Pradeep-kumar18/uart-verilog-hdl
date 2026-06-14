module uart_top #(
    parameter BAUD_DIV = 5208
)(
    input        clk,
    input        reset,
    input  [7:0] data_in,
    input        data_valid,
    output       tx,
    output       tx_done,
    input        rx,
    output [7:0] data_out,
    output       rx_done
);

wire baud_tick;

baud_gen #(.BAUD_DIV(BAUD_DIV)) u_baud_gen (
    .clk(clk), .reset(reset), .baud_tick(baud_tick)
);

uart_tx u_uart_tx (
    .clk(clk), .reset(reset), .baud_tick(baud_tick),
    .data_in(data_in), .data_valid(data_valid),
    .tx(tx), .tx_done(tx_done)
);

uart_rx #(.CLKS_PER_BIT(BAUD_DIV)) u_uart_rx (
    .clk(clk), .rst(reset), .rx(rx),
    .data_out(data_out), .rx_done(rx_done)
);

endmodule
