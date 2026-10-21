// PE (processing unit) of 2x2 matrix

module PE #(parameter width=8,parameter sum_width = 17) (
    input clk,
    input reset,
    input [width-1:0] a_in,
    input [width-1:0] b_in,
    output reg [width-1:0] a_out,
    output reg [width-1:0] b_out,
    output reg [sum_width-1: 0 ] sum
);

always @(posedge clk or posedge reset) begin
    if(reset) begin
        sum<=0;
        a_out<=0;
        b_out<=0;
    end
    else begin
        sum<= sum + ( a_in*b_in );
        a_out<=a_in;
        b_out<=b_in;
    end
end
    
endmodule