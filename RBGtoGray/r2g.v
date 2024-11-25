`timescale 1ns / 1ps

module r2g(
    input aclk,
    input aresetn,
    //slave interface
    input s_axis_tvalid,
    input [23:0] s_axis_tdata,
    output s_axis_tready,
    input s_axis_tuser,
    input s_axis_tlast,
    //master interface
    output reg m_axis_tvalid,
    output reg [23:0] m_axis_tdata,
    input m_axis_tready,
    output reg m_axis_tuser,
    output reg m_axis_tlast
);
    
    assign s_axis_tready = m_axis_tready;
    
    wire [7:0] grey_data;
    assign grey_data = (s_axis_tdata[23:16] + s_axis_tdata[15:8] + s_axis_tdata[7:0])/3;

    always @(posedge aclk) begin
        m_axis_tvalid <= s_axis_tvalid;
        m_axis_tdata <= {grey_data,grey_data,grey_data};
        m_axis_tlast <= s_axis_tlast;
        m_axis_tuser <= s_axis_tuser;
    end

endmodule
