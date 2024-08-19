`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2019 12:18:02 PM
// Design Name: 
// Module Name: tracer_load_ctrl
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


module tracer_load_ctrl(
    input                   s_axi_aclk,
    input                   s_axi_aresetn,
    
    input                   load_start,
    input                   store_start,
    output                  store_end,
    
    input       [7:0]       enh_ds_last_row,
    input       [8:0]       enh_ds_last_col,
    
    output                  load_center,
    output      [7:0]       center_row,
    output      [8:0]       center_col,

    output                  contour_rden,
    output                  load_contour,
    output                  contour_data,
    
    output                  store_trace,
    input       [15:0]      acc_trace,
    
    output                  tracer_buf_en,
    output      [3:0]       tracer_buf_we,
    output      [31:0]      tracer_buf_addr,
    output      [31:0]      tracer_buf_din,
    input       [31:0]      tracer_buf_dout
);

wire          load_contour_start;

wire          load_center_en;
wire  [31:0]  load_center_addr;
wire  [31:0]  load_center_din;

wire          load_contour_en;
wire  [31:0]  load_contour_addr;
wire  [31:0]  load_contour_din;

wire          store_trace_en;
wire  [31:0]  store_trace_addr;
wire  [31:0]  store_trace_dout;

assign        tracer_buf_en     =  load_center_en | load_contour_en | store_trace_en;
assign        tracer_buf_we     =  load_center_en? 4'b0000 : (load_contour_en? 4'b0000 : 4'b1111);
assign        tracer_buf_addr   =  load_center_en? load_center_addr : (load_contour_en? load_contour_addr : store_trace_addr);
assign        tracer_buf_din    =  store_trace_dout;
assign        load_center_din   =  tracer_buf_dout;
assign        load_contour_din  =  tracer_buf_dout;

tracer_load_center_ctrl U_tracer_load_center_ctrl(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),

    .load_start(load_start),
    .load_contour_start(load_contour_start),

    .load_center(load_center),
    .center_row(center_row),
    .center_col(center_col),

    .tracer_buf_en(load_center_en),
    .tracer_buf_addr(load_center_addr),
    .tracer_buf_din(load_center_din)
);

tracer_load_contour_ctrl U_tracer_load_contour_ctrl(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .load_contour_start(load_contour_start),
    
    .contour_rden(contour_rden),
    .load_contour(load_contour),
    .contour_data(contour_data),
    
    .tracer_buf_en(load_contour_en),
    .tracer_buf_addr(load_contour_addr),
    .tracer_buf_din(load_contour_din)
);

tracer_store_trace_ctrl U_tracer_store_trace_ctrl(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .enh_ds_last_row(enh_ds_last_row),
    .enh_ds_last_col(enh_ds_last_col),
    
    .store_start(store_start),
    .store_end(store_end),
    
    .store_trace(store_trace),
    .acc_trace(acc_trace),
    
    .tracer_buf_en(store_trace_en),
    .tracer_buf_addr(store_trace_addr),
    .tracer_buf_dout(store_trace_dout)
);

endmodule
