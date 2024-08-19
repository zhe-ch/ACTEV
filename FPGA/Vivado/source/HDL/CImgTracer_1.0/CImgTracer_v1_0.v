
`timescale 1 ns / 1 ps

	module CImgTracer_v1_0
	(
		// Users to add ports here
        input                   s_axi_aclk,
        input                   s_axi_aresetn,

        input                   load_start,
        output                  store_end,

        input                   enh_ds_ena,
        input      [7:0]        enh_ds_row,
        input      [8:0]        enh_ds_col,
        input      [7:0]        enh_ds_data,

        input                   flash_ena,
        input      [7:0]        flash_row,
        input      [8:0]        flash_col,
        input                   flash_state,
        input      [15:0]       flash_data,

        output                  ns_flash_ena,
        output     [7:0]        ns_flash_row,
        output     [8:0]        ns_flash_col,
        output                  ns_flash_state,
        output     [15:0]       ns_flash_data,

        input                   bram_clk,
        input                   bram_rst,
        input                   bram_ena,
        input      [3:0]        bram_wea,
        input      [31:0]       bram_addr,
        input      [31:0]       bram_din,
        output     [31:0]       bram_dout
		// User ports ends
	);
	// Add user logic here

    wire          load_center;
    wire  [7:0]   center_row;
    wire  [8:0]   center_col;

    wire  [7:0]   shared_enh_ds_row  =  load_center? center_row : enh_ds_row;
    wire  [8:0]   shared_enh_ds_col  =  load_center? center_col : enh_ds_col;

    wire          contour_rden;
    wire          load_contour;
    wire          contour_data;

    wire          store_start;
    wire          store_trace;
    wire  [15:0]  acc_trace;

    wire          s1_enh_ds_ena;
    wire  [7:0]   s1_enh_ds_row;
    wire  [8:0]   s1_enh_ds_col;
    wire  [7:0]   s1_enh_ds_data;
    
    wire          s2_enh_ds_ena;
    wire  [7:0]   s2_enh_ds_row;
    wire  [8:0]   s2_enh_ds_col;
    wire  [7:0]   s2_enh_ds_data;

    wire          s3_enh_ds_ena;
    wire  [7:0]   s3_enh_ds_row;
    wire  [8:0]   s3_enh_ds_col;
    wire  [7:0]   s3_enh_ds_data;

    wire          s4_enh_ds_ena;
    wire  [7:0]   s4_enh_ds_row;
    wire  [8:0]   s4_enh_ds_col;
    wire  [7:0]   s4_enh_ds_data;
    
    wire          s5_enh_ds_ena;
    wire  [7:0]   s5_enh_ds_row;
    wire  [8:0]   s5_enh_ds_col;
    wire  [7:0]   s5_enh_ds_data;

    wire          s6_enh_ds_ena;
    wire  [7:0]   s6_enh_ds_row;
    wire  [8:0]   s6_enh_ds_col;
    wire  [7:0]   s6_enh_ds_data;

    wire          s7_enh_ds_ena;
    wire  [7:0]   s7_enh_ds_row;
    wire  [8:0]   s7_enh_ds_col;
    wire  [7:0]   s7_enh_ds_data;

    wire          s8_enh_ds_ena;
    wire  [7:0]   s8_enh_ds_row;
    wire  [8:0]   s8_enh_ds_col;
    wire  [7:0]   s8_enh_ds_data;

    wire          s1_contour_data;
    wire          s2_contour_data;
    wire          s3_contour_data;
    wire          s4_contour_data;
    wire          s5_contour_data;
    wire          s6_contour_data;
    wire          s7_contour_data;
    wire          s8_contour_data;

    wire  [15:0]  s1_acc_trace;
    wire  [15:0]  s2_acc_trace;
    wire  [15:0]  s3_acc_trace;
    wire  [15:0]  s4_acc_trace;
    wire  [15:0]  s5_acc_trace;
    wire  [15:0]  s6_acc_trace;
    wire  [15:0]  s7_acc_trace;

    wire          tracer_buf_en;
    wire  [3:0]   tracer_buf_we;
    wire  [31:0]  tracer_buf_addr;
    wire  [31:0]  tracer_buf_din;
    wire  [31:0]  tracer_buf_dout;

    wire          s1_flash_ena;
    wire  [7:0]   s1_flash_row;
    wire  [8:0]   s1_flash_col;
    wire          s1_flash_state;
    wire  [15:0]  s1_flash_data;
    
    wire          s2_flash_ena;
    wire  [7:0]   s2_flash_row;
    wire  [8:0]   s2_flash_col;
    wire          s2_flash_state;
    wire  [15:0]  s2_flash_data;

    wire          s3_flash_ena;
    wire  [7:0]   s3_flash_row;
    wire  [8:0]   s3_flash_col;
    wire          s3_flash_state;
    wire  [15:0]  s3_flash_data;

    wire          s4_flash_ena;
    wire  [7:0]   s4_flash_row;
    wire  [8:0]   s4_flash_col;
    wire          s4_flash_state;
    wire  [15:0]  s4_flash_data;

    wire          s5_flash_ena;
    wire  [7:0]   s5_flash_row;
    wire  [8:0]   s5_flash_col;
    wire          s5_flash_state;
    wire  [15:0]  s5_flash_data;

    wire          s6_flash_ena;
    wire  [7:0]   s6_flash_row;
    wire  [8:0]   s6_flash_col;
    wire          s6_flash_state;
    wire  [15:0]  s6_flash_data;

    wire          s7_flash_ena;
    wire  [7:0]   s7_flash_row;
    wire  [8:0]   s7_flash_col;
    wire          s7_flash_state;
    wire  [15:0]  s7_flash_data;

    tracer_load_ctrl U_tracer_load_ctrl(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),

        .load_start(load_start),
        .store_start(store_start),
        .store_end(store_end),

        .enh_ds_last_row(s8_enh_ds_row),
        .enh_ds_last_col(s8_enh_ds_col),
        
        .load_center(load_center),
        .center_row(center_row),
        .center_col(center_col),
        
        .contour_rden(contour_rden),
        .load_contour(load_contour),
        .contour_data(contour_data),
        
        .store_trace(store_trace),
        .acc_trace(acc_trace),
        
        .tracer_buf_en(tracer_buf_en),
        .tracer_buf_we(tracer_buf_we),
        .tracer_buf_addr(tracer_buf_addr),
        .tracer_buf_din(tracer_buf_din),
        .tracer_buf_dout(tracer_buf_dout)
    );

    blk_mem_tracer_buf U_blk_mem_tracer_buf(
        .clka(s_axi_aclk),
        .rsta(~s_axi_aresetn),
        .ena(tracer_buf_en),
        .wea(tracer_buf_we),
        .addra(tracer_buf_addr),
        .dina(tracer_buf_din),
        .douta(tracer_buf_dout),
        .clkb(bram_clk),
        .rstb(bram_rst),
        .enb(bram_ena),
        .web(bram_wea),
        .addrb(bram_addr),
        .dinb(bram_din),
        .doutb(bram_dout)
    );

    tracer_segment U_tracer_segment_1(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),

        .load_center(load_center),

        .contour_rden(contour_rden),
        .load_contour(load_contour),
        .contour_data(contour_data),
        .ns_contour_data(s1_contour_data),

        .store_trace(store_trace),
        .ps_acc_trace(16'd0),
        .acc_trace(s1_acc_trace),
        
        .enh_ds_ena(enh_ds_ena),
        .enh_ds_row(shared_enh_ds_row),
        .enh_ds_col(shared_enh_ds_col),
        .enh_ds_data(enh_ds_data),

        .ns_enh_ds_ena(s1_enh_ds_ena),
        .ns_enh_ds_row(s1_enh_ds_row),
        .ns_enh_ds_col(s1_enh_ds_col),
        .ns_enh_ds_data(s1_enh_ds_data),
        
        .flash_ena(flash_ena),
        .flash_row(flash_row),
        .flash_col(flash_col),
        .flash_state(flash_state),
        .flash_data(flash_data),
        
        .ns_flash_ena(s1_flash_ena),
        .ns_flash_row(s1_flash_row),
        .ns_flash_col(s1_flash_col),
        .ns_flash_state(s1_flash_state),
        .ns_flash_data(s1_flash_data)
    );

    tracer_segment U_tracer_segment_2(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        
        .load_center(load_center),
        
        .contour_rden(contour_rden),
        .load_contour(load_contour),
        .contour_data(s1_contour_data),
        .ns_contour_data(s2_contour_data),
        
        .store_trace(store_trace),
        .ps_acc_trace(s1_acc_trace),
        .acc_trace(s2_acc_trace),
        
        .enh_ds_ena(s1_enh_ds_ena),
        .enh_ds_row(s1_enh_ds_row),
        .enh_ds_col(s1_enh_ds_col),
        .enh_ds_data(s1_enh_ds_data),
        
        .ns_enh_ds_ena(s2_enh_ds_ena),
        .ns_enh_ds_row(s2_enh_ds_row),
        .ns_enh_ds_col(s2_enh_ds_col),
        .ns_enh_ds_data(s2_enh_ds_data),
        
        .flash_ena(s1_flash_ena),
        .flash_row(s1_flash_row),
        .flash_col(s1_flash_col),
        .flash_state(s1_flash_state),
        .flash_data(s1_flash_data),
        
        .ns_flash_ena(s2_flash_ena),
        .ns_flash_row(s2_flash_row),
        .ns_flash_col(s2_flash_col),
        .ns_flash_state(s2_flash_state),
        .ns_flash_data(s2_flash_data)
    );

    tracer_segment U_tracer_segment_3(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),

        .load_center(load_center),

        .contour_rden(contour_rden),
        .load_contour(load_contour),
        .contour_data(s2_contour_data),
        .ns_contour_data(s3_contour_data),

        .store_trace(store_trace),       
        .ps_acc_trace(s2_acc_trace),
        .acc_trace(s3_acc_trace),
        
        .enh_ds_ena(s2_enh_ds_ena),
        .enh_ds_row(s2_enh_ds_row),
        .enh_ds_col(s2_enh_ds_col),
        .enh_ds_data(s2_enh_ds_data),
        
        .ns_enh_ds_ena(s3_enh_ds_ena),
        .ns_enh_ds_row(s3_enh_ds_row),
        .ns_enh_ds_col(s3_enh_ds_col),
        .ns_enh_ds_data(s3_enh_ds_data),
        
        .flash_ena(s2_flash_ena),
        .flash_row(s2_flash_row),
        .flash_col(s2_flash_col),
        .flash_state(s2_flash_state),
        .flash_data(s2_flash_data),
        
        .ns_flash_ena(s3_flash_ena),
        .ns_flash_row(s3_flash_row),
        .ns_flash_col(s3_flash_col),
        .ns_flash_state(s3_flash_state),
        .ns_flash_data(s3_flash_data)
    );

    tracer_segment U_tracer_segment_4(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        
        .load_center(load_center),

        .contour_rden(contour_rden),
        .load_contour(load_contour),
        .contour_data(s3_contour_data),
        .ns_contour_data(s4_contour_data),

        .store_trace(store_trace),        
        .ps_acc_trace(s3_acc_trace),
        .acc_trace(s4_acc_trace),
        
        .enh_ds_ena(s3_enh_ds_ena),
        .enh_ds_row(s3_enh_ds_row),
        .enh_ds_col(s3_enh_ds_col),
        .enh_ds_data(s3_enh_ds_data),
        
        .ns_enh_ds_ena(s4_enh_ds_ena),
        .ns_enh_ds_row(s4_enh_ds_row),
        .ns_enh_ds_col(s4_enh_ds_col),
        .ns_enh_ds_data(s4_enh_ds_data),

        .flash_ena(s3_flash_ena),
        .flash_row(s3_flash_row),
        .flash_col(s3_flash_col),
        .flash_state(s3_flash_state),
        .flash_data(s3_flash_data),
        
        .ns_flash_ena(s4_flash_ena),
        .ns_flash_row(s4_flash_row),
        .ns_flash_col(s4_flash_col),
        .ns_flash_state(s4_flash_state),
        .ns_flash_data(s4_flash_data)
    );

    tracer_segment U_tracer_segment_5(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        
        .load_center(load_center),

        .contour_rden(contour_rden),
        .load_contour(load_contour),
        .contour_data(s4_contour_data),
        .ns_contour_data(s5_contour_data),

        .store_trace(store_trace),
        .ps_acc_trace(s4_acc_trace),
        .acc_trace(s5_acc_trace),
        
        .enh_ds_ena(s4_enh_ds_ena),
        .enh_ds_row(s4_enh_ds_row),
        .enh_ds_col(s4_enh_ds_col),
        .enh_ds_data(s4_enh_ds_data),
        
        .ns_enh_ds_ena(s5_enh_ds_ena),
        .ns_enh_ds_row(s5_enh_ds_row),
        .ns_enh_ds_col(s5_enh_ds_col),
        .ns_enh_ds_data(s5_enh_ds_data),

        .flash_ena(s4_flash_ena),
        .flash_row(s4_flash_row),
        .flash_col(s4_flash_col),
        .flash_state(s4_flash_state),
        .flash_data(s4_flash_data),
        
        .ns_flash_ena(s5_flash_ena),
        .ns_flash_row(s5_flash_row),
        .ns_flash_col(s5_flash_col),
        .ns_flash_state(s5_flash_state),
        .ns_flash_data(s5_flash_data)
    );

    tracer_segment U_tracer_segment_6(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        
        .load_center(load_center),

        .contour_rden(contour_rden),
        .load_contour(load_contour),
        .contour_data(s5_contour_data),
        .ns_contour_data(s6_contour_data),

        .store_trace(store_trace),
        .ps_acc_trace(s5_acc_trace),
        .acc_trace(s6_acc_trace),
        
        .enh_ds_ena(s5_enh_ds_ena),
        .enh_ds_row(s5_enh_ds_row),
        .enh_ds_col(s5_enh_ds_col),
        .enh_ds_data(s5_enh_ds_data),
        
        .ns_enh_ds_ena(s6_enh_ds_ena),
        .ns_enh_ds_row(s6_enh_ds_row),
        .ns_enh_ds_col(s6_enh_ds_col),
        .ns_enh_ds_data(s6_enh_ds_data),

        .flash_ena(s5_flash_ena),
        .flash_row(s5_flash_row),
        .flash_col(s5_flash_col),
        .flash_state(s5_flash_state),
        .flash_data(s5_flash_data),
        
        .ns_flash_ena(s6_flash_ena),
        .ns_flash_row(s6_flash_row),
        .ns_flash_col(s6_flash_col),
        .ns_flash_state(s6_flash_state),
        .ns_flash_data(s6_flash_data)
    );

    tracer_segment U_tracer_segment_7(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        
        .load_center(load_center),

        .contour_rden(contour_rden),
        .load_contour(load_contour),
        .contour_data(s6_contour_data),
        .ns_contour_data(s7_contour_data),

        .store_trace(store_trace),
        .ps_acc_trace(s6_acc_trace),
        .acc_trace(s7_acc_trace),
        
        .enh_ds_ena(s6_enh_ds_ena),
        .enh_ds_row(s6_enh_ds_row),
        .enh_ds_col(s6_enh_ds_col),
        .enh_ds_data(s6_enh_ds_data),
        
        .ns_enh_ds_ena(s7_enh_ds_ena),
        .ns_enh_ds_row(s7_enh_ds_row),
        .ns_enh_ds_col(s7_enh_ds_col),
        .ns_enh_ds_data(s7_enh_ds_data),

        .flash_ena(s6_flash_ena),
        .flash_row(s6_flash_row),
        .flash_col(s6_flash_col),
        .flash_state(s6_flash_state),
        .flash_data(s6_flash_data),
        
        .ns_flash_ena(s7_flash_ena),
        .ns_flash_row(s7_flash_row),
        .ns_flash_col(s7_flash_col),
        .ns_flash_state(s7_flash_state),
        .ns_flash_data(s7_flash_data)
    );

    tracer_segment U_tracer_segment_8(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        
        .load_center(load_center),

        .contour_rden(contour_rden),
        .load_contour(load_contour),
        .contour_data(s7_contour_data),
        .ns_contour_data(s8_contour_data),

        .store_trace(store_trace),        
        .ps_acc_trace(s7_acc_trace),
        .acc_trace(acc_trace),
        
        .enh_ds_ena(s7_enh_ds_ena),
        .enh_ds_row(s7_enh_ds_row),
        .enh_ds_col(s7_enh_ds_col),
        .enh_ds_data(s7_enh_ds_data),

        .ns_enh_ds_ena(s8_enh_ds_ena),
        .ns_enh_ds_row(s8_enh_ds_row),
        .ns_enh_ds_col(s8_enh_ds_col),
        .ns_enh_ds_data(s8_enh_ds_data),

        .flash_ena(s7_flash_ena),
        .flash_row(s7_flash_row),
        .flash_col(s7_flash_col),
        .flash_state(s7_flash_state),
        .flash_data(s7_flash_data),
        
        .ns_flash_ena(ns_flash_ena),
        .ns_flash_row(ns_flash_row),
        .ns_flash_col(ns_flash_col),
        .ns_flash_state(ns_flash_state),
        .ns_flash_data(ns_flash_data)
    );

	// User logic ends

	endmodule
