`timescale 1ns / 1ps


module tb_TimeClock_Counter();

    reg i_clk = 1'b0, i_reset;
    wire [6:0] w_hour, w_min, w_sec, w_msec;

 TimeClock_Counter dut0(

    .i_clk(i_clk),
    .i_reset(i_reset),
    .o_hour(w_hour),
    .o_min(w_min),
    .o_sec(w_sec),
    .o_msec(w_msec) 
    );   

    always #5 i_clk = ~i_clk;  //  10ns 주기

    initial begin
        #00 i_reset = 1'b0;
        #10000 $finish;        
    end

endmodule
