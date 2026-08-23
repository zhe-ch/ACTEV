`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2019 11:10:36 AM
// Design Name: 
// Module Name: image_stream_in_ctrl
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

module image_stream_in_ctrl(
    input                s_axi_aclk,
    input                s_axi_aresetn,
    
    input                denoise_valid,
    input       [7:0]    denoise_dout,
    
    output               img_wren,
    output      [13:0]   img_wraddr,
    output      [7:0]    img_wrdata
);

reg     [18:0]   img_pix_wraddr;
assign           img_wraddr  =  img_pix_wraddr[13:0];

assign           img_wren    =  denoise_valid;
assign           img_wrdata  =  denoise_dout;

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        img_pix_wraddr  <=  19'd0;
    end
    else begin
        if (img_wren) begin
            img_pix_wraddr  <=  (img_pix_wraddr == 19'd360959)? 19'd0 : (img_pix_wraddr + 1'b1);
        end
        else begin
            img_pix_wraddr  <=  img_pix_wraddr;
        end
    end
end

endmodule
