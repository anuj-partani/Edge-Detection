`timescale 1ns / 1ps

module dataReg #(dataWidth = 8)(
    input i_clk,
    input i_data_valid,
    input [dataWidth-1:0] i_data,
    output reg [dataWidth-1:0] o_data   // Output data
);

	always @(posedge i_clk) begin
		if (i_data_valid) begin
			o_data <= i_data; // Latch input data
		end
	end

endmodule