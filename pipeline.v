`timescale 1ns / 1ps

module pipeline #(level=3,dataWidth=2)(
	input                  aclk,
	input [dataWidth-1:0]  inData,
	output [dataWidth-1:0] outData
);

	wire [dataWidth-1:0] w_wires[level-1:0];
	
	generate
	genvar i;
		for(i=0;i<level;i=i+1)
		begin
			if(i==0)
				dataReg #(.dataWidth(dataWidth))DR(
				.i_clk(aclk),
				.i_data(inData),
				.i_data_valid(1'b1),
				.o_data(w_wires[0])
				);
			else
				dataReg #(.dataWidth(dataWidth))DR(
				.i_clk(aclk),
				.i_data(w_wires[i-1]),
				.i_data_valid(1'b1),
				.o_data(w_wires[i])
				);
		end
	endgenerate
	
	
	assign outData = w_wires[level-1];
	
endmodule
