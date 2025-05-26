`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2025 19:04:22
// Design Name: 
// Module Name: testbench
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
`timescale 1ns/1ps
module image_filter_tb;

    reg clk, rst;
    reg [7:0] pixel_in;
    reg valid_in;
    wire [7:0] pixel_out;
    wire valid_out;

    // Image parameters
    parameter IMAGE_WIDTH  = 320;
    parameter IMAGE_HEIGHT = 240;
    parameter IMAGE_SIZE   = IMAGE_WIDTH * IMAGE_HEIGHT;
    parameter FLUSH_DELAY  = IMAGE_WIDTH * 3;

    // Memory arrays
    reg [7:0] image [0:IMAGE_SIZE-1];
    reg [7:0] output_image [0:IMAGE_SIZE-1];
    integer i, out_index, out_file;
    reg [31:0] flush_count;

    // Instantiate top-level Median + Sobel module
    image_filter_top uut (
        .clk(clk),
        .rst(rst),
        .pixel_in(pixel_in),
        .valid_in(valid_in),
        .pixel_out(pixel_out),
        .valid_out(valid_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Simulation stimulus
    initial begin
        // Initialization
        rst = 1;
        valid_in = 0;
        pixel_in = 8'd0;
        out_index = 0;
        flush_count = 0;

        #20 rst = 0;

        // Load grayscale input image (hex values)
        $readmemh("C:/Users/hp/edge/edge.sim/sim_1/behav/xsim/gray_data_hex.txt", image);

        for (i = 0; i < IMAGE_SIZE; i = i + 1) begin
            @(negedge clk);
            pixel_in = image[i];
            valid_in = 1;
        end

        // End input
        @(negedge clk);
        valid_in = 0;

        // Wait to flush remaining outputs
        repeat(FLUSH_DELAY) @(negedge clk);

        // Write final output to file
        out_file = $fopen("C:/Users/hp/edge/edge.sim/sim_1/behav/xsim/final_filtered_output.txt", "w");
        $display("Writing %0d filtered values to file...", out_index);
        for (i = 0; i < out_index; i = i + 1)
            $fdisplay(out_file, "%h", output_image[i]);
        $fclose(out_file);

        $stop;
    end

    // Capture output
    always @(posedge clk) begin
        if (valid_out) begin
            output_image[out_index] = pixel_out;
            out_index = out_index + 1;
        end
    end

endmodule

