`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2019 03:12:55 PM
// Design Name: 
// Module Name: preMCfilter_ctrl
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


module preMCfilter_ctrl(
    input                 pixclk,
    input                 reset_n,
    
    input                 s_axi_aclk,
    input                 s_axi_aresetn,
    
    input       [9:0]     roi_row_start,
    input       [9:0]     roi_col_start,
    
    input                 upd_template_begin,
    input                 upd_template_end,
    output reg            template_mode,

    input       [7:0]     sensor_din,

    input                 frame_begin,
    input                 line_begin,
    
    input                 frame_state,
    input                 line_state,
    
    output reg            tml_buf_rden,
    output reg  [14:0]    tml_buf_rdaddr,
    input       [31:0]    tml_buf_rddata,
    
    output reg            img_rowbuf_wren,
    output reg  [7:0]     img_rowbuf_wraddr,
    output reg  [7:0]     img_rowbuf_wrdata,
    
    output reg            tml_rowbuf_wren,
    output reg  [7:0]     tml_rowbuf_wraddr,
    output reg  [7:0]     tml_rowbuf_wrdata,
    
    output                filter_begin,
    output                filbuf_wready,
    
    output reg            fft_config_start
);

reg    [9:0]   cnt_line;
reg    [9:0]   cnt_pixel;

reg            tml_cnt_ena;
reg    [7:0]   tml_cnt_line;
reg    [7:0]   tml_cnt_pixel;

reg    [1:0]   tml_buf_rddata_sel;

reg    [7:0]   tml_rowbuf_sel_data;
reg            tml_rowbuf_sel;

assign        filter_begin   =  template_mode? (tml_rowbuf_wraddr == 8'd143) : (img_rowbuf_wraddr == 8'd143);
assign        filbuf_wready  =  template_mode? (tml_cnt_line >= 8'd16) : (cnt_line >= (roi_row_start+ 10'd8));

wire          mcorr_frame_begin  =  (cnt_line == (roi_row_start-10'd8)) && (cnt_pixel == (roi_col_start-10'd8-10'd1));

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
        if (frame_begin) begin
            cnt_pixel  <=  10'd0;
        end
        else if (frame_state && line_begin) begin
            cnt_pixel  <=  cnt_pixel + 1'b1;
        end
        else if (line_state) begin
            cnt_pixel  <=  cnt_pixel + 1'b1;
        end
        else begin
            cnt_pixel  <=  10'd0;
        end
    end
end

always @(posedge pixclk or negedge reset_n) begin
    if (~reset_n) begin
        img_rowbuf_wren  <=  1'b0;
    end
    else begin
        if ((cnt_line >= (roi_row_start-10'd8)) && (cnt_line < (roi_row_start-10'd8+10'd144)) && 
        (cnt_pixel >= (roi_col_start-10'd8-10'd1)) && (cnt_pixel < (roi_col_start-10'd8+10'd144-10'd1))) begin
            img_rowbuf_wren  <=  1'b1;
        end
        else begin
            img_rowbuf_wren  <=  1'b0;
        end
    end
end

always @(posedge pixclk or negedge reset_n) begin
    if (~reset_n) begin
        img_rowbuf_wraddr  <=  8'd0;
    end
    else begin
        if (img_rowbuf_wren) begin
            img_rowbuf_wraddr  <=  (img_rowbuf_wraddr == 8'd143)? 8'd0 : (img_rowbuf_wraddr + 1'b1);
        end
        else begin
            img_rowbuf_wraddr  <=  8'd0;
        end
    end
end

always @(posedge pixclk or negedge reset_n) begin
    if (~reset_n) begin
        img_rowbuf_wrdata  <=  8'd0;
    end
    else begin
        if ((cnt_line >= (roi_row_start-10'd8)) && (cnt_line < (roi_row_start-10'd8+10'd144)) && 
        (cnt_pixel >= (roi_col_start-10'd8-10'd1)) && (cnt_pixel < (roi_col_start-10'd8+10'd144-10'd1))) begin
            img_rowbuf_wrdata  <=  sensor_din;
        end
        else begin
            img_rowbuf_wrdata  <=  8'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_config_start  <=  1'b0;
    end
    else begin
        if ((upd_template_begin || mcorr_frame_begin) && (~fft_config_start)) begin
            fft_config_start  <=  1'b1;
        end
        else begin
            fft_config_start  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_cnt_ena  <=  1'b0;
    end
    else begin
        if (upd_template_begin) begin
            tml_cnt_ena  <=  1'b1;
        end
        else begin
            tml_cnt_ena  <=  ((tml_cnt_line == 8'd143) && (tml_cnt_pixel == 8'd255))? 1'b0 : tml_cnt_ena;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_cnt_line  <=  8'd0;
    end
    else begin
        if (upd_template_begin) begin
            tml_cnt_line  <=  8'd0;
        end
        else if (tml_cnt_pixel == 8'd255) begin
            tml_cnt_line  <=  (tml_cnt_line == 8'd143)? 8'd0 : (tml_cnt_line + 1'b1);
        end
        else begin
            tml_cnt_line  <=  tml_cnt_line;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_cnt_pixel  <=  8'd0;
    end
    else begin
        if (upd_template_begin) begin
            tml_cnt_pixel  <=  8'd0;
        end
        else if (tml_cnt_ena) begin
            tml_cnt_pixel  <=  (tml_cnt_pixel == 8'd255)? 8'd0 : (tml_cnt_pixel + 1'b1);
        end
        else begin
            tml_cnt_pixel  <=  8'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_buf_rden  <=  1'b0;
    end
    else begin
        tml_buf_rden  <=  tml_cnt_ena && (tml_cnt_pixel >= 8'd0) && (tml_cnt_pixel <= 8'd143);
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_buf_rdaddr  <=  15'd0;
    end
    else begin
        if (upd_template_begin) begin
            tml_buf_rdaddr  <=  15'd0;
        end
        else if (tml_buf_rden) begin
            tml_buf_rdaddr  <=  (tml_buf_rdaddr == 15'd20735)? 15'd0 : (tml_buf_rdaddr + 1'b1);
        end
        else begin
            tml_buf_rdaddr  <=  tml_buf_rdaddr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_buf_rddata_sel  <=  2'd0;
    end
    else begin
        tml_buf_rddata_sel  <=  tml_buf_rdaddr[1:0];
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        template_mode  <=  1'b0;
    end
    else begin
        if (upd_template_begin) begin
            template_mode  <=  1'b1;
        end
        else if (upd_template_end) begin
            template_mode  <=  1'b0;
        end
        else begin
            template_mode  <=  template_mode;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_rowbuf_sel  <=  1'b0;
    end
    else begin
        tml_rowbuf_sel  <=  tml_buf_rden;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_rowbuf_wren  <=  1'b0;
    end
    else begin
        tml_rowbuf_wren  <=  tml_rowbuf_sel;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_rowbuf_wraddr  <=  8'd0;
    end
    else begin
        if (tml_rowbuf_wren) begin
            tml_rowbuf_wraddr  <=  (tml_rowbuf_wraddr == 8'd143)? 8'd0 : (tml_rowbuf_wraddr + 1'b1);
        end
        else begin
            tml_rowbuf_wraddr  <=  8'd0;
        end
    end
end

always @(*) begin
    case (tml_buf_rddata_sel)
        2'd0: begin
            tml_rowbuf_sel_data  =  tml_buf_rddata[7:0];
        end
        2'd1: begin
            tml_rowbuf_sel_data  =  tml_buf_rddata[15:8];
        end
        2'd2: begin
            tml_rowbuf_sel_data  =  tml_buf_rddata[23:16];
        end
        2'd3: begin
            tml_rowbuf_sel_data  =  tml_buf_rddata[31:24];
        end
        default: begin
            tml_rowbuf_sel_data  =  tml_buf_rddata[7:0];
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_rowbuf_wrdata  <=  8'd0;
    end
    else begin
        tml_rowbuf_wrdata  <=  tml_rowbuf_sel_data;
    end
end

endmodule
