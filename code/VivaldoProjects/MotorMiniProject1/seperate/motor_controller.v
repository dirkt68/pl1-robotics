`timescale 1ns/1ps

module motor_controller(
    input [7:0] SW, // SW7 for direction, SW0 - SW6 for speed
    input clk,
    input reset,

    output [3:0] IN
);
    reg [18:0] timer_counter = 0; // 20 bits for counting, 21st bit for checking when to reset
    reg [6:0] pwm_count = 0;      // 6 bits for controlling PWM
    reg [3:0] in_temp;
    reg [6:0] width = 0;          // length of pwm output
    reg [7:0] SW_out;
    
    /*CLOCK CONFIG*/
    always @(posedge clk) begin
        if (reset == 1'b1) begin
            timer_counter <= 0;
        end
        else begin
            if (timer_counter[18] == 1'b1) begin
                timer_counter <= 0;
            end
        timer_counter <= timer_counter + 1;
        end
    end

/*PWM CHART*/
    always @(*) begin
        SW_out <= SW;
        if (timer_counter[17:16] > 0) begin
            case (SW_out) // 7 random pwm signals chosen
                8'b00000000: width = 0;
                8'b00000001: width = 30;
                8'b00000010: width = 40;
                8'b00000100: width = 50;
                8'b00001000: width = 60;
                8'b00010000: width = 70;
                8'b00100000: width = 80;
                8'b01000000: width = 90;
                8'b10000000: width = 0;
                8'b10000001: width = 30;
                8'b10000010: width = 40;
                8'b10000100: width = 50;
                8'b10001000: width = 60;
                8'b10010000: width = 70;
                8'b10100000: width = 80;
                8'b11000000: width = 90;
                default:     width = 0; // if multiple switches are selected, turn off to prevent error
             endcase
        end
    end

/*OUTPUT*/
    always @(*) begin
            if (timer_counter[18:17] > 0) begin
                pwm_count = pwm_count + 1;
                in_temp = (pwm_count > width) ? 4'b0000 : (SW[7] == 1'b1) ? 4'b1001 : 4'b0110;
            end
            if (pwm_count > 99) begin
                pwm_count = 0;
            end
    end
    assign IN = in_temp;
endmodule