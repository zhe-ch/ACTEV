`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2019 09:57:04 AM
// Design Name: 
// Module Name: tracer_store_trace_ctrl
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


module tracer_store_trace_ctrl(
    input                s_axi_aclk,
    input                s_axi_aresetn,
    
    input       [7:0]    enh_ds_last_row,
    input       [8:0]    enh_ds_last_col,
    
    output reg           store_start,
    output               store_end,
    
    output               store_trace,
    input       [15:0]   acc_trace,
    
    output reg           tracer_buf_en,
    output reg  [31:0]   tracer_buf_addr,
    output reg  [31:0]   tracer_buf_dout
);

reg            tracer_wren;
reg   [5:0]    tracer_wraddr;

assign         store_trace  =  tracer_wren;

assign         store_end  =  (tracer_wraddr == 6'd63);

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        store_start  <=  1'b0;
    end
    else begin
        if ((enh_ds_last_row == 8'd201) && (enh_ds_last_col == 9'd321)) begin
            store_start  <=  1'b1;
        end
        else begin
            store_start  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tracer_wren  <=  1'b0;
    end
    else begin
        if (store_start) begin
            tracer_wren  <=  1'b1;
        end
        else begin
            tracer_wren  <=  store_end? 1'b0 : tracer_wren;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tracer_wraddr  <=  6'd0;
    end
    else begin
        if (tracer_wren) begin
            tracer_wraddr  <=  tracer_wraddr + 1'b1;
        end
        else begin
            tracer_wraddr  <=  6'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tracer_buf_en  <=  1'b0;
    end
    else begin
        if (tracer_wren && tracer_wraddr[0]) begin
            tracer_buf_en  <=  1'b1;
        end
        else begin
            tracer_buf_en  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tracer_buf_addr  <=  {19'd0,11'd1314,2'd0};
    end
    else begin
        if (tracer_wren && tracer_wraddr[0]) begin
            tracer_buf_addr  <=  {19'd0,11'd1314,2'd0} + {25'd0,tracer_wraddr[5:1],2'd0};
        end
        else if (tracer_buf_addr == {19'd0,11'd1314+11'd31,2'd0}) begin
            tracer_buf_addr  <=  {19'd0,11'd1314,2'd0};
        end
        else begin
            tracer_buf_addr  <=  tracer_buf_addr;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        tracer_buf_dout  <=  32'd0;
    end
    else begin
        if (tracer_wren) begin
            tracer_buf_dout  <=  tracer_wraddr[0]? {acc_trace, tracer_buf_dout[15:0]} : {tracer_buf_dout[31:16], acc_trace};
        end
        else begin
            tracer_buf_dout  <=  32'd0;
        end
    end
end

endmodule
