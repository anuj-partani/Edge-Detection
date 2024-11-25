`timescale 1ns / 1ps

module sobel (
	input aclk,
	input aresetn,
	// slave interface
	input s_axis_tvalid,
	input [71:0] s_axis_tdata,
	output s_axis_tready,
	input s_axis_tlast,
	input s_axis_tuser,
	// master interface
	output m_axis_tvalid,
	output reg [23:0]  m_axis_tdata,
	input m_axis_tready,
	output m_axis_tlast,
	output m_axis_tuser,
	// threshold
	input   [31:0] threshold
);

	assign s_axis_tready = m_axis_tready;
	
	integer mac1;
	integer mac2;
	integer mac3;
	integer mac4;
	integer sum1;
	integer sum2;

	always @(posedge aclk) begin
	
		mac1 <= $signed(s_axis_tdata[7:0]) + $signed(2*s_axis_tdata[15:8])+ $signed(s_axis_tdata[23:16]); //1pipeline
		mac2 <= $signed(-s_axis_tdata[55:48]) + $signed(-2*s_axis_tdata[63:56])+ $signed(-s_axis_tdata[71:64]);
		sum1 <= $signed(mac1+mac2); //2pipeline
	
		mac3 <= $signed(s_axis_tdata[7:0]) + $signed(2*s_axis_tdata[31:24])+ $signed(s_axis_tdata[55:48]); //1pipeline
		mac4 <= $signed(-s_axis_tdata[23:16]) + $signed(-2*s_axis_tdata[47:40])+ $signed(-s_axis_tdata[71:64]);
		sum2 <= $signed(mac3+mac4); //2pipeline
	
		if(($signed(sum1) > $signed(threshold)) ||  ($signed(sum1) < $signed(-threshold)) || ($signed(sum2) > $signed(threshold)) ||  ($signed(sum2) < $signed(-threshold)))
			m_axis_tdata <= {8'd255,8'd255,8'd255};
		else
			m_axis_tdata <= 0;//3pipeline
			
	end
		
	pipeline #(.level(3),.dataWidth(1))PValid(
		.aclk(aclk),
		.inData(s_axis_tvalid),
		.outData(m_axis_tvalid)
	);    
		
	pipeline #(.level(3),.dataWidth(1))PUser(
		.aclk(aclk),
		.inData(s_axis_tuser),
		.outData(m_axis_tuser)
	);
	
	pipeline #(.level(3),.dataWidth(1))PLast(
		.aclk(aclk),
		.inData(s_axis_tlast),
		.outData(m_axis_tlast)
	);
	
endmodule