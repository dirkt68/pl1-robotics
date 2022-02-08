`timescale 1ns/1ps

module current_sensor(
        input clk,
        input VPA, // jxadc0
        input VPB, // jxadc1
        input VNA, // jxadc4
        input VNB, // jxadc5
        output reg reset_out,
        output [11:0] current_value
    );
    reg [6:0] addr_in;
    reg int_switch;
    reg [32:0] decimal;
    reg [32:0] counter;
    // reg [24:0] timer; 
    wire enable;
    wire [15:0] data;
    wire [11:0] data_out;

    reg [3:0] dig0;
    reg [3:0] dig1;
    reg [3:0] dig2;
    reg [3:0] dig3;
    reg [3:0] dig4;
    reg [3:0] dig5;
    reg [3:0] dig6;

    initial begin
        int_switch = 0;
        // timer = 0;
        counter = 0;
    end

/*CLOCK TO RUN ADC*/
    always @(posedge clk) begin
        //timer <= timer + 1;
        case (int_switch)
            0: begin
                addr_in <= 7'b0010110; //channel 22/vaux6
                int_switch <= 1;
            end
            1: begin
                addr_in <= 7'b0011110; //channel 30/vaux14
                int_switch <= 0;
            end
            default: begin
                addr_in <= 7'b0010110; //channel 22/vaux6
                int_switch <= 1;
            end
        endcase
    end

    //assign convst_in = counter[24];

/*XADC MODULE INSTANTIATION*/
    xadc_wiz_0 XLXI_7(
        .daddr_in(addr_in),
        .dclk_in(clk),
        .den_in(enable),
        // .convst_in(convst_in),
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
        .drdy_out()
    );

     //binary to decimal conversion
      always @ (posedge clk) begin
        if(counter == 10000000)begin
            decimal = data >> 4;
            //looks nicer if our max value is 1V instead of .999755
            if(decimal >= 4093)
            begin
                dig0 = 0;
                dig1 = 0;
                dig2 = 0;
                dig3 = 0;
                dig4 = 0;
                dig5 = 0;
                dig6 = 1;
                counter = 0;
            end
            else 
            begin
                decimal = decimal * 250000;
                decimal = decimal >> 10;

                dig0 = decimal % 10;
                decimal = decimal / 10;

                dig1 = decimal % 10;
                decimal = decimal / 10;

                dig2 = decimal % 10;
                decimal = decimal / 10;

                dig3 = decimal % 10;
                decimal = decimal / 10;

                dig4 = decimal % 10;
                decimal = decimal / 10;

                dig5 = decimal % 10;
                decimal = decimal / 10; 

                dig6 = decimal % 10;
                decimal = decimal / 10; 
                counter = 0;
            end
       end
       counter = counter + 1;

      end
    
    assign data_out[11:8] = dig4;
    assign data_out[7:4] = dig5;
    assign data_out[3:0] = dig6;

     always @(posedge clk) begin
             if (data_out >= 950) begin
                 reset_out <= 0;
             end
             else if (data_out < 950) begin
                 reset_out <= 0;
             end
     end
    
    //assign reset_out = reset_out_temp;
    assign current_value = data_out;

endmodule