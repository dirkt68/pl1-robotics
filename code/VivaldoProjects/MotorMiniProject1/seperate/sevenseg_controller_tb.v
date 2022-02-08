`timescale 1ns/1ps

module sevenseg_controller_tb;
    reg clk;
    reg SW7;
    reg [11:0] current_num;
    wire [6:0] SEG;
    wire [3:0] AN;
    integer i;

    sevenseg_controller UUT (clk, SW7, current_num, SEG, AN);
    initial begin
        clk = 0;
        forever begin
            #10;
            clk = ~clk;
        end
    end
    
    initial begin
        $dumpfile("sevenseg_controller.vcd");
        $dumpvars(0,sevenseg_controller_tb);
        SW7 = 0;
        current_num = 0;
        #100;

        $monitor({"SW7 = %d, current_num = %d, SEG = %d, AN = %d"}, SW7, current_num, SEG, AN);

        for (i = 0; i<10; i = i + 1) begin
            #100;
            SW7 = $urandom_range(1);
            current_num = $urandom_range(1000);
        end
    end
endmodule