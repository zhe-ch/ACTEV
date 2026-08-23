`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 12:25:48 PM
// Design Name: 
// Module Name: denoise_ctrl
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


module denoise_ctrl(
    input                 pixclk,
    input                 reset_n,
    
    input                 s_axi_aclk,
    input                 s_axi_aresetn,
    
    input                 sensor_state,
    input       [7:0]     sensor_din,
    
    input                 frame_begin,
    input                 line_begin,
    input                 frame_state,
    input                 line_state,
    
    output reg            rowbuf_pix_wren,
    output reg  [9:0]     rowbuf_pix_wraddr,
    output reg  [7:0]     rowbuf_pix_wrdata,
    
    output reg            rowbuf_wren,
    output reg  [9:0]     rowbuf_wraddr,
    
    output reg            rowbuf_rden,
    output reg  [9:0]     rowbuf_rdaddr,
    
    output                denoise_ap_start,
    input                 denoise_ap_done,
    input                 denoise_ap_idle,
    input                 denoise_ap_ready,
    
    output reg            denoise_valid
);

reg   [7:0]   rowbuf_rddata;

reg   [9:0]   cnt_pixel;
reg   [9:0]   cnt_line;
reg           cnt_line_valid;

wire          start_row  =  (~rowbuf_wren) && rowbuf_rden && cnt_line_valid;

reg   [2:0]   cnt_init;
reg   [9:0]   cnt_interval;

assign        denoise_ap_start   =   1'b1;

reg           rowbuf_ready;
reg           rowbuf_ready_reg;
wire          rowbuf_start  =  (~rowbuf_ready_reg) && rowbuf_ready;

always @(posedge pixclk or negedge reset_n) begin
    if (~reset_n) begin
        cnt_line  <=  10'd0;
    end
    else begin
        if (frame_begin) begin
            cnt_line  <=  10'd0;
        end
        else if (frame_state && line_begin) begin
            cnt_line  <=  cnt_line + 1'b1;
        end
        else if (cnt_pixel == 10'd846) begin
            cnt_line  <= (cnt_line == 10'd483)? 10'd0 : (cnt_line + 1'b1);
        end
        else begin
            cnt_line  <=  cnt_line;
        end
    end
end

always @(posedge pixclk or negedge reset_n) begin
    if (~reset_n) begin
        cnt_pixel  <=  10'd0;
    end
    else begin
        if ((cnt_line >= 10'd480) && (cnt_line <= 10'd483)) begin
            cnt_pixel  <=  (cnt_pixel == 10'd846)? 10'd0 : (cnt_pixel + 1'b1);
        end
        else begin
            cnt_pixel  <=  10'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_line_valid  <=  1'b0;
    end
    else begin
        if ((cnt_line >= 10'd2) && (cnt_line < 10'd482)) begin
            cnt_line_valid  <=  1'b1;
        end
        else begin
            cnt_line_valid  <=  1'b0;
        end
    end
end

always @(posedge pixclk or negedge reset_n) begin
    if (~reset_n) begin
        rowbuf_pix_wren  <=  1'b0;
    end
    else begin
        if (frame_state && line_begin) begin
            rowbuf_pix_wren  <=  1'b1;
        end
        else if ((cnt_pixel == 10'd0) && (cnt_line >= 10'd481) && (cnt_line <= 10'd483)) begin
            rowbuf_pix_wren  <=  1'b1;
        end
        else begin
            rowbuf_pix_wren  <=  (rowbuf_pix_wraddr == 10'd751)? 1'b0 : rowbuf_pix_wren;
        end
    end
end

always @(posedge pixclk or negedge reset_n) begin
    if (~reset_n) begin
        rowbuf_pix_wraddr  <=  10'd0;
    end
    else begin
        if (rowbuf_pix_wren) begin
            rowbuf_pix_wraddr  <=  rowbuf_pix_wraddr + 1'b1;
        end
        else begin
            rowbuf_pix_wraddr  <=  10'd0;
        end
    end
end

always @(posedge pixclk or negedge reset_n) begin
    if (~reset_n) begin
        rowbuf_pix_wrdata  <=  8'd0;
    end
    else begin
        if (frame_state && line_begin) begin
            rowbuf_pix_wrdata  <=  sensor_din;
        end
        else if (line_state) begin
            rowbuf_pix_wrdata  <=  sensor_din;
        end
        else if ((cnt_line >= 10'd481) && (cnt_line <= 10'd483)) begin
            rowbuf_pix_wrdata  <=  8'd0;
        end
        else begin
            rowbuf_pix_wrdata  <=  rowbuf_pix_wrdata;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_ready  <=  1'b0;
    end
    else begin
        if (rowbuf_pix_wraddr == 10'd752) begin
            rowbuf_ready  <=  1'b1;
        end
        else begin
            rowbuf_ready  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_ready_reg  <=  1'b0;
    end
    else begin
        rowbuf_ready_reg  <=  rowbuf_ready;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_rden  <=  1'b0;
    end
    else begin
        if (rowbuf_start) begin
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
        rowbuf_wren  <=  1'b0;
    end
    else begin
        if (rowbuf_rden) begin
            rowbuf_wren  <=  1'b1;
        end
        else begin
            rowbuf_wren  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        rowbuf_wraddr  <=  8'd0;
    end
    else begin
        if (rowbuf_wren) begin
            rowbuf_wraddr  <=  rowbuf_wraddr + 1'b1;
        end
        else begin
            rowbuf_wraddr  <=  8'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_init  <=  3'd0;
    end
    else begin
        if (start_row) begin
            cnt_init  <=  3'd1;
        end
        else begin
            cnt_init  <=  ((cnt_init > 3'd0) && (cnt_init < 3'd4))? (cnt_init + 1'b1) : 3'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        denoise_valid  <=  1'b0;
    end
    else begin
        if (cnt_init == 3'd4) begin
            denoise_valid  <=  1'b1;
        end
        else begin
            denoise_valid  <=  (cnt_interval == 10'd751)? 1'b0 : denoise_valid;
        end
    end
end
        

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_interval  <=  10'd0;
    end
    else begin
        if (denoise_valid) begin
            cnt_interval  <=  cnt_interval + 1'b1;
        end
        else begin
            cnt_interval  <=  10'd0;
        end
    end
end

endmodule
