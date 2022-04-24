`timescale 1ns / 1ps

module final_top(
	// all inputs go into JB, outputs go to JA for the motors, JC for the accessories or are routed internally
	input clk100,			// internal clock

	/*COMPARATOR*/
	input comparator, 		// JB9

	/*SERVO CONTROLS*/
	output servoOut,		// JC1

	/*ACTUATOR OUTPUtS*/
	output reg actuatorPull,	// JC2
	output reg actuatorPush,	// JC3

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

	/*SEVEN SEGMENT DISPLAY*/
	output [6:0] seg,	// output for the segments
	output [3:0] an		// output for the anodes
	);

	/*WIRES*/
	wire fireSig;
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

	fireController u4 (
		.*
	);

endmodule