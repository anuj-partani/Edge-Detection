`timescale 1ns / 1ps

module image_buffer(
    input aclk,
	input aresetn,
	// slave interface
    input [23:0] s_axis_tdata,
    input s_axis_tvalid,
    output s_axis_tready,
    input s_axis_tuser,
    input s_axis_tlast,
	// master interface
    output reg m_axis_tvalid,
    output [71:0] m_axis_tdata,
    input m_axis_tready,
    output reg m_axis_tuser,
    output reg m_axis_tlast
);
    
    wire [15:0] line_out;
    wire [2:1] out_valid_line;
    wire [7:0] in_image;
    wire [7:0] out_image;
    
    assign s_axis_tready = m_axis_tready;
    assign in_image = s_axis_tdata [7:0];
    
    always @(posedge aclk) begin
        m_axis_tvalid <= s_axis_tvalid;
        m_axis_tuser <= s_axis_tuser;
        m_axis_tlast <= s_axis_tlast;
    end

    line lb1 (
		.clk(aclk), 
        .reset(aresetn),
        .in_line(in_image),
        .in_valid(s_axis_tvalid),
        .out_valid(out_valid_line[1]),
        .out_line(line_out[7:0]),
        .out_filter_3(m_axis_tdata[23:0])
	);

    line lb2 (
		.clk(aclk),
		.reset(aresetn), 
		.in_line(line_out[7:0]),
		.in_valid(s_axis_tvalid),
		.out_valid(out_valid_line[2]),
		.out_line(line_out[15:8]),
		.out_filter_3(m_axis_tdata[47:24])
	);
 
    line lb3 (
		.clk(aclk), 
		.reset(aresetn),
		.in_line(line_out[15:8]),
		.in_valid(s_axis_tvalid),
		.out_valid(out_valid),
		.out_line(out_image),
		.out_filter_3(m_axis_tdata[71:48])
	);

endmodule
