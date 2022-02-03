`timescale 1ns / 1ps

// an[0] = segment furthest right, etc.
// to run a segment, set anode of the segment to one, then set the segments to what you want
// example: want to make position 2 say 5, an[1] = 1 and seg = afgcd = 1101101
// can use first three for current in mA, fourth display says F or r for direction

module sevenseg_controller(
        input clk,            // 100 MHz clock
        input SW7,            // switch which controls direction 0 = forward, 1 = backward
        input [12:0] current_num, // value of current
        output reg [6:0] SEG, // each segment of the display
        output reg [3:0] AN   // each anode which represents which section of 7seg display to activate
    );
    reg [20:0] counter = 0; // create 20 bit counter to create ~100 Hz refresh rate, if counter[20] == 1 reset
    reg [3:0] LED_BCD = 0; // each digit of the display goes here to get converted to the decimal number
    wire [1:0] LED_pos = 0; // this will take 2 MSB of the counter to update the numbers

/*CLOCK CONFIG*/
    always @(posedge clk) begin
        if (counter[20] == 1'b1) begin // reset counter if nearing overflow
            counter = 0;
        end
        counter <= counter + 1;
    end
    assign LED_pos = counter[19:18]; // will tell board which led to activate

/*LED CONTROL*/
    always @(*) begin
        case(LED_pos)
            2'b00: begin // LED4 - forward or backwards
                AN = 4'b0111;
                if (SW7 == 1'b1) begin
                    LED_BCD = 4'b1010; // sets to number 10 which will be the case for r
                end
                else begin
                    LED_BCD = 4'b1011; // sets to number 11 which will be the case for F
                end
            end
            2'b01: begin // LED3 - LED0
                AN = 4'b1011;
                LED_BCD = ((current_num % 1000) / 100); // third digit
            end
            2'b10: begin
                AN = 4'b1101;
                LED_BCD = ((current_num % 1000) % 100) / 10; // second digit
            end
            2'b11: begin
                AN = 4'b1110;
                LED_BCD = ((current_num % 1000) % 100) % 10; // last digit
            end
        endcase
    end

/*BCD CHART*/
    always @(*) begin
        case(LED_BCD)       //abcdefg
            4'b0000: SEG = 7'b0000001; // "0"
            4'b0001: SEG = 7'b1001111; // "1"
            4'b0010: SEG = 7'b0010010; // "2"
            4'b0011: SEG = 7'b0000110; // "3"
            4'b0100: SEG = 7'b1001100; // "4"
            4'b0101: SEG = 7'b0100100; // "5"
            4'b0110: SEG = 7'b0100000; // "6"
            4'b0111: SEG = 7'b0001111; // "7"
            4'b1000: SEG = 7'b0000000; // "8"
            4'b1001: SEG = 7'b0000100; // "9"
            4'b1010: SEG = 7'b1111010; // "r"
            4'b1011: SEG = 7'b0111000; // "F"
            default: SEG = 7'b0000001; // "0"
        endcase
    end

endmodule
