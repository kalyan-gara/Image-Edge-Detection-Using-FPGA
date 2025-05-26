`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2025 19:03:12
// Design Name: 
// Module Name: top_module
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

module image_filter_top (
    input clk,
    input rst,
    input [7:0] pixel_in,
    input valid_in,
    output [7:0] pixel_out,
    output valid_out
);

    wire [7:0] median_out;
    wire       median_valid;

    // Instantiate Median Filter
    source_code median_filter (
        .clk(clk),
        .rst(rst),
        .pixel_in(pixel_in),
        .valid_in(valid_in),
        .pixel_out(median_out),
        .valid_out(median_valid)
    );

    // Instantiate Sobel Filter
    sobel_filter sobel (
        .clk(clk),
        .rst(rst),
        .pixel_in(median_out),
        .valid_in(median_valid),
        .pixel_out(pixel_out),
        .valid_out(valid_out)
    );

endmodule

