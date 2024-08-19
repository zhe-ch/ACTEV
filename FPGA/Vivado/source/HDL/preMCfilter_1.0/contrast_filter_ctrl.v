`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2019 09:48:48 AM
// Design Name: 
// Module Name: contrast_filter_ctrl
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


module contrast_filter_ctrl(
    input               s_axi_aclk,
    input               s_axi_aresetn,
    
    input               filter_begin,
    input               filbuf_wready,
    
    output reg          rowbuf_rden,
    output reg  [7:0]   rowbuf_rdaddr,
    
    output reg          rowbuf_wren,
    output reg  [7:0]   rowbuf_wraddr,
    
    output              filter_ap_start,
    input               filter_ap_done,
    input               filter_ap_idle,
    input               filter_ap_ready,
    
    input       [7:0]   rowbuf_rddata_1,
    input       [7:0]   rowbuf_rddata_2,
    input       [7:0]   rowbuf_rddata_3,
    input       [7:0]   rowbuf_rddata_4,
    input       [7:0]   rowbuf_rddata_5,
    input       [7:0]   rowbuf_rddata_6,
    input       [7:0]   rowbuf_rddata_7,
    input       [7:0]   rowbuf_rddata_8,
    input       [7:0]   rowbuf_rddata_9,
    input       [7:0]   rowbuf_rddata_10,
    input       [7:0]   rowbuf_rddata_11,
    input       [7:0]   rowbuf_rddata_12,
    input       [7:0]   rowbuf_rddata_13,
    input       [7:0]   rowbuf_rddata_14,
    input       [7:0]   rowbuf_rddata_15,
    input       [7:0]   rowbuf_rddata_16,
    input       [7:0]   rowbuf_rddata_ext,
    
    output reg  [7:0]   filter_d0,
    output reg  [7:0]   filter_d1,
    output reg  [7:0]   filter_d2,
    output reg  [7:0]   filter_d3,
    output reg  [7:0]   filter_d4,
    output reg  [7:0]   filter_d5,
    output reg  [7:0]   filter_d6,
    output reg  [7:0]   filter_d7,
    output reg  [7:0]   filter_d8,
    output reg  [7:0]   filter_d9,
    output reg  [7:0]   filter_d10,
    output reg  [7:0]   filter_d11,
    output reg  [7:0]   filter_d12,
    output reg  [7:0]   filter_d13,
    output reg  [7:0]   filter_d14,
    output reg  [7:0]   filter_d15,
    output reg  [7:0]   filter_d16,
    
    input       [31:0]  filter_result,
    
    output reg          filbuf_wren,
    output reg  [13:0]  filbuf_wraddr,
    output reg  [31:0]  filbuf_wrdata
);

assign       filter_ap_start   =   1'b1;

reg          rowbuf_rden_reg;

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_rden  <=  1'b0;
    end
    else begin
        if (filter_begin) begin
            rowbuf_rden  <=  1'b1;
        end
        else begin
            rowbuf_rden  <=  (rowbuf_rdaddr == 8'd143)? 1'b0 : rowbuf_rden;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_rdaddr  <=  8'd0;
    end
    else begin
        if (rowbuf_rden) begin
            rowbuf_rdaddr  <=  (rowbuf_rdaddr == 8'd143)? 8'd0 : (rowbuf_rdaddr + 1'b1);
        end
        else begin
            rowbuf_rdaddr  <=  8'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_rden_reg  <=  1'b0;
    end
    else begin
        rowbuf_rden_reg  <=  rowbuf_rden;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wren  <=  1'b0;
    end
    else begin
        rowbuf_wren  <=  rowbuf_rden_reg;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wraddr  <=  8'd0;
    end
    else begin
        if (rowbuf_wren) begin
            rowbuf_wraddr  <=  (rowbuf_wraddr == 8'd143)? 8'd0 : (rowbuf_wraddr + 1'b1);
        end
        else begin
            rowbuf_wraddr  <=  8'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filbuf_wren  <=  1'b0;
    end
    else begin
        if (filbuf_wready && (rowbuf_rdaddr == 8'd26)) begin
            filbuf_wren  <=  1'b1;
        end
        else if ((filbuf_wraddr & 14'h007F) == 14'h007F) begin
            filbuf_wren  <=  1'b0;
        end
        else begin
            filbuf_wren  <=  filbuf_wren;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filbuf_wraddr  <=  14'd0;
    end
    else begin
        if (filbuf_wren) begin
            filbuf_wraddr  <=  filbuf_wraddr + 1'b1;
        end
        else begin
            filbuf_wraddr  <=  filbuf_wraddr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filbuf_wrdata  <=  32'd0;
    end
    else begin
        if (filbuf_wready && (rowbuf_rdaddr == 8'd26)) begin
            filbuf_wrdata  <=  filter_result;
        end
        else if (filbuf_wren) begin
            filbuf_wrdata  <=  filter_result;
        end
        else begin
            filbuf_wrdata  <=  32'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d0  <=  8'd0;
    end
    else begin
        filter_d0  <=  rowbuf_rddata_1;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d1  <=  8'd0;
    end
    else begin
        filter_d1  <=  rowbuf_rddata_2;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d2  <=  8'd0;
    end
    else begin
        filter_d2  <=  rowbuf_rddata_3;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d3  <=  8'd0;
    end
    else begin
        filter_d3  <=  rowbuf_rddata_4;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d4  <=  8'd0;
    end
    else begin
        filter_d4  <=  rowbuf_rddata_5;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d5  <=  8'd0;
    end
    else begin
        filter_d5  <=  rowbuf_rddata_6;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d6  <=  8'd0;
    end
    else begin
        filter_d6  <=  rowbuf_rddata_7;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d7  <=  8'd0;
    end
    else begin
        filter_d7  <=  rowbuf_rddata_8;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d8  <=  8'd0;
    end
    else begin
        filter_d8  <=  rowbuf_rddata_9;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d9  <=  8'd0;
    end
    else begin
        filter_d9  <=  rowbuf_rddata_10;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d10  <=  8'd0;
    end
    else begin
        filter_d10  <=  rowbuf_rddata_11;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d11  <=  8'd0;
    end
    else begin
        filter_d11  <=  rowbuf_rddata_12;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d12  <=  8'd0;
    end
    else begin
        filter_d12  <=  rowbuf_rddata_13;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d13  <=  8'd0;
    end
    else begin
        filter_d13  <=  rowbuf_rddata_14;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d14  <=  8'd0;
    end
    else begin
        filter_d14  <=  rowbuf_rddata_15;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d15  <=  8'd0;
    end
    else begin
        filter_d15  <=  rowbuf_rddata_16;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        filter_d16  <=  8'd0;
    end
    else begin
        filter_d16  <=  rowbuf_rddata_ext;
    end
end

endmodule
