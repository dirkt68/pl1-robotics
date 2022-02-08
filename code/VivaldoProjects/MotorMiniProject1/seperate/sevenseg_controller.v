`timescale 1ns / 1ps

// an[0] = segment furthest right, etc.
// to run a segment, set anode of the segment to one, then set the segments to what you want
// example: want to make position 2 say 5, an[1] = 1 and seg = afgcd = 1101101
// can use first three for current in mA, fourth display says F or r for direction

module sevenseg_controller(
        input clk,            // 100 MHz clock
        input SW7,            // switch which controls direction 0 = forward, 1 = backward
        input [11:0] current_num, // value of current
        output [6:0] SEG, // each segment of the display
        output [3:0] AN   // each anode which represents which section of 7seg display to activate
    );
    reg [3:0] an_temp;
    reg [19:0] counter; // create 19 bit counter to create ~380 Hz refresh rate, if counter[20] == 1 reset
    reg [3:0] LED_BCD;  // each digit of the display goes here to get converted to the decimal number
    reg [6:0] seg_temp;

    always @(posedge clk) begin
        counter <= counter + 1;
    end

/*LED CONTROL*/
    always @(*) begin
        case(counter[19:18])
            2'b00: begin // LED4 - forward or backwards
                an_temp = 4'b0111;
                if (SW7 == 1'b1) begin
                    LED_BCD = 4'b1010; // sets to number 10 which will be the case for r
                end
                else begin
                    LED_BCD = 4'b1011; // sets to number 11 which will be the case for F
                end
            end
            2'b01: begin // LED3 - LED0
                an_temp = 4'b1011;
                //LED_BCD = current_num[11:8];
                LED_BCD = ((current_num % 1000) / 100); // third digit
            end
            2'b10: begin
                an_temp = 4'b1101;
                //LED_BCD = current_num[7:4];
                LED_BCD = ((current_num % 1000) % 100) / 10; // second digit
            end
            2'b11: begin
                an_temp = 4'b1110;
                //LED_BCD = current_num[3:0];
                LED_BCD = ((current_num % 1000) % 100) % 10; // last digit
            end
        endcase
    end
    assign AN = an_temp;

/*BCD CHART*/
    always @(*) begin
        case(LED_BCD)            //gfedcba
            4'b0000: seg_temp = 7'b1000000; // "0"
            4'b0001: seg_temp = 7'b1111001; // "1"
            4'b0010: seg_temp = 7'b0100100; // "2"
            4'b0011: seg_temp = 7'b0110000; // "3"
            4'b0100: seg_temp = 7'b0011001; // "4"
            4'b0101: seg_temp = 7'b0010010; // "5"
            4'b0110: seg_temp = 7'b0000010; // "6"
            4'b0111: seg_temp = 7'b1111000; // "7"
            4'b1000: seg_temp = 7'b0000000; // "8"
            4'b1001: seg_temp = 7'b0011000; // "9"
            4'b1010: seg_temp = 7'b0101111; // "r"
            4'b1011: seg_temp = 7'b0001110; // "F"
            default: seg_temp = 7'b1000000; // "0"
        endcase
    end
    assign SEG = seg_temp;
endmodule
