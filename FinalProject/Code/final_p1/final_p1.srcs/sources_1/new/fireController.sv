`timescale 1ns / 1ps

parameter TIME_A = 600_000_000; // four second timer

/*STATE NAMES*/
parameter SETUP = 0;
parameter WAIT = 1;
parameter PUSH_TRIG = 2;
parameter PULL_TRIG = 3;

module fireController(
	input clk100,
	input fireSig,

	output actuatorPush,
	output actuatorPull
	);

	logic [31:0] timer = 0;

	logic [7:0] state = SETUP;
	logic actuatorPullTemp = 0;
	logic actuatorPushTemp = 0;

	assign actuatorPull = actuatorPullTemp;
	assign actuatorPush = actuatorPushTemp;

	always @(posedge clk100) begin
		case (state)
			SETUP: begin // ensure actuator is in ready position
				if (timer < TIME_A) begin
					timer <= timer + 1;
					state <= SETUP;
				end

				actuatorPullTemp <= 1;

				if (timer == TIME_A) begin
					state <= WAIT;
					actuatorPullTemp <= 0;
					timer <= 0;
				end
			end
			
			WAIT: begin // state to wait for a fire signal from the servo

				// when the fire signal is triggered, start pushing out the trigger
				if (fireSig) begin
					state <= PUSH_TRIG;
				end
				
				// if no fire trigger, just reset the state and the registers
				else begin
					timer <= 0;
					actuatorPushTemp <= 0;
					actuatorPullTemp <= 0;
					state <= WAIT;
				end
			end

			

			PUSH_TRIG: begin // push the acuator out to fire the gun for 5 seconds
				
				// increment the timer while in the state
				if (timer < TIME_A) begin
					timer <= timer + 1;
					state <= PUSH_TRIG;
				end

				actuatorPushTemp <= 1; // push the acuator

				// when timer hits five seconds, reset timer and turn off push, then switch to pull state
				if (timer == TIME_A) begin
					timer <= 0;
					actuatorPushTemp <= 0;
					state <= PULL_TRIG;
				end
			end

			PULL_TRIG: begin // state to pull the trigger, reloading the rubber band gun
				
				// increment the timer while in the state
				if (timer < TIME_A) begin
					timer <= timer + 1;
					state <= PULL_TRIG;
				end

				actuatorPullTemp <= 1; // pull trigger back

				// when timer hits five seconds, reset timer and state back to wait
				if (timer == TIME_A) begin
					timer <= 0;
					actuatorPullTemp <= 0;
					state <= WAIT;
				end
			end
		endcase
	end
endmodule
