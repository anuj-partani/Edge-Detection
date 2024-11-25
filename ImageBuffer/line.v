`timescale 1ns / 1ps

module line(
    input reset,
    input clk,
    input [7:0] in_line,
    input in_valid,
    output reg out_valid,
    output reg [7:0] out_line,
    output reg [23:0] out_filter_3
);

    wire [1920*8-1:0] pixel_out;
    wire [1919:0] out_valid_pixel;
	
    pixel p0(
		.clk(clk),
        .reset(reset),
        .in_pixel(in_line),
        .in_valid(in_valid),
        .out_valid(out_valid_pixel[0]),
        .out_pixel(pixel_out[7:0])
	);

    genvar i;
    generate
        for(i=1; i<1920; i=i+1) begin: pixels_Row
            pixel p1(
				.clk(clk),
                .reset(reset),
                .in_pixel(pixel_out[8*i-1:8*(i-1)]), 
                .in_valid(in_valid),
                .out_valid(out_valid_pixel[i]),
                .out_pixel(pixel_out[8*i+7:8*i])
			);
        end
    endgenerate
	
    always @(*) begin
        out_line = pixel_out[8*1920-1:8*1919];
        out_filter_3 = pixel_out[8*3-1:0];
        out_valid = out_valid_pixel[1919];
    end
	
endmodule             
    