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
        input [7:0] SW,           // switches
        input clk,                // clock input
        input reset               // check if reset necessary
    );
/*VARIABLE DECLARATION*/
    wire clk_out;      // clock output
    wire reset_out;    // reset output in case triggered
    wire [7:0] SW_out; // switch output signal

/*VARIABLE ASSIGNMENT*/
    assign SW_out = SW;
    assign clk_out = clk;
    assign reset_out = reset;

/*MODULE INSTANTATION*/
    motor_controller u0 (.SW(SW_out),        // switch output
                         .clk(clk_out),      // clock into motor_controller
                         .reset(reset_out),  // places returned input reset value into motor_controller
                         .reset_out(reset)); // takes reset signal from motor_controller and uses it as input
endmodule
