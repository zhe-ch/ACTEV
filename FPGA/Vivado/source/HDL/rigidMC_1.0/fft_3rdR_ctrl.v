`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 11:13:17 AM
// Design Name: 
// Module Name: fft_3rdR_ctrl
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


module fft_3rdR_ctrl(
    input               s_axi_aclk,
    input               s_axi_aresetn,
    
    input               fft_3rdR_start,
    output              fft_4thR_config,
    
    input               fft_0_data_ready,
    output              fft_0_data_valid,
    output              fft_0_data_last,
    output reg  [63:0]  fft_0_data_data,
    
    output              fft_0_result_ready,
    input               fft_0_result_valid,
    input               fft_0_result_last,
    input       [63:0]  fft_0_result_data,
    
    input               fft_1_data_ready,
    output              fft_1_data_valid,
    output              fft_1_data_last,
    output reg  [63:0]  fft_1_data_data,
    
    output              fft_1_result_ready,
    input               fft_1_result_valid,
    input               fft_1_result_last,
    input       [63:0]  fft_1_result_data,
    
    input               fft_2_data_ready,
    output              fft_2_data_valid,
    output              fft_2_data_last,
    output reg  [63:0]  fft_2_data_data,

    output              fft_2_result_ready,
    input               fft_2_result_valid,
    input               fft_2_result_last,
    input       [63:0]  fft_2_result_data,
    
    input               fft_3_data_ready,
    output              fft_3_data_valid,
    output              fft_3_data_last,
    output reg  [63:0]  fft_3_data_data,

    output              fft_3_result_ready,
    input               fft_3_result_valid,
    input               fft_3_result_last,
    input       [63:0]  fft_3_result_data,
    
    output              roi_bram_0_wren,
    output      [11:0]  roi_bram_0_wraddr,
    output      [63:0]  roi_bram_0_wrdata,
    output              roi_bram_0_rden,
    output      [11:0]  roi_bram_0_rdaddr,
    input       [31:0]  roi_bram_0_rddata,

    output              roi_bram_1_wren,
    output      [11:0]  roi_bram_1_wraddr,
    output      [63:0]  roi_bram_1_wrdata,
    output              roi_bram_1_rden,
    output      [11:0]  roi_bram_1_rdaddr,
    input       [31:0]  roi_bram_1_rddata,

    output              roi_bram_2_wren,
    output      [11:0]  roi_bram_2_wraddr,
    output      [63:0]  roi_bram_2_wrdata,
    output              roi_bram_2_rden,
    output      [11:0]  roi_bram_2_rdaddr,
    input       [31:0]  roi_bram_2_rddata,

    output              roi_bram_3_wren,
    output      [11:0]  roi_bram_3_wraddr,
    output      [63:0]  roi_bram_3_wrdata,
    output              roi_bram_3_rden,
    output      [11:0]  roi_bram_3_rdaddr,
    input       [31:0]  roi_bram_3_rddata,
    
    output              tml_bram_0_rden,
    output      [11:0]  tml_bram_0_rdaddr,
    input       [31:0]  tml_bram_0_rddata,
    
    output              tml_bram_1_rden,
    output      [11:0]  tml_bram_1_rdaddr,
    input       [31:0]  tml_bram_1_rddata,
    
    output              tml_bram_2_rden,
    output      [11:0]  tml_bram_2_rdaddr,
    input       [31:0]  tml_bram_2_rddata,
    
    output              tml_bram_3_rden,
    output      [11:0]  tml_bram_3_rdaddr,
    input       [31:0]  tml_bram_3_rddata
);

reg          cnt_fft_ena;
reg  [7:0]   cnt_fft_pix;
reg  [7:0]   cnt_fft_row;

reg          roi_bram_rden;
reg  [11:0]  roi_bram_rdaddr;
wire         roi_bram_wren;
reg  [11:0]  roi_bram_wraddr;

wire         fft_3rdR_end  =  (cnt_fft_row == 8'd31) && (cnt_fft_pix == 8'd129);

assign       fft_4thR_config  =  roi_bram_wren && (roi_bram_wraddr == 12'd4095);

wire         fft_start  =  (cnt_fft_pix == 8'd1);

reg          op_load;
reg          op_multiply;
reg          op_acc_shift;
reg          fft_data_valid;

reg  [31:0]  roi_0_data;
reg  [31:0]  roi_1_data;
reg  [31:0]  roi_2_data;
reg  [31:0]  roi_3_data;

reg  [31:0]  tml_0_data;
reg  [31:0]  tml_1_data;
reg  [31:0]  tml_2_data;
reg  [31:0]  tml_3_data;

reg  [31:0]  prod_0_roir_tmlr;
reg  [31:0]  prod_0_roii_tmli;
reg  [31:0]  prod_0_roir_tmli;
reg  [31:0]  prod_0_roii_tmlr;

reg  [31:0]  prod_1_roir_tmlr;
reg  [31:0]  prod_1_roii_tmli;
reg  [31:0]  prod_1_roir_tmli;
reg  [31:0]  prod_1_roii_tmlr;

reg  [31:0]  prod_2_roir_tmlr;
reg  [31:0]  prod_2_roii_tmli;
reg  [31:0]  prod_2_roir_tmli;
reg  [31:0]  prod_2_roii_tmlr;

reg  [31:0]  prod_3_roir_tmlr;
reg  [31:0]  prod_3_roii_tmli;
reg  [31:0]  prod_3_roir_tmli;
reg  [31:0]  prod_3_roii_tmlr;

wire [31:0]  acc_fft_0_r  =  $signed(prod_0_roir_tmlr) + $signed(prod_0_roii_tmli);
wire [31:0]  acc_fft_0_i  =  $signed(prod_0_roir_tmli) - $signed(prod_0_roii_tmlr);
wire [31:0]  acc_fft_1_r  =  $signed(prod_1_roir_tmlr) + $signed(prod_1_roii_tmli);
wire [31:0]  acc_fft_1_i  =  $signed(prod_1_roir_tmli) - $signed(prod_1_roii_tmlr);
wire [31:0]  acc_fft_2_r  =  $signed(prod_2_roir_tmlr) + $signed(prod_2_roii_tmli);
wire [31:0]  acc_fft_2_i  =  $signed(prod_2_roir_tmli) - $signed(prod_2_roii_tmlr);
wire [31:0]  acc_fft_3_r  =  $signed(prod_3_roir_tmlr) + $signed(prod_3_roii_tmli);
wire [31:0]  acc_fft_3_i  =  $signed(prod_3_roir_tmli) - $signed(prod_3_roii_tmlr);

wire [63:0]  fft_0_data_data_int  =  {acc_fft_0_i, acc_fft_0_r};
wire [63:0]  fft_1_data_data_int  =  {acc_fft_1_i, acc_fft_1_r};
wire [63:0]  fft_2_data_data_int  =  {acc_fft_2_i, acc_fft_2_r};
wire [63:0]  fft_3_data_data_int  =  {acc_fft_3_i, acc_fft_3_r};

assign       roi_bram_0_rden    =  roi_bram_rden;
assign       roi_bram_1_rden    =  roi_bram_rden;
assign       roi_bram_2_rden    =  roi_bram_rden;
assign       roi_bram_3_rden    =  roi_bram_rden;

assign       roi_bram_0_rdaddr  =  roi_bram_rdaddr;
assign       roi_bram_1_rdaddr  =  roi_bram_rdaddr;
assign       roi_bram_2_rdaddr  =  roi_bram_rdaddr;
assign       roi_bram_3_rdaddr  =  roi_bram_rdaddr;

wire         tml_bram_rden      =  roi_bram_rden;
reg  [11:0]  tml_bram_rdaddr; 

assign       tml_bram_0_rden    =  tml_bram_rden;
assign       tml_bram_1_rden    =  tml_bram_rden;
assign       tml_bram_2_rden    =  tml_bram_rden;
assign       tml_bram_3_rden    =  tml_bram_rden;

assign       tml_bram_0_rdaddr  =  tml_bram_rdaddr;
assign       tml_bram_1_rdaddr  =  tml_bram_rdaddr;
assign       tml_bram_2_rdaddr  =  tml_bram_rdaddr;
assign       tml_bram_3_rdaddr  =  tml_bram_rdaddr;

assign       fft_0_data_valid   =  fft_data_valid;
assign       fft_1_data_valid   =  fft_data_valid;
assign       fft_2_data_valid   =  fft_data_valid;
assign       fft_3_data_valid   =  fft_data_valid;

assign       fft_0_data_last    =  fft_data_valid && (~op_acc_shift);
assign       fft_1_data_last    =  fft_data_valid && (~op_acc_shift);
assign       fft_2_data_last    =  fft_data_valid && (~op_acc_shift);
assign       fft_3_data_last    =  fft_data_valid && (~op_acc_shift);

assign       fft_0_result_ready  =  1'b1;
assign       fft_1_result_ready  =  1'b1;
assign       fft_2_result_ready  =  1'b1;
assign       fft_3_result_ready  =  1'b1;

assign       roi_bram_wren      =  fft_0_result_ready && fft_0_result_valid;

assign       roi_bram_0_wren    =  roi_bram_wren;
assign       roi_bram_1_wren    =  roi_bram_wren;
assign       roi_bram_2_wren    =  roi_bram_wren;
assign       roi_bram_3_wren    =  roi_bram_wren;

assign       roi_bram_0_wraddr  =  roi_bram_wraddr;
assign       roi_bram_1_wraddr  =  roi_bram_wraddr;
assign       roi_bram_2_wraddr  =  roi_bram_wraddr;
assign       roi_bram_3_wraddr  =  roi_bram_wraddr;

assign       roi_bram_0_wrdata  =  fft_0_result_data;
assign       roi_bram_1_wrdata  =  fft_1_result_data;
assign       roi_bram_2_wrdata  =  fft_2_result_data;
assign       roi_bram_3_wrdata  =  fft_3_result_data;

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_fft_ena  <=  1'b0;
    end
    else begin
        if (fft_3rdR_start) begin
            cnt_fft_ena  <=  1'b1;
        end
        else if (fft_3rdR_end) begin
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
        roi_bram_rden  <=  1'b0;
    end
    else begin
        if (fft_start) begin
            roi_bram_rden  <=  1'b1;
        end
        else if ((roi_bram_rdaddr & 14'h007F) == 14'h007F) begin
            roi_bram_rden  <=  1'b0;
        end
        else begin
            roi_bram_rden  <=  roi_bram_rden;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_rdaddr  <=  12'd0;
    end
    else begin
        if (roi_bram_rden) begin
            roi_bram_rdaddr  <=  roi_bram_rdaddr + 1'b1;
        end
        else begin
            roi_bram_rdaddr  <=  roi_bram_rdaddr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_bram_rdaddr  <=  12'd0;
    end
    else begin
        if (tml_bram_rden) begin
            tml_bram_rdaddr  <=  tml_bram_rdaddr + 1'b1;
        end
        else begin
            tml_bram_rdaddr  <=  tml_bram_rdaddr;
        end
    end
end 

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        op_load  <=  1'b0;
    end
    else begin
        op_load  <=  roi_bram_rden;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        op_multiply  <=  1'b0;
    end
    else begin
        op_multiply  <=  op_load;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        op_acc_shift  <=  1'b0;
    end
    else begin
        op_acc_shift  <=  op_multiply;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_data_valid  <=  1'b0;
    end
    else begin
        fft_data_valid  <=  op_acc_shift;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_0_data  <=  32'd0;
    end
    else begin
        if (op_load) begin
            roi_0_data  <=  roi_bram_0_rddata;
        end
        else begin
            roi_0_data  <=  roi_0_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_1_data  <=  32'd0;
    end
    else begin
        if (op_load) begin
            roi_1_data  <=  roi_bram_1_rddata;
        end
        else begin
            roi_1_data  <=  roi_1_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_2_data  <=  32'd0;
    end
    else begin
        if (op_load) begin
            roi_2_data  <=  roi_bram_2_rddata;
        end
        else begin
            roi_2_data  <=  roi_2_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_3_data  <=  32'd0;
    end
    else begin
        if (op_load) begin
            roi_3_data  <=  roi_bram_3_rddata;
        end
        else begin
            roi_3_data  <=  roi_3_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_0_data  <=  32'd0;
    end
    else begin
        if (op_load) begin
            tml_0_data  <=  tml_bram_0_rddata;
        end
        else begin
            tml_0_data  <=  tml_0_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_1_data  <=  32'd0;
    end
    else begin
        if (op_load) begin
            tml_1_data  <=  tml_bram_1_rddata;
        end
        else begin
            tml_1_data  <=  tml_1_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_2_data  <=  32'd0;
    end
    else begin
        if (op_load) begin
            tml_2_data  <=  tml_bram_2_rddata;
        end
        else begin
            tml_2_data  <=  tml_2_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tml_3_data  <=  32'd0;
    end
    else begin
        if (op_load) begin
            tml_3_data  <=  tml_bram_3_rddata;
        end
        else begin
            tml_3_data  <=  tml_3_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_0_roir_tmlr  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_0_roir_tmlr  <=  $signed(roi_0_data[15:0]) * $signed(tml_0_data[15:0]);
        end
        else begin
            prod_0_roir_tmlr  <=  prod_0_roir_tmlr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_1_roir_tmlr  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_1_roir_tmlr  <=  $signed(roi_1_data[15:0]) * $signed(tml_1_data[15:0]);
        end
        else begin
            prod_1_roir_tmlr  <=  prod_1_roir_tmlr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_2_roir_tmlr  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_2_roir_tmlr  <=  $signed(roi_2_data[15:0]) * $signed(tml_2_data[15:0]);
        end
        else begin
            prod_2_roir_tmlr  <=  prod_2_roir_tmlr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_3_roir_tmlr  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_3_roir_tmlr  <=  $signed(roi_3_data[15:0]) * $signed(tml_3_data[15:0]);
        end
        else begin
            prod_3_roir_tmlr  <=  prod_3_roir_tmlr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_0_roii_tmli  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_0_roii_tmli  <=  $signed(roi_0_data[31:16]) * $signed(tml_0_data[31:16]);
        end
        else begin
            prod_0_roii_tmli  <=  prod_0_roii_tmli;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_1_roii_tmli  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_1_roii_tmli  <=  $signed(roi_1_data[31:16]) * $signed(tml_1_data[31:16]);
        end
        else begin
            prod_1_roii_tmli  <=  prod_1_roii_tmli;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_2_roii_tmli  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_2_roii_tmli  <=  $signed(roi_2_data[31:16]) * $signed(tml_2_data[31:16]);
        end
        else begin
            prod_2_roii_tmli  <=  prod_2_roii_tmli;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_3_roii_tmli  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_3_roii_tmli  <=  $signed(roi_3_data[31:16]) * $signed(tml_3_data[31:16]);
        end
        else begin
            prod_3_roii_tmli  <=  prod_3_roii_tmli;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_0_roir_tmli  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_0_roir_tmli  <=  $signed(roi_0_data[15:0]) * $signed(tml_0_data[31:16]);
        end
        else begin
            prod_0_roir_tmli  <=  prod_0_roir_tmli;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_1_roir_tmli  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_1_roir_tmli  <=  $signed(roi_1_data[15:0]) * $signed(tml_1_data[31:16]);
        end
        else begin
            prod_1_roir_tmli  <=  prod_1_roir_tmli;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_2_roir_tmli  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_2_roir_tmli  <=  $signed(roi_2_data[15:0]) * $signed(tml_2_data[31:16]);
        end
        else begin
            prod_2_roir_tmli  <=  prod_2_roir_tmli;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_3_roir_tmli  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_3_roir_tmli  <=  $signed(roi_3_data[15:0]) * $signed(tml_3_data[31:16]);
        end
        else begin
            prod_3_roir_tmli  <=  prod_3_roir_tmli;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_0_roii_tmlr  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_0_roii_tmlr  <=  $signed(roi_0_data[31:16]) * $signed(tml_0_data[15:0]);
        end
        else begin
            prod_0_roii_tmlr  <=  prod_0_roii_tmlr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_1_roii_tmlr  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_1_roii_tmlr  <=  $signed(roi_1_data[31:16]) * $signed(tml_1_data[15:0]);
        end
        else begin
            prod_1_roii_tmlr  <=  prod_1_roii_tmlr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_2_roii_tmlr  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_2_roii_tmlr  <=  $signed(roi_2_data[31:16]) * $signed(tml_2_data[15:0]);
        end
        else begin
            prod_2_roii_tmlr  <=  prod_2_roii_tmlr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        prod_3_roii_tmlr  <=  32'd0;
    end
    else begin
        if (op_multiply) begin
            prod_3_roii_tmlr  <=  $signed(roi_3_data[31:16]) * $signed(tml_3_data[15:0]);
        end
        else begin
            prod_3_roii_tmlr  <=  prod_3_roii_tmlr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_0_data_data  <=  64'd0;
    end
    else begin
        if (op_acc_shift) begin
            fft_0_data_data  <=  fft_0_data_data_int;
        end
        else begin
            fft_0_data_data  <=  fft_0_data_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_1_data_data  <=  64'd0;
    end
    else begin
        if (op_acc_shift) begin
            fft_1_data_data  <=  fft_1_data_data_int;
        end
        else begin
            fft_1_data_data  <=  fft_1_data_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_2_data_data  <=  64'd0;
    end
    else begin
        if (op_acc_shift) begin
            fft_2_data_data  <=  fft_2_data_data_int;
        end
        else begin
            fft_2_data_data  <=  fft_2_data_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_3_data_data  <=  64'd0;
    end
    else begin
        if (op_acc_shift) begin
            fft_3_data_data  <=  fft_3_data_data_int;
        end
        else begin
            fft_3_data_data  <=  fft_3_data_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_wraddr  <=  12'd0;
    end
    else begin
        if (roi_bram_wren) begin
            roi_bram_wraddr  <=  roi_bram_wraddr + 1'b1;
        end
        else begin
            roi_bram_wraddr  <=  roi_bram_wraddr;
        end
    end
end

endmodule
