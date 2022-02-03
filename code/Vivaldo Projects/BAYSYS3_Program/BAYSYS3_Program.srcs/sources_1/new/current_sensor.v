`timescale 1ns/1ps

module current_sensor(
        input [12:0] current_numA, 
        input [12:0] current_numB,
        input clk,
        output reg reset
    );

    always @(posedge clk) begin
        if ((current_numA > 900) || current_numB > 900) begin
        end
    end

endmodule