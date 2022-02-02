`timescale 1ns/1ps
//counter of 100_000 creates clock of 100Hz

module motor_controller(
    input [7:0] SW, // SW7 for direction, SW0 - SW6 for speed
    input clk,
    input reset,
    output reg [1:0] EN, // output for signal to the 2 motors
    output reg [7:0] LED, // LEDs that light when a switch is pulled
    output reg reset_out // pass reset through to top module
);
    reg [20:0] timer_counter = 0; // 20 bits for counting, 21st bit for checking when to reset
    reg [6:0] pwm_count = 0; // 6 bits for controlling PWM
    reg [6:0] width = 0; // length of pwm output
    reg stop_flag = 0;
    wire [1:0] activity = 0; // triggers motor movement
    wire [10:0] current_out = 0; // 10 bits for current output
    
    /*CLOCK CONFIG*/
    always @(posedge clk or reset) begin
        if (reset == 1'b1) begin
            stop_flag <= 1'b1;
            reset_out <= 1'b1;
            timer_counter <= 1'b0;
        end
        else if (reset == 1'b0 && stop_flag == 1'b1) begin
            stop_flag <= 1'b0;
            reset_out <= 1'b0;
            timer_counter <= 1'b0;
        end
        else begin
            if (timer_counter[20] == 1'b1) begin
                timer_counter = 0;
            end
        timer_counter = timer_counter + 1;
        end
    end
    assign activity = timer_counter[19:18];

/*PWM CHART*/
    always @(*) begin
        if (activity > 0) begin
            case (SW) // 7 random pwm signals chosen
                // 76543210 <- switches
                8'b00000001: width = 7;
                8'b00000010: width = 27;
                8'b00000100: width = 33;
                8'b00001000: width = 44;
                8'b00010000: width = 68;
                8'b00100000: width = 70;
                8'b01000000: width = 80;
                // reverse direction
                8'b10000001: width = 7;
                8'b10000010: width = 27;
                8'b10000100: width = 33;
                8'b10001000: width = 44;
                8'b10010000: width = 68;
                8'b10100000: width = 70;
                8'b11000000: width = 80;
                default:     width = 0;
             endcase
        end
    end

/*OUTPUT*/
    always @(*) begin
        if ((activity > 0) && (stop_flag != 1)) begin
            EN = (pwm_count > width) ? 0 : (SW[7] == 1'b1) ? -1 : 1;
            pwm_count = pwm_count + 1;
        end
    end
    
    // TODO: add current sensor here, current out will come from this module first
    sevenseg_controller u0 (.clk(clk),
                            .SW7(SW[7]),
                            .current_num(current_out));


endmodule