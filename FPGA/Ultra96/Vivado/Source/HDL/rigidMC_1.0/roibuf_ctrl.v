`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 11:15:06 AM
// Design Name: 
// Module Name: roibuf_ctrl
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


module roibuf_ctrl(
    input                 s_axi_aclk,
    input                 s_axi_aresetn,

    input         [1:0]   fft_state,

    output reg            roi_bram_0_wren,
    output reg    [11:0]  roi_bram_0_wraddr,
    output reg    [63:0]  roi_bram_0_wrdata,
    output reg            roi_bram_0_rden,
    output reg    [11:0]  roi_bram_0_rdaddr,
    input         [63:0]  roi_bram_0_rddata,

    output reg            roi_bram_1_wren,
    output reg    [11:0]  roi_bram_1_wraddr,
    output reg    [63:0]  roi_bram_1_wrdata,
    output reg            roi_bram_1_rden,
    output reg    [11:0]  roi_bram_1_rdaddr,
    input         [63:0]  roi_bram_1_rddata,

    output reg            roi_bram_2_wren,
    output reg    [11:0]  roi_bram_2_wraddr,
    output reg    [63:0]  roi_bram_2_wrdata,
    output reg            roi_bram_2_rden,
    output reg    [11:0]  roi_bram_2_rdaddr,
    input         [63:0]  roi_bram_2_rddata,

    output reg            roi_bram_3_wren,
    output reg    [11:0]  roi_bram_3_wraddr,
    output reg    [63:0]  roi_bram_3_wrdata,
    output reg            roi_bram_3_rden,
    output reg    [11:0]  roi_bram_3_rdaddr,
    input         [63:0]  roi_bram_3_rddata,
    
    // 1stR Ctrl
    input                 roi_bram_1stR_0_wren,
    input         [11:0]  roi_bram_1stR_0_wraddr,
    input         [63:0]  roi_bram_1stR_0_wrdata,

    input                 roi_bram_1stR_1_wren,
    input         [11:0]  roi_bram_1stR_1_wraddr,
    input         [63:0]  roi_bram_1stR_1_wrdata,

    input                 roi_bram_1stR_2_wren,
    input         [11:0]  roi_bram_1stR_2_wraddr,
    input         [63:0]  roi_bram_1stR_2_wrdata,

    input                 roi_bram_1stR_3_wren,
    input         [11:0]  roi_bram_1stR_3_wraddr,
    input         [63:0]  roi_bram_1stR_3_wrdata,
    
    // 2ndR Ctrl
    input                 roi_bram_2ndR_0_wren,
    input         [11:0]  roi_bram_2ndR_0_wraddr,
    input         [31:0]  roi_bram_2ndR_0_wrdata,
    input                 roi_bram_2ndR_0_rden,
    input         [11:0]  roi_bram_2ndR_0_rdaddr,
    output        [63:0]  roi_bram_2ndR_0_rddata,

    input                 roi_bram_2ndR_1_wren,
    input         [11:0]  roi_bram_2ndR_1_wraddr,
    input         [31:0]  roi_bram_2ndR_1_wrdata,
    input                 roi_bram_2ndR_1_rden,
    input         [11:0]  roi_bram_2ndR_1_rdaddr,
    output        [63:0]  roi_bram_2ndR_1_rddata,

    input                 roi_bram_2ndR_2_wren,
    input         [11:0]  roi_bram_2ndR_2_wraddr,
    input         [31:0]  roi_bram_2ndR_2_wrdata,
    input                 roi_bram_2ndR_2_rden,
    input         [11:0]  roi_bram_2ndR_2_rdaddr,
    output        [63:0]  roi_bram_2ndR_2_rddata,

    input                 roi_bram_2ndR_3_wren,
    input         [11:0]  roi_bram_2ndR_3_wraddr,
    input         [31:0]  roi_bram_2ndR_3_wrdata,
    input                 roi_bram_2ndR_3_rden,
    input         [11:0]  roi_bram_2ndR_3_rdaddr,
    output        [63:0]  roi_bram_2ndR_3_rddata,
    
    // 3rdR Ctrl
    input                 roi_bram_3rdR_0_wren,
    input         [11:0]  roi_bram_3rdR_0_wraddr,
    input         [63:0]  roi_bram_3rdR_0_wrdata,
    input                 roi_bram_3rdR_0_rden,
    input         [11:0]  roi_bram_3rdR_0_rdaddr,
    output        [31:0]  roi_bram_3rdR_0_rddata,

    input                 roi_bram_3rdR_1_wren,
    input         [11:0]  roi_bram_3rdR_1_wraddr,
    input         [63:0]  roi_bram_3rdR_1_wrdata,
    input                 roi_bram_3rdR_1_rden,
    input         [11:0]  roi_bram_3rdR_1_rdaddr,
    output        [31:0]  roi_bram_3rdR_1_rddata,

    input                 roi_bram_3rdR_2_wren,
    input         [11:0]  roi_bram_3rdR_2_wraddr,
    input         [63:0]  roi_bram_3rdR_2_wrdata,
    input                 roi_bram_3rdR_2_rden,
    input         [11:0]  roi_bram_3rdR_2_rdaddr,
    output        [31:0]  roi_bram_3rdR_2_rddata,

    input                 roi_bram_3rdR_3_wren,
    input         [11:0]  roi_bram_3rdR_3_wraddr,
    input         [63:0]  roi_bram_3rdR_3_wrdata,
    input                 roi_bram_3rdR_3_rden,
    input         [11:0]  roi_bram_3rdR_3_rdaddr,
    output        [31:0]  roi_bram_3rdR_3_rddata,
    
    // 4thR Ctrl
    input                 roi_bram_4thR_0_wren,
    input         [11:0]  roi_bram_4thR_0_wraddr,
    input         [63:0]  roi_bram_4thR_0_wrdata,
    input                 roi_bram_4thR_0_rden,
    input         [11:0]  roi_bram_4thR_0_rdaddr,
    output        [63:0]  roi_bram_4thR_0_rddata,

    input                 roi_bram_4thR_1_wren,
    input         [11:0]  roi_bram_4thR_1_wraddr,
    input         [63:0]  roi_bram_4thR_1_wrdata,
    input                 roi_bram_4thR_1_rden,
    input         [11:0]  roi_bram_4thR_1_rdaddr,
    output        [63:0]  roi_bram_4thR_1_rddata,

    input                 roi_bram_4thR_2_wren,
    input         [11:0]  roi_bram_4thR_2_wraddr,
    input         [63:0]  roi_bram_4thR_2_wrdata,
    input                 roi_bram_4thR_2_rden,
    input         [11:0]  roi_bram_4thR_2_rdaddr,
    output        [63:0]  roi_bram_4thR_2_rddata,

    input                 roi_bram_4thR_3_wren,
    input         [11:0]  roi_bram_4thR_3_wraddr,
    input         [63:0]  roi_bram_4thR_3_wrdata,
    input                 roi_bram_4thR_3_rden,
    input         [11:0]  roi_bram_4thR_3_rdaddr,
    output        [63:0]  roi_bram_4thR_3_rddata
);

assign    roi_bram_2ndR_0_rddata  =  (fft_state == 2'd1)? roi_bram_0_rddata : 64'd0;
assign    roi_bram_2ndR_1_rddata  =  (fft_state == 2'd1)? roi_bram_1_rddata : 64'd0;
assign    roi_bram_2ndR_2_rddata  =  (fft_state == 2'd1)? roi_bram_2_rddata : 64'd0;
assign    roi_bram_2ndR_3_rddata  =  (fft_state == 2'd1)? roi_bram_3_rddata : 64'd0;

assign    roi_bram_3rdR_0_rddata  =  (fft_state == 2'd2)? roi_bram_0_rddata[31:0] : 32'd0;
assign    roi_bram_3rdR_1_rddata  =  (fft_state == 2'd2)? roi_bram_1_rddata[31:0] : 32'd0;
assign    roi_bram_3rdR_2_rddata  =  (fft_state == 2'd2)? roi_bram_2_rddata[31:0] : 32'd0;
assign    roi_bram_3rdR_3_rddata  =  (fft_state == 2'd2)? roi_bram_3_rddata[31:0] : 32'd0;

assign    roi_bram_4thR_0_rddata  =  (fft_state == 2'd3)? roi_bram_0_rddata : 64'd0;
assign    roi_bram_4thR_1_rddata  =  (fft_state == 2'd3)? roi_bram_1_rddata : 64'd0;
assign    roi_bram_4thR_2_rddata  =  (fft_state == 2'd3)? roi_bram_2_rddata : 64'd0;
assign    roi_bram_4thR_3_rddata  =  (fft_state == 2'd3)? roi_bram_3_rddata : 64'd0;

always @(*) begin
    case (fft_state)
        2'd0: begin
            roi_bram_0_wren    =  roi_bram_1stR_0_wren;
            roi_bram_0_wraddr  =  roi_bram_1stR_0_wraddr;
            roi_bram_0_wrdata  =  roi_bram_1stR_0_wrdata;
            roi_bram_0_rden    =  1'b0;
            roi_bram_0_rdaddr  =  12'd0;

            roi_bram_1_wren    =  roi_bram_1stR_1_wren;
            roi_bram_1_wraddr  =  roi_bram_1stR_1_wraddr;
            roi_bram_1_wrdata  =  roi_bram_1stR_1_wrdata;
            roi_bram_1_rden    =  1'b0;
            roi_bram_1_rdaddr  =  12'd0;

            roi_bram_2_wren    =  roi_bram_1stR_2_wren;
            roi_bram_2_wraddr  =  roi_bram_1stR_2_wraddr;
            roi_bram_2_wrdata  =  roi_bram_1stR_2_wrdata;
            roi_bram_2_rden    =  1'b0;
            roi_bram_2_rdaddr  =  12'd0;

            roi_bram_3_wren    =  roi_bram_1stR_3_wren;
            roi_bram_3_wraddr  =  roi_bram_1stR_3_wraddr;
            roi_bram_3_wrdata  =  roi_bram_1stR_3_wrdata;
            roi_bram_3_rden    =  1'b0;
            roi_bram_3_rdaddr  =  12'd0;
        end
        2'd1: begin
            roi_bram_0_wren    =  roi_bram_2ndR_0_wren;
            roi_bram_0_wraddr  =  roi_bram_2ndR_0_wraddr;
            roi_bram_0_wrdata  =  {32'd0, roi_bram_2ndR_0_wrdata};
            roi_bram_0_rden    =  roi_bram_2ndR_0_rden;
            roi_bram_0_rdaddr  =  roi_bram_2ndR_0_rdaddr;

            roi_bram_1_wren    =  roi_bram_2ndR_1_wren;
            roi_bram_1_wraddr  =  roi_bram_2ndR_1_wraddr;
            roi_bram_1_wrdata  =  {32'd0, roi_bram_2ndR_1_wrdata};
            roi_bram_1_rden    =  roi_bram_2ndR_1_rden;
            roi_bram_1_rdaddr  =  roi_bram_2ndR_1_rdaddr;

            roi_bram_2_wren    =  roi_bram_2ndR_2_wren;
            roi_bram_2_wraddr  =  roi_bram_2ndR_2_wraddr;
            roi_bram_2_wrdata  =  {32'd0, roi_bram_2ndR_2_wrdata};
            roi_bram_2_rden    =  roi_bram_2ndR_2_rden;
            roi_bram_2_rdaddr  =  roi_bram_2ndR_2_rdaddr;

            roi_bram_3_wren    =  roi_bram_2ndR_3_wren;
            roi_bram_3_wraddr  =  roi_bram_2ndR_3_wraddr;
            roi_bram_3_wrdata  =  {32'd0, roi_bram_2ndR_3_wrdata};
            roi_bram_3_rden    =  roi_bram_2ndR_3_rden;
            roi_bram_3_rdaddr  =  roi_bram_2ndR_3_rdaddr;
        end
        2'd2: begin
            roi_bram_0_wren    =  roi_bram_3rdR_0_wren;
            roi_bram_0_wraddr  =  roi_bram_3rdR_0_wraddr;
            roi_bram_0_wrdata  =  roi_bram_3rdR_0_wrdata;
            roi_bram_0_rden    =  roi_bram_3rdR_0_rden;
            roi_bram_0_rdaddr  =  roi_bram_3rdR_0_rdaddr;

            roi_bram_1_wren    =  roi_bram_3rdR_1_wren;
            roi_bram_1_wraddr  =  roi_bram_3rdR_1_wraddr;
            roi_bram_1_wrdata  =  roi_bram_3rdR_1_wrdata;
            roi_bram_1_rden    =  roi_bram_3rdR_1_rden;
            roi_bram_1_rdaddr  =  roi_bram_3rdR_1_rdaddr;

            roi_bram_2_wren    =  roi_bram_3rdR_2_wren;
            roi_bram_2_wraddr  =  roi_bram_3rdR_2_wraddr;
            roi_bram_2_wrdata  =  roi_bram_3rdR_2_wrdata;
            roi_bram_2_rden    =  roi_bram_3rdR_2_rden;
            roi_bram_2_rdaddr  =  roi_bram_3rdR_2_rdaddr;

            roi_bram_3_wren    =  roi_bram_3rdR_3_wren;
            roi_bram_3_wraddr  =  roi_bram_3rdR_3_wraddr;
            roi_bram_3_wrdata  =  roi_bram_3rdR_3_wrdata;
            roi_bram_3_rden    =  roi_bram_3rdR_3_rden;
            roi_bram_3_rdaddr  =  roi_bram_3rdR_3_rdaddr;
        end
        2'd3: begin
            roi_bram_0_wren    =  roi_bram_4thR_0_wren;
            roi_bram_0_wraddr  =  roi_bram_4thR_0_wraddr;
            roi_bram_0_wrdata  =  roi_bram_4thR_0_wrdata;
            roi_bram_0_rden    =  roi_bram_4thR_0_rden;
            roi_bram_0_rdaddr  =  roi_bram_4thR_0_rdaddr;

            roi_bram_1_wren    =  roi_bram_4thR_1_wren;
            roi_bram_1_wraddr  =  roi_bram_4thR_1_wraddr;
            roi_bram_1_wrdata  =  roi_bram_4thR_1_wrdata;
            roi_bram_1_rden    =  roi_bram_4thR_1_rden;
            roi_bram_1_rdaddr  =  roi_bram_4thR_1_rdaddr;

            roi_bram_2_wren    =  roi_bram_4thR_2_wren;
            roi_bram_2_wraddr  =  roi_bram_4thR_2_wraddr;
            roi_bram_2_wrdata  =  roi_bram_4thR_2_wrdata;
            roi_bram_2_rden    =  roi_bram_4thR_2_rden;
            roi_bram_2_rdaddr  =  roi_bram_4thR_2_rdaddr;

            roi_bram_3_wren    =  roi_bram_4thR_3_wren;
            roi_bram_3_wraddr  =  roi_bram_4thR_3_wraddr;
            roi_bram_3_wrdata  =  roi_bram_4thR_3_wrdata;
            roi_bram_3_rden    =  roi_bram_4thR_3_rden;
            roi_bram_3_rdaddr  =  roi_bram_4thR_3_rdaddr;
        end
        default: begin
            roi_bram_0_wren    =  roi_bram_1stR_0_wren;
            roi_bram_0_wraddr  =  roi_bram_1stR_0_wraddr;
            roi_bram_0_wrdata  =  roi_bram_1stR_0_wrdata;
            roi_bram_0_rden    =  1'b0;
            roi_bram_0_rdaddr  =  12'd0;

            roi_bram_1_wren    =  roi_bram_1stR_1_wren;
            roi_bram_1_wraddr  =  roi_bram_1stR_1_wraddr;
            roi_bram_1_wrdata  =  roi_bram_1stR_1_wrdata;
            roi_bram_1_rden    =  1'b0;
            roi_bram_1_rdaddr  =  12'd0;

            roi_bram_2_wren    =  roi_bram_1stR_2_wren;
            roi_bram_2_wraddr  =  roi_bram_1stR_2_wraddr;
            roi_bram_2_wrdata  =  roi_bram_1stR_2_wrdata;
            roi_bram_2_rden    =  1'b0;
            roi_bram_2_rdaddr  =  12'd0;

            roi_bram_3_wren    =  roi_bram_1stR_3_wren;
            roi_bram_3_wraddr  =  roi_bram_1stR_3_wraddr;
            roi_bram_3_wrdata  =  roi_bram_1stR_3_wrdata;
            roi_bram_3_rden    =  1'b0;
            roi_bram_3_rdaddr  =  12'd0;
        end
    endcase
end

endmodule
