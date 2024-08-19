`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2019 05:12:13 PM
// Design Name: 
// Module Name: tracer_element
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


module tracer_element(
    input                     s_axi_aclk,
    input                     s_axi_aresetn,

    input                     load_center,

    input                     contour_rden,
    input                     load_contour,
    input                     contour_data,
    output                    ns_contour_data,

    input                     store_trace,
    input        [15:0]       ps_acc_trace,
    output       [15:0]       acc_trace,

    input                     enh_ds_ena,
    input        [7:0]        enh_ds_row,
    input        [8:0]        enh_ds_col,
    input        [7:0]        enh_ds_data,
    
    output                    ns_enh_ds_ena,
    output       [7:0]        ns_enh_ds_row,
    output       [8:0]        ns_enh_ds_col,
    output       [7:0]        ns_enh_ds_data,
    
    input                     flash_ena,
    input        [7:0]        flash_row,
    input        [8:0]        flash_col,
    input                     flash_state,
    input        [15:0]       flash_data,
    
    output                    ns_flash_ena,
    output       [7:0]        ns_flash_row,
    output       [8:0]        ns_flash_col,
    output                    ns_flash_state,
    output       [15:0]       ns_flash_data
);

wire          contour_buf_rden;
wire  [9:0]   contour_buf_rdaddr;
wire  [7:0]   contour_buf_rddata;
wire          contour_buf_wren;
wire  [9:0]   contour_buf_wraddr;
wire  [7:0]   contour_buf_wrdata;

tracer_element_core U_tracer_element_core(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),

    .load_center(load_center),

    .contour_rden(contour_rden),
    .load_contour(load_contour),
    .contour_data(contour_data),
    .ns_contour_data(ns_contour_data),

    .store_trace(store_trace),    
    .ps_acc_trace(ps_acc_trace),
    .acc_trace(acc_trace),

    .enh_ds_ena(enh_ds_ena),
    .enh_ds_row(enh_ds_row),
    .enh_ds_col(enh_ds_col),
    .enh_ds_data(enh_ds_data),

    .ns_enh_ds_ena(ns_enh_ds_ena),
    .ns_enh_ds_row(ns_enh_ds_row),
    .ns_enh_ds_col(ns_enh_ds_col),
    .ns_enh_ds_data(ns_enh_ds_data),

    .flash_ena(flash_ena),
    .flash_row(flash_row),
    .flash_col(flash_col),
    .flash_state(flash_state),
    .flash_data(flash_data),
    
    .ns_flash_ena(ns_flash_ena),
    .ns_flash_row(ns_flash_row),
    .ns_flash_col(ns_flash_col),
    .ns_flash_state(ns_flash_state),
    .ns_flash_data(ns_flash_data),

    .contour_buf_rden(contour_buf_rden),
    .contour_buf_rdaddr(contour_buf_rdaddr),
    .contour_buf_rddata(contour_buf_rddata),
    .contour_buf_wren(contour_buf_wren),
    .contour_buf_wraddr(contour_buf_wraddr),
    .contour_buf_wrdata(contour_buf_wrdata)
);

blk_mem_contour_buf U_blk_mem_contour_buf(
    .clka(s_axi_aclk),
    .ena(1'b1),
    .wea(contour_buf_wren),
    .addra(contour_buf_wraddr),
    .dina(contour_buf_wrdata),
    .clkb(s_axi_aclk),
    .enb(contour_buf_rden),
    .addrb(contour_buf_rdaddr),
    .doutb(contour_buf_rddata)
);

endmodule
