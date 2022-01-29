`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2022 03:19:25 PM
// Design Name: 
// Module Name: 7seg_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// to run a segment, set anode of the segment to one, then set the segments to what you want
// example: want to make position 2 say 5, an[1] = 1 and seg = afgcd = 1101101

module sevenseg_controller(
        input clk,
        input num_display,
        input num_pos,
        output [6:0] SEG, // each segment of the display
        output [3:0] AN  // each anode which represents which section of 7seg display to activate
    );

    always @(posedge clk) begin

    end
endmodule
