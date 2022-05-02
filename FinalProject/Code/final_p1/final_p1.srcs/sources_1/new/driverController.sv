`timescale 1ns/1ps

// infraSensor0 = right
// infraSensor1 = middle
// infraSensor2 = left
// max number = 131_071 = 2^17

/*PWM SIZE PARAMS*/
parameter COAST_SPEED = 81_750; // 65% speed

/*DIRECTION PARAMS*/
parameter SPIN_RIGHT = 4'b1010;
parameter SPIN_LEFT = 4'b0101;
parameter FORWARD = 4'b1001;
parameter REVERSE = 4'b0110;
parameter PAUSE = 4'b0000;

module driverController (
	input clk100,
	input [2:0] infraSensor,
	input comparator,
	input motor,
	output [3:0] IN
);

logic [16:0] widthCounter = 0;
logic [16:0] pwmSize = COAST_SPEED;
logic [3:0] inTemp = 0;

always @(posedge clk100) begin
	widthCounter <= widthCounter + 1;

	if ((widthCounter < pwmSize) && !motor && !comparator) begin
		case (infraSensor)
			3'b000: inTemp <= FORWARD;
			3'b001: inTemp <= SPIN_RIGHT;
			3'b010: inTemp <= FORWARD;
			3'b011: inTemp <= SPIN_RIGHT;
			3'b100: inTemp <= SPIN_LEFT;
			3'b101: inTemp <= FORWARD;
			3'b110: inTemp <= SPIN_LEFT;
			3'b111: inTemp <= FORWARD;
		endcase
	end

	else begin
		inTemp <= PAUSE;
	end

end

assign IN = inTemp;

endmodule