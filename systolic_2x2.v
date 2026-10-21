module systolic_2x2 (
    input clk,
    input reset,
    input [7:0] a0,
    input [7:0] a1,
    input [7:0] b0,
    input [7:0] b1,
    output [16:0] sum00,sum01,sum10,sum11
);

wire [7:0] w1,w2,w3,w4;

PE #(.width(8), .sum_width(17)) pe00 (.clk(clk),.reset(reset),.a_in(a0),.b_in(b0),.a_out(w1),.b_out(w3),.sum(sum00));
PE #(.width(8), .sum_width(17)) pe01 (.clk(clk),.reset(reset),.a_in(w1),.b_in(b1),.a_out(),.b_out(w4),.sum(sum01));
PE #(.width(8), .sum_width(17)) pe10 (.clk(clk),.reset(reset),.a_in(a1),.b_in(w3),.a_out(w2),.b_out(),.sum(sum10));
PE #(.width(8), .sum_width(17)) pe11 (.clk(clk),.reset(reset),.a_in(w2),.b_in(w4),.a_out(),.b_out(),.sum(sum11));
    
endmodule