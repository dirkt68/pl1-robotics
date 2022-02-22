`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2015 03:26:51 PM
// Design Name: 
// Module Name: // Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Fixed timing slack (ArtVVB 06/01/17)
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module current_sensor(
    input CLK100MHZ,
    input vauxp6,
    input vauxn6,
    input vauxp14,
    input vauxn14,
    output [15:0] sseg_data_out
);

    wire enable;
    wire ready;
    wire [15:0] data;
    reg [6:0] Address_in;

    reg [32:0] count;
    reg [1:0] state = 0;
    reg [15:0] sseg_data;
	
	//binary to decimal converter signals
    reg b2d_start;
    reg int_sw;
    reg [15:0] b2d_din;
    wire [15:0] b2d_dout;
    wire b2d_done;

    //xadc instantiation connect the eoc_out .den_in to get continuous conversion
    xadc_wiz_0  XLXI_7 (
        .daddr_in(Address_in),
        .dclk_in(CLK100MHZ), 
        .den_in(enable), 
        .di_in(0), 
        .dwe_in(0), 
        .busy_out(),
        .vauxp6(vauxp6),
        .vauxn6(vauxn6),
        .vauxp14(vauxp14),
        .vauxn14(vauxn14),
        .vn_in(0), 
        .vp_in(0), 
        .alarm_out(), 
        .do_out(data), 
        .eoc_out(enable),
        .eos_out(),
        .channel_out(),
        .drdy_out(ready)
    );
    
    //binary to decimal conversion
    always @ (posedge(CLK100MHZ)) begin
        case (state)
        0: begin
            state <= 1;
            count <= 0;
        end
        1: begin
            if (count >= 10000000) begin
                if (data > 16'hFFD0) begin
                    sseg_data <= 16'h1000;
                    state <= 0;
                end 
                else begin
                    b2d_start <= 1'b1;
                    b2d_din <= data;
                    state <= 2;
                end
            end else
            count <= count + 1'b1;
        end
        2: begin
            b2d_start <= 1'b0;
            if (b2d_done == 1'b1) begin
                sseg_data <= b2d_dout;
                state <= 0;
            end
        end
        endcase
    end
    
    bin2dec m_b2d (
        .clk(CLK100MHZ),
        .start(b2d_start),
        .din(b2d_din),
        .done(b2d_done),
        .dout(b2d_dout)
    );
      
    always @(posedge(CLK100MHZ)) begin
        case(int_sw)
            0: begin
                Address_in <= 8'h16; // channel 22
                int_sw <= 1;
            end
            1: begin
                Address_in <= 8'h1e; // channel 30
                int_sw <= 0;
            end
            default: begin
                Address_in <= 8'h16; // channel 22
                int_sw <= 1;
            end
        endcase
    end
    assign sseg_data_out = sseg_data;
endmodule