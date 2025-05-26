`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2025 19:01:14
// Design Name: 
// Module Name: sobel_filter
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


module sobel_filter(
    input clk,
    input rst,
    input [7:0] pixel_in,
    input valid_in,
    output reg [7:0] pixel_out,
    output reg valid_out
);

    // Line buffers
    reg [7:0] row1 [0:2];
    reg [7:0] row2 [0:2];
    reg [7:0] row3 [0:2];

    // Sobel window
    reg [7:0] window [0:8];
    integer i;

    // Shift register logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 3; i = i + 1) begin
                row1[i] <= 8'd0;
                row2[i] <= 8'd0;
                row3[i] <= 8'd0;
            end
        end else if (valid_in) begin
            // Shift rows
            row1[2] <= row1[1];
            row1[1] <= row1[0];
            row1[0] <= pixel_in;

            row2[2] <= row2[1];
            row2[1] <= row2[0];
            row2[0] <= row1[2];

            row3[2] <= row3[1];
            row3[1] <= row3[0];
            row3[0] <= row2[2];
        end
    end

    // Sobel logic
    reg [10:0] Gx, Gy;
    reg [10:0] abs_Gx, abs_Gy;
    reg [10:0] magnitude;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pixel_out <= 8'd0;
            valid_out <= 1'b0;
        end else if (valid_in) begin
            // Fill 3x3 window
            window[0] = row3[2]; window[1] = row3[1]; window[2] = row3[0];
            window[3] = row2[2]; window[4] = row2[1]; window[5] = row2[0];
            window[6] = row1[2]; window[7] = row1[1]; window[8] = row1[0];

            // Compute Gx
            Gx = -window[0] + window[2]
               - (window[3] << 1) + (window[5] << 1)
               - window[6] + window[8];

            // Compute Gy
            Gy =  window[0] + (window[1] << 1) + window[2]
               - window[6] - (window[7] << 1) - window[8];

            // Take absolute values
            abs_Gx = (Gx[10]) ? -Gx : Gx;
            abs_Gy = (Gy[10]) ? -Gy : Gy;

            // Approximate gradient magnitude
            magnitude = abs_Gx + abs_Gy;

            // Clamp to 255
            pixel_out <= (magnitude > 255) ? 8'd255 : magnitude[7:0];
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end

endmodule
