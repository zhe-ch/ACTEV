`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 11:37:45 AM
// Design Name: 
// Module Name: fft_fp2int_converter
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


module fft_fp2int_converter(
    input            s_axi_aclk,
    input            s_axi_aresetn,
    
    input   [63:0]   data_0,
    input   [63:0]   data_1,
    input   [63:0]   data_2,
    input   [63:0]   data_3,
    
    output  [63:0]   result_0,
    output  [63:0]   result_1,
    output  [63:0]   result_2,
    output  [63:0]   result_3
);

wire  [31:0]   result_0_r;
wire  [31:0]   result_0_i;
wire  [31:0]   result_1_r;
wire  [31:0]   result_1_i;
wire  [31:0]   result_2_r;
wire  [31:0]   result_2_i;
wire  [31:0]   result_3_r;
wire  [31:0]   result_3_i;

assign         result_0  =  {result_0_i, result_0_r};
assign         result_1  =  {result_1_i, result_1_r};
assign         result_2  =  {result_2_i, result_2_r};
assign         result_3  =  {result_3_i, result_3_r};

fft_fp2int_unit U_fft_fp2int_unit_0r(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .fp_data(data_0[31:0]),
    .int_data(result_0_r)
);

fft_fp2int_unit U_fft_fp2int_unit_0i(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .fp_data(data_0[63:32]),
    .int_data(result_0_i)
);

fft_fp2int_unit U_fft_fp2int_unit_1r(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .fp_data(data_1[31:0]),
    .int_data(result_1_r)
);

fft_fp2int_unit U_fft_fp2int_unit_1i(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .fp_data(data_1[63:32]),
    .int_data(result_1_i)
);

fft_fp2int_unit U_fft_fp2int_unit_2r(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .fp_data(data_2[31:0]),
    .int_data(result_2_r)
);

fft_fp2int_unit U_fft_fp2int_unit_2i(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .fp_data(data_2[63:32]),
    .int_data(result_2_i)
);

fft_fp2int_unit U_fft_fp2int_unit_3r(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .fp_data(data_3[31:0]),
    .int_data(result_3_r)
);

fft_fp2int_unit U_fft_fp2int_unit_3i(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .fp_data(data_3[63:32]),
    .int_data(result_3_i)
);

endmodule
