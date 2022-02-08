`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2022 07:17:39 PM
// Design Name: 
// Module Name: test_adder_tb
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


module test_adder_tb;
    reg [3:0] a;
    reg [3:0] b;
    reg c_in;
    wire [3:0] sum;
    wire c_out;
    integer i;

test_adder UUT (a, b, c_in, sum, c_out);
initial begin
    a <= 0;
    b <= 0;
    c_in <= 0;

    $monitor ("a = 0x%0h b = 0x%0h c_in = 0x%0h c_out = 0x%0h sum = 0x%0h", a, b, c_in, c_out, sum);

    for (i = 0; i < 10; i = i + 1) begin
        #100;
        a <= $random;
        b <= $random;
        c_in <= $random;
    end
end
endmodule