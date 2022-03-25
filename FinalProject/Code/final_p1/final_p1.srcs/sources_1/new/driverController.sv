`timescale 1ns/1ps

// infraSensor0 = right
// infraSensor1 = middle
// infraSensor2 = left
// max number = 131_071 = 2^17

parameter COAST_SPEED = 91_750; // 70% speed
parameter MAX_SPEED = 117_965; // 90% speed for turning
parameter DRIVE_BY = 19_661; // 15% speed
parameter MAX_SPEED_DB = 32_768; // 35% speed for turning

module driverController (
  input clk100,
  input RRPhotoT,
  input LRPhotoT,
  input [2:0] infraSensor,
  input comparator,
  output [3:0] IN
);

logic [16:0] widthCounter = 0;
logic [16:0] pwmSize = COAST_SPEED;
logic [3:0] inTemp = 0;

always @(posedge clk100 iff (!comparator)) begin
  widthCounter <= widthCounter + 1;
  
  if (RRPhotoT || LRPhotoT) begin
    pwmSize <= DRIVE_BY;
  end
  else begin
    pwmSize <= COAST_SPEED;
  end

  case (infraSensor)
    3'b010: begin
      if (widthCounter < pwmSize) begin
        inTemp <= 4'b0110;
      end
      else begin
        inTemp <= 4'b0000;
      end
    end
    
    3'b001: begin
      if (widthCounter < pwmSize) begin
        inTemp <= 4'b0101;
      end
      else begin
        inTemp <= 4'b0000;
      end
    end

    3'b100: begin
      if (widthCounter < pwmSize) begin
        inTemp <= 4'b1010;
      end
      else begin
        inTemp <= 4'b0000;
      end
    end

    3'b110: begin
      if (widthCounter < pwmSize) begin
        inTemp <= 4'b1010;
      end
      else begin
        inTemp <= 4'b0000;
      end
    end

    3'b011: begin
      if (widthCounter < pwmSize) begin
        inTemp <= 4'b0101;
      end
      else begin
        inTemp <= 4'b0000;
      end
    end
    
    default: begin
      if (widthCounter < pwmSize) begin
        inTemp <= 4'b1001;
      end
      else begin
        inTemp <= 4'b0000;
      end
    end
  endcase
end

assign IN = inTemp;

endmodule