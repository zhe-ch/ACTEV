`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 05:30:35 PM
// Design Name: 
// Module Name: frame_indication_gen
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


module frame_indication_gen(
    input                clock,
    input                reset_n,

    input                sensor_state,
    input                sensor_fv,
    input                sensor_lv,

    input      [9:0]     crop_row_start,
    input      [9:0]     crop_row_end,
    input      [10:0]    crop_col_start,
    input      [10:0]    crop_col_end,

    output               frame_begin,
    output               frame_end,
    output               roi_line_begin,
    output               roi_line_end,

    output reg [9:0]     cnt_line,
    output reg [10:0]    cnt_pixel,

    output reg           frame_state,
    output reg           roi_line_state
);

reg         sensor_fv_reg;
reg         sensor_lv_reg;

//reg [9:0]   cnt_line;
//reg [10:0]  cnt_pixel;

assign   frame_begin  =  sensor_fv && (~sensor_fv_reg);
assign   frame_end    =  (~sensor_fv) && sensor_fv_reg;
wire     line_begin   =  sensor_lv && (~sensor_lv_reg);
wire     line_end     =  (~sensor_lv) && sensor_lv_reg;

reg      line_state;

assign   roi_line_begin  =  (cnt_line >= crop_row_start) && (cnt_line <= crop_row_end) && (cnt_pixel == crop_col_start);
assign   roi_line_end    =  (cnt_line >= crop_row_start) && (cnt_line <= crop_row_end) && (cnt_pixel == crop_col_end);

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        cnt_line  <=  10'd0;
    end
    else begin
        if (sensor_state) begin
            if (frame_begin) begin
                cnt_line  <=  10'd0;
            end
            else if (frame_end) begin
                cnt_line  <=  10'd0;
            end
            else if (line_end) begin
                cnt_line  <=  cnt_line + 1'b1;
            end
            else begin
                cnt_line  <=  cnt_line;
            end
        end
        else begin
            cnt_line  <=  10'd0;
        end
    end
end

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        cnt_pixel  <=  11'd0;
    end
    else begin
        if (sensor_state) begin
            if (line_begin) begin
                cnt_pixel  <=  cnt_pixel + 1'b1;
            end
            else if (line_end) begin
                cnt_pixel  <=  11'd0;
            end
            else if (line_state) begin
                cnt_pixel  <=  cnt_pixel + 1'b1;
            end
            else begin
                cnt_pixel  <=  11'd0;
            end
        end
        else begin
            cnt_pixel  <=  11'd0;
        end
    end
end

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        sensor_fv_reg  <=  1'b0;
    end
    else begin
        sensor_fv_reg  <=  sensor_fv;
    end
end

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        sensor_lv_reg  <=  1'b0;
    end
    else begin
        sensor_lv_reg  <=  sensor_lv;
    end
end

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        frame_state  <=  1'b0;
    end
    else begin
        if (sensor_state && frame_begin) begin
            frame_state  <=  1'b1;
        end
        else if (frame_end) begin
            frame_state  <=  1'b0;
        end
        else begin
            frame_state  <=  frame_state;
        end
    end
end

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        line_state  <=  1'b0;
    end
    else begin
        if (frame_state) begin
            if (line_begin) begin
                line_state  <=  1'b1;
            end
            else if (line_end) begin
                line_state  <=  1'b0;
            end
            else begin
                line_state  <=  line_state;
            end
        end
        else begin
            line_state  <=  1'b0;
        end
    end
end

always @(posedge clock or negedge reset_n) begin
    if (~reset_n) begin
        roi_line_state  <=  1'b0;
    end
    else begin
        if (frame_state) begin
            if (roi_line_begin) begin
                roi_line_state  <=  1'b1;
            end
            else if (roi_line_end) begin
                roi_line_state  <=  1'b0;
            end
            else begin
                roi_line_state  <=  roi_line_state;
            end
        end
        else begin
            roi_line_state  <=  1'b0;
        end
    end
end

endmodule
