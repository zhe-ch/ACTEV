`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 11:11:03 AM
// Design Name: 
// Module Name: fft_1stR_ctrl
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


module fft_1stR_ctrl(
    input                s_axi_aclk,
    input                s_axi_aresetn,

    output               fft_2ndR_config,
    
    input                fft_data_ready,
    output reg           fft_data_valid,
    output reg           fft_data_last,
    output       [63:0]  fft_data_data,
    
    output               fft_result_ready,
    input                fft_result_valid,
    input                fft_result_last,
    input        [63:0]  fft_result_data,
    
    input                filbuf_wren,
    input        [13:0]  filbuf_wraddr,
    input        [31:0]  filbuf_wrdata,
    
    output               roi_bram_0_wren,
    output       [11:0]  roi_bram_0_wraddr,
    output       [63:0]  roi_bram_0_wrdata,
    
    output               roi_bram_1_wren,
    output       [11:0]  roi_bram_1_wraddr,
    output       [63:0]  roi_bram_1_wrdata,
    
    output               roi_bram_2_wren,
    output       [11:0]  roi_bram_2_wraddr,
    output       [63:0]  roi_bram_2_wrdata,
    
    output               roi_bram_3_wren,
    output       [11:0]  roi_bram_3_wraddr,
    output       [63:0]  roi_bram_3_wrdata
);

assign       fft_result_ready   =  1'b1;

wire         roi_bram_wren      =  fft_result_ready && fft_result_valid;
reg  [13:0]  roi_bram_wraddr;
wire [63:0]  roi_bram_wrdata    =  fft_result_data;

assign       fft_2ndR_config    =  roi_bram_wren && (roi_bram_wraddr == 14'd16383);

assign       roi_bram_0_wren    =  (roi_bram_wren && (roi_bram_wraddr[13:12] == 2'd0));
assign       roi_bram_1_wren    =  (roi_bram_wren && (roi_bram_wraddr[13:12] == 2'd1));
assign       roi_bram_2_wren    =  (roi_bram_wren && (roi_bram_wraddr[13:12] == 2'd2));
assign       roi_bram_3_wren    =  (roi_bram_wren && (roi_bram_wraddr[13:12] == 2'd3));

assign       roi_bram_0_wraddr  =  roi_bram_wraddr[11:0];
assign       roi_bram_1_wraddr  =  roi_bram_wraddr[11:0];
assign       roi_bram_2_wraddr  =  roi_bram_wraddr[11:0];
assign       roi_bram_3_wraddr  =  roi_bram_wraddr[11:0];

assign       roi_bram_0_wrdata  =  roi_bram_wrdata;
assign       roi_bram_1_wrdata  =  roi_bram_wrdata;
assign       roi_bram_2_wrdata  =  roi_bram_wrdata;
assign       roi_bram_3_wrdata  =  roi_bram_wrdata;

reg  [31:0]  fft_data_data_reg;
assign       fft_data_data[31:0]   =  fft_data_data_reg;
assign       fft_data_data[63:32]  =  32'd0;

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_data_valid  <=  1'b0;
    end
    else begin
        if (filbuf_wren) begin
            fft_data_valid  <=  1'b1;
        end
        else begin
            fft_data_valid  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_data_last  <=  1'b0;
    end
    else begin
        if ((filbuf_wraddr & 14'h007F) == 14'h007F) begin
            fft_data_last  <=  1'b1;
        end
        else begin
            fft_data_last  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_data_data_reg  <=  32'd0;
    end
    else begin
        fft_data_data_reg  <=  filbuf_wrdata;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        roi_bram_wraddr  <=  14'd0;
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
