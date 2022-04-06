`timescale 1ns/1ps

// infraSensor0 = right
// infraSensor1 = middle
// infraSensor2 = left
// max number = 131_071 = 2^17

/*PWM SIZE PARAMS*/
parameter COAST_SPEED = 91_750; // 70% speed
parameter DRIVE_BY = 39_321; // 30% speed

/*DIRECTION PARAMS*/
parameter SPIN_RIGHT = 4'b0101;
parameter SPIN_LEFT = 4'b1010;
parameter FORWARD = 4'b0110;
parameter PAUSE = 4'b0000;

module driverController (
  input clk100,
  input [2:0] infraSensor,
  input [1:0] RFreq,
  input [1:0] LFreq,
  input comparator,
  input motor,
  output [3:0] IN
);

logic [16:0] widthCounter = 0;
logic [16:0] pwmSize = COAST_SPEED;
logic [3:0] inTemp = 0;

always @(posedge clk100) begin
  widthCounter <= widthCounter + 1;
  if (RFreq == 2 || LFreq == 2) begin
    pwmSize <= DRIVE_BY;
  end
  else begin
    pwmSize <= COAST_SPEED;
  end

  if ((widthCounter < pwmSize) && !motor /*&& !comparator*/) begin
    case (infraSensor)
      3'b100: inTemp <= SPIN_LEFT;
      3'b001: inTemp <= SPIN_RIGHT;
      3'b110: inTemp <= SPIN_LEFT;
      3'b011: inTemp <= SPIN_RIGHT;
      default: inTemp <= FORWARD;
    endcase
  end
  
  else begin
    inTemp <= PAUSE;
  end

end

assign IN = inTemp;

endmodule