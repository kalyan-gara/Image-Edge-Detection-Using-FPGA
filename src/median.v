`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2025 18:59:19
// Design Name: 
// Module Name: source_code
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


module source_code(
    input clk,                         // Clock signal
    input rst,                         // Reset signal
    input [7:0] pixel_in,              // 8-bit grayscale pixel input
    input valid_in,                    // Data valid signal for input pixel
    output reg [7:0] pixel_out,        // 8-bit median filtered output
    output reg valid_out               // Data valid signal for output pixel
);

    // Three line buffers (each holds 3 pixels for a 3-column window)
    reg [7:0] line_buffer_1 [0:2];
    reg [7:0] line_buffer_2 [0:2];
    reg [7:0] line_buffer_3 [0:2];

    // Update the shift registers on every valid pixel input.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            line_buffer_1[0] <= 8'b0;  line_buffer_1[1] <= 8'b0;  line_buffer_1[2] <= 8'b0;
            line_buffer_2[0] <= 8'b0;  line_buffer_2[1] <= 8'b0;  line_buffer_2[2] <= 8'b0;
            line_buffer_3[0] <= 8'b0;  line_buffer_3[1] <= 8'b0;  line_buffer_3[2] <= 8'b0;
        end else if (valid_in) begin
            // Shift pixels in row 1 (newest row): shift right (oldest pixel in [2])
            line_buffer_1[2] <= line_buffer_1[1];
            line_buffer_1[1] <= line_buffer_1[0];
            line_buffer_1[0] <= pixel_in;
            
            // Shift row 2: new value comes from the oldest pixel of row1
            line_buffer_2[2] <= line_buffer_2[1];
            line_buffer_2[1] <= line_buffer_2[0];
            line_buffer_2[0] <= line_buffer_1[2];
            
            // Shift row 3: new value comes from the oldest pixel of row2
            line_buffer_3[2] <= line_buffer_3[1];
            line_buffer_3[1] <= line_buffer_3[0];
            line_buffer_3[0] <= line_buffer_2[2];
        end
    end

    // Combinational median calculation.
    // We create a 3x3 window from the line buffers, then sort the nine values.
    reg [7:0] window [0:8];
    reg [7:0] sorted [0:8];
    integer i, j;
    reg [7:0] temp;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pixel_out <= 8'b0;
            valid_out <= 1'b0;
        end else if (valid_in) begin
            // Form the 3x3 window.
            // Note: The ordering here is determined by how the shift registers are updated.
            window[0] = line_buffer_3[2]; // top-left
            window[1] = line_buffer_3[1]; // top-middle
            window[2] = line_buffer_3[0]; // top-right
            window[3] = line_buffer_2[2]; // mid-left
            window[4] = line_buffer_2[1]; // center
            window[5] = line_buffer_2[0]; // mid-right
            window[6] = line_buffer_1[2]; // bottom-left
            window[7] = line_buffer_1[1]; // bottom-middle
            window[8] = line_buffer_1[0]; // bottom-right
            
            // Copy the window into the sorted array.
            for (i = 0; i < 9; i = i + 1) begin
                sorted[i] = window[i];
            end

            // Bubble sort: sort the nine values in ascending order.
            for (i = 0; i < 9; i = i + 1) begin
                for (j = 0; j < 8 - i; j = j + 1) begin
                    if (sorted[j] > sorted[j+1]) begin
                        temp = sorted[j];
                        sorted[j] = sorted[j+1];
                        sorted[j+1] = temp;
                    end
                end
            end

            // The median is the 5th value (index 4) after sorting.
            pixel_out <= sorted[4];
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end

endmodule

