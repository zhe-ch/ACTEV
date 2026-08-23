`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2019 11:13:14 AM
// Design Name: 
// Module Name: background_subtractor_ctrl
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

module background_subtractor_ctrl(
    input               s_axi_aclk,
    input               s_axi_aresetn,
    
    output              img_rden,
    output      [13:0]  img_rdaddr,
    input       [7:0]   img_rddata,

    input               dilation_valid,
    input       [7:0]   dilation_dout,
    
    output reg          enhance_valid,
    output reg  [7:0]   enhance_dout
);

reg     [18:0]   img_pix_rdaddr;

assign           img_rden     =   dilation_valid;
assign           img_rdaddr   =   img_pix_rdaddr[13:0];

reg              dilation_valid_reg;
reg     [7:0]    bkground_data;

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        img_pix_rdaddr  <=  19'd0;
    end
    else begin
        if (img_rden) begin
            img_pix_rdaddr  <=  (img_pix_rdaddr == 19'd360959)? 19'd0 : (img_pix_rdaddr + 1'b1);
        end
        else begin
            img_pix_rdaddr  <=  img_pix_rdaddr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        dilation_valid_reg  <=  1'b0;
    end
    else begin
        dilation_valid_reg  <=  dilation_valid;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        enhance_valid  <=  1'b0;
    end
    else begin
        enhance_valid  <=  dilation_valid_reg;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        bkground_data  <=  8'd0;
    end
    else begin
        if (dilation_valid) begin
            bkground_data  <=  dilation_dout;
        end
        else begin
            bkground_data  <=  bkground_data;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        enhance_dout  <=  8'd0;
    end
    else begin
        enhance_dout  <=  img_rddata - bkground_data;
    end
end

endmodule
