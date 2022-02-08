`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2022 01:34:47 PM
// Design Name: 
// Module Name: motor_driver_tb
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


module motor_driver_tb;
    reg SW0;
    reg SW1;
    wire LED0;
    integer i;

    motor_driver_top UUT (SW0, SW1, LED0);

    initial begin
    SW0 <= 0;
    SW1 <= 0;

    $monitor ("SW0 = 0x%0h SW1 = 0x%0h LED0 = 0x%0h", SW0, SW1, LED0);
    for (i = 0; i < 10; i = i + 1)begin
        #100;
        SW0 = $urandom_range(1);
        SW1 = $urandom_range(1);
    end
    end


endmodule
