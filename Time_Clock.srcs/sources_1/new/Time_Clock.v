`timescale 1ns / 1ps


module Time_Clock(  
    input i_clk,
    input i_reset,
    input i_modeSW,
    input i_pwswitch,
    output [3:0] o_digitposition,
    output [7:0] o_font
    );

    
    //1
    wire w_clk_1khz;
    Clock_Divider Clock_Div(
    .i_clk(i_clk),
    .i_reset(i_reset),
    .o_clk(w_clk_1khz)
    );

    wire [2:0] w_fnd_counter;
    ClockCounter_FND cntFnd(
    .i_clk(w_clk_1khz),
    .i_reset(i_reset),
    .o_counter(w_fnd_counter)
    );

    FND_DigitDecoder decoder_fnd(
    .i_pwswitch(i_pwswitch),
    .i_select(w_fnd_counter),
    .o_digitposition(o_digitposition)
    );

    
    
    //2

    wire [6:0] w_hour, w_min, w_sec, w_msec;
    TimeClock_Counter TimeClockCnt(
    .i_clk(w_clk_1khz),
    .i_reset(i_reset),
    .o_hour(w_hour),
    .o_min(w_min),
    .o_sec(w_sec),
    .o_msec(w_msec)
    );

    wire [3:0] w_min10, w_min1, w_hour10, w_hour1;
    Digit_Divider digitDiv_hourmin(
    .i_a(w_min),
    .i_b(w_hour),
    .o_a10(w_min10),
    .o_a1(w_min1),
    .o_b10(w_hour10),
    .o_b1(w_hour1)
    );

    wire [3:0] w_sec10, w_sec1, w_msec10, w_msec1;
    Digit_Divider digitDiv_secmsec(
    .i_a(w_msec),
    .i_b(w_sec),
    .o_a10(w_msec10),
    .o_a1(w_msec1),
    .o_b10(w_sec10),
    .o_b1(w_sec1)
    );

    wire [3:0] w_hourMinMux;
    Mux_4to1 Mux_hourmin(
    .i_a(w_min1),
    .i_b(w_min10),
    .i_c(w_hour1),
    .i_d(w_hour10),
    .i_a1(11),
    .i_b1(11),
    .i_c1(w_fndDP),
    .i_d1(11),
    .i_sel(w_fnd_counter),
    .o_y(w_hourMinMux)
    );

    wire [3:0] w_secMsecMux;
    Mux_4to1 Mux_secmsec(
    .i_a(w_msec1),
    .i_b(w_msec10),
    .i_c(w_sec1),
    .i_d(w_sec10),
    .i_a1(11),
    .i_b1(11),
    .i_c1(w_fndDP),
    .i_d1(11),
    .i_sel(w_fnd_counter),
    .o_y( w_secMsecMux)
    );

    wire [3:0] w_fndDP;
    Comparator comp(
    .i_msec(w_msec),
    .o_fndDP(w_fndDP)
    );

    wire [3:0] w_fndValueMux;
    Mux_2to1 mux_fndValue(
    .i_a(w_secMsecMux),
    .i_b(w_hourMinMux),
    .i_sel(i_modeSW),
    .o_y(w_fndValueMux)
    );

    BCDtoFND_Decoder fndFont(
    .i_value(w_fndValueMux),
    .i_pwswitch(i_pwswitch),
    .o_font(o_font)
    );






endmodule
