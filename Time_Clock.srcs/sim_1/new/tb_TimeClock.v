`timescale 1ns / 1ps

module tb_TimeClock();

    reg i_clk = 0;
    reg i_reset = 0;
    reg i_modeSW = 0;
    wire [3:0] o_digitposition;
    wire [7:0] o_font;


    Time_Clock dut(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_modeSW(i_modeSW),
    .o_digitposition(o_digitposition),
    .o_font(o_font)
    );

    always #5 i_clk = ~i_clk;

    initial begin
        #00 i_modeSW = 1'b0;
        #10000 i_modeSW = 1'b1;
        #10000 i_modeSW = 1'b0;
        #10000 i_modeSW = 1'b1;
        #10000 i_modeSW = 1'b0;
        #10000 $finish;
    end


endmodule
