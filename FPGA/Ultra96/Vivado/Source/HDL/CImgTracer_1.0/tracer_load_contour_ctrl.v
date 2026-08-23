`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2019 09:56:44 AM
// Design Name: 
// Module Name: tracer_load_contour_ctrl
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


module tracer_load_contour_ctrl(
    input                s_axi_aclk,
    input                s_axi_aresetn,
    
    input                load_contour_start,
    
    output reg           contour_rden,
    output reg           load_contour,
    output reg           contour_data,
    
    output               tracer_buf_en,
    output      [31:0]   tracer_buf_addr,
    input       [31:0]   tracer_buf_din
);

reg             tracer_rden;
reg   [10:0]    tracer_rdaddr;

assign          tracer_buf_en    =  tracer_rden;
assign          tracer_buf_addr  =  {19'd0, tracer_rdaddr, 2'd0};

reg   [4:0]     shift_bit;
reg   [4:0]     shift_bit_reg;

reg             cnt_block;
reg   [9:0]     cnt_pixel;

reg             contour_rden_reg;

reg   [31:0]    tracer_buf_din_reg;

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_pixel  <=  10'd0;
    end
    else begin
        if (tracer_rden) begin
            cnt_pixel  <=  (cnt_pixel == 10'd624)? 10'd0 : (cnt_pixel + 1'b1);
        end
        else begin
            cnt_pixel  <=  10'd0;
        end
    end
end


always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        cnt_block  <=  1'b0;
    end
    else begin
        if ((cnt_pixel == 10'd624) && (shift_bit == 5'd31)) begin
            cnt_block  <=  (cnt_block == 1'b1)? 1'b0 : (cnt_block + 1'b1);
        end
        else begin
            cnt_block  <=  cnt_block;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tracer_rden  <=  1'b0;
    end
    else begin
        if (load_contour_start) begin
            tracer_rden  <=  1'b1;
        end
        else begin
            if ((cnt_pixel == 10'd624) && (shift_bit == 5'd31) && (cnt_block == 1'b1)) begin
                tracer_rden  <=  1'b0;
            end
            else begin
                tracer_rden  <=  tracer_rden;
            end
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tracer_rdaddr  <=  11'd64;
    end
    else begin
        if (tracer_rden) begin
            if (cnt_pixel == 10'd624) begin
                if (shift_bit == 5'd31) begin
                    tracer_rdaddr  <=  tracer_rdaddr + 1'b1;
                end
                else begin
                    tracer_rdaddr  <=  tracer_rdaddr + 1'b1 - 10'd625;
                end
            end
            else begin
                tracer_rdaddr  <=  tracer_rdaddr + 1'b1;
            end
        end
        else begin
            tracer_rdaddr  <=  11'd64;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        shift_bit  <=  5'd0;
    end
    else begin
        if (cnt_pixel == 10'd624) begin
            shift_bit  <=  shift_bit + 1'b1;
        end
        else begin
            shift_bit  <=  shift_bit;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        contour_rden  <=  1'b0;
    end
    else begin
        contour_rden  <=  tracer_rden;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tracer_buf_din_reg  <=  1'b0;
    end
    else begin
        tracer_buf_din_reg  <=  tracer_buf_din;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        shift_bit_reg  <=  5'd0;
    end
    else begin
        shift_bit_reg  <=  shift_bit;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        contour_data  <=  32'd0;
    end
    else begin
        contour_data  <=  (tracer_buf_din_reg >> shift_bit_reg) & 32'h1;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        contour_rden_reg  <=  1'b0;
    end
    else begin
        contour_rden_reg  <=  contour_rden;
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        load_contour  <=  1'b0;
    end
    else begin
        load_contour  <=  contour_rden_reg;
    end
end

endmodule
