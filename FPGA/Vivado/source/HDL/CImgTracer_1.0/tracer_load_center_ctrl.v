`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2019 09:56:19 AM
// Design Name: 
// Module Name: tracer_load_center_ctrl
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


module tracer_load_center_ctrl(
    input                s_axi_aclk,
    input                s_axi_aresetn,
    
    input                load_start,
    output               load_contour_start,
    
    output reg           load_center,
    output      [7:0]    center_row,
    output      [8:0]    center_col,
    
    output               tracer_buf_en,
    output      [31:0]   tracer_buf_addr,
    input       [31:0]   tracer_buf_din
);

reg            tracer_rden;
reg   [5:0]    tracer_rdaddr;

assign         tracer_buf_en    =  tracer_rden;
assign         tracer_buf_addr  =  {24'd0, tracer_rdaddr, 2'd0};

assign         center_row   =   tracer_buf_din[7:0];
assign         center_col   =   tracer_buf_din[24:16];

assign         load_contour_start  =  load_center && (~tracer_rden);

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tracer_rden  <=  1'b0;
    end
    else begin
        if (load_start) begin
            tracer_rden  <=  1'b1;
        end
        else begin
            tracer_rden  <=  (tracer_rdaddr == 6'd63)? 1'b0 : tracer_rden;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tracer_rdaddr  <=  6'd0;
    end
    else begin
        if (tracer_rden) begin
            tracer_rdaddr  <=  tracer_rdaddr + 1'b1;
        end
        else begin
            tracer_rdaddr  <=  6'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        load_center  <=  1'b0;
    end
    else begin
        load_center  <=  tracer_rden;
    end
end

endmodule
