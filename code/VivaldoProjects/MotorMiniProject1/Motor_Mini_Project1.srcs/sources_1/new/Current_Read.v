`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Texas Tech
// Engineer: Erik Manis
// 
// Create Date: 02/08/2022 08:27:12 PM
// Design Name: 
// Module Name: Current_Read
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


module Current_Read (
    input CLK100MHZ,
    input vauxp6,
    input vauxn6,
    input vauxp7,
    input vauxn7,
    input vauxp14,
    input vauxn14,
    input vauxp15,
    input vauxn15,
    input vp_in,
    input vp_vn,
    output [3:0] AN,
    output [6:0] SEG,
);
    
    wire enable;
    wire ready;
    wire [15:0] data;
    reg [6:0] Address_In;
    
    reg [32:0] count;
    localparam S_IDLE = 0;
    localparam S_FRAME_WAIT = 1;
    localparam S_CONVERSION = 2;
    reg [1:0] state = S_IDLE;
    reg [15:0] sseg_data;    
    
    reg B2D_Start;
    reg [15:0] B2D_din;
    wire [15:0] B2D_dout;
    wire B2D_Done;
    
    xadc_wiz_0 XLXI_7 (
        .daddr_in(Address_In),
        .den_in(endable),
        .di_in(0),
        .dwe_in(0),
        .busy_out(),
        .vauxp6(vauxp6),
        .vauxn6(vauxn6),
        .vauxp7(vauxp7),
        .vauxn7(vauxn7),
        .vauxp14(vauxp14),
        .vauxn14(vauxn14),
        .vauxp15(vauxp15),
        .vauxn15(vauxn15),
        .vn_in(vn_in), 
        .vp_in(vp_in), 
        .alarm_out(), 
        .do_out(data), 
        .reset_in(),
        .eoc_out(enable),
        .channel_out(),
        .drdy_out(ready),
        .eos_out(enable)       
    );


    always @ (posedge (CLK100MHZ)) begin
        case (state)
        S_IDLE: begin
            state <= S_FRAME_WAIT;
            count <= 'b0;
        end
        S_FRAME_WAIT: begin
            if (count >= 10000000) begin
                if (data > 16'hFFD0) begin
                    sseg_data <= 16'h1000;
                    state <= S_IDLE;
                end else begin
                    B2D_Start <= 1'b1;
                    B2D_din <= data;
                    state <= S_CONVERSION;
                end 
             end else
                count <= count + 1'b1;
        end
        S_CONVERSION: begin
            B2D_Start <= 1'b0;
            if (B2D_Done == 1'b1) begin
                sseg_data <= B2D_dout;
                state <= S_IDLE;
            end 
        end 
        endcase    
    end 
    
    Bin2Dec (
        .clk(CLK100MHZ),
        .start(b2d_start),
        .din(b2d_din),
        .done(b2d_done),
        .dout(b2d_dout)
    );
        
        

    
endmodule










