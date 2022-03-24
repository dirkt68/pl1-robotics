`timescale 1ns / 1ps

module final_top(
    input clk100,
    
    /*SERVO CONTROLS*/
    input servoPhotoT,      // JB1
    output servoOut,        // JC1
    
    /*INFRARED SENSORS*/
    input infraSensorRight, // JB2
    input infraSensorMid,   // JB3
    input infraSensorLeft,  // JB4

    /*PHOTOTRANSISTORS*/
    input RRPhotoT, // JB7
    input RBPhotoT, // JB8
    input LRPhotoT, // JB9
    input LBPhotoT, // JB10

    input [3:0] IN, // motor control pins
    output [6:0] seg,   // output for the segments
    output [3:0] an    // output for the anodes
    );

    /*WIRES*/
    wire reset;

    sevsegController u0 (
        .*
    );

    servoController u1 (
        .*
    );

endmodule
  