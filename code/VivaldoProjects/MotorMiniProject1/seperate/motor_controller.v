`timescale 1ns/1ps

module motor_controller(
    input [7:0] SW, // SW7 for direction, SW0 - SW6 for speed
    input clk,
    input reset,
    output [3:0] IN
);
    reg [16:0] timer_counter; // 17 bits for creating ~762Hz frequency
    reg [3:0] in_temp;
    reg [16:0] width;         // size of pulse
    reg [7:0] SW_out;
    
    initial begin
        timer_counter = 0;
        width = 0;
    end

/*PWM CHART*/
    always @(*) begin
        SW_out <= SW;
        case (SW_out)
            8'b00000000: width = 17'd0;
            8'b00000001: width = 17'd39321;  // 30%
            8'b00000010: width = 17'd52428; // 40%
            8'b00000100: width = 17'd65536; // 50%
            8'b00001000: width = 17'd78643; // 60%
            8'b00010000: width = 17'd91750; // 70%
            8'b00100000: width = 17'd104858; // 80%
            8'b01000000: width = 17'd117965; // 90%
            8'b10000000: width = 17'd0;
            8'b10000001: width = 17'd39321;  // 30%
            8'b10000010: width = 17'd52428; // 40%
            8'b10000100: width = 17'd65536; // 50%
            8'b10001000: width = 17'd78643; // 60%
            8'b10010000: width = 17'd91750; // 70%
            8'b10100000: width = 17'd104858; // 80%
            8'b11000000: width = 17'd117965; // 90%
            default:     width = 17'd0; // if multiple switches are selected, turn off to prevent error
        endcase
    end

/*OUTPUT*/
    always @(posedge clk) begin
        timer_counter <= timer_counter + 1;
        if (reset == 0) begin
            if ((timer_counter < width) && (SW[7] == 1)) begin
                in_temp <= 4'b1001;
            end
            else if ((timer_counter < width) && (SW[7] == 0)) begin
                in_temp <= 4'b0110;
            end
            else begin
                in_temp <= 4'b0000;
            end
        end
        else begin
            in_temp <= 4'b0000;
        end
    end
    assign IN = in_temp;

endmodule