`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2019 10:49:56 AM
// Design Name: 
// Module Name: erosion_ctrl
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


module erosion_ctrl(
    input                 s_axi_aclk,
    input                 s_axi_aresetn,

    input                 sensor_state,

    input                 denoise_valid,
    input       [7:0]     denoise_dout,

    output reg            rowbuf_wren,
    output reg  [9:0]     rowbuf_wraddr,

    output reg            rowbuf_rden,
    output reg  [9:0]     rowbuf_rdaddr,

    output                erosion_ap_start,
    input                 erosion_ap_done,
    input                 erosion_ap_idle,
    input                 erosion_ap_ready,

    output                erosion_init,

    output reg            erosion_valid,
    
    input       [7:0]     rowbuf_rddata_1,
    input       [7:0]     rowbuf_rddata_2,
    input       [7:0]     rowbuf_rddata_3,
    input       [7:0]     rowbuf_rddata_4,
    input       [7:0]     rowbuf_rddata_5,
    input       [7:0]     rowbuf_rddata_6,
    input       [7:0]     rowbuf_rddata_7,
    input       [7:0]     rowbuf_rddata_8,
    input       [7:0]     rowbuf_rddata_9,
    input       [7:0]     rowbuf_rddata_10,
    input       [7:0]     rowbuf_rddata_11,
    input       [7:0]     rowbuf_rddata_12,
    input       [7:0]     rowbuf_rddata_13,
    input       [7:0]     rowbuf_rddata_14,
    input       [7:0]     rowbuf_rddata_15,
    input       [7:0]     rowbuf_rddata_16,
    input       [7:0]     rowbuf_rddata_17,
    input       [7:0]     rowbuf_rddata_18,
    
    output reg  [7:0]     rowbuf_wrdata_0,
    output reg  [7:0]     rowbuf_wrdata_1,
    output reg  [7:0]     rowbuf_wrdata_2,
    output reg  [7:0]     rowbuf_wrdata_3,
    output reg  [7:0]     rowbuf_wrdata_4,
    output reg  [7:0]     rowbuf_wrdata_5,
    output reg  [7:0]     rowbuf_wrdata_6,
    output reg  [7:0]     rowbuf_wrdata_7,
    output reg  [7:0]     rowbuf_wrdata_8,
    output reg  [7:0]     rowbuf_wrdata_9,
    output reg  [7:0]     rowbuf_wrdata_10,
    output reg  [7:0]     rowbuf_wrdata_11,
    output reg  [7:0]     rowbuf_wrdata_12,
    output reg  [7:0]     rowbuf_wrdata_13,
    output reg  [7:0]     rowbuf_wrdata_14,
    output reg  [7:0]     rowbuf_wrdata_15,
    output reg  [7:0]     rowbuf_wrdata_16,
    output reg  [7:0]     rowbuf_wrdata_17,
    output reg  [7:0]     rowbuf_wrdata_18
);

reg   [7:0]   rowbuf_rddata;

reg   [9:0]   cnt_pixel;

reg   [9:0]   cnt_line;
wire          cnt_line_valid = (cnt_line >= 10'd10) && (cnt_line < 10'd490);

reg           rowreg_wren;
reg   [7:0]   rowreg_wrdata;

wire          start_row  =  (~rowbuf_wren) && rowreg_wren && cnt_line_valid;
reg   [4:0]   cnt_init;
reg   [9:0]   cnt_interval;

reg           denoise_valid_reg;
wire          line_begin  =  denoise_valid && (~denoise_valid_reg);

assign        erosion_ap_start   =   1'b1;
assign        erosion_init       =   rowbuf_wren && (rowbuf_wraddr == 10'd0) && cnt_line_valid;

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        denoise_valid_reg  <=  1'b0;
    end
    else begin
        denoise_valid_reg  <=  denoise_valid;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_line  <=  10'd0;
    end
    else begin
        if (line_begin) begin
            cnt_line  <=  cnt_line + 1'b1;
        end
        else if (cnt_pixel == 10'd846) begin
            cnt_line  <=  (cnt_line == 10'd498)? 10'd0 : (cnt_line + 1'b1);
        end
        else begin
            cnt_line  <=  cnt_line;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_pixel  <=  10'd0;
    end
    else begin
        if ((cnt_line >= 10'd480) && (cnt_line <= 10'd498)) begin
            cnt_pixel  <=  (cnt_pixel == 10'd846)? 10'd0 : (cnt_pixel + 1'b1);
        end
        else begin
            cnt_pixel  <=  10'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_rden  <=  1'b0;
    end
    else begin
        if (line_begin) begin
            rowbuf_rden  <=  1'b1;
        end
        else if ((cnt_pixel == 10'd0) && (cnt_line >= 10'd481) && (cnt_line <= 10'd498)) begin
            rowbuf_rden  <=  1'b1;
        end
        else begin
            rowbuf_rden  <=  (rowbuf_rdaddr == 10'd751)? 1'b0 : rowbuf_rden;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_rdaddr  <=  10'd0;
    end
    else begin
        if (rowbuf_rden) begin
            rowbuf_rdaddr  <=  rowbuf_rdaddr + 1'b1;
        end
        else begin
            rowbuf_rdaddr  <=  10'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_rddata  <=  8'd0;
    end
    else begin
        if (denoise_valid) begin
            rowbuf_rddata  <=  denoise_dout;
        end
        else if ((cnt_line >= 10'd481) && (cnt_line <= 10'd498)) begin
            rowbuf_rddata  <=  8'd255;
        end
        else begin
            rowbuf_rddata  <=  rowbuf_rddata;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowreg_wren  <=  1'b0;
    end
    else begin
        rowreg_wren  <=  rowbuf_rden;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wren  <=  1'b0;
    end
    else begin
        rowbuf_wren  <=  rowreg_wren;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wraddr  <=  10'd0;
    end
    else begin
        if (rowbuf_wren) begin
            rowbuf_wraddr  <=  rowbuf_wraddr + 1'b1;
        end
        else begin
            rowbuf_wraddr  <=  10'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowreg_wrdata  <=  8'd0;
    end
    else begin
        rowreg_wrdata  <=  rowbuf_rddata;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_init  <=  5'd0;
    end
    else begin
        if (start_row) begin
            cnt_init  <=  5'd1;
        end
        else begin
            cnt_init  <=  ((cnt_init > 5'd0) && (cnt_init < 5'd18))? (cnt_init + 1'b1) : 5'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        erosion_valid  <=  1'b0;
    end
    else begin
        if (cnt_init == 5'd18) begin
            erosion_valid  <=  1'b1;
        end
        else begin
            erosion_valid  <=  (cnt_interval == 10'd751)? 1'b0 : erosion_valid;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_interval  <=  10'd0;
    end
    else begin
        if (erosion_valid) begin
            cnt_interval  <=  cnt_interval + 1'b1;
        end
        else begin
            cnt_interval  <=  10'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_0  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_0  <=  rowbuf_rddata_1;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_1  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_1  <=  rowbuf_rddata_2;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_2  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_2  <=  rowbuf_rddata_3;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_3  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_3  <=  rowbuf_rddata_4;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_4  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_4  <=  rowbuf_rddata_5;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_5  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_5  <=  rowbuf_rddata_6;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_6  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_6  <=  rowbuf_rddata_7;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_7  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_7  <=  rowbuf_rddata_8;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_8  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_8  <=  rowbuf_rddata_9;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_9  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_9  <=  rowbuf_rddata_10;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_10  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_10  <=  rowbuf_rddata_11;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_11  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_11  <=  rowbuf_rddata_12;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_12  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_12  <=  rowbuf_rddata_13;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_13  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_13  <=  rowbuf_rddata_14;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_14  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_14  <=  rowbuf_rddata_15;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_15  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_15  <=  rowbuf_rddata_16;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_16  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_16  <=  rowbuf_rddata_17;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_17  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_17  <=  rowbuf_rddata_18;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wrdata_18  <=  8'd0;
    end
    else begin
        rowbuf_wrdata_18  <=  rowreg_wrdata;
    end
end

endmodule