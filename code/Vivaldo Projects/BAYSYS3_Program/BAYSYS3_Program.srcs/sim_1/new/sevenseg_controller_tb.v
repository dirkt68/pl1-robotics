`timescale 1ns/1ps

module sevenseg_controller_tb;
    reg clk;
    reg SW7;
    reg [16:0] current_num;
    wire [6:0] SEG;
    wire [3:0] AN;
    integer i;

sevenseg_controller UUT (clk, SW7, current_num, SEG, AN);
initial begin
    clk = 0;
    forever begin
        #10;
        clk <= ~clk;
    end

    $monitor("current = %d, SW7 = %1b, AN = %2b, SEG = %7b", current_num, SW7, AN, SEG);

    for (i = 0; i < 10; i = i + 1) begin
    #100;
    current_num <= $urandom_range(1000);
    SW7 <= $urandom_range(1);
    end
end
endmodule