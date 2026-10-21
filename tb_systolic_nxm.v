`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2026 10:35:45
// Design Name: 
// Module Name: tb_systolic_nxm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_systolic_nxm();

    // 1. Updated for 4x3 grid
    parameter WIDTH = 8;
    parameter ROWS = 4;
    parameter COLS = 3;
    localparam SUM_W = (2*WIDTH) + $clog2(COLS);

    // 2. Declare TB signals (a is now 32 bits, b is 24 bits)
    reg clk;
    reg reset;
    reg  [(WIDTH*ROWS)-1:0] a;
    reg  [(WIDTH*COLS)-1:0] b;
    wire [(SUM_W*ROWS*COLS)-1:0] sum;

    // 3. Instantiate the Unit Under Test (UUT)
    systolic_nxm #(
        .width(WIDTH),
        .rows(ROWS),
        .cols(COLS)
    ) uut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .sum(sum)
    );

    wire [SUM_W-1:0] sum_view [0 : (ROWS*COLS)-1];
    
    genvar i;
    generate
        for (i = 0; i < ROWS*COLS; i = i + 1) begin : unpack_view
            assign sum_view[i] = sum[(i * SUM_W) +: SUM_W];
        end
    endgenerate

    // 4. Generate the Clock (10ns period)
    always #5 clk = ~clk;

 initial begin
        clk = 0;
        reset = 1;
        a = 0;
        b = 0;

        #20; 
        reset = 0;

        // Cycle 0: Feed A00 and B00
        #10;
        //    Row3, Row2, Row1, Row0
        a = {8'd0,  8'd0, 8'd0, 8'd1}; 
        //    Col2, Col1, Col0
        b = {8'd0,  8'd0, 8'd1}; 

        // Cycle 1: Feed A10, A01, B10, B01
        #10;
        a = {8'd0,  8'd0, 8'd4, 8'd2};
        b = {8'd0,  8'd0, 8'd0}; // B10 is 0, B01 is 0
        
        // Cycle 2: Feed A20, A11, A02, B20, B11, B02
        #10;
        a = {8'd0,  8'd7, 8'd5, 8'd3};
        b = {8'd0,  8'd1, 8'd0}; // B11 is 1

        // Cycle 3: Feed A30, A21, A12, B21, B12
        #10;
        a = {8'd10, 8'd8, 8'd6, 8'd0};
        b = {8'd0,  8'd0, 8'd0}; 

        // Cycle 4: Feed A31, A22, B22
        #10;
        a = {8'd11, 8'd9, 8'd0, 8'd0};
        b = {8'd1,  8'd0, 8'd0}; // B22 is 1

        // Cycle 5: Feed A32
        #10;
        a = {8'd12, 8'd0, 8'd0, 8'd0};
        b = {8'd0,  8'd0, 8'd0}; 

        // Cycle 6+: Flush with zeros
        #10;
        a = 32'd0;
        b = 24'd0;

        // Wait for pipeline to finish
        #100;
        
        $finish;
    end

endmodule
