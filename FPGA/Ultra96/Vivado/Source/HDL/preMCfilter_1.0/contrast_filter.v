`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2019 09:03:11 AM
// Design Name: 
// Module Name: contrast_filter
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


module contrast_filter(
    input            s_axi_aclk,
    input            s_axi_aresetn,
    
    input            filter_begin,
    input            filbuf_wready,
    
    output           rowbuf_rden,
    output  [7:0]    rowbuf_rdaddr,
    input   [7:0]    rowbuf_rddata,
    
    output           filbuf_wren,
    output  [13:0]   filbuf_wraddr,
    output  [31:0]   filbuf_wrdata
);

wire          filter_ap_start;
wire          filter_ap_done;
wire          filter_ap_idle;
wire          filter_ap_ready;

wire  [31:0]  filter_result;

wire  [7:0]   rowbuf_rddata_ext = rowbuf_rddata;

wire  [7:0]   rowbuf_rddata_0;
wire  [7:0]   rowbuf_rddata_1;
wire  [7:0]   rowbuf_rddata_2;
wire  [7:0]   rowbuf_rddata_3;
wire  [7:0]   rowbuf_rddata_4;
wire  [7:0]   rowbuf_rddata_5;
wire  [7:0]   rowbuf_rddata_6;
wire  [7:0]   rowbuf_rddata_7;
wire  [7:0]   rowbuf_rddata_8;
wire  [7:0]   rowbuf_rddata_9;
wire  [7:0]   rowbuf_rddata_10;
wire  [7:0]   rowbuf_rddata_11;
wire  [7:0]   rowbuf_rddata_12;
wire  [7:0]   rowbuf_rddata_13;
wire  [7:0]   rowbuf_rddata_14;
wire  [7:0]   rowbuf_rddata_15;
wire  [7:0]   rowbuf_rddata_16;

wire          rowbuf_wren;
wire  [7:0]   rowbuf_wraddr;

wire  [7:0]   filter_d0;
wire  [7:0]   filter_d1;
wire  [7:0]   filter_d2;
wire  [7:0]   filter_d3;
wire  [7:0]   filter_d4;
wire  [7:0]   filter_d5;
wire  [7:0]   filter_d6;
wire  [7:0]   filter_d7;
wire  [7:0]   filter_d8;
wire  [7:0]   filter_d9;
wire  [7:0]   filter_d10;
wire  [7:0]   filter_d11;
wire  [7:0]   filter_d12;
wire  [7:0]   filter_d13;
wire  [7:0]   filter_d14;
wire  [7:0]   filter_d15;
wire  [7:0]   filter_d16;

contrast_filter_ctrl U_contrast_filter_ctrl(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .filter_begin(filter_begin),
    .filbuf_wready(filbuf_wready),
    
    .rowbuf_rden(rowbuf_rden),
    .rowbuf_rdaddr(rowbuf_rdaddr),
    
    .rowbuf_wren(rowbuf_wren),
    .rowbuf_wraddr(rowbuf_wraddr),
    
    .filter_ap_start(filter_ap_start),
    .filter_ap_done(filter_ap_done),
    .filter_ap_idle(filter_ap_idle),
    .filter_ap_ready(filter_ap_ready),

    .rowbuf_rddata_1(rowbuf_rddata_1),
    .rowbuf_rddata_2(rowbuf_rddata_2),
    .rowbuf_rddata_3(rowbuf_rddata_3),
    .rowbuf_rddata_4(rowbuf_rddata_4),
    .rowbuf_rddata_5(rowbuf_rddata_5),
    .rowbuf_rddata_6(rowbuf_rddata_6),
    .rowbuf_rddata_7(rowbuf_rddata_7),
    .rowbuf_rddata_8(rowbuf_rddata_8),
    .rowbuf_rddata_9(rowbuf_rddata_9),
    .rowbuf_rddata_10(rowbuf_rddata_10),
    .rowbuf_rddata_11(rowbuf_rddata_11),
    .rowbuf_rddata_12(rowbuf_rddata_12),
    .rowbuf_rddata_13(rowbuf_rddata_13),
    .rowbuf_rddata_14(rowbuf_rddata_14),
    .rowbuf_rddata_15(rowbuf_rddata_15),
    .rowbuf_rddata_16(rowbuf_rddata_16),
    .rowbuf_rddata_ext(rowbuf_rddata_ext),
    
    .filter_d0(filter_d0),
    .filter_d1(filter_d1),
    .filter_d2(filter_d2),
    .filter_d3(filter_d3),
    .filter_d4(filter_d4),
    .filter_d5(filter_d5),
    .filter_d6(filter_d6),
    .filter_d7(filter_d7),
    .filter_d8(filter_d8),
    .filter_d9(filter_d9),
    .filter_d10(filter_d10),
    .filter_d11(filter_d11),
    .filter_d12(filter_d12),
    .filter_d13(filter_d13),
    .filter_d14(filter_d14),
    .filter_d15(filter_d15),
    .filter_d16(filter_d16),

    .filter_result(filter_result),

    .filbuf_wren(filbuf_wren),
    .filbuf_wraddr(filbuf_wraddr),
    .filbuf_wrdata(filbuf_wrdata)
);

filter_accel_0 U_filter_accel_0(
    .ap_clk(s_axi_aclk),
    .ap_rst(~s_axi_aresetn),
    .ap_start(filter_ap_start),
    .ap_done(filter_ap_done),
    .ap_idle(filter_ap_idle),
    .ap_ready(filter_ap_ready),
    .in0(filter_d0),
    .in1(filter_d1),
    .in2(filter_d2),
    .in3(filter_d3),
    .in4(filter_d4),
    .in5(filter_d5),
    .in6(filter_d6),
    .in7(filter_d7),
    .in8(filter_d8),
    .in9(filter_d9),
    .in10(filter_d10),
    .in11(filter_d11),
    .in12(filter_d12),
    .in13(filter_d13),
    .in14(filter_d14),
    .in15(filter_d15),
    .in16(filter_d16),
    .out_r_ap_vld(),
    .out_r(filter_result)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_0(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d0),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_0)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_1(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d1),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_1)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_2(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d2),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_2)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_3(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d3),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_3)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_4(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d4),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_4)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_5(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d5),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_5)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_6(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d6),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_6)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_7(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d7),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_7)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_8(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d8),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_8)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_9(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d9),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_9)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_10(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d10),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_10)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_11(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d11),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_11)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_12(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d12),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_12)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_13(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d13),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_13)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_14(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d14),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_14)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_15(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d15),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_15)
);

blk_mem_roi_rowbuf U_blk_mem_roi_rowbuf_16(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(filter_d16),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_16)
);

endmodule
