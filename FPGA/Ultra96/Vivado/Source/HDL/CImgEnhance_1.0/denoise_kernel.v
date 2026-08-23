`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 10:37:50 AM
// Design Name: 
// Module Name: denoise_kernel
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


module denoise_kernel(
    input               pixclk,
    input               reset_n,
    
    input               s_axi_aclk,
    input               s_axi_aresetn,
    
    input               sensor_state,
    input   [7:0]       sensor_din,
    
    input               frame_begin,
    input               line_begin,
    input               frame_state,
    input               line_state,
    
    output              denoise_valid,
    output  [7:0]       denoise_dout
);

wire          rowbuf_pix_wren;
wire  [9:0]   rowbuf_pix_wraddr;
wire  [7:0]   rowbuf_pix_wrdata;

wire          rowbuf_wren;
wire  [9:0]   rowbuf_wraddr;

wire          rowbuf_rden;
wire  [9:0]   rowbuf_rdaddr;

wire  [7:0]   rowbuf_rddata_0;
wire  [7:0]   rowbuf_rddata_1;
wire  [7:0]   rowbuf_rddata_2;
wire  [7:0]   rowbuf_rddata_sync;

wire  [7:0]   rowbuf_wrdata_0   =  rowbuf_rddata_1;
wire  [7:0]   rowbuf_wrdata_1   =  rowbuf_rddata_2;
wire  [7:0]   rowbuf_wrdata_2  =  rowbuf_rddata_sync;

wire          denoise_ap_start;
wire          denoise_ap_done;
wire          denoise_ap_idle;
wire          denoise_ap_ready;

wire  [7:0]   denoise_d0  =  rowbuf_wren? rowbuf_wrdata_0 : 8'd0;
wire  [7:0]   denoise_d1  =  rowbuf_wren? rowbuf_wrdata_1 : 8'd0;
wire  [7:0]   denoise_d2  =  rowbuf_wren? rowbuf_wrdata_2 : 8'd0;

denoise_ctrl U_denoise_ctrl(
    .pixclk(pixclk),
    .reset_n(reset_n),
    
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .sensor_state(sensor_state),
    .sensor_din(sensor_din),
    
    .frame_begin(frame_begin),
    .line_begin(line_begin),
    .frame_state(frame_state),
    .line_state(line_state),
    
    .rowbuf_pix_wren(rowbuf_pix_wren),
    .rowbuf_pix_wraddr(rowbuf_pix_wraddr),
    .rowbuf_pix_wrdata(rowbuf_pix_wrdata),
    
    .rowbuf_wren(rowbuf_wren),
    .rowbuf_wraddr(rowbuf_wraddr),
    
    .rowbuf_rden(rowbuf_rden),
    .rowbuf_rdaddr(rowbuf_rdaddr),
    
    .denoise_ap_start(denoise_ap_start),
    .denoise_ap_done(denoise_ap_done),
    .denoise_ap_idle(denoise_ap_idle),
    .denoise_ap_ready(denoise_ap_ready),
    
    .denoise_valid(denoise_valid)
);

denoise_filter_0 U_denoise_filter_0(
    .ap_clk(s_axi_aclk),
    .ap_rst(~s_axi_aresetn),
    .ap_start(denoise_ap_start),
    .ap_done(denoise_ap_done),
    .ap_idle(denoise_ap_idle),
    .ap_ready(denoise_ap_ready),
    .in0(denoise_d0),
    .in1(denoise_d1),
    .in2(denoise_d2),
    .out_r_ap_vld(),
    .out_r(denoise_dout)
);

blk_mem_denoise_rowbuf U_blk_mem_denoise_rowbuf_0(
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

blk_mem_denoise_rowbuf U_blk_mem_denoise_rowbuf_1(
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

blk_mem_denoise_rowbuf U_blk_mem_denoise_rowbuf_2(
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

blk_mem_denoise_rowbuf U_blk_mem_denoise_rowbuf_sync(
    .clka(pixclk),
    .ena(rowbuf_pix_wren),
    .wea(1'b1),
    .addra(rowbuf_pix_wraddr),
    .dina(rowbuf_pix_wrdata),
    .clkb(s_axi_aclk),
    .enb(rowbuf_rden),
    .addrb(rowbuf_rdaddr),
    .doutb(rowbuf_rddata_sync)
);

endmodule
