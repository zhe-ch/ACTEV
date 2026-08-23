
`timescale 1 ns / 1 ps

	module preMCfilter_v1_0
	(
		// Users to add ports here
        input            pixclk,
        input            reset,

        input            s_axi_aclk,
        input            s_axi_aresetn,

        input   [9:0]    roi_row_start,
        input   [9:0]    roi_col_start,

        input            upd_template_begin,
        input            upd_template_end,
        output           template_mode,

        input   [7:0]    sensor_din,

        input            frame_begin,
        input            line_begin,

        input            frame_state,
        input            line_state,

        output           fft_config_start,

        output           filbuf_wren,
        output  [13:0]   filbuf_wraddr,
        output  [31:0]   filbuf_wrdata,
        
        input            tml_bram_clk,
        input            tml_bram_rst,
        input            tml_bram_ena,
        input   [3:0]    tml_bram_wea,
        input   [31:0]   tml_bram_addr,
        input   [31:0]   tml_bram_din,
        output  [31:0]   tml_bram_dout
		// User ports ends
	);

	// Add user logic here
	wire             filter_begin;
	wire             filbuf_wready;
	
	wire             rowbuf_rden;
	wire   [7:0]     rowbuf_rdaddr;
	wire   [7:0]     rowbuf_rddata;
	
	wire   [7:0]     rowbuf_img_rddata;
	wire   [7:0]     rowbuf_tml_rddata;
	
	assign           rowbuf_rddata = template_mode ? rowbuf_tml_rddata : rowbuf_img_rddata;
	
	wire             tml_buf_rden;
	wire   [14:0]    tml_buf_rdaddr;
	wire   [31:0]    tml_buf_rddata;
	
	wire             img_rowbuf_wren;
	wire   [7:0]     img_rowbuf_wraddr;
	wire   [7:0]     img_rowbuf_wrdata;
	
	wire             tml_rowbuf_wren;
	wire   [7:0]     tml_rowbuf_wraddr;
	wire   [7:0]     tml_rowbuf_wrdata;
	
	assign           tml_bram_dout  =  32'd0;
	
	preMCfilter_ctrl U_preMCfilter_ctrl(
	    .pixclk(pixclk),
	    .reset_n(~reset),
	    
	    .s_axi_aclk(s_axi_aclk),
	    .s_axi_aresetn(s_axi_aresetn),
	    
	    .roi_row_start(roi_row_start),
	    .roi_col_start(roi_col_start),
	    
	    .upd_template_begin(upd_template_begin),
	    .upd_template_end(upd_template_end),
	    .template_mode(template_mode),
	    
	    .sensor_din(sensor_din),
	    
	    .frame_begin(frame_begin),
	    .line_begin(line_begin),
	    
	    .frame_state(frame_state),
	    .line_state(line_state),
	    
	    .tml_buf_rden(tml_buf_rden),
	    .tml_buf_rdaddr(tml_buf_rdaddr),
	    .tml_buf_rddata(tml_buf_rddata),
	    
	    .img_rowbuf_wren(img_rowbuf_wren),
	    .img_rowbuf_wraddr(img_rowbuf_wraddr),
	    .img_rowbuf_wrdata(img_rowbuf_wrdata),
	    
	    .tml_rowbuf_wren(tml_rowbuf_wren),
	    .tml_rowbuf_wraddr(tml_rowbuf_wraddr),
	    .tml_rowbuf_wrdata(tml_rowbuf_wrdata),
	    
	    .filter_begin(filter_begin),
	    .filbuf_wready(filbuf_wready),
	    
	    .fft_config_start(fft_config_start)
	);
	
    contrast_filter U_contrast_filter(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
    
        .filter_begin(filter_begin),
        .filbuf_wready(filbuf_wready),
    
        .rowbuf_rden(rowbuf_rden),
        .rowbuf_rdaddr(rowbuf_rdaddr),
        .rowbuf_rddata(rowbuf_rddata),
    
        .filbuf_wren(filbuf_wren),
        .filbuf_wraddr(filbuf_wraddr),
        .filbuf_wrdata(filbuf_wrdata)
    );

    blk_mem_roi_rowbuf U_blk_mem_roi_img_rowbuf(
        .clka(pixclk),
        .ena(img_rowbuf_wren),
        .wea(1'b1),
        .addra(img_rowbuf_wraddr),
        .dina(img_rowbuf_wrdata),
        .clkb(s_axi_aclk),
        .enb(rowbuf_rden),
        .addrb(rowbuf_rdaddr),
        .doutb(rowbuf_img_rddata)
    );

    blk_mem_roi_rowbuf U_blk_mem_roi_tml_rowbuf(
        .clka(s_axi_aclk),
        .ena(tml_rowbuf_wren),
        .wea(1'b1),
        .addra(tml_rowbuf_wraddr),
        .dina(tml_rowbuf_wrdata),
        .clkb(s_axi_aclk),
        .enb(rowbuf_rden),
        .addrb(rowbuf_rdaddr),
        .doutb(rowbuf_tml_rddata)
    );
    
    blk_mem_tml_buf U_blk_mem_tml_buf(
        .clka(tml_bram_clk),
        .ena(tml_bram_ena),
        .wea(tml_bram_wea),
        .addra(tml_bram_addr),
        .dina(tml_bram_din),
        .clkb(s_axi_aclk),
        .enb(tml_buf_rden),
        .addrb({17'd0, tml_buf_rdaddr}),
        .doutb(tml_buf_rddata)
    );
	// User logic ends

	endmodule
