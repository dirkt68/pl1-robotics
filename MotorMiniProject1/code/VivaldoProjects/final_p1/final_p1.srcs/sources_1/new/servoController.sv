`timescale 1ns / 1ps

module servoController(
        input clk100,
        input [2:0] sw,
        input reset,
        output servoOut
    );

    // initalize a max of 1KHz counter, width, and temporary in-between register for the output
    logic [17:0] max1kclk = 0;
    logic [17:0] width = 0;
    logic servoOutTemp = 0;

    // check which switch is pulled to determine which position the servo sits at
    always @(posedge clk100) begin
        case (sw)
            3'b001: width <= 50_000;  // 50% PWM
            3'b010: width <= 75_000;  // 75% PWM
            3'b100: width <= 100_000; // 100% PWM
        endcase
    end

    // begin outputting to the servo, if reset is triggered skip always block
    always @(posedge clk100 iff reset == 0) begin
        if (max1kclk == 100_000) begin
            max1kclk <= 0;
        end
        max1kclk <= max1kclk + 1;

        if (max1kclk < width) begin
            servoOutTemp <= 1;
        end
        else begin
            servoOutTemp <= 0;
        end
    end
    
    assign servoOut = servoOutTemp;

endmodule
