`timescale 1ns / 1ps

// IMPORTANT: for testing, increment counter by the step to cycle through all the positions
// in the future replace general increment with increment based on phototransistor

/*DEFINITONS*/
parameter MAX_PWM_SIGNAL = 250_000; // 400Hz clock from 1/2.5ms
parameter MAX_POS = 240_000; // max clockwise position
parameter NEUTRAL_POS = 150_000; // face middle position
parameter MIN_POS = 60_000; // min clockwise position
parameter STEP = 1000; // ~ 1 degree of movement
parameter TIME_S = 500_000_000; // 5 seconds to spin and hold the servo

/*MODULE*/
module servoController(
        input clk100,
        input [1:0] servoFreq,
        input [1:0] RFreq,
        input [1:0] LFreq,

        output reg fireSig,
        output servoOut
    );

    // using 20 bit counter for a count to reach 250_000
    logic [19:0] pwmSize = NEUTRAL_POS;
    logic [19:0] pulseCount = 0; // use this as a counter to compare to pwmCount
	logic [28:0] timer = 0; // timer for when the servo starts moving to find an enemy
    logic servoOutTemp = 0;
	logic timerLStart = 0;
	logic timerRStart = 0;
	logic pauseMovement = 0;
	
    // servo logic
    always @(posedge clk100) begin
        pulseCount <= pulseCount + 1;

		if (timerLStart || timerRStart) begin
			timer <= timer + 1;
		end
        
        if ((pulseCount < pwmSize)) begin
            servoOutTemp <= 1'b1;
        end

        else begin
            servoOutTemp <= 1'b0;
        end

       if (pulseCount == MAX_PWM_SIGNAL) begin
        	pulseCount <= 20'd0;
			
			if (RFreq == 2 || timerRStart) begin
				timerRStart <= 1;

				if (servoFreq != 2 && !pauseMovement) begin
					pwmSize <= (pwmSize < MAX_POS) ? (pwmSize + STEP) : (pwmSize);
				end

			end
			
			else if (LFreq == 2 || timerLStart) begin
				timerLStart <= 1;

				if (servoFreq != 2 && !pauseMovement) begin
					pwmSize <= (pwmSize > MIN_POS) ? (pwmSize - STEP) : (pwmSize);
				end

				end
		end

		if (servoFreq == 2) begin
			pauseMovement <= 1;
			fireSig <= 1;
		end
		
		else if (pwmSize >= MAX_POS || pwmSize <= MIN_POS) begin
			pauseMovement <= 1;
			fireSig <= 1;
		end

		if (timer == TIME_S) begin
		   timerRStart <= 0;
		   timerLStart <= 0;
		   timer <= 0;
		   pwmSize <= NEUTRAL_POS;
		   pauseMovement <= 0;
		   fireSig <= 0;
	   end
    end
    
    assign servoOut = servoOutTemp;
endmodule
