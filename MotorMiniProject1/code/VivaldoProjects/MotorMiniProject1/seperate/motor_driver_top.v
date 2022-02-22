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
        input [1:0] VA,
        input [1:0] VB,
        output [7:0] LED,
        output [3:0] AN,
        output [6:0] SEG,
        output [3:0] IN
    );
/*WIRE DECLARATION*/
    wire reset;              // reset wire
    wire [15:0] current; // current output
    wire [3:0] in_temp;      // temporary wire for the output to the motors
    wire [6:0] seg_temp;     // temporary wire for the segment values
    wire [3:0] an_temp;      // temporary wire for the anode value

/*MODULE INSTANTATION*/
    current_sensor u1 (.CLK100MHZ(clk),
                       .sseg_data_out(current),
                       .vauxp6(VA[0]),
                       .vauxn6(VA[1]),
                       .vauxp14(VB[0]),
                       .vauxn14(VB[1])
                       );

    comparator u3 (.current_num(current),
                   .clk(clk),
                   .reset_out(reset)
                   );

    sevenseg_controller u2 (.clk(clk),
                            .SW7(SW[7]),
                            .current_num(current),
                            .SEG(seg_temp),
                            .AN(an_temp)
                            );
    
    motor_controller u0 (.SW(SW),        // switch output
                         .clk(clk),      // clock into motor_controller
                         .reset_in(reset),
                         .IN(in_temp)
                         );

    assign SEG = seg_temp;
    assign AN = an_temp;
    assign IN = in_temp;
    assign LED = SW;

endmodule
