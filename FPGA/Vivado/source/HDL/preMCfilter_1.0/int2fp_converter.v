`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2019 09:41:15 AM
// Design Name: 
// Module Name: int2fp_converter
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


module int2fp_converter(
    input               s_axi_aclk,
    input               s_axi_aresetn,
    
    input   [31:0]      int_data,
    output  [31:0]      fp_data
);

wire           ap_start_0;
wire           ap_start_1;
wire           ap_start_2;
wire           ap_start_3;

wire  [31:0]   input_r_0;
wire  [31:0]   input_r_1;
wire  [31:0]   input_r_2;
wire  [31:0]   input_r_3;

wire  [31:0]   output_r_0;
wire  [31:0]   output_r_1;
wire  [31:0]   output_r_2;
wire  [31:0]   output_r_3;

int2fp_converter_ctrl U_int2fp_converter_ctrl(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .int_data(int_data),
    .fp_data(fp_data),
    
    .ap_start_0(ap_start_0),
    .ap_start_1(ap_start_1),
    .ap_start_2(ap_start_2),
    .ap_start_3(ap_start_3),
    
    .input_r_0(input_r_0),
    .input_r_1(input_r_1),
    .input_r_2(input_r_2),
    .input_r_3(input_r_3),
    
    .output_r_0(output_r_0),
    .output_r_1(output_r_1),
    .output_r_2(output_r_2),
    .output_r_3(output_r_3)
);

int2fp_0 U_int2fp_0_0(
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

int2fp_0 U_int2fp_0_1(
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

int2fp_0 U_int2fp_0_2(
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

int2fp_0 U_int2fp_0_3(
    .ap_clk(s_axi_aclk),
    .ap_rst(~s_axi_aresetn),
    .ap_start(ap_start_3),
    .ap_done(),
    .ap_idle(),
    .ap_ready(),
    .input_r(input_r_3),
    .output_r_ap_vld(),
    .output_r(output_r_3)
);

endmodule