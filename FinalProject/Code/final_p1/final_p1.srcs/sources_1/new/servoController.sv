`timescale 1ns / 1ps

// IMPORTANT: for testing, increment counter by the step to cycle through all the positions
// in the future replace general increment with increment based on phototransistor

parameter MAX_PWM_SIGNAL = 500_000; // 200Hz clock
parameter MAX_POS = 230_000; // max clockwise position
parameter MIN_POS = 70_000; // min clockwise position
parameter STEP = 100; // increment count by 100 to turn clockwise by 1 degree

module servoController(
        input clk100,
        input [1:0] stopSignal,
        output servoOut
    );

    // using 19 bit counter for a count to reach 500_000
    logic [19:0] pwmSize = MIN_POS; // add 100 each iteration, then subtract 100 when it reaches max position
    logic [19:0] pulseCount = 0; // use this as a counter to compare to pwmCount
    logic servoOutTemp = 0;
    logic reverse = 0; // set to 1 when servo is returning to minimum


    // begin outputting to the servo, if stopSignal is triggered skip always block
    always @(posedge clk100) begin
        pulseCount <= pulseCount + 1;
        
        if ((pulseCount < pwmSize)) begin
            servoOutTemp <= 1'b1;
        end
        else begin
            servoOutTemp <= 1'b0;
        end

       if (pulseCount == MAX_PWM_SIGNAL) begin
            pulseCount <= 19'd0;

            if (pwmSize == MAX_POS) begin
                reverse <= 1'b1;
            end
            else if (pwmSize == MIN_POS) begin
                reverse <= 1'b0;
            end
            
            if (stopSignal != 2'b10) begin
                case (reverse)
                    0: pwmSize <= pwmSize + STEP;
                    1: pwmSize <= pwmSize - STEP;
                endcase
            end
       end

    end
    
    assign servoOut = servoOutTemp;

endmodule
