`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2019 10:55:34 AM
// Design Name: 
// Module Name: dilation_kernel
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


module dilation_kernel(
    input               s_axi_aclk,
    input               s_axi_aresetn,
    
    input               sensor_state,
    
    input               erosion_valid,
    input   [7:0]       erosion_dout,
    
    output              dilation_valid,
    output  [7:0]       dilation_dout
);

wire          rowbuf_wren;
wire  [9:0]   rowbuf_wraddr;
wire  [7:0]   rowbuf_wrdata;

wire          rowbuf_rden;
wire  [9:0]   rowbuf_rdaddr;

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
wire  [7:0]   rowbuf_rddata_17;
wire  [7:0]   rowbuf_rddata_18;

wire  [7:0]   rowbuf_wrdata_0;
wire  [7:0]   rowbuf_wrdata_1;
wire  [7:0]   rowbuf_wrdata_2;
wire  [7:0]   rowbuf_wrdata_3;
wire  [7:0]   rowbuf_wrdata_4;
wire  [7:0]   rowbuf_wrdata_5;
wire  [7:0]   rowbuf_wrdata_6;
wire  [7:0]   rowbuf_wrdata_7;
wire  [7:0]   rowbuf_wrdata_8;
wire  [7:0]   rowbuf_wrdata_9;
wire  [7:0]   rowbuf_wrdata_10;
wire  [7:0]   rowbuf_wrdata_11;
wire  [7:0]   rowbuf_wrdata_12;
wire  [7:0]   rowbuf_wrdata_13;
wire  [7:0]   rowbuf_wrdata_14;
wire  [7:0]   rowbuf_wrdata_15;
wire  [7:0]   rowbuf_wrdata_16;
wire  [7:0]   rowbuf_wrdata_17;
wire  [7:0]   rowbuf_wrdata_18;

wire          dilation_ap_start;
wire          dilation_ap_done;
wire          dilation_ap_idle;
wire          dilation_ap_ready;

wire          dilation_init;

wire  [7:0]   dilation_d0   =  rowbuf_wrdata_0;
wire  [7:0]   dilation_d1   =  rowbuf_wrdata_1;
wire  [7:0]   dilation_d2   =  rowbuf_wrdata_2;
wire  [7:0]   dilation_d3   =  rowbuf_wrdata_3;
wire  [7:0]   dilation_d4   =  rowbuf_wrdata_4;
wire  [7:0]   dilation_d5   =  rowbuf_wrdata_5;
wire  [7:0]   dilation_d6   =  rowbuf_wrdata_6;
wire  [7:0]   dilation_d7   =  rowbuf_wrdata_7;
wire  [7:0]   dilation_d8   =  rowbuf_wrdata_8;
wire  [7:0]   dilation_d9   =  rowbuf_wrdata_9;
wire  [7:0]   dilation_d10  =  rowbuf_wrdata_10;
wire  [7:0]   dilation_d11  =  rowbuf_wrdata_11;
wire  [7:0]   dilation_d12  =  rowbuf_wrdata_12;
wire  [7:0]   dilation_d13  =  rowbuf_wrdata_13;
wire  [7:0]   dilation_d14  =  rowbuf_wrdata_14;
wire  [7:0]   dilation_d15  =  rowbuf_wrdata_15;
wire  [7:0]   dilation_d16  =  rowbuf_wrdata_16;
wire  [7:0]   dilation_d17  =  rowbuf_wrdata_17;
wire  [7:0]   dilation_d18  =  rowbuf_wrdata_18;

dilation_ctrl U_dilation_ctrl(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .sensor_state(sensor_state),
    
    .erosion_valid(erosion_valid),
    .erosion_dout(erosion_dout),

    .rowbuf_wren(rowbuf_wren),
    .rowbuf_wraddr(rowbuf_wraddr),

    .rowbuf_rden(rowbuf_rden),
    .rowbuf_rdaddr(rowbuf_rdaddr),

    .dilation_ap_start(dilation_ap_start),
    .dilation_ap_done(dilation_ap_done),
    .dilation_ap_idle(dilation_ap_idle),
    .dilation_ap_ready(dilation_ap_ready),
    
    .dilation_init(dilation_init),
    
    .dilation_valid(dilation_valid),
    
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
    .rowbuf_rddata_17(rowbuf_rddata_17),
    .rowbuf_rddata_18(rowbuf_rddata_18),
    
    .rowbuf_wrdata_0(rowbuf_wrdata_0),
    .rowbuf_wrdata_1(rowbuf_wrdata_1),
    .rowbuf_wrdata_2(rowbuf_wrdata_2),
    .rowbuf_wrdata_3(rowbuf_wrdata_3),
    .rowbuf_wrdata_4(rowbuf_wrdata_4),
    .rowbuf_wrdata_5(rowbuf_wrdata_5),
    .rowbuf_wrdata_6(rowbuf_wrdata_6),
    .rowbuf_wrdata_7(rowbuf_wrdata_7),
    .rowbuf_wrdata_8(rowbuf_wrdata_8),
    .rowbuf_wrdata_9(rowbuf_wrdata_9),
    .rowbuf_wrdata_10(rowbuf_wrdata_10),
    .rowbuf_wrdata_11(rowbuf_wrdata_11),
    .rowbuf_wrdata_12(rowbuf_wrdata_12),
    .rowbuf_wrdata_13(rowbuf_wrdata_13),
    .rowbuf_wrdata_14(rowbuf_wrdata_14),
    .rowbuf_wrdata_15(rowbuf_wrdata_15),
    .rowbuf_wrdata_16(rowbuf_wrdata_16),
    .rowbuf_wrdata_17(rowbuf_wrdata_17),
    .rowbuf_wrdata_18(rowbuf_wrdata_18)
);

dilation_accel_0 U_dilation_accel_0(
    .ap_clk(s_axi_aclk),
    .ap_rst(~s_axi_aresetn),
    .ap_start(dilation_ap_start),
    .ap_done(dilation_ap_done),
    .ap_idle(dilation_ap_idle),
    .ap_ready(dilation_ap_ready),
    .init(dilation_init),
    .in0(dilation_d0),
    .in1(dilation_d1),
    .in2(dilation_d2),
    .in3(dilation_d3),
    .in4(dilation_d4),
    .in5(dilation_d5),
    .in6(dilation_d6),
    .in7(dilation_d7),
    .in8(dilation_d8),
    .in9(dilation_d9),
    .in10(dilation_d10),
    .in11(dilation_d11),
    .in12(dilation_d12),
    .in13(dilation_d13),
    .in14(dilation_d14),
    .in15(dilation_d15),
    .in16(dilation_d16),
    .in17(dilation_d17),
    .in18(dilation_d18),
    .out_r_ap_vld(),
    .out_r(dilation_dout)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_0(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_0),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_0)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_1(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_1),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_1)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_2(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_2),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_2)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_3(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_3),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_3)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_4(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_4),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_4)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_5(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_5),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_5)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_6(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_6),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_6)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_7(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_7),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_7)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_8(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_8),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_8)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_9(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_9),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_9)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_10(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_10),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_10)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_11(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_11),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_11)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_12(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_12),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_12)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_13(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_13),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_13)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_14(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_14),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_14)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_15(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_15),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_15)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_16(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_16),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_16)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_17(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_17),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_17)
);

blk_mem_dilation_rowbuf U_blk_mem_dilation_rowbuf_18(
    .clka(s_axi_aclk),
    .ena(rowbuf_wren),
    .wea(1'b1),
    .addra(rowbuf_wraddr),
    .dina(rowbuf_wrdata_18),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_18)
);

endmodule
