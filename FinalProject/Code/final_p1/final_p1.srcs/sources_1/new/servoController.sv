`timescale 1ns / 1ps

// IMPORTANT: for testing, increment counter by the step to cycle through all the positions
// in the future replace general increment with increment based on phototransistor

/*DEFINITONS*/
parameter MAX_PWM_SIGNAL = 250_000; // 400Hz clock from 1/2.5ms
parameter MAX_POS = 240_000; // max clockwise position
parameter MIN_POS = 60_000; // min clockwise position
parameter STEP = 100; // increment count by 100 to turn clockwise by 1 degree

/*MODULE*/
module servoController(
        input clk100,
        input servoPhotoT,
        output servoOut
    );

    // using 20 bit counter for a count to reach 250_000
    logic [19:0] pwmSize = MIN_POS; // add 100 each iteration, then subtract 100 when it reaches max position
    logic [19:0] pulseCount = 0; // use this as a counter to compare to pwmCount
    logic servoOutTemp = 0;
    logic reverse = 0; // set to 1 when servo is returning to minimum

    // servo logic
    always @(posedge clk100) begin
        pulseCount <= pulseCount + 1;
        
        if ((pulseCount < pwmSize)) begin
            servoOutTemp <= 1'b1;
        end
        else begin
            servoOutTemp <= 1'b0;
        end

     //TODO: replace sweeping with sit at middle position until triggered
       if (pulseCount == MAX_PWM_SIGNAL) begin
            pulseCount <= 20'd0;

            if (pwmSize == MAX_POS) begin
                reverse <= 1'b1;
            end
            else if (pwmSize == MIN_POS) begin
                reverse <= 1'b0;
            end
            
            if (!servoPhotoT) begin
                case (reverse)
                    0: pwmSize <= pwmSize + STEP;
                    1: pwmSize <= pwmSize - STEP;
                endcase
            end
       end

    end
    
    assign servoOut = servoOutTemp;

endmodule
