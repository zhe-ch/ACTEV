`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2019 10:42:32 AM
// Design Name: 
// Module Name: erosion_kernel
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


module erosion_kernel(
    input               s_axi_aclk,
    input               s_axi_aresetn,

    input               sensor_state,

    input               denoise_valid,
    input   [7:0]       denoise_dout,

    output              erosion_valid,
    output  [7:0]       erosion_dout
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

wire          erosion_ap_start;
wire          erosion_ap_done;
wire          erosion_ap_idle;
wire          erosion_ap_ready;

wire          erosion_init;

wire  [7:0]   erosion_d0   =  rowbuf_wrdata_0;
wire  [7:0]   erosion_d1   =  rowbuf_wrdata_1;
wire  [7:0]   erosion_d2   =  rowbuf_wrdata_2;
wire  [7:0]   erosion_d3   =  rowbuf_wrdata_3;
wire  [7:0]   erosion_d4   =  rowbuf_wrdata_4;
wire  [7:0]   erosion_d5   =  rowbuf_wrdata_5;
wire  [7:0]   erosion_d6   =  rowbuf_wrdata_6;
wire  [7:0]   erosion_d7   =  rowbuf_wrdata_7;
wire  [7:0]   erosion_d8   =  rowbuf_wrdata_8;
wire  [7:0]   erosion_d9   =  rowbuf_wrdata_9;
wire  [7:0]   erosion_d10  =  rowbuf_wrdata_10;
wire  [7:0]   erosion_d11  =  rowbuf_wrdata_11;
wire  [7:0]   erosion_d12  =  rowbuf_wrdata_12;
wire  [7:0]   erosion_d13  =  rowbuf_wrdata_13;
wire  [7:0]   erosion_d14  =  rowbuf_wrdata_14;
wire  [7:0]   erosion_d15  =  rowbuf_wrdata_15;
wire  [7:0]   erosion_d16  =  rowbuf_wrdata_16;
wire  [7:0]   erosion_d17  =  rowbuf_wrdata_17;
wire  [7:0]   erosion_d18  =  rowbuf_wrdata_18;

erosion_ctrl U_erosion_ctrl(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),

    .sensor_state(sensor_state),
    
    .denoise_valid(denoise_valid),
    .denoise_dout(denoise_dout),
    
    .rowbuf_wren(rowbuf_wren),
    .rowbuf_wraddr(rowbuf_wraddr),
    
    .rowbuf_rden(rowbuf_rden),
    .rowbuf_rdaddr(rowbuf_rdaddr),

    .erosion_ap_start(erosion_ap_start),
    .erosion_ap_done(erosion_ap_done),
    .erosion_ap_idle(erosion_ap_idle),
    .erosion_ap_ready(erosion_ap_ready),
    
    .erosion_init(erosion_init),
    
    .erosion_valid(erosion_valid),
    
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

erosion_accel_0 U_erosion_accel_0(
    .ap_clk(s_axi_aclk),
    .ap_rst(~s_axi_aresetn),
    .ap_start(erosion_ap_start),
    .ap_done(erosion_ap_done),
    .ap_idle(erosion_ap_idle),
    .ap_ready(erosion_ap_ready),
    .init(erosion_init),
    .in0(erosion_d0),
    .in1(erosion_d1),
    .in2(erosion_d2),
    .in3(erosion_d3),
    .in4(erosion_d4),
    .in5(erosion_d5),
    .in6(erosion_d6),
    .in7(erosion_d7),
    .in8(erosion_d8),
    .in9(erosion_d9),
    .in10(erosion_d10),
    .in11(erosion_d11),
    .in12(erosion_d12),
    .in13(erosion_d13),
    .in14(erosion_d14),
    .in15(erosion_d15),
    .in16(erosion_d16),
    .in17(erosion_d17),
    .in18(erosion_d18),
    .out_r_ap_vld(),
    .out_r(erosion_dout)
);

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_0(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_1(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_2(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_3(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_4(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_5(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_6(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_7(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_8(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_9(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_10(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_11(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_12(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_13(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_14(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_15(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_16(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_17(
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

blk_mem_erosion_rowbuf U_blk_mem_erosion_rowbuf_18(
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
