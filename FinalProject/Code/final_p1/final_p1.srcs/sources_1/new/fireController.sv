`timescale 1ns / 1ps

parameter FIVE_SECS = 500_000_000; // five second timer

/*STATE NAMES*/
parameter WAIT = 0;
parameter PUSH_TRIG = 1;
parameter PULL_TRIG = 2;

module fireController(
	input clk100,
	input fireSig,

	output reg actuatorPush,
	output reg actuatorPull
	);

	logic [28:0] timer = 0;

	int state = WAIT;

	always @(posedge clk100) begin
		case (state)
			WAIT: begin // state to wait for a fire signal from the servo
				
				// when the fire signal is triggered, start pushing out the trigger
				if (fireSig) begin
					state <= PUSH_TRIG;
				end
				
				// if no fire trigger, just reset the state and the registers
				else begin
					timer <= 0;
					actuatorPush <= 0;
					actuatorPull <= 0;
					state <= WAIT;
				end
			end

			PUSH_TRIG: begin // push the acuator out to fire the gun for 5 seconds
				
				// increment the timer while in the state
				if (timer < FIVE_SECS) begin
					timer <= timer + 1;
				end

				actuatorPush <= 1; // push the acuator

				// when timer hits five seconds, reset timer and turn off push, then switch to pull state
				if (timer == FIVE_SECS) begin
					timer <= 0;
					actuatorPush <= 0;
					state <= PULL_TRIG;
				end
			end

			PULL_TRIG: begin // state to pull the trigger, reloading the rubber band gun
				
				// increment the timer while in the state
				if (timer < FIVE_SECS) begin
					timer <= timer + 1;
				end

				actuatorPull <= 1; // pull trigger back

				// when timer hits five seconds, reset timer and state back to wait
				if (timer == FIVE_SECS) begin
					timer <= 0;
					actuatorPull <= 0;
					state <= WAIT;
				end
			end

			default : state <= WAIT;

		endcase
	end
endmodule
