module systolic_top_module #(
    parameter width =8,
    parameter N=3
) (
    input clk,
    input reset,
    input start,
    input [width*N-1:0] a_flat,
    input [width*N-1:0] b_flat,
    output done,
    output [((2*width + $clog2(N))*N*N)-1:0] sum_flat //  [((2*width + $clog2(cols))*rows*cols)-1:0] modified for NxN
);
    wire [width*N-1:0] a_gated;
    wire [width*N-1:0] b_gated;
    wire pe_en;
    wire [N-1:0] col_en;
    wire [N-1:0] row_en;
                
    systolic_nxm #(.width(width),.rows(N),.cols(N)) systolic_array(.clk(clk),.reset(reset),.pe_en(pe_en),.a(a_gated),.b(b_gated),.sum(sum_flat));
    systolic_nxn_fsm #(.N(N)) systolic_fsm (.clk(clk),.reset(reset),.start(start),.pe_en(pe_en),.row_en(row_en),.col_en(col_en),.done(done));


   
    

    genvar i;
    generate 
        for (i =0 ;i<N ;i=i+1 ) begin : input_gating_loop
            assign a_gated[i*width +: width]=row_en[i] ? a_flat[i*width +: width ] : {width{1'b0}} ;
            assign b_gated[i*width +: width]=col_en[i] ? b_flat[i*width +: width ] : {width{1'b0}} ;
            
        end

    endgenerate

   


endmodule