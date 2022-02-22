`timescale 1ns/1ps
`include "current_sensor.v"

module current_sensor_tb;
    reg [7:0] SW;
    reg clk;
    reg reset;
    wire [3:0] IN;

    current_sensor UUT (SW, clk, reset, IN);
    initial begin
        clk = 0;
        forever begin
            #10;
            clk = ~clk;
        end
    end

    initial begin
        reset = 0;
        SW = 0;
        #100;
        SW = 8'b00000001;
        #100;
        SW = 8'b00000010;
        #100;
        SW = 8'b00000100;
        #100;
        SW = 8'b00001000;
        #100;
        SW = 8'b00010000;
        #100;
        SW = 8'b00100000;
        #100;
        SW = 8'b01000000;
        #100;
        SW = 8'b10000001;
        #100;
        SW = 8'b10000010;
        #100;
        SW = 8'b10000100;
        #100;
        SW = 8'b10001000;
        #100;
        SW = 8'b10010000;
        #100;
        SW = 8'b10100000;
        #100;
        SW = 8'b11000000;
        #100;
    end
endmodule