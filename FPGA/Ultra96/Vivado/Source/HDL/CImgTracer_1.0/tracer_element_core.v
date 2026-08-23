`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2019 09:25:44 AM
// Design Name: 
// Module Name: trace_element_core
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


module tracer_element_core(
    input                     s_axi_aclk,
    input                     s_axi_aresetn,

    input                     load_center,

    input                     contour_rden,
    input                     load_contour,
    input                     contour_data,
    output reg                ns_contour_data,

    input                     store_trace,
    input        [15:0]       ps_acc_trace,
    output reg   [15:0]       acc_trace,

    input                     enh_ds_ena,
    input        [7:0]        enh_ds_row,
    input        [8:0]        enh_ds_col,
    input        [7:0]        enh_ds_data,

    output reg                ns_enh_ds_ena,
    output reg   [7:0]        ns_enh_ds_row,
    output reg   [8:0]        ns_enh_ds_col,
    output reg   [7:0]        ns_enh_ds_data,

    input                     flash_ena,
    input        [7:0]        flash_row,
    input        [8:0]        flash_col,
    input                     flash_state,
    input        [15:0]       flash_data,
    
    output reg                ns_flash_ena,
    output reg   [7:0]        ns_flash_row,
    output reg   [8:0]        ns_flash_col,
    output reg                ns_flash_state,
    output reg   [15:0]       ns_flash_data,

    output                    contour_buf_rden,
    output       [9:0]        contour_buf_rdaddr,
    input        [7:0]        contour_buf_rddata,
    output                    contour_buf_wren,
    output reg   [9:0]        contour_buf_wraddr,
    output reg   [7:0]        contour_buf_wrdata
);

reg   [9:0]    contour_rdaddr;

reg   [9:0]    c1_contour_buf_rdaddr;
reg   [9:0]    c2_contour_buf_rdaddr;
reg   [9:0]    c3_contour_buf_rdaddr;
reg   [9:0]    c4_contour_buf_rdaddr;
reg   [9:0]    c5_contour_buf_rdaddr;
reg   [9:0]    c6_contour_buf_rdaddr;
reg   [9:0]    c7_contour_buf_rdaddr;
reg   [9:0]    c8_contour_buf_rdaddr;

reg            load_center_reg;
wire           load_center_end  =  (~load_center) && load_center_reg;
reg   [2:0]    load_sel;

reg            store_trace_reg;
wire           store_trace_start  =  store_trace && (~store_trace_reg);
reg   [2:0]    store_sel;

reg   [7:0]    c1_center_row;
reg   [8:0]    c1_center_col;

reg   [7:0]    c2_center_row;
reg   [8:0]    c2_center_col;

reg   [7:0]    c3_center_row;
reg   [8:0]    c3_center_col;

reg   [7:0]    c4_center_row;
reg   [8:0]    c4_center_col;

reg   [7:0]    c5_center_row;
reg   [8:0]    c5_center_col;

reg   [7:0]    c6_center_row;
reg   [8:0]    c6_center_col;

reg   [7:0]    c7_center_row;
reg   [8:0]    c7_center_col;

reg   [7:0]    c8_center_row;
reg   [8:0]    c8_center_col;

wire  [7:0]    c1_flash_rdist = (flash_row > c1_center_row)? (flash_row - c1_center_row) : (c1_center_row - flash_row);
wire  [8:0]    c1_flash_cdist = (flash_col > c1_center_col)? (flash_col - c1_center_col) : (c1_center_col - flash_col);

wire  [7:0]    c2_flash_rdist = (flash_row > c2_center_row)? (flash_row - c2_center_row) : (c2_center_row - flash_row);
wire  [8:0]    c2_flash_cdist = (flash_col > c2_center_col)? (flash_col - c2_center_col) : (c2_center_col - flash_col);

wire  [7:0]    c3_flash_rdist = (flash_row > c3_center_row)? (flash_row - c3_center_row) : (c3_center_row - flash_row);
wire  [8:0]    c3_flash_cdist = (flash_col > c3_center_col)? (flash_col - c3_center_col) : (c3_center_col - flash_col);

wire  [7:0]    c4_flash_rdist = (flash_row > c4_center_row)? (flash_row - c4_center_row) : (c4_center_row - flash_row);
wire  [8:0]    c4_flash_cdist = (flash_col > c4_center_col)? (flash_col - c4_center_col) : (c4_center_col - flash_col);

wire  [7:0]    c5_flash_rdist = (flash_row > c5_center_row)? (flash_row - c5_center_row) : (c5_center_row - flash_row);
wire  [8:0]    c5_flash_cdist = (flash_col > c5_center_col)? (flash_col - c5_center_col) : (c5_center_col - flash_col);

wire  [7:0]    c6_flash_rdist = (flash_row > c6_center_row)? (flash_row - c6_center_row) : (c6_center_row - flash_row);
wire  [8:0]    c6_flash_cdist = (flash_col > c6_center_col)? (flash_col - c6_center_col) : (c6_center_col - flash_col);

wire  [7:0]    c7_flash_rdist = (flash_row > c7_center_row)? (flash_row - c7_center_row) : (c7_center_row - flash_row);
wire  [8:0]    c7_flash_cdist = (flash_col > c7_center_col)? (flash_col - c7_center_col) : (c7_center_col - flash_col);

wire  [7:0]    c8_flash_rdist = (flash_row > c8_center_row)? (flash_row - c8_center_row) : (c8_center_row - flash_row);
wire  [8:0]    c8_flash_cdist = (flash_col > c8_center_col)? (flash_col - c8_center_col) : (c8_center_col - flash_col);

wire  [7:0]    c1_enh_rdist = (ns_enh_ds_row > c1_center_row)? (ns_enh_ds_row - c1_center_row) : (c1_center_row - ns_enh_ds_row);
wire  [8:0]    c1_enh_cdist = (ns_enh_ds_col > c1_center_col)? (ns_enh_ds_col - c1_center_col) : (c1_center_col - ns_enh_ds_col);

wire  [7:0]    c2_enh_rdist = (ns_enh_ds_row > c2_center_row)? (ns_enh_ds_row - c2_center_row) : (c2_center_row - ns_enh_ds_row);
wire  [8:0]    c2_enh_cdist = (ns_enh_ds_col > c2_center_col)? (ns_enh_ds_col - c2_center_col) : (c2_center_row - ns_enh_ds_col);

wire  [7:0]    c3_enh_rdist = (ns_enh_ds_row > c3_center_row)? (ns_enh_ds_row - c3_center_row) : (c3_center_row - ns_enh_ds_row);
wire  [8:0]    c3_enh_cdist = (ns_enh_ds_col > c3_center_col)? (ns_enh_ds_col - c3_center_col) : (c3_center_row - ns_enh_ds_col);

wire  [7:0]    c4_enh_rdist = (ns_enh_ds_row > c4_center_row)? (ns_enh_ds_row - c4_center_row) : (c4_center_row - ns_enh_ds_row);
wire  [8:0]    c4_enh_cdist = (ns_enh_ds_col > c4_center_col)? (ns_enh_ds_col - c4_center_col) : (c4_center_row - ns_enh_ds_col);

wire  [7:0]    c5_enh_rdist = (ns_enh_ds_row > c5_center_row)? (ns_enh_ds_row - c5_center_row) : (c5_center_row - ns_enh_ds_row);
wire  [8:0]    c5_enh_cdist = (ns_enh_ds_col > c5_center_col)? (ns_enh_ds_col - c5_center_col) : (c5_center_row - ns_enh_ds_col);

wire  [7:0]    c6_enh_rdist = (ns_enh_ds_row > c6_center_row)? (ns_enh_ds_row - c6_center_row) : (c6_center_row - ns_enh_ds_row);
wire  [8:0]    c6_enh_cdist = (ns_enh_ds_col > c6_center_col)? (ns_enh_ds_col - c6_center_col) : (c6_center_row - ns_enh_ds_col);

wire  [7:0]    c7_enh_rdist = (ns_enh_ds_row > c7_center_row)? (ns_enh_ds_row - c7_center_row) : (c7_center_row - ns_enh_ds_row);
wire  [8:0]    c7_enh_cdist = (ns_enh_ds_col > c7_center_col)? (ns_enh_ds_col - c7_center_col) : (c7_center_row - ns_enh_ds_col);

wire  [7:0]    c8_enh_rdist = (ns_enh_ds_row > c8_center_row)? (ns_enh_ds_row - c8_center_row) : (c8_center_row - ns_enh_ds_row);
wire  [8:0]    c8_enh_cdist = (ns_enh_ds_col > c8_center_col)? (ns_enh_ds_col - c8_center_col) : (c8_center_row - ns_enh_ds_col);

wire           c1_acc_trace_ready     =  enh_ds_ena && (c1_enh_rdist <= 8'd12) && (c1_enh_cdist <= 9'd12);
wire           c2_acc_trace_ready     =  enh_ds_ena && (c2_enh_rdist <= 8'd12) && (c2_enh_cdist <= 9'd12);
wire           c3_acc_trace_ready     =  enh_ds_ena && (c3_enh_rdist <= 8'd12) && (c3_enh_cdist <= 9'd12);
wire           c4_acc_trace_ready     =  enh_ds_ena && (c4_enh_rdist <= 8'd12) && (c4_enh_cdist <= 9'd12);
wire           c5_acc_trace_ready     =  enh_ds_ena && (c5_enh_rdist <= 8'd12) && (c5_enh_cdist <= 9'd12);
wire           c6_acc_trace_ready     =  enh_ds_ena && (c6_enh_rdist <= 8'd12) && (c6_enh_cdist <= 9'd12);
wire           c7_acc_trace_ready     =  enh_ds_ena && (c7_enh_rdist <= 8'd12) && (c7_enh_cdist <= 9'd12);
wire           c8_acc_trace_ready     =  enh_ds_ena && (c8_enh_rdist <= 8'd12) && (c8_enh_cdist <= 9'd12);

reg            c1_acc_trace_enable;
reg            c2_acc_trace_enable;
reg            c3_acc_trace_enable;
reg            c4_acc_trace_enable;
reg            c5_acc_trace_enable;
reg            c6_acc_trace_enable;
reg            c7_acc_trace_enable;
reg            c8_acc_trace_enable;

wire           c1_contour_buf_rden  =  c1_acc_trace_enable;
wire           c2_contour_buf_rden  =  c2_acc_trace_enable;
wire           c3_contour_buf_rden  =  c3_acc_trace_enable;
wire           c4_contour_buf_rden  =  c4_acc_trace_enable;
wire           c5_contour_buf_rden  =  c5_acc_trace_enable;
wire           c6_contour_buf_rden  =  c6_acc_trace_enable;
wire           c7_contour_buf_rden  =  c7_acc_trace_enable;
wire           c8_contour_buf_rden  =  c8_acc_trace_enable;

wire           c_contour_buf_rden;
reg   [9:0]    c_contour_buf_rdaddr;

assign         contour_buf_rden    =  contour_rden | c_contour_buf_rden;
assign         contour_buf_rdaddr  =  contour_rden? contour_rdaddr : c_contour_buf_rden;

assign         contour_buf_wren    =  load_contour;

reg   [15:0]   c1_acc_trace;
reg   [15:0]   c2_acc_trace;
reg   [15:0]   c3_acc_trace;
reg   [15:0]   c4_acc_trace;
reg   [15:0]   c5_acc_trace;
reg   [15:0]   c6_acc_trace;
reg   [15:0]   c7_acc_trace;
reg   [15:0]   c8_acc_trace;

reg   [15:0]   c_acc_trace;

reg            contour_buf_rddata_reg;

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        load_center_reg  <=  1'b0;
    end
    else begin
        load_center_reg  <=  load_center;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        store_trace_reg  <=  1'b0;
    end
    else begin
        store_trace_reg  <=  store_trace;
    end
end

always @(*) begin
    case (load_sel)
        3'd0: begin
            contour_buf_rddata_reg  =  contour_buf_rddata[0];
        end
        3'd1: begin
            contour_buf_rddata_reg  =  contour_buf_rddata[1];
        end
        3'd2: begin
            contour_buf_rddata_reg  =  contour_buf_rddata[2];
        end
        3'd3: begin
            contour_buf_rddata_reg  =  contour_buf_rddata[3];
        end
        3'd4: begin
            contour_buf_rddata_reg  =  contour_buf_rddata[4];
        end
        3'd5: begin
            contour_buf_rddata_reg  =  contour_buf_rddata[5];
        end
        3'd6: begin
            contour_buf_rddata_reg  =  contour_buf_rddata[6];
        end
        3'd7: begin
            contour_buf_rddata_reg  =  contour_buf_rddata[7];
        end
        default: begin
            contour_buf_rddata_reg  =  contour_buf_rddata[0];
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        ns_contour_data  <=  3'd0;
    end
    else begin
        ns_contour_data  <=  contour_buf_rddata_reg;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c1_acc_trace_enable  <=  1'b0;
    end
    else begin
        c1_acc_trace_enable  <=  c1_acc_trace_ready;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c2_acc_trace_enable  <=  1'b0;
    end
    else begin
        c2_acc_trace_enable  <=  c2_acc_trace_ready;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c3_acc_trace_enable  <=  1'b0;
    end
    else begin
        c3_acc_trace_enable  <=  c3_acc_trace_ready;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c4_acc_trace_enable  <=  1'b0;
    end
    else begin
        c4_acc_trace_enable  <=  c4_acc_trace_ready;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c5_acc_trace_enable  <=  1'b0;
    end
    else begin
        c5_acc_trace_enable  <=  c5_acc_trace_ready;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c6_acc_trace_enable  <=  1'b0;
    end
    else begin
        c6_acc_trace_enable  <=  c6_acc_trace_ready;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c7_acc_trace_enable  <=  1'b0;
    end
    else begin
        c7_acc_trace_enable  <=  c7_acc_trace_ready;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c8_acc_trace_enable  <=  1'b0;
    end
    else begin
        c8_acc_trace_enable  <=  c8_acc_trace_ready;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        contour_rdaddr  <=  10'd0;
    end
    else begin
        if (contour_rden) begin
            contour_rdaddr  <=  (contour_rdaddr == 10'd624)? 10'd0 : (contour_rdaddr + 1'b1);
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c1_contour_buf_rdaddr  <=  10'd0;
    end
    else begin
        if (c1_contour_buf_rden) begin
            c1_contour_buf_rdaddr  <=  (c1_contour_buf_rdaddr == 10'd624)? 10'd0 : (c1_contour_buf_rdaddr + 1'b1);
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c2_contour_buf_rdaddr  <=  10'd0;
    end
    else begin
        if (c2_contour_buf_rden) begin
            c2_contour_buf_rdaddr  <=  (c2_contour_buf_rdaddr == 10'd624)? 10'd0 : (c2_contour_buf_rdaddr + 1'b1);
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c3_contour_buf_rdaddr  <=  10'd0;
    end
    else begin
        if (c3_contour_buf_rden) begin
            c3_contour_buf_rdaddr  <=  (c3_contour_buf_rdaddr == 10'd624)? 10'd0 : (c3_contour_buf_rdaddr + 1'b1);
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c4_contour_buf_rdaddr  <=  10'd0;
    end
    else begin
        if (c4_contour_buf_rden) begin
            c4_contour_buf_rdaddr  <=  (c4_contour_buf_rdaddr == 10'd624)? 10'd0 : (c4_contour_buf_rdaddr + 1'b1);
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c5_contour_buf_rdaddr  <=  10'd0;
    end
    else begin
        if (c5_contour_buf_rden) begin
            c5_contour_buf_rdaddr  <=  (c5_contour_buf_rdaddr == 10'd624)? 10'd0 : (c5_contour_buf_rdaddr + 1'b1);
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c6_contour_buf_rdaddr  <=  10'd0;
    end
    else begin
        if (c6_contour_buf_rden) begin
            c6_contour_buf_rdaddr  <=  (c6_contour_buf_rdaddr == 10'd624)? 10'd0 : (c6_contour_buf_rdaddr + 1'b1);
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c7_contour_buf_rdaddr  <=  10'd0;
    end
    else begin
        if (c7_contour_buf_rden) begin
            c7_contour_buf_rdaddr  <=  (c7_contour_buf_rdaddr == 10'd624)? 10'd0 : (c7_contour_buf_rdaddr + 1'b1);
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c8_contour_buf_rdaddr  <=  10'd0;
    end
    else begin
        if (c8_contour_buf_rden) begin
            c8_contour_buf_rdaddr  <=  (c8_contour_buf_rdaddr == 10'd624)? 10'd0 : (c8_contour_buf_rdaddr + 1'b1);
        end
    end
end

always @(*) begin
    case ({c8_contour_buf_rden,c7_contour_buf_rden,c6_contour_buf_rden,c5_contour_buf_rden,c4_contour_buf_rden,c3_contour_buf_rden,c2_contour_buf_rden,c1_contour_buf_rden})
        8'b00000001: begin
            c_contour_buf_rdaddr  =  c1_contour_buf_rdaddr;
        end
        8'b00000010: begin
            c_contour_buf_rdaddr  =  c2_contour_buf_rdaddr;
        end
        8'b00000100: begin
            c_contour_buf_rdaddr  =  c3_contour_buf_rdaddr;
        end
        8'b00001000: begin
            c_contour_buf_rdaddr  =  c4_contour_buf_rdaddr;
        end
        8'b00010000: begin
            c_contour_buf_rdaddr  =  c5_contour_buf_rdaddr;
        end
        8'b00100000: begin
            c_contour_buf_rdaddr  =  c6_contour_buf_rdaddr;
        end
        8'b01000000: begin
            c_contour_buf_rdaddr  =  c7_contour_buf_rdaddr;
        end
        8'b10000000: begin
            c_contour_buf_rdaddr  =  c8_contour_buf_rdaddr;
        end
        default: begin
            c_contour_buf_rdaddr  =  c1_contour_buf_rdaddr;
        end
    endcase
end

always @(*) begin
    case (load_sel)
        3'd0: begin
            contour_buf_wrdata  =  {7'd0, contour_data};
        end
        3'd1: begin
            contour_buf_wrdata  =  {6'd0, contour_data, 1'd0};
        end
        3'd2: begin
            contour_buf_wrdata  =  {5'd0, contour_data, 2'd0};
        end
        3'd3: begin
            contour_buf_wrdata  =  {4'd0, contour_data, 3'd0};
        end
        3'd4: begin
            contour_buf_wrdata  =  {3'd0, contour_data, 4'd0};
        end
        3'd5: begin
            contour_buf_wrdata  =  {2'd0, contour_data, 5'd0};
        end
        3'd6: begin
            contour_buf_wrdata  =  {1'd0, contour_data, 6'd0};
        end
        3'd7: begin
            contour_buf_wrdata  =  {contour_data, 7'd0};
        end
        default: begin
            contour_buf_wrdata  =  {7'd0, contour_data};
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        contour_buf_wraddr  <=  10'd0;
    end
    else begin
        if (contour_buf_wren) begin
            contour_buf_wraddr  <=  (contour_buf_wraddr == 10'd624)? 10'd0 : (contour_buf_wraddr + 1'b1);
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c1_acc_trace  <=  16'd0;
    end
    else begin
        if (c1_acc_trace_enable) begin
            c1_acc_trace  <=  contour_buf_rddata[0]? (c1_acc_trace + ns_enh_ds_data) : c1_acc_trace;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c2_acc_trace  <=  16'd0;
    end
    else begin
        if (c2_acc_trace_enable) begin
            c2_acc_trace  <=  contour_buf_rddata[1]? (c2_acc_trace + ns_enh_ds_data) : c2_acc_trace;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c3_acc_trace  <=  16'd0;
    end
    else begin
        if (c3_acc_trace_enable) begin
            c3_acc_trace  <=  contour_buf_rddata[2]? (c3_acc_trace + ns_enh_ds_data) : c3_acc_trace;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c4_acc_trace  <=  16'd0;
    end
    else begin
        if (c4_acc_trace_enable) begin
            c4_acc_trace  <=  contour_buf_rddata[3]? (c4_acc_trace + ns_enh_ds_data) : c4_acc_trace;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c5_acc_trace  <=  16'd0;
    end
    else begin
        if (c5_acc_trace_enable) begin
            c5_acc_trace  <=  contour_buf_rddata[4]? (c5_acc_trace + ns_enh_ds_data) : c5_acc_trace;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c6_acc_trace  <=  16'd0;
    end
    else begin
        if (c6_acc_trace_enable) begin
            c6_acc_trace  <=  contour_buf_rddata[5]? (c6_acc_trace + ns_enh_ds_data) : c6_acc_trace;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c7_acc_trace  <=  16'd0;
    end
    else begin
        if (c7_acc_trace_enable) begin
            c7_acc_trace  <=  contour_buf_rddata[6]? (c7_acc_trace + ns_enh_ds_data) : c7_acc_trace;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c8_acc_trace  <=  16'd0;
    end
    else begin
        if (c8_acc_trace_enable) begin
            c8_acc_trace  <=  contour_buf_rddata[7]? (c8_acc_trace + ns_enh_ds_data) : c8_acc_trace;
        end
    end
end

always @(*) begin
    case (store_sel)
        3'd0: begin
            c_acc_trace  =  c1_acc_trace;
        end
        3'd1: begin
            c_acc_trace  =  c2_acc_trace;
        end
        3'd2: begin
            c_acc_trace  =  c3_acc_trace;
        end
        3'd3: begin
            c_acc_trace  =  c4_acc_trace;
        end
        3'd4: begin
            c_acc_trace  =  c5_acc_trace;
        end
        3'd5: begin
            c_acc_trace  =  c6_acc_trace;
        end
        3'd6: begin
            c_acc_trace  =  c7_acc_trace;
        end
        3'd7: begin
            c_acc_trace  =  c8_acc_trace;
        end
        default: begin
            c_acc_trace  =  c1_acc_trace;
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        acc_trace  <=  16'd0;
    end
    else begin
        if (store_trace_start) begin
            acc_trace  <=  c_acc_trace;
        end
        else if (store_trace_reg) begin
            acc_trace  <=  ps_acc_trace;
        end
    end
end        

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        load_sel  <=  3'b0;
    end
    else begin
        if (load_center_end) begin
            load_sel  <=  (load_sel == 3'd7)? 3'd0 : (load_sel + 1'b1);
        end
        else begin
            load_sel  <=   load_sel;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        store_sel  <=  3'd0;
    end
    else begin
        if (store_trace_start) begin
            store_sel  <=  (store_sel == 3'd7)? 3'd0 : (store_sel + 1'b1);
        end
        else begin
            store_sel  <=  store_sel;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c1_center_row  <=  8'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd0)) begin
            c1_center_row  <=  ns_enh_ds_row;
        end
        else begin
            c1_center_row  <=  c1_center_row;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c1_center_col  <=  9'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd0)) begin
            c1_center_col  <=  ns_enh_ds_col;
        end
        else begin
            c1_center_col  <=  c1_center_col;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c2_center_row  <=  8'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd1)) begin
            c2_center_row  <=  ns_enh_ds_row;
        end
        else begin
            c2_center_row  <=  c2_center_row;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c2_center_col  <=  9'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd1)) begin
            c2_center_col  <=  ns_enh_ds_col;
        end
        else begin
            c2_center_col  <=  c2_center_col;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c3_center_row  <=  8'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd2)) begin
            c3_center_row  <=  ns_enh_ds_row;
        end
        else begin
            c3_center_row  <=  c3_center_row;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c3_center_col  <=  9'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd2)) begin
            c3_center_col  <=  ns_enh_ds_col;
        end
        else begin
            c3_center_col  <=  c3_center_col;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c4_center_row  <=  8'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd3)) begin
            c4_center_row  <=  ns_enh_ds_row;
        end
        else begin
            c4_center_row  <=  c4_center_row;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c4_center_col  <=  9'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd3)) begin
            c4_center_col  <=  ns_enh_ds_col;
        end
        else begin
            c4_center_col  <=  c4_center_col;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c5_center_row  <=  8'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd4)) begin
            c5_center_row  <=  ns_enh_ds_row;
        end
        else begin
            c5_center_row  <=  c5_center_row;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c5_center_col  <=  9'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd4)) begin
            c5_center_col  <=  ns_enh_ds_col;
        end
        else begin
            c5_center_col  <=  c5_center_col;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c6_center_row  <=  8'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd5)) begin
            c6_center_row  <=  ns_enh_ds_row;
        end
        else begin
            c6_center_row  <=  c6_center_row;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c6_center_col  <=  9'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd5)) begin
            c6_center_col  <=  ns_enh_ds_col;
        end
        else begin
            c6_center_col  <=  c6_center_col;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c7_center_row  <=  8'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd6)) begin
            c7_center_row  <=  ns_enh_ds_row;
        end
        else begin
            c7_center_row  <=  c7_center_row;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c6_center_col  <=  9'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd6)) begin
            c7_center_col  <=  ns_enh_ds_col;
        end
        else begin
            c7_center_col  <=  c7_center_col;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c8_center_row  <=  8'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd7)) begin
            c8_center_row  <=  ns_enh_ds_row;
        end
        else begin
            c8_center_row  <=  c8_center_row;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        c8_center_col  <=  9'd0;
    end
    else begin
        if (load_center_end && (load_sel == 3'd7)) begin
            c8_center_col  <=  ns_enh_ds_col;
        end
        else begin
            c8_center_col  <=  c8_center_col;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        ns_enh_ds_ena  <=  1'b0;
    end
    else begin
        ns_enh_ds_ena  <=  enh_ds_ena;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        ns_enh_ds_row  <=  8'd0;
    end
    else begin
        ns_enh_ds_row  <=  enh_ds_row;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        ns_enh_ds_col  <=  9'd0;
    end
    else begin
        ns_enh_ds_col  <=  enh_ds_col;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        ns_enh_ds_data  <=  8'd0;
    end
    else begin
        ns_enh_ds_data  <=  enh_ds_data;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        ns_flash_ena  <=  1'b0;
    end
    else begin
        ns_flash_ena  <=  flash_ena;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        ns_flash_row  <=  8'd0;
    end
    else begin
        ns_flash_row  <=  flash_row;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        ns_flash_col  <=  9'd0;
    end
    else begin
        ns_flash_col  <=  flash_col;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        ns_flash_state  <=  1'b0;
    end
    else begin
        if (c1_flash_rdist + c1_flash_cdist < 10'd10) begin
            ns_flash_state  <=  1'b0;
        end
        if (c2_flash_rdist + c2_flash_cdist < 10'd10) begin
            ns_flash_state  <=  1'b0;
        end
        if (c3_flash_rdist + c3_flash_cdist < 10'd10) begin
            ns_flash_state  <=  1'b0;
        end
        if (c4_flash_rdist + c4_flash_cdist < 10'd10) begin
            ns_flash_state  <=  1'b0;
        end
        if (c5_flash_rdist + c5_flash_cdist < 10'd10) begin
            ns_flash_state  <=  1'b0;
        end
        if (c6_flash_rdist + c6_flash_cdist < 10'd10) begin
            ns_flash_state  <=  1'b0;
        end
        if (c7_flash_rdist + c7_flash_cdist < 10'd10) begin
            ns_flash_state  <=  1'b0;
        end
        if (c8_flash_rdist + c8_flash_cdist < 10'd10) begin
            ns_flash_state  <=  1'b0;
        end
        else begin
            ns_flash_state  <=  flash_state;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        ns_flash_data  <=  16'd0;
    end
    else begin
        ns_flash_data  <=  flash_data;
    end
end

endmodule
