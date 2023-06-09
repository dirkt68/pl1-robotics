`timescale 1ns/1ps

module sevsegController(
    input clk100,
	input [1:0] RFreq,
    input [1:0] LFreq,
    output [6:0] seg,
    output [3:0] an
);

    // create enumerators for anode position and switch position
    typedef enum {FOUR = 0, THREE = 1, TWO = 2, ONE = 3} ANODE_POS;

    // create one object for each
    ANODE_POS position;

    // initalize a 20 bit counter and in-between registers for the outputs
    logic [19:0] counter = 0;
    logic [6:0] seg_temp;
    logic [3:0] an_temp;

    // initalize position and switch with default values
    initial begin
        position = FOUR;
    end

    // increment the counter
    always @(posedge clk100) begin
        counter <= counter + 1;
    end

    // cast the number in the switch input to its corresponding enum value
    assign position = ANODE_POS'(counter[19:18]);

    // determine which anode to activate based on position
    always @(posedge clk100) begin
        case (position)
            FOUR:    an_temp <= 4'b0111;
            THREE:   an_temp <= 4'b1011;
            TWO:     an_temp <= 4'b1101;
            ONE:     an_temp <= 4'b1110;
            default: an_temp <= 4'b0111;
        endcase
    end
    
    // output the anode
    assign an = an_temp;

    // determine what to output based on which phototransistor sees a light
    always @(posedge clk100) begin
        if (RFreq == 2 || LFreq == 2) begin
            seg_temp <= 7'b1000110; // C for criminal
        end
        else if (RFreq == 1 || LFreq == 1) begin
            seg_temp <= 7'b0001110; // F for friend
        end
        else begin
            seg_temp <= 7'b0111111; // dash for nothing
        end
    end
    
    // output segments
    assign seg = seg_temp;
    
endmodule