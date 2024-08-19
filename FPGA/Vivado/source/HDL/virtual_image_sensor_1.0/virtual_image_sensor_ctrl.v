`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2018 10:57:58 AM
// Design Name: 
// Module Name: virtual_image_sensor_ctrl
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


module virtual_image_sensor_ctrl(
    input               pixclk,
    input               reset,
    input               sensor_set_virtual,

    input               sensor_fv,
    input               sensor_lv,
    input       [7:0]   sensor_pix_data,

    output              out_fv,
    output              out_lv,
    output      [7:0]   out_pix_data
);

wire         virtual_fv;
wire         virtual_lv;
reg          virtual_fv_reg;
reg          virtual_lv_reg;
reg  [7:0]   virtual_pix_data;

assign       out_fv  =  sensor_set_virtual? virtual_fv_reg : sensor_fv;
assign       out_lv  =  sensor_set_virtual? virtual_lv_reg : sensor_lv;
assign       out_pix_data  =  sensor_set_virtual? virtual_pix_data : sensor_pix_data;

reg  [21:0]  cnt_cycle;
reg  [11:0]  cnt_pix;

always @(posedge pixclk) begin
    virtual_fv_reg  <=  virtual_fv;
end
    
always @(posedge pixclk) begin
    virtual_lv_reg  <=  virtual_lv;
end

assign  virtual_fv  =  (cnt_cycle >= 22'd1) && (cnt_cycle <= 22'd2768224);
assign  virtual_lv  =  (cnt_pix >= 12'd1521) && (cnt_pix <= 12'd2816);

always @(posedge pixclk) begin
    if (sensor_set_virtual) begin
        cnt_cycle  <=  (cnt_cycle == 22'd2924799)? 22'd0 : (cnt_cycle + 1'b1);
    end
    else begin
        cnt_cycle  <=  ((cnt_cycle > 22'd0) && (cnt_cycle < 22'd2924799))? (cnt_cycle + 1'b1) : 22'd0;
    end
end

always @(posedge pixclk) begin
    if (virtual_fv) begin
        cnt_pix  <=  (cnt_pix == 12'd2847)? 12'd0 : (cnt_pix + 1'b1);
    end
    else begin
        cnt_pix  <=  12'd0;
    end
end

always @(posedge pixclk) begin
    if (reset) begin
        virtual_pix_data  <=  8'd0;
    end
    else begin
        if (cnt_cycle == 22'd2924799) begin
            virtual_pix_data  <=  virtual_pix_data + 1'b1;
        end
        else begin
            virtual_pix_data  <=  virtual_pix_data;
        end
    end
end

endmodule