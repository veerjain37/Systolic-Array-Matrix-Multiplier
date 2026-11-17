`timescale 1ns/1ps


module tb_systolic_top_module(
   
);

localparam width=8;
localparam N= 3 ;    
localparam sum_width = 2*width + $clog2(N) ; // for single sum element

reg clk;
reg reset;
reg start;
reg [width*N-1 :0]a_flat;
reg [width*N-1 :0]b_flat;
wire done;
wire [((sum_width)*N*N)-1:0] sum_flat;



always #5 clk=~clk; 

systolic_top_module #(.width(width),.N(N)) uut (.clk(clk),.reset(reset),.start(start),.a_flat(a_flat),.b_flat(b_flat),.done(done),.sum_flat(sum_flat));

initial begin
    clk=0;
    start=0;
    reset=1;
    a_flat=0;
    b_flat=0;

    #10 reset =0;
    start=1;

    #10 start=0;

    // for matrix A=[[1 2 3] [4 5 6] [7 8 9 ]] and B=[[1 0 0] [0 1 0] [0 0 1]]
    a_flat={8'd0,8'd0,8'd1};
    b_flat={8'd0,8'd0,8'd1};
    #10
    a_flat={8'd0,8'd4,8'd2};
    b_flat={8'd0,8'd0,8'd0};
    #10
    a_flat={8'd7,8'd5,8'd3};
    b_flat={8'd0,8'd1,8'd0};
    #10
    a_flat={8'd8,8'd6,8'd0};
    b_flat={8'd0,8'd0,8'd0};
    #10
    a_flat={8'd9,8'd0,8'd0};
    b_flat={8'd1,8'd0,8'd0};
    #10
    // data insertion completed 
    a_flat={8'd0,8'd0,8'd0};
    b_flat={8'd0,8'd0,8'd0};
    
    wait(done==1'b1); // wait till done is high

    #20

    // displaying result
    $display("Result");
    // output will be in single row
    $display("[%0d %0d %0d]", sum_flat[0*sum_width +: sum_width],sum_flat[1*sum_width +: sum_width],sum_flat[2*sum_width +: sum_width]);
    $display("[%0d %0d %0d]", sum_flat[3*sum_width +: sum_width],sum_flat[4*sum_width +: sum_width],sum_flat[5*sum_width +: sum_width]);
    $display("[%0d %0d %0d]", sum_flat[6*sum_width +: sum_width],sum_flat[7*sum_width +: sum_width],sum_flat[8*sum_width +: sum_width]);
    $finish;
end

endmodule