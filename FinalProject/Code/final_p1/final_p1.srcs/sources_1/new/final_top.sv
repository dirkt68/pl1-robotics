`timescale 1ns / 1ps

module final_top(
    input clk100,
    input comparator,
    
    /*SERVO CONTROLS*/
    output servoOut,        // JC1
    
    /*INFRARED SENSORS*/
    input [2:0] infraSensor, // JB2, JB3, JB4
                             // right, middle, left

    /*PHOTOTRANSISTORS*/
    input servoPhotoT,      // JB1
	input RPhotoT,          // JB7
    input LPhotoT,          // JB8

    /*MOTOR*/
    input motor,     // SW0 - turn off motors when unwanted
    output [3:0] IN, // motor control pins

    output [6:0] seg,   // output for the segments
    output [3:0] an    // output for the anodes
    );

    /*WIRES*/
    wire stopSig;
	wire [1:0] RFreq;
	wire [1:0] LFreq;
	wire [1:0] servoFreq;

    sevsegController u0 (
        .*
    );

    servoController u1 (
        .*
    );

    driverController u2 (
        .*
    );

	freqCounter u3 (
		.*
	);

endmodule
  