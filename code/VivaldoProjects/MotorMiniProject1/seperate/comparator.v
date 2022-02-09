`timescale 1ns/1ps

module comparator(
    input [15:0] current_num,
    input clk,
    output reg reset_out
);
    always @(posedge clk) begin
        reset_out <= (current_num >= 900) ? 1 : 0;
    end
endmodule

