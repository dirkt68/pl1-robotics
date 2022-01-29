`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Texas Tech University
// Engineer: Dirk Thieme
// 
// Create Date: 01/29/2022 01:02:47 PM
// Design Name: Motor Driver Top
// Module Name: motor_driver_top
// Project Name: Motor Mini Project
// Target Devices: Basys 3 Board
// Tool Versions: Viviado 2021.2
// Description: A file to drive a motor using the built in switches to control the speed and direction of the motor
// 
// Dependencies: 
// 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module motor_driver_top(
        input [7:0] SW,       // switches
        input clk,            // clock input
        input current_level,  // level of current passing through the resistor
        output reg [7:0] LED, // LED output above switches to notify which is active
        
        output reg [6:0] SEG, // each segment of the display
        output reg [3:0] AN   // each anode which represents which section of 7seg display to activate
    );

always @* begin

end


endmodule
