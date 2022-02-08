//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2022 07:11:16 PM
// Design Name: 
// Module Name: test_adder
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


module test_adder(
    input [3:0] a,
    input [3:0] b,
    input c_in,
    output reg [3:0] sum,
    output reg c_out
    );

    always @ (a or b or c_in) begin
        {c_out, sum} = a + b + c_in;
    end

endmodule
