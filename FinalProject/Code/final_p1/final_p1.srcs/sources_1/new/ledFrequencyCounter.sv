`timescale 1ns/1ps

module ledFrequencyCounter(
    input clk100,
    input photoT,
    output [1:0] freqOut
    );

logic [11:0] freqCount = 0;
logic [27:0] count = 0;
logic old_sig = 0;
logic [11:0] freqBetween = 0;
logic [1:0] freq_temp = 0;

always @(posedge clk100) begin
    //if (photoT) begin
    //    freq_temp <= 2'b11;
    //end
    //else begin
    //    freq_temp <= 2'b00;
    //end
    
    
    count <= count + 1; // increment counter any time clock is updated

    //if the previous signal has changed, update freqCount
    if (photoT != old_sig) begin
        freqCount <= freqCount + 1;
    end
    
    //when the count hits 10,000,000, reset counters and send the value divided by 2
    if (count == 100_000_000) begin
        freqBetween <= freqCount >> 1;
        freqCount <= 0;
        count <= 0;
    end

    //update the previous signal
    old_sig <= photoT;

    // if frequency is around 1000Hz, send a 2
    if (freqBetween == 12'b001111101000) begin 
       freq_temp <= 2;
    end
    // if frequency is around 300Hz, send a 1
    else if (freqBetween == 12'b000100101100) begin
       freq_temp <= 1;
    end
    // otherwise send a 0
    else begin
       freq_temp <= 0;
    end
end

assign freqOut = freq_temp;

endmodule