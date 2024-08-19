`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2019 11:06:44 AM
// Design Name: 
// Module Name: background_subtractor
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


module background_subtractor(
    input           s_axi_aclk,
    input           s_axi_aresetn,
    
    input           denoise_valid,
    input   [7:0]   denoise_dout,

    input           dilation_valid,
    input   [7:0]   dilation_dout,
    
    output          enhance_valid,
    output  [7:0]   enhance_dout
);

wire           img_wren;
wire  [13:0]   img_wraddr;
wire  [7:0]    img_wrdata;

wire           img_rden;
wire  [13:0]   img_rdaddr;
wire  [7:0]    img_rddata;

image_stream_in_ctrl U_image_stream_in_ctrl(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .denoise_valid(denoise_valid),
    .denoise_dout(denoise_dout),
    
    .img_wren(img_wren),
    .img_wraddr(img_wraddr),
    .img_wrdata(img_wrdata)
);

background_subtractor_ctrl U_background_subtractor_ctrl(
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),
    
    .img_rden(img_rden),
    .img_rdaddr(img_rdaddr),
    .img_rddata(img_rddata),
    
    .dilation_valid(dilation_valid),
    .dilation_dout(dilation_dout),
    
    .enhance_valid(enhance_valid),
    .enhance_dout(enhance_dout)
);

blk_mem_enh_img_fifo U_blk_mem_enh_img_fifo(
    .clka(s_axi_aclk),
    .ena(1'b1),
    .wea(img_wren),
    .addra(img_wraddr),
    .dina(img_wrdata),
    .clkb(s_axi_aclk),
    .enb(img_rden),
    .addrb(img_rdaddr),
    .doutb(img_rddata)
);

endmodule
