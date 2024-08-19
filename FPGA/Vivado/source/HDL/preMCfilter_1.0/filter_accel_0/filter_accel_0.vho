-- (c) Copyright 1995-2020 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:hls:filter_accel:1.0
-- IP Revision: 2010092331

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT filter_accel_0
  PORT (
    out_r_ap_vld : OUT STD_LOGIC;
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in3 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in4 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in5 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in7 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in8 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in9 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in10 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in11 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in12 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in13 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in14 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in15 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    in16 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    out_r : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : filter_accel_0
  PORT MAP (
    out_r_ap_vld => out_r_ap_vld,
    ap_clk => ap_clk,
    ap_rst => ap_rst,
    ap_start => ap_start,
    ap_done => ap_done,
    ap_idle => ap_idle,
    ap_ready => ap_ready,
    in0 => in0,
    in1 => in1,
    in2 => in2,
    in3 => in3,
    in4 => in4,
    in5 => in5,
    in6 => in6,
    in7 => in7,
    in8 => in8,
    in9 => in9,
    in10 => in10,
    in11 => in11,
    in12 => in12,
    in13 => in13,
    in14 => in14,
    in15 => in15,
    in16 => in16,
    out_r => out_r
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file filter_accel_0.vhd when simulating
-- the core, filter_accel_0. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.

