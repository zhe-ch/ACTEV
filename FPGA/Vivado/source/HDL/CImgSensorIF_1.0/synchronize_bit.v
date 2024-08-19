`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2019 05:29:16 PM
// Design Name: 
// Module Name: synchronize_bit
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


module synchronize_bit(
    input           clock,
    input           datain,
    output          result
);
    
reg   stage_1_reg;
reg   stage_2_reg;

assign    result  =  stage_2_reg;

always @(posedge clock) begin
    stage_1_reg  <=  datain;
end

always @(posedge clock) begin
    stage_2_reg  <=  stage_1_reg;
end

endmodule
