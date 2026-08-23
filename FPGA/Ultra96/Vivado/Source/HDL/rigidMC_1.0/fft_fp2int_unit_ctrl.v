`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 11:44:12 AM
// Design Name: 
// Module Name: fft_fp2int_unit_ctrl
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


module fft_fp2int_unit_ctrl(
    input                 s_axi_aclk,
    input                 s_axi_aresetn,
    
    input       [31:0]    fp_data,
    output reg  [31:0]    int_data,
    
    output                ap_start_0,
    output                ap_start_1,
    output                ap_start_2,
    
    output      [31:0]    input_r_0,
    output      [31:0]    input_r_1,
    output      [31:0]    input_r_2,

    input       [31:0]    output_r_0,
    input       [31:0]    output_r_1,
    input       [31:0]    output_r_2
);

reg      [1:0]   ch_sel;
reg      [31:0]  sel_data;

assign           input_r_0  =  (ch_sel == 2'd0)? fp_data : input_r_0;
assign           input_r_1  =  (ch_sel == 2'd1)? fp_data : input_r_1;
assign           input_r_2  =  (ch_sel == 2'd2)? fp_data : input_r_2;

assign           ap_start_0  =  (ch_sel == 2'd0);
assign           ap_start_1  =  (ch_sel == 2'd1);
assign           ap_start_2  =  (ch_sel == 2'd2);

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        ch_sel  <=  1'b0;
    end
    else begin
        ch_sel  <=  (ch_sel == 2'd2)? 2'd0 : (ch_sel + 1'b1);
    end
end

always @(*) begin
    case (ch_sel)
        2'd0: begin
            sel_data  =  output_r_0;
        end
        2'd1: begin
            sel_data  =  output_r_1;
        end
        2'd2: begin
            sel_data  =  output_r_2;
        end
        default: begin
            sel_data  =  output_r_0;
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        int_data  <=  32'd0;
    end
    else begin
        int_data  <=  sel_data;
    end
end

endmodule
