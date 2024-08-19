`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2020 04:29:53 PM
// Design Name: 
// Module Name: CImgBuffer_ctrl
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


module CImgBuffer_ctrl(
    input                clock,
    input                reset_n,
    
    input                sensor_state,
    input       [7:0]    sensor_din,
    
    input                frame_begin,
    input                line_begin,
    input                frame_state,
    input                line_state,
    
    output reg           miss_state,
    
    output reg           buf_wren,
    output reg  [13:0]   buf_wraddr,
    output reg  [31:0]   buf_wrdata,
    
    input       [13:0]   buffer_size,
    output reg           interrupt
);

reg   [1:0]   buf_byte_ena;
reg   [2:0]   cnt_interrupt;

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        miss_state  <=  1'b0;
    end
    else begin
        if (frame_begin) begin
            if (cnt_interrupt < 3'd5) begin
                miss_state  <=  1'b1;
            end
            else begin
                miss_state  <=  1'b0;
            end
        end
        else begin
            miss_state  <=  miss_state;
        end
    end
end

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        buf_byte_ena  <=  2'd0;
    end
    else begin
        if (frame_state && line_begin) begin
            buf_byte_ena  <=  buf_byte_ena + 1'b1;
        end
        else if (line_state) begin
            buf_byte_ena  <=  buf_byte_ena + 1'b1;
        end
        else begin
            buf_byte_ena  <=  2'd0;
        end
    end
end

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        buf_wren  <=  1'b0;
    end
    else begin
        if (line_state && (buf_byte_ena == 2'd3)) begin
            buf_wren  <=  1'b1;
        end
        else begin
            buf_wren  <=  1'b0;
        end
    end
end

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        buf_wraddr  <=  14'd0;
    end
    else begin
        if (sensor_state && frame_begin) begin
            buf_wraddr  <=  14'd0;
        end
        else begin
            if (buf_wren) begin
                if (buf_wraddr == buffer_size - 1'b1) begin
                    buf_wraddr  <=  14'd8192;
                end
                else if (buf_wraddr == buffer_size + 14'd8192 - 1'b1) begin
                    buf_wraddr  <=  14'd0;
                end
                else begin
                    buf_wraddr  <=  buf_wraddr + 1'b1;
                end
            end
            else begin
                buf_wraddr  <=  buf_wraddr;
            end
        end
    end
end

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        buf_wrdata   <=  32'd0;
    end
    else begin
        if (frame_state) begin
            buf_wrdata[7:0]    <=  (buf_byte_ena == 2'd0)? sensor_din : buf_wrdata[7:0];
            buf_wrdata[15:8]   <=  (buf_byte_ena == 2'd1)? sensor_din : buf_wrdata[15:8];
            buf_wrdata[23:16]  <=  (buf_byte_ena == 2'd2)? sensor_din : buf_wrdata[23:16];
            buf_wrdata[31:24]  <=  (buf_byte_ena == 2'd3)? sensor_din : buf_wrdata[31:24];
        end
        else begin
            buf_wrdata  <=  32'd0;
        end
    end
end

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        interrupt  <=  1'b0;
    end
    else begin
        if ((buf_wraddr == (buffer_size - 1'b1)) && (buf_byte_ena == 2'd0)) begin
            interrupt  <=  1'b1;
        end
        else if ((buf_wraddr == (buffer_size + 14'd8192 - 1'b1)) && (buf_byte_ena == 2'd0)) begin
            interrupt  <=  1'b1;
        end
        else begin
            interrupt  <=  1'b0;
        end
    end
end

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        cnt_interrupt  <=  3'd0;
    end
    else begin
        if (frame_begin) begin
            cnt_interrupt  <=  3'd0;
        end
        else begin
            if (interrupt == 1'b1) begin
                cnt_interrupt  <=  cnt_interrupt + 1'b1;
            end
            else begin
                cnt_interrupt  <=  cnt_interrupt;
            end
        end
    end
end

endmodule
