`timescale 1ns / 1ps

parameter MAX_COUNT = 10_000_000;

module freqCounter(
	input clk100,
	input RPhotoT,
	input LPhotoT,
	input servoPhotoT,
	
	output reg [1:0] RFreq,
	output reg [1:0] LFreq,
	output reg [1:0] servoFreq
    );

	logic [26:0] counter = 0;
	logic ROld = 0;
	logic LOld = 0;
	logic SOld = 0;
	logic [15:0] RFreqCount = 0;
	logic [15:0] LFreqCount = 0;
	logic [15:0] servoFreqCount = 0;
	logic [15:0] RFreqOut = 0;
	logic [15:0] LFreqOut = 0;
	logic [15:0] servoFreqOut = 0;

	always @(posedge clk100) begin
		counter <= counter + 1;

		if (RPhotoT != ROld) begin
			RFreqCount <= RFreqCount + 1;
		end
		else if (LPhotoT != LOld) begin
			LFreqCount <= LFreqCount + 1;
		end
		else if (servoPhotoT != SOld) begin
			servoFreqCount <= servoFreqCount + 1;
		end

		if (counter == MAX_COUNT) begin
			counter <= 0;
			
			RFreqOut <= RFreqCount >> 1;
			LFreqOut <= LFreqCount >> 1;
			servoFreqOut <= servoFreqCount >> 1;
			
			RFreqCount <= 0;
			LFreqCount <= 0;
			servoFreqCount <= 0;
		end

		ROld = RPhotoT;
		LOld = LPhotoT;
		SOld = servoPhotoT;
	end

	always @(clk100) begin
		/*RIGHT PHOTOTRANSISTOR*/
		if (RFreqOut > 10 && RFreqOut < 40)begin
			RFreq <= 2'b01; // 1 for friend
		end
		else if (RFreqOut > 40 && RFreqOut < 110) begin
			RFreq <= 2'b10; // 2 for enemy
		end
		else begin
			RFreq <= 2'b00; // 0 for none
		end

		/*LEFT PHOTOTRANSISTOR*/
		if (LFreqOut > 10 && LFreqOut < 40)begin
			LFreq <= 2'b01;
		end
		else if (LFreqOut > 40 && LFreqOut < 110) begin
			LFreq <= 2'b10;
		end
		else begin
			LFreq <= 2'b00;
		end

		/*SERVO PHOTOTRANSISTOR*/
		if (servoFreqOut > 10 && servoFreqOut < 40)begin
			servoFreq <= 2'b01;
		end
		else if (servoFreqOut > 40 && servoFreqOut < 110) begin
			servoFreq <= 2'b10;
		end
		else begin
			servoFreq <= 2'b00;
		end
	end
endmodule
