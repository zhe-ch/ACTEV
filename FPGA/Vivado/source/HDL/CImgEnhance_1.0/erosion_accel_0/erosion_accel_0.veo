// (c) Copyright 1995-2019 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.

// IP VLNV: xilinx.com:hls:erosion_accel:1.0
// IP Revision: 1908311446

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
erosion_accel_0 your_instance_name (
  .out_r_ap_vld(out_r_ap_vld),  // output wire out_r_ap_vld
  .ap_clk(ap_clk),              // input wire ap_clk
  .ap_rst(ap_rst),              // input wire ap_rst
  .ap_start(ap_start),          // input wire ap_start
  .ap_done(ap_done),            // output wire ap_done
  .ap_idle(ap_idle),            // output wire ap_idle
  .ap_ready(ap_ready),          // output wire ap_ready
  .init(init),                  // input wire [0 : 0] init
  .in0(in0),                    // input wire [7 : 0] in0
  .in1(in1),                    // input wire [7 : 0] in1
  .in2(in2),                    // input wire [7 : 0] in2
  .in3(in3),                    // input wire [7 : 0] in3
  .in4(in4),                    // input wire [7 : 0] in4
  .in5(in5),                    // input wire [7 : 0] in5
  .in6(in6),                    // input wire [7 : 0] in6
  .in7(in7),                    // input wire [7 : 0] in7
  .in8(in8),                    // input wire [7 : 0] in8
  .in9(in9),                    // input wire [7 : 0] in9
  .in10(in10),                  // input wire [7 : 0] in10
  .in11(in11),                  // input wire [7 : 0] in11
  .in12(in12),                  // input wire [7 : 0] in12
  .in13(in13),                  // input wire [7 : 0] in13
  .in14(in14),                  // input wire [7 : 0] in14
  .in15(in15),                  // input wire [7 : 0] in15
  .in16(in16),                  // input wire [7 : 0] in16
  .in17(in17),                  // input wire [7 : 0] in17
  .in18(in18),                  // input wire [7 : 0] in18
  .out_r(out_r)                // output wire [7 : 0] out_r
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file erosion_accel_0.v when simulating
// the core, erosion_accel_0. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.

