`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 11:41:45 AM
// Design Name: 
// Module Name: fft_fp2int_unit
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


module fft_fp2int_unit(
    input             s_axi_aclk,
    input             s_axi_aresetn,
    
    input   [31:0]    fp_data,
    output  [31:0]    int_data
);

wire            ap_start_0;
wire            ap_start_1;
wire            ap_start_2;

wire   [31:0]   input_r_0;
wire   [31:0]   input_r_1;
wire   [31:0]   input_r_2;

wire   [31:0]   output_r_0;
wire   [31:0]   output_r_1;
wire   [31:0]   output_r_2;

fft_fp2int_unit_ctrl U_fft_fp2int_unit_ctrl(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .fp_data(fp_data),
    .int_data(int_data),
    
    .ap_start_0(ap_start_0),
    .ap_start_1(ap_start_1),
    .ap_start_2(ap_start_2),
    
    .input_r_0(input_r_0),
    .input_r_1(input_r_1),
    .input_r_2(input_r_2),
    
    .output_r_0(output_r_0),
    .output_r_1(output_r_1),
    .output_r_2(output_r_2)
);

fp2int_0 U_fp2int_0_0(
    .ap_clk(s_axi_aclk),
    .ap_rst(~s_axi_aresetn),
    .ap_start(ap_start_0),
    .ap_done(),
    .ap_idle(),
    .ap_ready(),
    .input_r(input_r_0),
    .output_r_ap_vld(),
    .output_r(output_r_0)
);

fp2int_0 U_fp2int_0_1(
    .ap_clk(s_axi_aclk),
    .ap_rst(~s_axi_aresetn),
    .ap_start(ap_start_1),
    .ap_done(),
    .ap_idle(),
    .ap_ready(),
    .input_r(input_r_1),
    .output_r_ap_vld(),
    .output_r(output_r_1)
);

fp2int_0 U_fp2int_0_2(
    .ap_clk(s_axi_aclk),
    .ap_rst(~s_axi_aresetn),
    .ap_start(ap_start_2),
    .ap_done(),
    .ap_idle(),
    .ap_ready(),
    .input_r(input_r_2),
    .output_r_ap_vld(),
    .output_r(output_r_2)
);

endmodule
