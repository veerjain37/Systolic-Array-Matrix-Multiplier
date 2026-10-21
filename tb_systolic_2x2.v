`timescale 1ns/1ps
module tb_systolic_2x2;
reg clk;
reg reset;
reg [7:0] a0,a1,b0,b1;
wire [16:0] sum00,sum01,sum10,sum11;

systolic_2x2 dut (.clk(clk),.reset(reset),.a0(a0),.a1(a1),.b0(b0),.b1(b1),.sum00(sum00),.sum01(sum01),.sum10(sum10),.sum11(sum11));

initial begin
    clk=1'b0;
    forever #5 clk=~clk;
end

/* 
A=[1 2][3 4]
b=[1 0][0 1]

enter like a2->a1
          a4->a3->0
*/


initial begin
    reset=1'b1;
    #9 reset= 1'b0;

    a0=8'd1;
    a1=8'd0;
    b0=8'd1;
    b1=8'd0;
    #10;

    a0=8'd2;
    a1=8'd3;
    b0=8'd0;
    b1=8'd0;

    #10;
    a0=8'd0;
    a1=8'd4;
    b0=8'd0;
    b1=8'd1;
    #10;
    a0=8'd0;
    a1=8'd0;
    b0=8'd0;
    b1=8'd0;
    #50 $finish;

end


endmodule