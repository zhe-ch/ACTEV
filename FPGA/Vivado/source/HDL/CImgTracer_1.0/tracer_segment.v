`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2019 05:51:00 PM
// Design Name: 
// Module Name: tracer_segment
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


module tracer_segment(
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

wire          seg_load_center;
wire          seg_contour_rden;
wire          seg_load_contour;
wire          seg_store_trace;

wire          t1_enh_ds_ena;
wire  [7:0]   t1_enh_ds_row;
wire  [8:0]   t1_enh_ds_col;
wire  [7:0]   t1_enh_ds_data;
    
wire          t2_enh_ds_ena;
wire  [7:0]   t2_enh_ds_row;
wire  [8:0]   t2_enh_ds_col;
wire  [7:0]   t2_enh_ds_data;

wire          t3_enh_ds_ena;
wire  [7:0]   t3_enh_ds_row;
wire  [8:0]   t3_enh_ds_col;
wire  [7:0]   t3_enh_ds_data;

wire          t4_enh_ds_ena;
wire  [7:0]   t4_enh_ds_row;
wire  [8:0]   t4_enh_ds_col;
wire  [7:0]   t4_enh_ds_data;
    
wire          t5_enh_ds_ena;
wire  [7:0]   t5_enh_ds_row;
wire  [8:0]   t5_enh_ds_col;
wire  [7:0]   t5_enh_ds_data;

wire          t6_enh_ds_ena;
wire  [7:0]   t6_enh_ds_row;
wire  [8:0]   t6_enh_ds_col;
wire  [7:0]   t6_enh_ds_data;

wire          t7_enh_ds_ena;
wire  [7:0]   t7_enh_ds_row;
wire  [8:0]   t7_enh_ds_col;
wire  [7:0]   t7_enh_ds_data;

wire          t1_contour_data;
wire          t2_contour_data;
wire          t3_contour_data;
wire          t4_contour_data;
wire          t5_contour_data;
wire          t6_contour_data;
wire          t7_contour_data;

wire  [15:0]  t1_acc_trace;
wire  [15:0]  t2_acc_trace;
wire  [15:0]  t3_acc_trace;
wire  [15:0]  t4_acc_trace;
wire  [15:0]  t5_acc_trace;
wire  [15:0]  t6_acc_trace;
wire  [15:0]  t7_acc_trace;

wire          t1_flash_ena;
wire  [7:0]   t1_flash_row;
wire  [8:0]   t1_flash_col;
wire          t1_flash_state;
wire  [15:0]  t1_flash_data;

wire          t2_flash_ena;
wire  [7:0]   t2_flash_row;
wire  [8:0]   t2_flash_col;
wire          t2_flash_state;
wire  [15:0]  t2_flash_data;

wire          t3_flash_ena;
wire  [7:0]   t3_flash_row;
wire  [8:0]   t3_flash_col;
wire          t3_flash_state;
wire  [15:0]  t3_flash_data;

wire          t4_flash_ena;
wire  [7:0]   t4_flash_row;
wire  [8:0]   t4_flash_col;
wire          t4_flash_state;
wire  [15:0]  t4_flash_data;

wire          t5_flash_ena;
wire  [7:0]   t5_flash_row;
wire  [8:0]   t5_flash_col;
wire          t5_flash_state;
wire  [15:0]  t5_flash_data;

wire          t6_flash_ena;
wire  [7:0]   t6_flash_row;
wire  [8:0]   t6_flash_col;
wire          t6_flash_state;
wire  [15:0]  t6_flash_data;

wire          t7_flash_ena;
wire  [7:0]   t7_flash_row;
wire  [8:0]   t7_flash_col;
wire          t7_flash_state;
wire  [15:0]  t7_flash_data;

tracer_segment_ctrl U_tracer_segment_ctrl(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .load_center(load_center),
    .contour_rden(contour_rden),
    .load_contour(load_contour),
    .store_trace(store_trace),

    .seg_load_center(seg_load_center),
    .seg_contour_rden(seg_contour_rden),
    .seg_load_contour(seg_load_contour),
    .seg_store_trace(seg_store_trace)
);

tracer_element U_tracer_element_1(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .load_center(seg_load_center),

    .contour_rden(seg_contour_rden),
    .load_contour(seg_load_contour),
    .contour_data(contour_data),
    .ns_contour_data(t1_contour_data),

    .store_trace(seg_store_trace),
    .ps_acc_trace(ps_acc_trace),
    .acc_trace(t1_acc_trace),

    .enh_ds_ena(enh_ds_ena),
    .enh_ds_row(enh_ds_row),
    .enh_ds_col(enh_ds_col),
    .enh_ds_data(enh_ds_data),

    .ns_enh_ds_ena(t1_enh_ds_ena),
    .ns_enh_ds_row(t1_enh_ds_row),
    .ns_enh_ds_col(t1_enh_ds_col),
    .ns_enh_ds_data(t1_enh_ds_data),
    
    .flash_ena(flash_ena),
    .flash_row(flash_row),
    .flash_col(flash_col),
    .flash_state(flash_state),
    .flash_data(flash_data),
    
    .ns_flash_ena(t1_flash_ena),
    .ns_flash_row(t1_flash_row),
    .ns_flash_col(t1_flash_col),
    .ns_flash_state(t1_flash_state),
    .ns_flash_data(t1_flash_data)
);

tracer_element U_tracer_element_2(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),

    .load_center(seg_load_center),

    .contour_rden(seg_contour_rden),
    .load_contour(seg_load_contour),
    .contour_data(t1_contour_data),
    .ns_contour_data(t2_contour_data),

    .store_trace(seg_store_trace),
    .ps_acc_trace(t1_acc_trace),
    .acc_trace(t2_acc_trace),

    .enh_ds_ena(t1_enh_ds_ena),
    .enh_ds_row(t1_enh_ds_row),
    .enh_ds_col(t1_enh_ds_col),
    .enh_ds_data(t1_enh_ds_data),
        
    .ns_enh_ds_ena(t2_enh_ds_ena),
    .ns_enh_ds_row(t2_enh_ds_row),
    .ns_enh_ds_col(t2_enh_ds_col),
    .ns_enh_ds_data(t2_enh_ds_data),
    
    .flash_ena(t1_flash_ena),
    .flash_row(t1_flash_row),
    .flash_col(t1_flash_col),
    .flash_state(t1_flash_state),
    .flash_data(t1_flash_data),
    
    .ns_flash_ena(t2_flash_ena),
    .ns_flash_row(t2_flash_row),
    .ns_flash_col(t2_flash_col),
    .ns_flash_state(t2_flash_state),
    .ns_flash_data(t2_flash_data)
);

tracer_element U_tracer_element_3(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),

    .load_center(seg_load_center),

    .contour_rden(seg_contour_rden),
    .load_contour(seg_load_contour),
    .contour_data(t2_contour_data),
    .ns_contour_data(t3_contour_data),

    .store_trace(seg_store_trace),
    .ps_acc_trace(t2_acc_trace),
    .acc_trace(t3_acc_trace),

    .enh_ds_ena(t2_enh_ds_ena),
    .enh_ds_row(t2_enh_ds_row),
    .enh_ds_col(t2_enh_ds_col),
    .enh_ds_data(t2_enh_ds_data),
        
    .ns_enh_ds_ena(t3_enh_ds_ena),
    .ns_enh_ds_row(t3_enh_ds_row),
    .ns_enh_ds_col(t3_enh_ds_col),
    .ns_enh_ds_data(t3_enh_ds_data),

    .flash_ena(t2_flash_ena),
    .flash_row(t2_flash_row),
    .flash_col(t2_flash_col),
    .flash_state(t2_flash_state),
    .flash_data(t2_flash_data),
    
    .ns_flash_ena(t3_flash_ena),
    .ns_flash_row(t3_flash_row),
    .ns_flash_col(t3_flash_col),
    .ns_flash_state(t3_flash_state),
    .ns_flash_data(t3_flash_data)
);

tracer_element U_tracer_element_4(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),

    .load_center(seg_load_center),

    .contour_rden(seg_contour_rden),
    .load_contour(seg_load_contour),
    .contour_data(t3_contour_data),
    .ns_contour_data(t4_contour_data),

    .store_trace(seg_store_trace),    
    .ps_acc_trace(t3_acc_trace),
    .acc_trace(t4_acc_trace),
    
    .enh_ds_ena(t3_enh_ds_ena),
    .enh_ds_row(t3_enh_ds_row),
    .enh_ds_col(t3_enh_ds_col),
    .enh_ds_data(t3_enh_ds_data),
        
    .ns_enh_ds_ena(t4_enh_ds_ena),
    .ns_enh_ds_row(t4_enh_ds_row),
    .ns_enh_ds_col(t4_enh_ds_col),
    .ns_enh_ds_data(t4_enh_ds_data),

    .flash_ena(t3_flash_ena),
    .flash_row(t3_flash_row),
    .flash_col(t3_flash_col),
    .flash_state(t3_flash_state),
    .flash_data(t3_flash_data),
    
    .ns_flash_ena(t4_flash_ena),
    .ns_flash_row(t4_flash_row),
    .ns_flash_col(t4_flash_col),
    .ns_flash_state(t4_flash_state),
    .ns_flash_data(t4_flash_data)
);

tracer_element U_tracer_element_5(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),

    .load_center(seg_load_center),

    .contour_rden(seg_contour_rden),
    .load_contour(seg_load_contour),
    .contour_data(t4_contour_data),
    .ns_contour_data(t5_contour_data),

    .store_trace(seg_store_trace),    
    .ps_acc_trace(t4_acc_trace),
    .acc_trace(t5_acc_trace),
    
    .enh_ds_ena(t4_enh_ds_ena),
    .enh_ds_row(t4_enh_ds_row),
    .enh_ds_col(t4_enh_ds_col),
    .enh_ds_data(t4_enh_ds_data),
        
    .ns_enh_ds_ena(t5_enh_ds_ena),
    .ns_enh_ds_row(t5_enh_ds_row),
    .ns_enh_ds_col(t5_enh_ds_col),
    .ns_enh_ds_data(t5_enh_ds_data),

    .flash_ena(t4_flash_ena),
    .flash_row(t4_flash_row),
    .flash_col(t4_flash_col),
    .flash_state(t4_flash_state),
    .flash_data(t4_flash_data),
    
    .ns_flash_ena(t5_flash_ena),
    .ns_flash_row(t5_flash_row),
    .ns_flash_col(t5_flash_col),
    .ns_flash_state(t5_flash_state),
    .ns_flash_data(t5_flash_data)
);

tracer_element U_tracer_element_6(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),

    .load_center(seg_load_center),

    .contour_rden(seg_contour_rden),
    .load_contour(seg_load_contour),
    .contour_data(t5_contour_data),
    .ns_contour_data(t6_contour_data),

    .store_trace(seg_store_trace),
    .ps_acc_trace(t5_acc_trace),
    .acc_trace(t6_acc_trace),
    
    .enh_ds_ena(t5_enh_ds_ena),
    .enh_ds_row(t5_enh_ds_row),
    .enh_ds_col(t5_enh_ds_col),
    .enh_ds_data(t5_enh_ds_data),
        
    .ns_enh_ds_ena(t6_enh_ds_ena),
    .ns_enh_ds_row(t6_enh_ds_row),
    .ns_enh_ds_col(t6_enh_ds_col),
    .ns_enh_ds_data(t6_enh_ds_data),

    .flash_ena(t5_flash_ena),
    .flash_row(t5_flash_row),
    .flash_col(t5_flash_col),
    .flash_state(t5_flash_state),
    .flash_data(t5_flash_data),
    
    .ns_flash_ena(t6_flash_ena),
    .ns_flash_row(t6_flash_row),
    .ns_flash_col(t6_flash_col),
    .ns_flash_state(t6_flash_state),
    .ns_flash_data(t6_flash_data)
);

tracer_element U_tracer_element_7(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),

    .load_center(seg_load_center),

    .contour_rden(seg_contour_rden),
    .load_contour(seg_load_contour),
    .contour_data(t6_contour_data),
    .ns_contour_data(t7_contour_data),

    .store_trace(seg_store_trace),
    .ps_acc_trace(t6_acc_trace),
    .acc_trace(t7_acc_trace),

    .enh_ds_ena(t6_enh_ds_ena),
    .enh_ds_row(t6_enh_ds_row),
    .enh_ds_col(t6_enh_ds_col),
    .enh_ds_data(t6_enh_ds_data),
        
    .ns_enh_ds_ena(t7_enh_ds_ena),
    .ns_enh_ds_row(t7_enh_ds_row),
    .ns_enh_ds_col(t7_enh_ds_col),
    .ns_enh_ds_data(t7_enh_ds_data),

    .flash_ena(t6_flash_ena),
    .flash_row(t6_flash_row),
    .flash_col(t6_flash_col),
    .flash_state(t6_flash_state),
    .flash_data(t6_flash_data),
    
    .ns_flash_ena(t7_flash_ena),
    .ns_flash_row(t7_flash_row),
    .ns_flash_col(t7_flash_col),
    .ns_flash_state(t7_flash_state),
    .ns_flash_data(t7_flash_data)
);

tracer_element U_tracer_element_8(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),

    .load_center(seg_load_center),

    .contour_rden(seg_contour_rden),
    .load_contour(seg_load_contour),
    .contour_data(t7_contour_data),
    .ns_contour_data(ns_contour_data),

    .store_trace(seg_store_trace),
    .ps_acc_trace(t7_acc_trace),
    .acc_trace(acc_trace),

    .enh_ds_ena(t7_enh_ds_ena),
    .enh_ds_row(t7_enh_ds_row),
    .enh_ds_col(t7_enh_ds_col),
    .enh_ds_data(t7_enh_ds_data),

    .ns_enh_ds_ena(ns_enh_ds_ena),
    .ns_enh_ds_row(ns_enh_ds_row),
    .ns_enh_ds_col(ns_enh_ds_col),
    .ns_enh_ds_data(ns_enh_ds_data),

    .flash_ena(t7_flash_ena),
    .flash_row(t7_flash_row),
    .flash_col(t7_flash_col),
    .flash_state(t7_flash_state),
    .flash_data(t7_flash_data),
    
    .ns_flash_ena(ns_flash_ena),
    .ns_flash_row(ns_flash_row),
    .ns_flash_col(ns_flash_col),
    .ns_flash_state(ns_flash_state),
    .ns_flash_data(ns_flash_data)
);

endmodule
