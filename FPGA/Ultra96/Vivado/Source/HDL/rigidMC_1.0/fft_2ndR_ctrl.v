`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 11:12:04 AM
// Design Name: 
// Module Name: fft_2ndR_ctrl
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


module fft_2ndR_ctrl(
    input               s_axi_aclk,
    input               s_axi_aresetn,
    
    input               fft_2ndR_start,
    output              fft_3rdR_config,
    
    input               template_mode,
    output              upd_template_end,
    
    input               fft_0_data_ready,
    output reg          fft_0_data_valid,
    output reg          fft_0_data_last,
    output      [63:0]  fft_0_data_data,
    
    output              fft_0_result_ready,
    input               fft_0_result_valid,
    input               fft_0_result_last,
    input       [63:0]  fft_0_result_data,
    
    input               fft_1_data_ready,
    output reg          fft_1_data_valid,
    output reg          fft_1_data_last,
    output      [63:0]  fft_1_data_data,
    
    output              fft_1_result_ready,
    input               fft_1_result_valid,
    input               fft_1_result_last,
    input       [63:0]  fft_1_result_data,
    
    input               fft_2_data_ready,
    output reg          fft_2_data_valid,
    output reg          fft_2_data_last,
    output      [63:0]  fft_2_data_data,

    output              fft_2_result_ready,
    input               fft_2_result_valid,
    input               fft_2_result_last,
    input       [63:0]  fft_2_result_data,
    
    input               fft_3_data_ready,
    output reg          fft_3_data_valid,
    output reg          fft_3_data_last,
    output      [63:0]  fft_3_data_data,

    output              fft_3_result_ready,
    input               fft_3_result_valid,
    input               fft_3_result_last,
    input       [63:0]  fft_3_result_data,
    
    output reg          roi_bram_0_wren,
    output reg  [11:0]  roi_bram_0_wraddr,
    output reg  [31:0]  roi_bram_0_wrdata,
    output reg          roi_bram_0_rden,
    output reg  [11:0]  roi_bram_0_rdaddr,
    input       [63:0]  roi_bram_0_rddata,
    
    output reg          roi_bram_1_wren,
    output reg  [11:0]  roi_bram_1_wraddr,
    output reg  [31:0]  roi_bram_1_wrdata,
    output reg          roi_bram_1_rden,
    output reg  [11:0]  roi_bram_1_rdaddr,
    input       [63:0]  roi_bram_1_rddata,

    output reg          roi_bram_2_wren,
    output reg  [11:0]  roi_bram_2_wraddr,
    output reg  [31:0]  roi_bram_2_wrdata,
    output reg          roi_bram_2_rden,
    output reg  [11:0]  roi_bram_2_rdaddr,
    input       [63:0]  roi_bram_2_rddata,

    output reg          roi_bram_3_wren,
    output reg  [11:0]  roi_bram_3_wraddr,
    output reg  [31:0]  roi_bram_3_wrdata,
    output reg          roi_bram_3_rden,
    output reg  [11:0]  roi_bram_3_rdaddr,
    input       [63:0]  roi_bram_3_rddata,

    output reg          tml_bram_0_wren,
    output reg  [11:0]  tml_bram_0_wraddr,
    output reg  [31:0]  tml_bram_0_wrdata,

    output reg          tml_bram_1_wren,
    output reg  [11:0]  tml_bram_1_wraddr,
    output reg  [31:0]  tml_bram_1_wrdata,

    output reg          tml_bram_2_wren,
    output reg  [11:0]  tml_bram_2_wraddr,
    output reg  [31:0]  tml_bram_2_wrdata,

    output reg          tml_bram_3_wren,
    output reg  [11:0]  tml_bram_3_wraddr,
    output reg  [31:0]  tml_bram_3_wrdata
);

reg          cnt_fft_ena;
reg  [7:0]   cnt_fft_pix;
reg  [7:0]   cnt_fft_row;

wire         fft_end  =  (cnt_fft_row == 8'd31) && (cnt_fft_pix == 8'd129);

wire         fft_start_0   =  (cnt_fft_pix == 8'd1);
wire         fft_start_1   =  (cnt_fft_pix == 8'd33);
wire         fft_start_2   =  (cnt_fft_pix == 8'd65);
wire         fft_start_3   =  (cnt_fft_pix == 8'd97);

reg  [1:0]   roi_bram_0_rddata_sel;
reg  [1:0]   roi_bram_1_rddata_sel;
reg  [1:0]   roi_bram_2_rddata_sel;
reg  [1:0]   roi_bram_3_rddata_sel;

reg  [63:0]  fft_0_bram_rddata;
reg  [63:0]  fft_1_bram_rddata;
reg  [63:0]  fft_2_bram_rddata;
reg  [63:0]  fft_3_bram_rddata;

assign       fft_0_data_data   =   fft_0_bram_rddata;
assign       fft_1_data_data   =   fft_1_bram_rddata;
assign       fft_2_data_data   =   fft_2_bram_rddata;
assign       fft_3_data_data   =   fft_3_bram_rddata;

assign       fft_0_result_ready   =   1'b1;
assign       fft_1_result_ready   =   1'b1;
assign       fft_2_result_ready   =   1'b1;
assign       fft_3_result_ready   =   1'b1;

wire         tml_valid_0       =   fft_0_result_valid && template_mode;
wire         tml_valid_1       =   fft_1_result_valid && template_mode;
wire         tml_valid_2       =   fft_2_result_valid && template_mode;
wire         tml_valid_3       =   fft_3_result_valid && template_mode;

wire         tml_bram_0_sel    =   tml_valid_0;
wire         tml_bram_1_sel    =   tml_valid_1;
wire         tml_bram_2_sel    =   tml_valid_2;
wire         tml_bram_3_sel    =   tml_valid_3;

reg  [11:0]  tml_bram_0_sel_addr;
reg  [11:0]  tml_bram_1_sel_addr;
reg  [11:0]  tml_bram_2_sel_addr;
reg  [11:0]  tml_bram_3_sel_addr;

reg  [31:0]  tml_bram_0_sel_data;
reg  [31:0]  tml_bram_1_sel_data;
reg  [31:0]  tml_bram_2_sel_data;
reg  [31:0]  tml_bram_3_sel_data;

wire         roi_valid_0       =   fft_0_result_valid && (~template_mode);
wire         roi_valid_1       =   fft_1_result_valid && (~template_mode);
wire         roi_valid_2       =   fft_2_result_valid && (~template_mode);
wire         roi_valid_3       =   fft_3_result_valid && (~template_mode);

wire         roi_bram_0_sel    =   roi_valid_0;
wire         roi_bram_1_sel    =   roi_valid_1;
wire         roi_bram_2_sel    =   roi_valid_2;
wire         roi_bram_3_sel    =   roi_valid_3;

reg  [11:0]  roi_bram_0_sel_addr;
reg  [11:0]  roi_bram_1_sel_addr;
reg  [11:0]  roi_bram_2_sel_addr;
reg  [11:0]  roi_bram_3_sel_addr;

reg  [31:0]  roi_bram_0_sel_data;
reg  [31:0]  roi_bram_1_sel_data;
reg  [31:0]  roi_bram_2_sel_data;
reg  [31:0]  roi_bram_3_sel_data;

assign       fft_3rdR_config  =  roi_bram_3_wren && (roi_bram_3_wraddr == 12'd4095) && (~template_mode);
assign       upd_template_end =  tml_bram_3_wren && (tml_bram_3_wraddr == 12'd4095) && template_mode;

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_0_wren  <=  1'b0;
    end
    else begin
        tml_bram_0_wren  <=  tml_bram_0_sel;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_1_wren  <=  1'b0;
    end
    else begin
        tml_bram_1_wren  <=  tml_bram_1_sel;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_2_wren  <=  1'b0;
    end
    else begin
        tml_bram_2_wren  <=  tml_bram_2_sel;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_3_wren  <=  1'b0;
    end
    else begin
        tml_bram_3_wren  <=  tml_bram_3_sel;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_0_wren  <=  1'b0;
    end
    else begin
        roi_bram_0_wren  <=  roi_bram_0_sel;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_1_wren  <=  1'b0;
    end
    else begin
        roi_bram_1_wren  <=  roi_bram_1_sel;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_2_wren  <=  1'b0;
    end
    else begin
        roi_bram_2_wren  <=  roi_bram_2_sel;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_3_wren  <=  1'b0;
    end
    else begin
        roi_bram_3_wren  <=  roi_bram_3_sel;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_fft_ena  <=  1'b0;
    end
    else begin
        if (fft_2ndR_start) begin
            cnt_fft_ena  <=  1'b1;
        end
        else if (fft_end) begin
            cnt_fft_ena  <=  1'b0;
        end
        else begin
            cnt_fft_ena  <=  cnt_fft_ena;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_fft_pix  <=  8'd0;
    end
    else begin
        if (cnt_fft_ena) begin
            cnt_fft_pix  <=  (cnt_fft_pix == 8'd129)? 8'd0 : (cnt_fft_pix + 1'b1);
        end
        else begin
            cnt_fft_pix  <=  8'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_fft_row  <=  8'd0;
    end
    else begin
        if (cnt_fft_ena) begin
            cnt_fft_row  <=  (cnt_fft_pix == 8'd129)? (cnt_fft_row + 1'b1) : cnt_fft_row;
        end
        else begin
            cnt_fft_row  <=  8'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_0_rden  <=  1'b0;
    end
    else begin
        if (fft_start_0) begin
            roi_bram_0_rden  <=  1'b1;
        end
        else if ((roi_bram_0_rdaddr & 12'hFE0) == 12'hFE0) begin
            roi_bram_0_rden  <=  1'b0;
        end
        else begin
            roi_bram_0_rden  <=  roi_bram_0_rden;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_0_rdaddr  <=  12'd0;
    end
    else begin
        if (roi_bram_0_rden) begin
            if ((roi_bram_0_rdaddr & 12'hFE0) == 12'hFE0) begin
                roi_bram_0_rdaddr  <=  (roi_bram_0_rdaddr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_bram_0_rdaddr & 12'hF80) == 12'hF80) begin
                roi_bram_0_rdaddr  <=  roi_bram_0_rdaddr[6:0] + 12'd32;
            end
            else begin
                roi_bram_0_rdaddr  <=  roi_bram_0_rdaddr + 12'd128;
            end
        end
        else begin
            roi_bram_0_rdaddr  <=  roi_bram_0_rdaddr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_0_rddata_sel  <=  2'd0;
    end
    else begin
        roi_bram_0_rddata_sel  <=  roi_bram_0_rdaddr[6:5];
    end
end

always @(*) begin
    case (roi_bram_0_rddata_sel)
        2'd0: begin
            fft_0_bram_rddata  =  roi_bram_0_rddata;
        end
        2'd1: begin
            fft_0_bram_rddata  =  roi_bram_1_rddata;
        end
        2'd2: begin
            fft_0_bram_rddata  =  roi_bram_2_rddata;
        end
        2'd3: begin
            fft_0_bram_rddata  =  roi_bram_3_rddata;
        end
        default: begin
            fft_0_bram_rddata  =  roi_bram_0_rddata;
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_0_data_valid  <=  1'b0;
    end
    else begin
        fft_0_data_valid  <=  roi_bram_0_rden;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_0_data_last  <=  1'b0;
    end
    else begin
        if ((roi_bram_0_rdaddr & 12'hFE0) == 12'hFE0) begin
            fft_0_data_last  <=  1'b1;
        end
        else begin
            fft_0_data_last  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_0_sel_addr  <=  12'd0;
    end
    else begin
        if (tml_bram_0_sel) begin
            if ((tml_bram_0_sel_addr & 12'hFE0) == 12'hFE0) begin
                tml_bram_0_sel_addr  <=  (tml_bram_0_sel_addr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((tml_bram_0_sel_addr & 12'hF80) == 12'hF80) begin
                tml_bram_0_sel_addr  <=  tml_bram_0_sel_addr[6:0] + 12'd32;
            end
            else begin
                tml_bram_0_sel_addr  <=  tml_bram_0_sel_addr + 12'd128;
            end
        end
        else begin
            tml_bram_0_sel_addr  <=  tml_bram_0_sel_addr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_0_wraddr  <=  12'd0;
    end
    else begin
        tml_bram_0_wraddr  <=  tml_bram_0_sel_addr;
    end
end

always @(*) begin
    case (tml_bram_0_sel_addr[6:5])
        2'd0: begin
            tml_bram_0_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
        2'd1: begin
            tml_bram_0_sel_data  =  {fft_1_result_data[60:45], fft_1_result_data[28:13]};
        end
        2'd2: begin
            tml_bram_0_sel_data  =  {fft_2_result_data[60:45], fft_2_result_data[28:13]};
        end
        2'd3: begin
            tml_bram_0_sel_data  =  {fft_3_result_data[60:45], fft_3_result_data[28:13]};
        end
        default: begin
            tml_bram_0_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_0_wrdata  <=  32'd0;
    end
    else begin
        tml_bram_0_wrdata  <=  tml_bram_0_sel_data;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_0_sel_addr  <=  12'd0;
    end
    else begin
        if (roi_bram_0_sel) begin
            if ((roi_bram_0_sel_addr & 12'hFE0) == 12'hFE0) begin
                roi_bram_0_sel_addr  <=  (roi_bram_0_sel_addr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_bram_0_sel_addr & 12'hF80) == 12'hF80) begin
                roi_bram_0_sel_addr  <=  roi_bram_0_sel_addr[6:0] + 12'd32;
            end
            else begin
                roi_bram_0_sel_addr  <=  roi_bram_0_sel_addr + 12'd128;
            end
        end
        else begin
            roi_bram_0_sel_addr  <=  roi_bram_0_sel_addr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_0_wraddr  <=  12'd0;
    end
    else begin
        roi_bram_0_wraddr  <=  roi_bram_0_sel_addr;
    end
end

always @(*) begin
    case (roi_bram_0_sel_addr[6:5])
        2'd0: begin
            roi_bram_0_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
        2'd1: begin
            roi_bram_0_sel_data  =  {fft_1_result_data[60:45], fft_1_result_data[28:13]};
        end
        2'd2: begin
            roi_bram_0_sel_data  =  {fft_2_result_data[60:45], fft_2_result_data[28:13]};
        end
        2'd3: begin
            roi_bram_0_sel_data  =  {fft_3_result_data[60:45], fft_3_result_data[28:13]};
        end
        default: begin
            roi_bram_0_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_0_wrdata  <=  32'd0;
    end
    else begin
        roi_bram_0_wrdata  <=  roi_bram_0_sel_data;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_1_rden  <=  1'b0;
    end
    else begin
        if (fft_start_1) begin
            roi_bram_1_rden  <=  1'b1;
        end
        else if ((roi_bram_1_rdaddr & 12'hFE0) == 12'hFE0) begin
            roi_bram_1_rden  <=  1'b0;
        end
        else begin
            roi_bram_1_rden  <=  roi_bram_1_rden;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_1_rdaddr  <=  12'd0;
    end
    else begin
        if (roi_bram_1_rden) begin
            if ((roi_bram_1_rdaddr & 12'hFE0) == 12'hFE0) begin
                roi_bram_1_rdaddr  <=  (roi_bram_1_rdaddr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_bram_1_rdaddr & 12'hF80) == 12'hF80) begin
                roi_bram_1_rdaddr  <=  roi_bram_1_rdaddr[6:0] + 12'd32;
            end
            else begin
                roi_bram_1_rdaddr  <=  roi_bram_1_rdaddr + 12'd128;
            end
        end
        else begin
            roi_bram_1_rdaddr  <=  roi_bram_1_rdaddr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_1_rddata_sel  <=  2'd0;
    end
    else begin
        roi_bram_1_rddata_sel  <=  roi_bram_1_rdaddr[6:5];
    end
end

always @(*) begin
    case (roi_bram_1_rddata_sel)
        2'd0: begin
            fft_1_bram_rddata  =  roi_bram_0_rddata;
        end
        2'd1: begin
            fft_1_bram_rddata  =  roi_bram_1_rddata;
        end
        2'd2: begin
            fft_1_bram_rddata  =  roi_bram_2_rddata;
        end
        2'd3: begin
            fft_1_bram_rddata  =  roi_bram_3_rddata;
        end
        default: begin
            fft_1_bram_rddata  =  roi_bram_0_rddata;
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_1_data_valid  <=  1'b0;
    end
    else begin
        fft_1_data_valid  <=  roi_bram_1_rden;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_1_data_last  <=  1'b0;
    end
    else begin
        if ((roi_bram_1_rdaddr & 12'hFE0) == 12'hFE0) begin
            fft_1_data_last  <=  1'b1;
        end
        else begin
            fft_1_data_last  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_1_sel_addr  <=  12'd0;
    end
    else begin
        if (tml_bram_1_sel) begin
            if ((tml_bram_1_sel_addr & 12'hFE0) == 12'hFE0) begin
                tml_bram_1_sel_addr  <=  (tml_bram_1_sel_addr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((tml_bram_1_sel_addr & 12'hF80) == 12'hF80) begin
                tml_bram_1_sel_addr  <=  tml_bram_1_sel_addr[6:0] + 12'd32;
            end
            else begin
                tml_bram_1_sel_addr  <=  tml_bram_1_sel_addr + 12'd128;
            end
        end
        else begin
            tml_bram_1_sel_addr  <=  tml_bram_1_sel_addr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_1_wraddr  <=  12'd0;
    end
    else begin
        tml_bram_1_wraddr  <=  tml_bram_1_sel_addr;
    end
end

always @(*) begin
    case (tml_bram_1_sel_addr[6:5])
        2'd0: begin
            tml_bram_1_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
        2'd1: begin
            tml_bram_1_sel_data  =  {fft_1_result_data[60:45], fft_1_result_data[28:13]};
        end
        2'd2: begin
            tml_bram_1_sel_data  =  {fft_2_result_data[60:45], fft_2_result_data[28:13]};
        end
        2'd3: begin
            tml_bram_1_sel_data  =  {fft_3_result_data[60:45], fft_3_result_data[28:13]};
        end
        default: begin
            tml_bram_1_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_1_wrdata  <=  32'd0;
    end
    else begin
        tml_bram_1_wrdata  <=  tml_bram_1_sel_data;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_1_sel_addr  <=  12'd0;
    end
    else begin
        if (roi_bram_1_sel) begin
            if ((roi_bram_1_sel_addr & 12'hFE0) == 12'hFE0) begin
                roi_bram_1_sel_addr  <=  (roi_bram_1_sel_addr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_bram_1_sel_addr & 12'hF80) == 12'hF80) begin
                roi_bram_1_sel_addr  <=  roi_bram_1_sel_addr[6:0] + 12'd32;
            end
            else begin
                roi_bram_1_sel_addr  <=  roi_bram_1_sel_addr + 12'd128;
            end
        end
        else begin
            roi_bram_1_sel_addr  <=  roi_bram_1_sel_addr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_1_wraddr  <=  12'd0;
    end
    else begin
        roi_bram_1_wraddr  <=  roi_bram_1_sel_addr;
    end
end

always @(*) begin
    case (roi_bram_1_sel_addr[6:5])
        2'd0: begin
            roi_bram_1_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
        2'd1: begin
            roi_bram_1_sel_data  =  {fft_1_result_data[60:45], fft_1_result_data[28:13]};
        end
        2'd2: begin
            roi_bram_1_sel_data  =  {fft_2_result_data[60:45], fft_2_result_data[28:13]};
        end
        2'd3: begin
            roi_bram_1_sel_data  =  {fft_3_result_data[60:45], fft_3_result_data[28:13]};
        end
        default: begin
            roi_bram_1_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_1_wrdata  <=  32'd0;
    end
    else begin
        roi_bram_1_wrdata  <=  roi_bram_1_sel_data;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_2_rden  <=  1'b0;
    end
    else begin
        if (fft_start_2) begin
            roi_bram_2_rden  <=  1'b1;
        end
        else if ((roi_bram_2_rdaddr & 12'hFE0) == 12'hFE0) begin
            roi_bram_2_rden  <=  1'b0;
        end
        else begin
            roi_bram_2_rden  <=  roi_bram_2_rden;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_2_rdaddr  <=  12'd0;
    end
    else begin
        if (roi_bram_2_rden) begin
            if ((roi_bram_2_rdaddr & 12'hFE0) == 12'hFE0) begin
                roi_bram_2_rdaddr  <=  (roi_bram_2_rdaddr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_bram_2_rdaddr & 12'hF80) == 12'hF80) begin
                roi_bram_2_rdaddr  <=  roi_bram_2_rdaddr[6:0] + 12'd32;
            end
            else begin
                roi_bram_2_rdaddr  <=  roi_bram_2_rdaddr + 12'd128;
            end
        end
        else begin
            roi_bram_2_rdaddr  <=  roi_bram_2_rdaddr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_2_rddata_sel  <=  2'd0;
    end
    else begin
        roi_bram_2_rddata_sel  <=  roi_bram_2_rdaddr[6:5];
    end
end

always @(*) begin
    case (roi_bram_2_rddata_sel)
        2'd0: begin
            fft_2_bram_rddata  =  roi_bram_0_rddata;
        end
        2'd1: begin
            fft_2_bram_rddata  =  roi_bram_1_rddata;
        end
        2'd2: begin
            fft_2_bram_rddata  =  roi_bram_2_rddata;
        end
        2'd3: begin
            fft_2_bram_rddata  =  roi_bram_3_rddata;
        end
        default: begin
            fft_2_bram_rddata  =  roi_bram_0_rddata;
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_2_data_valid  <=  1'b0;
    end
    else begin
        fft_2_data_valid  <=  roi_bram_2_rden;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_2_data_last  <=  1'b0;
    end
    else begin
        if ((roi_bram_2_rdaddr & 12'hFE0) == 12'hFE0) begin
            fft_2_data_last  <=  1'b1;
        end
        else begin
            fft_2_data_last  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_2_sel_addr  <=  12'd0;
    end
    else begin
        if (tml_bram_2_sel) begin
            if ((tml_bram_2_sel_addr & 12'hFE0) == 12'hFE0) begin
                tml_bram_2_sel_addr  <=  (tml_bram_2_sel_addr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((tml_bram_2_sel_addr & 12'hF80) == 12'hF80) begin
                tml_bram_2_sel_addr  <=  tml_bram_2_sel_addr[6:0] + 12'd32;
            end
            else begin
                tml_bram_2_sel_addr  <=  tml_bram_2_sel_addr + 12'd128;
            end
        end
        else begin
            tml_bram_2_sel_addr  <=  tml_bram_2_sel_addr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_2_wraddr  <=  12'd0;
    end
    else begin
        tml_bram_2_wraddr  <=  tml_bram_2_sel_addr;
    end
end

always @(*) begin
    case (tml_bram_2_sel_addr[6:5])
        2'd0: begin
            tml_bram_2_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
        2'd1: begin
            tml_bram_2_sel_data  =  {fft_1_result_data[60:45], fft_1_result_data[28:13]};
        end
        2'd2: begin
            tml_bram_2_sel_data  =  {fft_2_result_data[60:45], fft_2_result_data[28:13]};
        end
        2'd3: begin
            tml_bram_2_sel_data  =  {fft_3_result_data[60:45], fft_3_result_data[28:13]};
        end
        default: begin
            tml_bram_2_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_2_wrdata  <=  32'd0;
    end
    else begin
        tml_bram_2_wrdata  <=  tml_bram_2_sel_data;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_2_sel_addr  <=  12'd0;
    end
    else begin
        if (roi_bram_2_sel) begin
            if ((roi_bram_2_sel_addr & 12'hFE0) == 12'hFE0) begin
                roi_bram_2_sel_addr  <=  (roi_bram_2_sel_addr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_bram_2_sel_addr & 12'hF80) == 12'hF80) begin
                roi_bram_2_sel_addr  <=  roi_bram_2_sel_addr[6:0] + 12'd32;
            end
            else begin
                roi_bram_2_sel_addr  <=  roi_bram_2_sel_addr + 12'd128;
            end
        end
        else begin
            roi_bram_2_sel_addr  <=  roi_bram_2_sel_addr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_2_wraddr  <=  12'd0;
    end
    else begin
        roi_bram_2_wraddr  <=  roi_bram_2_sel_addr;
    end
end

always @(*) begin
    case (roi_bram_2_sel_addr[6:5])
        2'd0: begin
            roi_bram_2_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
        2'd1: begin
            roi_bram_2_sel_data  =  {fft_1_result_data[60:45], fft_1_result_data[28:13]};
        end
        2'd2: begin
            roi_bram_2_sel_data  =  {fft_2_result_data[60:45], fft_2_result_data[28:13]};
        end
        2'd3: begin
            roi_bram_2_sel_data  =  {fft_3_result_data[60:45], fft_3_result_data[28:13]};
        end
        default: begin
            roi_bram_2_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_2_wrdata  <=  32'd0;
    end
    else begin
        roi_bram_2_wrdata  <=  roi_bram_2_sel_data;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_3_rden  <=  1'b0;
    end
    else begin
        if (fft_start_3) begin
            roi_bram_3_rden  <=  1'b1;
        end
        else if ((roi_bram_3_rdaddr & 12'hFE0) == 12'hFE0) begin
            roi_bram_3_rden  <=  1'b0;
        end
        else begin
            roi_bram_3_rden  <=  roi_bram_3_rden;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_3_rdaddr  <=  12'd0;
    end
    else begin
        if (roi_bram_3_rden) begin
            if ((roi_bram_3_rdaddr & 12'hFE0) == 12'hFE0) begin
                roi_bram_3_rdaddr  <=  (roi_bram_3_rdaddr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_bram_3_rdaddr & 12'hF80) == 12'hF80) begin
                roi_bram_3_rdaddr  <=  roi_bram_3_rdaddr[6:0] + 12'd32;
            end
            else begin
                roi_bram_3_rdaddr  <=  roi_bram_3_rdaddr + 12'd128;
            end
        end
        else begin
            roi_bram_3_rdaddr  <=  roi_bram_3_rdaddr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_3_rddata_sel  <=  2'd0;
    end
    else begin
        roi_bram_3_rddata_sel  <=  roi_bram_3_rdaddr[6:5];
    end
end

always @(*) begin
    case (roi_bram_3_rddata_sel)
        2'd0: begin
            fft_3_bram_rddata  =  roi_bram_0_rddata;
        end
        2'd1: begin
            fft_3_bram_rddata  =  roi_bram_1_rddata;
        end
        2'd2: begin
            fft_3_bram_rddata  =  roi_bram_2_rddata;
        end
        2'd3: begin
            fft_3_bram_rddata  =  roi_bram_3_rddata;
        end
        default: begin
            fft_3_bram_rddata  =  roi_bram_0_rddata;
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_3_data_valid  <=  1'b0;
    end
    else begin
        fft_3_data_valid  <=  roi_bram_3_rden;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_3_data_last  <=  1'b0;
    end
    else begin
        if ((roi_bram_3_rdaddr & 12'hFE0) == 12'hFE0) begin
            fft_3_data_last  <=  1'b1;
        end
        else begin
            fft_3_data_last  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_3_sel_addr  <=  12'd0;
    end
    else begin
        if (tml_bram_3_sel) begin
            if ((tml_bram_3_sel_addr & 12'hFE0) == 12'hFE0) begin
                tml_bram_3_sel_addr  <=  (tml_bram_3_sel_addr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((tml_bram_3_sel_addr & 12'hF80) == 12'hF80) begin
                tml_bram_3_sel_addr  <=  tml_bram_3_sel_addr[6:0] + 12'd32;
            end
            else begin
                tml_bram_3_sel_addr  <=  tml_bram_3_sel_addr + 12'd128;
            end
        end
        else begin
            tml_bram_3_sel_addr  <=  tml_bram_3_sel_addr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_3_wraddr  <=  12'd0;
    end
    else begin
        tml_bram_3_wraddr  <=  tml_bram_3_sel_addr;
    end
end

always @(*) begin
    case (tml_bram_3_sel_addr[6:5])
        2'd0: begin
            tml_bram_3_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
        2'd1: begin
            tml_bram_3_sel_data  =  {fft_1_result_data[60:45], fft_1_result_data[28:13]};
        end
        2'd2: begin
            tml_bram_3_sel_data  =  {fft_2_result_data[60:45], fft_2_result_data[28:13]};
        end
        2'd3: begin
            tml_bram_3_sel_data  =  {fft_3_result_data[60:45], fft_3_result_data[28:13]};
        end
        default: begin
            tml_bram_3_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_3_wrdata  <=  32'd0;
    end
    else begin
        tml_bram_3_wrdata  <=  tml_bram_3_sel_data;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_3_sel_addr  <=  12'd0;
    end
    else begin
        if (roi_bram_3_sel) begin
            if ((roi_bram_3_sel_addr & 12'hFE0) == 12'hFE0) begin
                roi_bram_3_sel_addr  <=  (roi_bram_3_sel_addr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_bram_3_sel_addr & 12'hF80) == 12'hF80) begin
                roi_bram_3_sel_addr  <=  roi_bram_3_sel_addr[6:0] + 12'd32;
            end
            else begin
                roi_bram_3_sel_addr  <=  roi_bram_3_sel_addr + 12'd128;
            end
        end
        else begin
            roi_bram_3_sel_addr  <=  roi_bram_3_sel_addr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_3_wraddr  <=  12'd0;
    end
    else begin
        roi_bram_3_wraddr  <=  roi_bram_3_sel_addr;
    end
end

always @(*) begin
    case (roi_bram_3_sel_addr[6:5])
        2'd0: begin
            roi_bram_3_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
        2'd1: begin
            roi_bram_3_sel_data  =  {fft_1_result_data[60:45], fft_1_result_data[28:13]};
        end
        2'd2: begin
            roi_bram_3_sel_data  =  {fft_2_result_data[60:45], fft_2_result_data[28:13]};
        end
        2'd3: begin
            roi_bram_3_sel_data  =  {fft_3_result_data[60:45], fft_3_result_data[28:13]};
        end
        default: begin
            roi_bram_3_sel_data  =  {fft_0_result_data[60:45], fft_0_result_data[28:13]};
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_3_wrdata  <=  32'd0;
    end
    else begin
        roi_bram_3_wrdata  <=  roi_bram_3_sel_data;
    end
end

endmodule
