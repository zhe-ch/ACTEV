`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2019 11:27:23 AM
// Design Name: 
// Module Name: tracer_segment_ctrl
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


module tracer_segment_ctrl(
    input                     s_axi_aclk,
    input                     s_axi_aresetn,
    
    input                     load_center,
    input                     contour_rden,
    input                     load_contour,
    input                     store_trace,
    
    output                    seg_load_center,
    output                    seg_contour_rden,
    output                    seg_load_contour,
    output                    seg_store_trace
);

assign    seg_load_center   =  load_center;
assign    seg_contour_rden  =  contour_rden;
assign    seg_load_contour  =  load_contour;
assign    seg_store_trace   =  store_trace;

endmodule
