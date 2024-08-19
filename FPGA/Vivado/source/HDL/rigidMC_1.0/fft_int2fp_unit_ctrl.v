`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 04:21:02 PM
// Design Name: 
// Module Name: fft_int2fp_unit_ctrl
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


module fft_int2fp_unit_ctrl(
    input                 s_axi_aclk,
    input                 s_axi_aresetn,
    
    input       [31:0]    int_data,
    output reg  [31:0]    fp_data,
    
    output                ap_start_0,
    output                ap_start_1,
    output                ap_start_2,
    output                ap_start_3,
    
    output      [31:0]    input_r_0,
    output      [31:0]    input_r_1,
    output      [31:0]    input_r_2,
    output      [31:0]    input_r_3,
    
    input       [31:0]    output_r_0,
    input       [31:0]    output_r_1,
    input       [31:0]    output_r_2,
    input       [31:0]    output_r_3
);

reg   [1:0]   ch_sel;

assign        input_r_0  =  (ch_sel == 3'd0)? int_data : input_r_0;
assign        input_r_1  =  (ch_sel == 3'd1)? int_data : input_r_1;
assign        input_r_2  =  (ch_sel == 3'd2)? int_data : input_r_2;
assign        input_r_3  =  (ch_sel == 3'd3)? int_data : input_r_3;

assign        ap_start_0  =  (ch_sel == 3'd0);
assign        ap_start_1  =  (ch_sel == 3'd1);
assign        ap_start_2  =  (ch_sel == 3'd2);
assign        ap_start_3  =  (ch_sel == 3'd3);

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        ch_sel  <=  2'd0;
    end
    else begin
        ch_sel  <=  (ch_sel == 2'd3)? 2'd0 : (ch_sel + 1'b1);
    end
end

always @(*) begin
    case (ch_sel)
        3'd0: begin
            fp_data  =  output_r_0;
        end
        3'd1: begin
            fp_data  =  output_r_1;
        end
        3'd2: begin
            fp_data  =  output_r_2;
        end
        3'd3: begin
            fp_data  =  output_r_3;
        end
        default: begin
            fp_data  =  output_r_0;
        end
    endcase
end

endmodule
