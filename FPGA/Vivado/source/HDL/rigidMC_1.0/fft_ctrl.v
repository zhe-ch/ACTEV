`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 11:09:47 AM
// Design Name: 
// Module Name: fft_ctrl
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


module fft_ctrl(
    input               s_axi_aclk,
    input               s_axi_aresetn,
    
    input               fft_config_start,
    
    output reg          fft_config_valid,
    output reg  [15:0]  fft_config_data,
    
    input               fft_2ndR_config,
    output reg          fft_2ndR_start,
    
    input               fft_3rdR_config,
    output reg          fft_3rdR_start,
    
    input               fft_4thR_config,
    output reg          fft_4thR_start,
    
    output reg  [1:0]   fft_state,
    
    input               fft_0_data_ready,
    output reg          fft_0_data_valid,
    output reg          fft_0_data_last,
    output reg  [63:0]  fft_0_data_data,
    
    output reg          fft_0_result_ready,
    input               fft_0_result_valid,
    input               fft_0_result_last,
    input       [63:0]  fft_0_result_data,
    
    input               fft_1_data_ready,
    output reg          fft_1_data_valid,
    output reg          fft_1_data_last,
    output reg  [63:0]  fft_1_data_data,
    
    output reg          fft_1_result_ready,
    input               fft_1_result_valid,
    input               fft_1_result_last,
    input       [63:0]  fft_1_result_data,
    
    input               fft_2_data_ready,
    output reg          fft_2_data_valid,
    output reg          fft_2_data_last,
    output reg  [63:0]  fft_2_data_data,
    
    output reg          fft_2_result_ready,
    input               fft_2_result_valid,
    input               fft_2_result_last,
    input       [63:0]  fft_2_result_data,

    input               fft_3_data_ready,
    output reg          fft_3_data_valid,
    output reg          fft_3_data_last,
    output reg  [63:0]  fft_3_data_data,
    
    output reg          fft_3_result_ready,
    input               fft_3_result_valid,
    input               fft_3_result_last,
    input       [63:0]  fft_3_result_data,
    
    // 1stR
    output              fft_1stR_data_ready,
    input               fft_1stR_data_valid,
    input               fft_1stR_data_last,
    input       [63:0]  fft_1stR_data_data,
    
    input               fft_1stR_result_ready,
    output              fft_1stR_result_valid,
    output              fft_1stR_result_last,
    output      [63:0]  fft_1stR_result_data,
    
    // 2ndR
    output              fft_2ndR_0_data_ready,
    input               fft_2ndR_0_data_valid,
    input               fft_2ndR_0_data_last,
    input       [63:0]  fft_2ndR_0_data_data,
    
    input               fft_2ndR_0_result_ready,
    output              fft_2ndR_0_result_valid,
    output              fft_2ndR_0_result_last,
    output      [63:0]  fft_2ndR_0_result_data,
    
    output              fft_2ndR_1_data_ready,
    input               fft_2ndR_1_data_valid,
    input               fft_2ndR_1_data_last,
    input       [63:0]  fft_2ndR_1_data_data,
    
    input               fft_2ndR_1_result_ready,
    output              fft_2ndR_1_result_valid,
    output              fft_2ndR_1_result_last,
    output      [63:0]  fft_2ndR_1_result_data,

    output              fft_2ndR_2_data_ready,
    input               fft_2ndR_2_data_valid,
    input               fft_2ndR_2_data_last,
    input       [63:0]  fft_2ndR_2_data_data,
    
    input               fft_2ndR_2_result_ready,
    output              fft_2ndR_2_result_valid,
    output              fft_2ndR_2_result_last,
    output      [63:0]  fft_2ndR_2_result_data,
    
    output              fft_2ndR_3_data_ready,
    input               fft_2ndR_3_data_valid,
    input               fft_2ndR_3_data_last,
    input       [63:0]  fft_2ndR_3_data_data,
    
    input               fft_2ndR_3_result_ready,
    output              fft_2ndR_3_result_valid,
    output              fft_2ndR_3_result_last,
    output      [63:0]  fft_2ndR_3_result_data,
    
    // 3rdR
    output              fft_3rdR_0_data_ready,
    input               fft_3rdR_0_data_valid,
    input               fft_3rdR_0_data_last,
    input       [63:0]  fft_3rdR_0_data_data,

    input               fft_3rdR_0_result_ready,
    output              fft_3rdR_0_result_valid,
    output              fft_3rdR_0_result_last,
    output      [63:0]  fft_3rdR_0_result_data,

    output              fft_3rdR_1_data_ready,
    input               fft_3rdR_1_data_valid,
    input               fft_3rdR_1_data_last,
    input       [63:0]  fft_3rdR_1_data_data,

    input               fft_3rdR_1_result_ready,
    output              fft_3rdR_1_result_valid,
    output              fft_3rdR_1_result_last,
    output      [63:0]  fft_3rdR_1_result_data,

    output              fft_3rdR_2_data_ready,
    input               fft_3rdR_2_data_valid,
    input               fft_3rdR_2_data_last,
    input       [63:0]  fft_3rdR_2_data_data,

    input               fft_3rdR_2_result_ready,
    output              fft_3rdR_2_result_valid,
    output              fft_3rdR_2_result_last,
    output      [63:0]  fft_3rdR_2_result_data,

    output              fft_3rdR_3_data_ready,
    input               fft_3rdR_3_data_valid,
    input               fft_3rdR_3_data_last,
    input       [63:0]  fft_3rdR_3_data_data,

    input               fft_3rdR_3_result_ready,
    output              fft_3rdR_3_result_valid,
    output              fft_3rdR_3_result_last,
    output      [63:0]  fft_3rdR_3_result_data,
    
    // 4thR
    output              fft_4thR_0_data_ready,
    input               fft_4thR_0_data_valid,
    input               fft_4thR_0_data_last,
    input       [63:0]  fft_4thR_0_data_data,

    input               fft_4thR_0_result_ready,
    output              fft_4thR_0_result_valid,
    output              fft_4thR_0_result_last,
    output      [63:0]  fft_4thR_0_result_data,

    output              fft_4thR_1_data_ready,
    input               fft_4thR_1_data_valid,
    input               fft_4thR_1_data_last,
    input       [63:0]  fft_4thR_1_data_data,

    input               fft_4thR_1_result_ready,
    output              fft_4thR_1_result_valid,
    output              fft_4thR_1_result_last,
    output      [63:0]  fft_4thR_1_result_data,

    output              fft_4thR_2_data_ready,
    input               fft_4thR_2_data_valid,
    input               fft_4thR_2_data_last,
    input       [63:0]  fft_4thR_2_data_data,

    input               fft_4thR_2_result_ready,
    output              fft_4thR_2_result_valid,
    output              fft_4thR_2_result_last,
    output      [63:0]  fft_4thR_2_result_data,

    output              fft_4thR_3_data_ready,
    input               fft_4thR_3_data_valid,
    input               fft_4thR_3_data_last,
    input       [63:0]  fft_4thR_3_data_data,

    input               fft_4thR_3_result_ready,
    output              fft_4thR_3_result_valid,
    output              fft_4thR_3_result_last,
    output      [63:0]  fft_4thR_3_result_data
);

assign     fft_1stR_data_ready    =  (fft_state == 2'd0)? fft_0_data_ready : 1'b0;
assign     fft_1stR_result_valid  =  (fft_state == 2'd0)? fft_0_result_valid : 1'b0;
assign     fft_1stR_result_last   =  (fft_state == 2'd0)? fft_0_result_last : 1'b0;
assign     fft_1stR_result_data   =  (fft_state == 2'd0)? fft_0_result_data : 64'd0;

assign     fft_2ndR_0_data_ready    =  (fft_state == 2'd1)? fft_0_data_ready : 1'b0;
assign     fft_2ndR_0_result_valid  =  (fft_state == 2'd1)? fft_0_result_valid : 1'b0;
assign     fft_2ndR_0_result_last   =  (fft_state == 2'd1)? fft_0_result_last : 1'b0;
assign     fft_2ndR_0_result_data   =  (fft_state == 2'd1)? fft_0_result_data : 64'd0;

assign     fft_2ndR_1_data_ready    =  (fft_state == 2'd1)? fft_1_data_ready : 1'b0;
assign     fft_2ndR_1_result_valid  =  (fft_state == 2'd1)? fft_1_result_valid : 1'b0;
assign     fft_2ndR_1_result_last   =  (fft_state == 2'd1)? fft_1_result_last : 1'b0;
assign     fft_2ndR_1_result_data   =  (fft_state == 2'd1)? fft_1_result_data : 64'd0;

assign     fft_2ndR_2_data_ready    =  (fft_state == 2'd1)? fft_2_data_ready : 1'b0;
assign     fft_2ndR_2_result_valid  =  (fft_state == 2'd1)? fft_2_result_valid : 1'b0;
assign     fft_2ndR_2_result_last   =  (fft_state == 2'd1)? fft_2_result_last : 1'b0;
assign     fft_2ndR_2_result_data   =  (fft_state == 2'd1)? fft_2_result_data : 64'd0;

assign     fft_2ndR_3_data_ready    =  (fft_state == 2'd1)? fft_3_data_ready : 1'b0;
assign     fft_2ndR_3_result_valid  =  (fft_state == 2'd1)? fft_3_result_valid : 1'b0;
assign     fft_2ndR_3_result_last   =  (fft_state == 2'd1)? fft_3_result_last : 1'b0;
assign     fft_2ndR_3_result_data   =  (fft_state == 2'd1)? fft_3_result_data : 64'd0;

assign     fft_3rdR_0_data_ready    =  (fft_state == 2'd2)? fft_0_data_ready : 1'b0;
assign     fft_3rdR_0_result_valid  =  (fft_state == 2'd2)? fft_0_result_valid : 1'b0;
assign     fft_3rdR_0_result_last   =  (fft_state == 2'd2)? fft_0_result_last : 1'b0;
assign     fft_3rdR_0_result_data   =  (fft_state == 2'd2)? fft_0_result_data : 64'd0;

assign     fft_3rdR_1_data_ready    =  (fft_state == 2'd2)? fft_1_data_ready : 1'b0;
assign     fft_3rdR_1_result_valid  =  (fft_state == 2'd2)? fft_1_result_valid : 1'b0;
assign     fft_3rdR_1_result_last   =  (fft_state == 2'd2)? fft_1_result_last : 1'b0;
assign     fft_3rdR_1_result_data   =  (fft_state == 2'd2)? fft_1_result_data : 64'd0;

assign     fft_3rdR_2_data_ready    =  (fft_state == 2'd2)? fft_2_data_ready : 1'b0;
assign     fft_3rdR_2_result_valid  =  (fft_state == 2'd2)? fft_2_result_valid : 1'b0;
assign     fft_3rdR_2_result_last   =  (fft_state == 2'd2)? fft_2_result_last : 1'b0;
assign     fft_3rdR_2_result_data   =  (fft_state == 2'd2)? fft_2_result_data : 64'd0;

assign     fft_3rdR_3_data_ready    =  (fft_state == 2'd2)? fft_3_data_ready : 1'b0;
assign     fft_3rdR_3_result_valid  =  (fft_state == 2'd2)? fft_3_result_valid : 1'b0;
assign     fft_3rdR_3_result_last   =  (fft_state == 2'd2)? fft_3_result_last : 1'b0;
assign     fft_3rdR_3_result_data   =  (fft_state == 2'd2)? fft_3_result_data : 64'd0;

assign     fft_4thR_0_data_ready    =  (fft_state == 2'd3)? fft_0_data_ready : 1'b0;
assign     fft_4thR_0_result_valid  =  (fft_state == 2'd3)? fft_0_result_valid : 1'b0;
assign     fft_4thR_0_result_last   =  (fft_state == 2'd3)? fft_0_result_last : 1'b0;
assign     fft_4thR_0_result_data   =  (fft_state == 2'd3)? fft_0_result_data : 64'd0;

assign     fft_4thR_1_data_ready    =  (fft_state == 2'd3)? fft_1_data_ready : 1'b0;
assign     fft_4thR_1_result_valid  =  (fft_state == 2'd3)? fft_1_result_valid : 1'b0;
assign     fft_4thR_1_result_last   =  (fft_state == 2'd3)? fft_1_result_last : 1'b0;
assign     fft_4thR_1_result_data   =  (fft_state == 2'd3)? fft_1_result_data : 64'd0;

assign     fft_4thR_2_data_ready    =  (fft_state == 2'd3)? fft_2_data_ready : 1'b0;
assign     fft_4thR_2_result_valid  =  (fft_state == 2'd3)? fft_2_result_valid : 1'b0;
assign     fft_4thR_2_result_last   =  (fft_state == 2'd3)? fft_2_result_last : 1'b0;
assign     fft_4thR_2_result_data   =  (fft_state == 2'd3)? fft_2_result_data : 64'd0;

assign     fft_4thR_3_data_ready    =  (fft_state == 2'd3)? fft_3_data_ready : 1'b0;
assign     fft_4thR_3_result_valid  =  (fft_state == 2'd3)? fft_3_result_valid : 1'b0;
assign     fft_4thR_3_result_last   =  (fft_state == 2'd3)? fft_3_result_last : 1'b0;
assign     fft_4thR_3_result_data   =  (fft_state == 2'd3)? fft_3_result_data : 64'd0;

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_state  <=  2'd0;
    end
    else begin
        if (fft_config_start) begin
            fft_state  <=  2'd0;
        end
        else if (fft_2ndR_start) begin
            fft_state  <=  2'd1;
        end
        else if (fft_3rdR_start) begin
            fft_state  <=  2'd2;
        end
        else if (fft_4thR_start) begin
            fft_state  <=  2'd3;
        end
        else begin
            fft_state  <=  fft_state;
        end
    end
end

always @(*) begin
    case (fft_state)
        2'd0: begin
            fft_0_data_valid    =  fft_1stR_data_valid;
            fft_0_data_last     =  fft_1stR_data_last;
            fft_0_data_data     =  fft_1stR_data_data;
            fft_0_result_ready  =  fft_1stR_result_ready;
            
            fft_1_data_valid    =  1'b0;
            fft_1_data_last     =  1'b0;
            fft_1_data_data     =  64'd0;
            fft_1_result_ready  =  1'b0;

            fft_2_data_valid    =  1'b0;
            fft_2_data_last     =  1'b0;
            fft_2_data_data     =  64'd0;
            fft_2_result_ready  =  1'b0;

            fft_3_data_valid    =  1'b0;
            fft_3_data_last     =  1'b0;
            fft_3_data_data     =  64'd0;
            fft_3_result_ready  =  1'b0;
        end
        2'd1: begin
            fft_0_data_valid    =  fft_2ndR_0_data_valid;
            fft_0_data_last     =  fft_2ndR_0_data_last;
            fft_0_data_data     =  fft_2ndR_0_data_data;
            fft_0_result_ready  =  fft_2ndR_0_result_ready;

            fft_1_data_valid    =  fft_2ndR_1_data_valid;
            fft_1_data_last     =  fft_2ndR_1_data_last;
            fft_1_data_data     =  fft_2ndR_1_data_data;
            fft_1_result_ready  =  fft_2ndR_1_result_ready;

            fft_2_data_valid    =  fft_2ndR_2_data_valid;
            fft_2_data_last     =  fft_2ndR_2_data_last;
            fft_2_data_data     =  fft_2ndR_2_data_data;
            fft_2_result_ready  =  fft_2ndR_2_result_ready;

            fft_3_data_valid    =  fft_2ndR_3_data_valid;
            fft_3_data_last     =  fft_2ndR_3_data_last;
            fft_3_data_data     =  fft_2ndR_3_data_data;
            fft_3_result_ready  =  fft_2ndR_3_result_ready;
        end
        2'd2: begin
            fft_0_data_valid    =  fft_3rdR_0_data_valid;
            fft_0_data_last     =  fft_3rdR_0_data_last;
            fft_0_data_data     =  fft_3rdR_0_data_data;
            fft_0_result_ready  =  fft_3rdR_0_result_ready;

            fft_1_data_valid    =  fft_3rdR_1_data_valid;
            fft_1_data_last     =  fft_3rdR_1_data_last;
            fft_1_data_data     =  fft_3rdR_1_data_data;
            fft_1_result_ready  =  fft_3rdR_1_result_ready;

            fft_2_data_valid    =  fft_3rdR_2_data_valid;
            fft_2_data_last     =  fft_3rdR_2_data_last;
            fft_2_data_data     =  fft_3rdR_2_data_data;
            fft_2_result_ready  =  fft_3rdR_2_result_ready;

            fft_3_data_valid    =  fft_3rdR_3_data_valid;
            fft_3_data_last     =  fft_3rdR_3_data_last;
            fft_3_data_data     =  fft_3rdR_3_data_data;
            fft_3_result_ready  =  fft_3rdR_3_result_ready;
        end
        2'd3: begin
            fft_0_data_valid    =  fft_4thR_0_data_valid;
            fft_0_data_last     =  fft_4thR_0_data_last;
            fft_0_data_data     =  fft_4thR_0_data_data;
            fft_0_result_ready  =  fft_4thR_0_result_ready;

            fft_1_data_valid    =  fft_4thR_1_data_valid;
            fft_1_data_last     =  fft_4thR_1_data_last;
            fft_1_data_data     =  fft_4thR_1_data_data;
            fft_1_result_ready  =  fft_4thR_1_result_ready;

            fft_2_data_valid    =  fft_4thR_2_data_valid;
            fft_2_data_last     =  fft_4thR_2_data_last;
            fft_2_data_data     =  fft_4thR_2_data_data;
            fft_2_result_ready  =  fft_4thR_2_result_ready;

            fft_3_data_valid    =  fft_4thR_3_data_valid;
            fft_3_data_last     =  fft_4thR_3_data_last;
            fft_3_data_data     =  fft_4thR_3_data_data;
            fft_3_result_ready  =  fft_4thR_3_result_ready;
        end
        default: begin
            fft_0_data_valid    =  fft_1stR_data_valid;
            fft_0_data_last     =  fft_1stR_data_last;
            fft_0_data_data     =  fft_1stR_data_data;
            fft_0_result_ready  =  fft_1stR_result_ready;

            fft_1_data_valid    =  1'b0;
            fft_1_data_last     =  1'b0;
            fft_1_data_data     =  64'd0;
            fft_1_result_ready  =  1'b0;

            fft_2_data_valid    =  1'b0;
            fft_2_data_last     =  1'b0;
            fft_2_data_data     =  64'd0;
            fft_2_result_ready  =  1'b0;

            fft_3_data_valid    =  1'b0;
            fft_3_data_last     =  1'b0;
            fft_3_data_data     =  64'd0;
            fft_3_result_ready  =  1'b0;
        end
    endcase
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_config_valid  <=  1'b0;
    end
    else begin
        if (fft_config_start) begin
            fft_config_valid  <=  1'b1;
        end
        else if (fft_2ndR_config) begin
            fft_config_valid  <=  1'b1;
        end
        else if (fft_3rdR_config) begin
            fft_config_valid  <=  1'b1;
        end
        else if (fft_4thR_config) begin
            fft_config_valid  <=  1'b1;
        end
        else begin
            fft_config_valid  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_config_data  <=  16'd0;
    end
    else begin
        if (fft_config_start) begin
            fft_config_data  <=  16'd1; //2B
        end
        else if (fft_2ndR_config) begin
            fft_config_data  <=  16'd1; //B5
        end
        else if (fft_3rdR_config) begin
            fft_config_data  <=  16'd0; //0A
        end
        else if (fft_4thR_config) begin
            fft_config_data  <=  16'd0; //2A
        end
        else begin
            fft_config_data  <=  16'd0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_2ndR_start  <=  1'b0;
    end
    else begin
        if (fft_2ndR_config) begin
            fft_2ndR_start  <=  1'b1;
        end
        else begin
            fft_2ndR_start  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_3rdR_start  <=  1'b0;
    end
    else begin
        if (fft_3rdR_config) begin
            fft_3rdR_start  <=  1'b1;
        end
        else begin
            fft_3rdR_start  <=  1'b0;
        end
    end
end

always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (~s_axi_aresetn) begin
        fft_4thR_start  <=  1'b0;
    end
    else begin
        if (fft_4thR_config) begin
            fft_4thR_start  <=  1'b1;
        end
        else begin
            fft_4thR_start  <=  1'b0;
        end
    end
end

endmodule
