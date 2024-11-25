`timescale 1ns / 1ps

module pixel(
    input reset,
    input clk,
    input [7:0] in_pixel,
    input in_valid,
    output reg out_valid,
    output reg [7:0] out_pixel
);

    always @(posedge clk) begin
        if (~reset) begin
            out_pixel = 8'd0;
        end
        else if (in_valid) begin
            out_pixel<=in_pixel;
            out_valid<=1'b1;
        end
        else
            out_valid<=1'b0;
    end

endmodule