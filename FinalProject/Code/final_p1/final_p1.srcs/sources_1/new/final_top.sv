`timescale 1ns / 1ps

module final_top(
    input clk100,
    input servoPhotoT, // JA1
    output servoOut, // JC1
    output [6:0] seg,   // output for the segments
    output [3:0] an    // output for the anodes
    );

    wire [1:0] freqConnector;
    wire reset;

    sevseg_controller u0 (
        .*,
        .freqIn(freqConnector)
    );

    ledFrequencyCounter u1 (
        .*,
        .photoT(servoPhotoT),
        .freqOut(freqConnector)
    );

    servoController u2 (
        .*,
        .stopSignal(freqConnector)
    );

endmodule
  