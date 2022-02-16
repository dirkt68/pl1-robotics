`timescale 1ns/1ps
// TODO: fix current read
module current_sensor(
        input reset,
        input clk,
        input VPA,
        input VPB,
        input VNA,
        input VNB,
        output reset_out,
        output [15:0] current_value
    );
    reg [6:0] addr_in;
    reg counter;
    wire enable;
    wire ready;
    reg reset_out_temp;
    wire [15:0] data;

/*XADC MODULE INSTANTIATION*/
    xadc_wiz_0 XLXI_7(
        .daddr_in(addr_in),
        .dclk_in(clk),
        .den_in(enable),
        .reset_in(reset),
        .di_in(0),
        .dwe_in(0),
        .busy_out(),
        .vauxp6(VPA),
        .vauxn6(VNA),
        .vauxp14(VPB),
        .vauxn14(VNB),
        .vp_in(0),
        .vn_in(0),
        .alarm_out(),
        .do_out(data),
        .eoc_out(enable),
        .eos_out(),
        .channel_out(),
        .drdy_out(ready)
    );

    always @(posedge clk) begin
        if(ready)begin
            case (counter)
                0: begin
                    addr_in <= 7'b0010110; // vauxp6/n6 channel 22
                    counter <= counter + 1;
                end
                1: begin
                    addr_in <= 7'b0011110; // vauxp9/n9 channel 30
                    counter <= 0;
                end
                default: begin
                    addr_in <= 7'b0010110; // vauxp6/n6 channel 22
                    counter <= 0;
                end
            endcase
            if (data >= 950) begin
                reset_out_temp <= 1;
            end
            else if (data < 950) begin
                reset_out_temp <= 0;
            end
        end
    end
    
    // not sure if works yet
    assign reset_out = 0;//reset_out_temp;
    assign current_value = data;

endmodule