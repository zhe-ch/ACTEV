`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 11:14:13 AM
// Design Name: 
// Module Name: fft_4thR_ctrl
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


module fft_4thR_ctrl(
    input               s_axi_aclk,
    input               s_axi_aresetn,
    
    input               fft_4thR_start,
    
    output reg          motion_extract_end,
    output      [13:0]  max_corr_addr,
    
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
    output      [63:0]  roi_bram_0_wrdata,
    output reg          roi_bram_0_rden,
    output reg  [11:0]  roi_bram_0_rdaddr,
    input       [63:0]  roi_bram_0_rddata,
    
    output reg          roi_bram_1_wren,
    output reg  [11:0]  roi_bram_1_wraddr,
    output      [63:0]  roi_bram_1_wrdata,
    output reg          roi_bram_1_rden,
    output reg  [11:0]  roi_bram_1_rdaddr,
    input       [63:0]  roi_bram_1_rddata,

    output reg          roi_bram_2_wren,
    output reg  [11:0]  roi_bram_2_wraddr,
    output      [63:0]  roi_bram_2_wrdata,
    output reg          roi_bram_2_rden,
    output reg  [11:0]  roi_bram_2_rdaddr,
    input       [63:0]  roi_bram_2_rddata,

    output reg          roi_bram_3_wren,
    output reg  [11:0]  roi_bram_3_wraddr,
    output      [63:0]  roi_bram_3_wrdata,
    output reg          roi_bram_3_rden,
    output reg  [11:0]  roi_bram_3_rdaddr,
    input       [63:0]  roi_bram_3_rddata
);

reg           cnt_fft_ena;
reg  [7:0]    cnt_fft_pix;
reg  [7:0]    cnt_fft_row;

wire          fft_end  =  (cnt_fft_row == 8'd31) && (cnt_fft_pix == 8'd129);

wire          fft_start_0   =  (cnt_fft_pix == 8'd1);
wire          fft_start_1   =  (cnt_fft_pix == 8'd33);
wire          fft_start_2   =  (cnt_fft_pix == 8'd65);
wire          fft_start_3   =  (cnt_fft_pix == 8'd97);

reg  [1:0]    roi_bram_0_rddata_sel;
reg  [1:0]    roi_bram_1_rddata_sel;
reg  [1:0]    roi_bram_2_rddata_sel;
reg  [1:0]    roi_bram_3_rddata_sel;

reg  [63:0]   fft_0_bram_rddata;
reg  [63:0]   fft_1_bram_rddata;
reg  [63:0]   fft_2_bram_rddata;
reg  [63:0]   fft_3_bram_rddata;

reg           op_acc_0;
reg           op_acc_1;
reg           op_acc_2;
reg           op_acc_3;

reg  [63:0]   roi_data_0;
reg  [63:0]   roi_data_1;
reg  [63:0]   roi_data_2;
reg  [63:0]   roi_data_3;

reg  [31:0]   prod_r_0;
reg  [31:0]   prod_i_0;

reg  [31:0]   prod_r_1;
reg  [31:0]   prod_i_1;

reg  [31:0]   prod_r_2;
reg  [31:0]   prod_i_2;

reg  [31:0]   prod_r_3;
reg  [31:0]   prod_i_3;

reg  [31:0]   crosscorr_0;
reg  [31:0]   crosscorr_1;
reg  [31:0]   crosscorr_2;
reg  [31:0]   crosscorr_3;

assign        fft_0_data_data   =   fft_0_bram_rddata;
assign        fft_1_data_data   =   fft_1_bram_rddata;
assign        fft_2_data_data   =   fft_2_bram_rddata;
assign        fft_3_data_data   =   fft_3_bram_rddata;

assign        fft_0_result_ready   =   1'b1;
assign        fft_1_result_ready   =   1'b1;
assign        fft_2_result_ready   =   1'b1;
assign        fft_3_result_ready   =   1'b1;

wire          op_multiply_0   =   fft_0_result_ready && fft_0_result_valid;
wire          op_multiply_1   =   fft_1_result_ready && fft_1_result_valid;
wire          op_multiply_2   =   fft_2_result_ready && fft_2_result_valid;
wire          op_multiply_3   =   fft_3_result_ready && fft_3_result_valid;

reg  [11:0]   roi_addr_0;
reg  [11:0]   roi_addr_1;
reg  [11:0]   roi_addr_2;
reg  [11:0]   roi_addr_3;

assign        roi_bram_0_wrdata   =   {32'd0, crosscorr_0};
assign        roi_bram_1_wrdata   =   {32'd0, crosscorr_1};
assign        roi_bram_2_wrdata   =   {32'd0, crosscorr_2};
assign        roi_bram_3_wrdata   =   {32'd0, crosscorr_3};

reg  [31:0]   max_corr_0;
reg  [31:0]   max_corr_1;
reg  [31:0]   max_corr_2;
reg  [31:0]   max_corr_3;

reg  [13:0]   max_addr_0;
reg  [13:0]   max_addr_1;
reg  [13:0]   max_addr_2;
reg  [13:0]   max_addr_3;

reg           op_findmax_s1;
reg           op_findmax_s2;

assign        max_corr_addr   =  max_addr_0;

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_fft_ena  <=  1'b0;
    end
    else begin
        if (fft_4thR_start) begin
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
        if (roi_bram_0_rden) begin
            fft_0_data_valid  <=  1'b1;
        end
        else begin
            fft_0_data_valid  <=  1'b0;
        end
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
        roi_addr_0  <=  12'd0;
    end
    else begin
        if (op_multiply_0) begin
            if ((roi_addr_0 & 12'hFE0) == 12'hFE0) begin
                roi_addr_0  <=  (roi_addr_0[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_addr_0 & 12'hF80) == 12'hF80) begin
                roi_addr_0  <=  roi_addr_0[6:0] + 12'd32;
            end
            else begin
                roi_addr_0  <=  roi_addr_0 + 12'd128;
            end
        end
        else begin
            roi_addr_0  <=  roi_addr_0;
        end
    end
end

always @(*) begin
    case (roi_addr_0[6:5])
        2'd0: begin
            roi_data_0  =  fft_0_result_data;
        end
        2'd1: begin
            roi_data_0  =  fft_1_result_data;
        end
        2'd2: begin
            roi_data_0  =  fft_2_result_data;
        end
        2'd3: begin
            roi_data_0  =  fft_3_result_data;
        end
        default: begin
            roi_data_0  =  fft_0_result_data;
        end
    endcase
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
        if (roi_bram_1_rden) begin
            fft_1_data_valid  <=  1'b1;
        end
        else begin
            fft_1_data_valid  <=  1'b0;
        end
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
        roi_addr_1  <=  12'd0;
    end
    else begin
        if (op_multiply_1) begin
            if ((roi_addr_1 & 12'hFE0) == 12'hFE0) begin
                roi_addr_1  <=  (roi_addr_1[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_addr_1 & 12'hF80) == 12'hF80) begin
                roi_addr_1  <=  roi_addr_1[6:0] + 12'd32;
            end
            else begin
                roi_addr_1  <=  roi_addr_1 + 12'd128;
            end
        end
        else begin
            roi_addr_1  <=  roi_addr_1;
        end
    end
end

always @(*) begin
    case (roi_addr_1[6:5])
        2'd0: begin
            roi_data_1  =  fft_0_result_data;
        end
        2'd1: begin
            roi_data_1  =  fft_1_result_data;
        end
        2'd2: begin
            roi_data_1  =  fft_2_result_data;
        end
        2'd3: begin
            roi_data_1  =  fft_3_result_data;
        end
        default: begin
            roi_data_1  =  fft_0_result_data;
        end
    endcase
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
        if (roi_bram_2_rden) begin
            fft_2_data_valid  <=  1'b1;
        end
        else begin
            fft_2_data_valid  <=  1'b0;
        end
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
        roi_addr_2  <=  12'd0;
    end
    else begin
        if (op_multiply_2) begin
            if ((roi_addr_2 & 12'hFE0) == 12'hFE0) begin
                roi_addr_2  <=  (roi_addr_2[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_addr_2 & 12'hF80) == 12'hF80) begin
                roi_addr_2  <=  roi_addr_2[6:0] + 12'd32;
            end
            else begin
                roi_addr_2  <=  roi_addr_2 + 12'd128;
            end
        end
        else begin
            roi_addr_2  <=  roi_addr_2;
        end
    end
end

always @(*) begin
    case (roi_addr_2[6:5])
        2'd0: begin
            roi_data_2  =  fft_0_result_data;
        end
        2'd1: begin
            roi_data_2  =  fft_1_result_data;
        end
        2'd2: begin
            roi_data_2  =  fft_2_result_data;
        end
        2'd3: begin
            roi_data_2  =  fft_3_result_data;
        end
        default: begin
            roi_data_2  =  fft_0_result_data;
        end
    endcase
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
        if (roi_bram_3_rden) begin
            fft_3_data_valid  <=  1'b1;
        end
        else begin
            fft_3_data_valid  <=  1'b0;
        end
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
        roi_addr_3  <=  12'd0;
    end
    else begin
        if (op_multiply_3) begin
            if ((roi_addr_3 & 12'hFE0) == 12'hFE0) begin
                roi_addr_3  <=  (roi_addr_3[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_addr_3 & 12'hF80) == 12'hF80) begin
                roi_addr_3  <=  roi_addr_3[6:0] + 12'd32;
            end
            else begin
                roi_addr_3  <=  roi_addr_3 + 12'd128;
            end
        end
        else begin
            roi_addr_3  <=  roi_addr_3;
        end
    end
end

always @(*) begin
    case (roi_addr_3[6:5])
        2'd0: begin
            roi_data_3  =  fft_0_result_data;
        end
        2'd1: begin
            roi_data_3  =  fft_1_result_data;
        end
        2'd2: begin
            roi_data_3  =  fft_2_result_data;
        end
        2'd3: begin
            roi_data_3  =  fft_3_result_data;
        end
        default: begin
            roi_data_3  =  fft_0_result_data;
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        op_acc_0  <=  1'b0;
    end
    else begin
        op_acc_0  <=  op_multiply_0;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        op_acc_1  <=  1'b0;
    end
    else begin
        op_acc_1  <=  op_multiply_1;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        op_acc_2  <=  1'b0;
    end
    else begin
        op_acc_2  <=  op_multiply_2;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        op_acc_3  <=  1'b0;
    end
    else begin
        op_acc_3  <=  op_multiply_3;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_0_wren <=  1'b0;
    end
    else begin
        roi_bram_0_wren  <=  op_acc_0;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_1_wren <=  1'b0;
    end
    else begin
        roi_bram_1_wren  <=  op_acc_1;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_2_wren <=  1'b0;
    end
    else begin
        roi_bram_2_wren  <=  op_acc_2;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_3_wren <=  1'b0;
    end
    else begin
        roi_bram_3_wren  <=  op_acc_3;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        op_findmax_s1  <=  1'b0;
    end
    else begin
        if (roi_bram_3_wren && (roi_bram_3_wraddr == 12'd4095)) begin
            op_findmax_s1  <=  1'b1;
        end
        else begin
            op_findmax_s1  <=  1'b0;
        end
    end
end         

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        op_findmax_s2  <=  1'b0;
    end
    else begin
        op_findmax_s2  <=  op_findmax_s1;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        motion_extract_end  <=  1'b0;
    end
    else begin
        motion_extract_end  <=  op_findmax_s2;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_r_0  <=  32'd0;
    end
    else begin
        if (op_multiply_0) begin
            prod_r_0  <=  (roi_data_0[31] == 1'b0)? roi_data_0[31:0] : ((~roi_data_0[31:0]) + 32'd1);
        end
        else begin
            prod_r_0  <=  prod_r_0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_i_0  <=  32'd0;
    end
    else begin
        if (op_multiply_0) begin
            prod_i_0  <=  (roi_data_0[63] == 1'b0)? roi_data_0[63:32] : ((~roi_data_0[63:32]) + 32'd1);
        end
        else begin
            prod_i_0  <=  prod_i_0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_r_1  <=  32'd0;
    end
    else begin
        if (op_multiply_1) begin
            prod_r_1  <=  (roi_data_1[31] == 1'b0)? roi_data_1[31:0] : ((~roi_data_1[31:0]) + 32'd1);
        end
        else begin
            prod_r_1  <=  prod_r_1;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_i_1  <=  32'd0;
    end
    else begin
        if (op_multiply_1) begin
            prod_i_1  <=  (roi_data_1[63] == 1'b0)? roi_data_1[63:32] : ((~roi_data_1[63:32]) + 32'd1);
        end
        else begin
            prod_i_1  <=  prod_i_1;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_r_2  <=  32'd0;
    end
    else begin
        if (op_multiply_2) begin
            prod_r_2  <=  (roi_data_2[31] == 1'b0)? roi_data_2[31:0] : ((~roi_data_2[31:0]) + 32'd1);
        end
        else begin
            prod_r_2  <=  prod_r_2;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_i_2  <=  32'd0;
    end
    else begin
        if (op_multiply_2) begin
            prod_i_2  <=  (roi_data_2[63] == 1'b0)? roi_data_2[63:32] : ((~roi_data_2[63:32]) + 32'd1);
        end
        else begin
            prod_i_2 <=  prod_i_2;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_r_3  <=  32'd0;
    end
    else begin
        if (op_multiply_3) begin
            prod_r_3  <=  (roi_data_3[31] == 1'b0)? roi_data_3[31:0] : ((~roi_data_3[31:0]) + 32'd1);
        end
        else begin
            prod_r_3  <=  prod_r_3;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_i_3  <=  32'd0;
    end
    else begin
        if (op_multiply_3) begin
            prod_i_3  <=  (roi_data_3[63] == 1'b0)? roi_data_3[63:32] : ((~roi_data_3[63:32]) + 32'd1);
        end
        else begin
            prod_i_3 <=  prod_i_3;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        crosscorr_0  <=  32'd0;
    end
    else begin
        if (op_acc_0) begin
            crosscorr_0  <=  prod_r_0 + prod_i_0;
        end
        else begin
            crosscorr_0  <=  crosscorr_0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        crosscorr_1  <=  32'd0;
    end
    else begin
        if (op_acc_1) begin
            crosscorr_1  <=  prod_r_1 + prod_i_1;
        end
        else begin
            crosscorr_1  <=  crosscorr_1;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        crosscorr_2  <=  32'd0;
    end
    else begin
        if (op_acc_2) begin
            crosscorr_2  <=  prod_r_2 + prod_i_2;
        end
        else begin
            crosscorr_2  <=  crosscorr_2;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        crosscorr_3  <=  32'd0;
    end
    else begin
        if (op_acc_3) begin
            crosscorr_3  <=  prod_r_3 + prod_i_3;
        end
        else begin
            crosscorr_3  <=  crosscorr_3;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_0_wraddr  <=  12'd0;
    end
    else begin
        if (roi_bram_0_wren) begin
            if ((roi_bram_0_wraddr & 12'hFE0) == 12'hFE0) begin
                roi_bram_0_wraddr  <=  (roi_bram_0_wraddr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_bram_0_wraddr & 12'hF80) == 12'hF80) begin
                roi_bram_0_wraddr  <=  roi_bram_0_wraddr[6:0] + 12'd32;
            end
            else begin
                roi_bram_0_wraddr  <=  roi_bram_0_wraddr + 12'd128;
            end
        end
        else begin
            roi_bram_0_wraddr  <=  roi_bram_0_wraddr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_1_wraddr  <=  12'd0;
    end
    else begin
        if (roi_bram_1_wren) begin
            if ((roi_bram_1_wraddr & 12'hFE0) == 12'hFE0) begin
                roi_bram_1_wraddr  <=  (roi_bram_1_wraddr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_bram_1_wraddr & 12'hF80) == 12'hF80) begin
                roi_bram_1_wraddr  <=  roi_bram_1_wraddr[6:0] + 12'd32;
            end
            else begin
                roi_bram_1_wraddr  <=  roi_bram_1_wraddr + 12'd128;
            end
        end
        else begin
            roi_bram_1_wraddr  <=  roi_bram_1_wraddr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_2_wraddr  <=  12'd0;
    end
    else begin
        if (roi_bram_2_wren) begin
            if ((roi_bram_2_wraddr & 12'hFE0) == 12'hFE0) begin
                roi_bram_2_wraddr  <=  (roi_bram_2_wraddr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_bram_2_wraddr & 12'hF80) == 12'hF80) begin
                roi_bram_2_wraddr  <=  roi_bram_2_wraddr[6:0] + 12'd32;
            end
            else begin
                roi_bram_2_wraddr  <=  roi_bram_2_wraddr + 12'd128;
            end
        end
        else begin
            roi_bram_2_wraddr  <=  roi_bram_2_wraddr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_3_wraddr  <=  12'd0;
    end
    else begin
        if (roi_bram_3_wren) begin
            if ((roi_bram_3_wraddr & 12'hFE0) == 12'hFE0) begin
                roi_bram_3_wraddr  <=  (roi_bram_3_wraddr[4:0] + 1'b1) & 12'h01F;
            end
            else if ((roi_bram_3_wraddr & 12'hF80) == 12'hF80) begin
                roi_bram_3_wraddr  <=  roi_bram_3_wraddr[6:0] + 12'd32;
            end
            else begin
                roi_bram_3_wraddr  <=  roi_bram_3_wraddr + 12'd128;
            end
        end
        else begin
            roi_bram_3_wraddr  <=  roi_bram_3_wraddr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        max_corr_0  <=  32'd0;
    end
    else begin
        if (fft_4thR_start) begin
            max_corr_0  <=  32'd0;
        end
        else begin
            if (roi_bram_0_wren) begin
                if (crosscorr_0 > max_corr_0) begin
                    max_corr_0  <=  crosscorr_0;
                end
                else begin
                    max_corr_0  <=  max_corr_0;
                end
            end
            else if (op_findmax_s1) begin
                if (max_corr_0 > max_corr_1) begin
                    max_corr_0  <=  max_corr_0;
                end
                else begin
                    max_corr_0  <=  max_corr_1;
                end
            end
            else begin
                max_corr_0  <=  max_corr_0;
            end
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        max_corr_1  <=  32'd0;
    end
    else begin
        if (fft_4thR_start) begin
            max_corr_1  <=  32'd0;
        end
        else begin
            if (roi_bram_1_wren) begin
                if (crosscorr_1 > max_corr_1) begin
                    max_corr_1  <=  crosscorr_1;
                end
                else begin
                    max_corr_1  <=  max_corr_1;
                end
            end
            else begin
                max_corr_1  <=  max_corr_1;
            end
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        max_corr_2  <=  32'd0;
    end
    else begin
        if (fft_4thR_start) begin
            max_corr_2  <=  32'd0;
        end
        else begin
            if (roi_bram_2_wren) begin
                if (crosscorr_2 > max_corr_2) begin
                    max_corr_2  <=  crosscorr_2;
                end
                else begin
                    max_corr_2  <=  max_corr_2;
                end
            end
            else if (op_findmax_s1) begin
                if (max_corr_2 > max_corr_3) begin
                    max_corr_2  <=  max_corr_2;
                end
                else begin
                    max_corr_2  <=  max_corr_3;
                end
            end
            else begin
                max_corr_2  <=  max_corr_2;
            end
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        max_corr_3  <=  32'd0;
    end
    else begin
        if (fft_4thR_start) begin
            max_corr_3  <=  32'd0;
        end
        else begin
            if (roi_bram_3_wren) begin
                if (crosscorr_3 > max_corr_3) begin
                    max_corr_3  <=  crosscorr_3;
                end
                else begin
                    max_corr_3  <=  max_corr_3;
                end
            end
            else begin
                max_corr_3  <=  max_corr_3;
            end
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        max_addr_0  <=  14'd0;
    end
    else begin
        if (fft_4thR_start) begin
            max_addr_0  <=  14'd0;
        end
        else begin
            if (roi_bram_0_wren) begin
                if (crosscorr_0 > max_corr_0) begin
                    max_addr_0  <=  {2'd0,roi_bram_0_wraddr};
                end
                else begin
                    max_addr_0  <=  max_addr_0;
                end
            end
            else if (op_findmax_s1) begin
                if (max_corr_0 > max_corr_1) begin
                    max_addr_0  <=  max_addr_0 + 14'h0000;
                end
                else begin
                    max_addr_0  <=  max_addr_1 + 14'h1000;
                end
            end
            else if (op_findmax_s2) begin
                if (max_corr_0 > max_corr_2) begin
                    max_addr_0  <=  max_addr_0;
                end
                else begin
                    max_addr_0  <=  max_addr_2;
                end
            end
            else begin
                max_addr_0  <=  max_addr_0;
            end
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        max_addr_1  <=  14'd0;
    end
    else begin
        if (fft_4thR_start) begin
            max_addr_1  <=  14'd0;
        end
        else begin
            if (roi_bram_1_wren) begin
                if (crosscorr_1 > max_corr_1) begin
                    max_addr_1  <=  {2'd0,roi_bram_1_wraddr};
                end
                else begin
                    max_addr_1  <=  max_addr_1;
                end
            end
            else begin
                max_addr_1  <=  max_addr_1;
            end
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        max_addr_2  <=  14'd0;
    end
    else begin
        if (fft_4thR_start) begin
            max_addr_2  <=  14'd0;
        end
        else begin
            if (roi_bram_2_wren) begin
                if (crosscorr_2 > max_corr_2) begin
                    max_addr_2  <=  {2'd0,roi_bram_2_wraddr};
                end
                else begin
                    max_addr_2  <=  max_addr_2;
                end
            end
            else if (op_findmax_s1) begin
                if (max_corr_2 > max_corr_3) begin
                    max_addr_2  <=  max_addr_2 + 14'h2000;
                end
                else begin
                    max_addr_2  <=  max_addr_3 + 14'h3000;
                end
            end
            else begin
                max_addr_2  <=  max_addr_2;
            end
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        max_addr_3  <=  14'd0;
    end
    else begin
        if (fft_4thR_start) begin
            max_addr_3  <=  14'd0;
        end
        else begin
            if (roi_bram_3_wren) begin
                if (crosscorr_3 > max_corr_3) begin
                    max_addr_3  <=  {2'd0,roi_bram_3_wraddr};
                end
                else begin
                    max_addr_3  <=  max_addr_3;
                end
            end
            else begin
                max_addr_3  <=  max_addr_3;
            end
        end
    end
end

endmodule
