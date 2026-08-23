
`timescale 1 ns / 1 ps

	module CImgProcCtrl_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 5
	)
	(
		// Users to add ports here
		output           sensor_state,
		output           start_record,
		output           sensor_set_virtual,
		output           upd_template_begin,
		input            upd_template_end,

        output  [9:0]    crop_row_start,
        output  [9:0]    crop_row_end,
        output  [10:0]   crop_col_start,
        output  [10:0]   crop_col_end,

        output  [9:0]    roi_row_start,
        output  [9:0]    roi_col_start,

        output  [13:0]   buffer_size,

		input            motion_extract_end,
		input   [13:0]   max_corr_addr,
		
		input            miss_state,
		// User ports ends
		// Do not modify the ports beyond this line

		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
	
	// Add user logic here
	wire      miss_state_sync;
	
	// synchronize frame valid
    synchronize_bit U_miss_state_sync(
        .clock(s00_axi_aclk),
        .reset_n(s00_axi_aresetn),
        .datain(miss_state),
        .result(miss_state_sync)
    );
	
	CImgProcCtrl_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) CImgProcCtrl_v1_0_S00_AXI_inst (
	
	    .sensor_state(sensor_state),
	    .start_record(start_record),
	    .sensor_set_virtual(sensor_set_virtual),
	    .upd_template_begin(upd_template_begin),
	    .upd_template_end(upd_template_end),
	    
	    .crop_row_start(crop_row_start),
	    .crop_row_end(crop_row_end),
	    .crop_col_start(crop_col_start),
	    .crop_col_end(crop_col_end),
	    
	    .roi_row_start(roi_row_start),
	    .roi_col_start(roi_col_start),
	    
	    .buffer_size(buffer_size),
	    
	    .motion_extract_end(motion_extract_end),
	    .max_corr_addr(max_corr_addr),
	
	    .miss_state(miss_state_sync),
	
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

	// User logic ends

	endmodule
