`timescale 1ns / 1ps

module final_top(
    input clk100,
    input [4:0] sw,     // temporary switch input
    output [6:0] seg,   // output for the segments
    output [3:0] an,    // output for the anodes
    output servoOut     // frequency output to control Servo
    );

    logic reset = 0;

    sevseg_controller u0 (
        .sw(sw[1:0]),
        .*
    );

    servoController u1 (
        .sw(sw[4:2]),
        .*
    );

endmodule
  