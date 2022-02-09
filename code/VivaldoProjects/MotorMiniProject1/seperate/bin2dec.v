`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Arthur Brown
// 
// Create Date: 03/23/2017
// Module Name: bcd
// Project Name: OLED Demo
// Target Devices: Nexys Video
// Tool Versions: Vivado 2016.4
// Description: converts an input in the range (0x0000-0xFFFF) to a hex string in the range (16'h0000-16'h1000)
//              assert start & din, some amount of time later, done is asserted with valid dout
// Dependencies: none
// 
// 03/23/2017(ArtVVB): Created
//
//////////////////////////////////////////////////////////////////////////////////

module bin2dec (
    input clk,
    input start,
    input [15:0] din,
    output done,
    output reg [15:0] dout
);
    //{0x0000-0xFFFF}->{"0000"-"1000"} 
    reg [2:0] state = 0;
    reg [31:0] data;
    reg [31:0] div;
    reg [3:0] mod;
    reg [1:0] byte_count;
    
    assign done = (state == 0 || state == 1) ? 1 : 0;
    
    always@(posedge clk)
        case (state)
        0: begin
            if (start == 1) begin
                state <= 2;
                data <= ({16'b0, din} * 1000) >> 16;
                byte_count <= 0;
            end
        end
        1: begin
            if (start == 0)
                state <= 0;
        end
        2: begin
            div <= data / 10;
            mod <= data % 10;
            state <= 4;
        end
        3: begin
            if (byte_count == 3)
                state <= 1;
            else
                state <= 2;
            data <= div;
            byte_count <= byte_count + 1;
        end
        4: begin
            dout[11:0] <= dout[15:4];
            dout[15:12] <= mod[3:0];
            state <= 3;
        end
        default: begin
            state <= 0;
        end
        endcase
    
endmodule