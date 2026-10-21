module systolic_nxm #(parameter width=8, parameter rows=3 , parameter cols=3) (
    input clk,
    input reset,
    input [(width*rows)-1:0] a,
    input [(width*cols)-1:0] b,
    output [((2*width + $clog2(cols))*rows*cols)-1:0] sum 
);

wire [width-1:0] wa [0:rows-1][0:cols-1];
wire [width-1:0] wb [0:rows-1][0:cols-1];

localparam sum_width = 2*width + $clog2(cols) ;

genvar r;
genvar c;
generate
    for (r =0 ;r<rows ;r=r+1) begin : row_loop
        for ( c=0 ;c<cols ;c=c+1 ) begin : col_loop
            PE#(
                .width(width),
                .sum_width(sum_width) 
            ) pe( .clk(clk),
                   .reset(reset),
                   .a_in((c==0)? a[(width*r) +: width]: wa[r][c-1]),
                   .b_in((r==0)? b[(width*c) +: width] : wb[r-1][c]),
                   .a_out(wa[r][c]),
                   .b_out(wb[r][c]),
                   .sum(sum[((sum_width)*c + sum_width*r*cols)  +: sum_width])

            );


        end
        
    end
endgenerate

    
endmodule