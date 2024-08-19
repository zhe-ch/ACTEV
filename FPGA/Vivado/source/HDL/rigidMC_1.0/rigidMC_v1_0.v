
`timescale 1 ns / 1 ps

	module rigidMC_v1_0
	(
		// Users to add ports here
		input                fft_config_start,
		
        input                template_mode,
        output               upd_template_end,
        
        output               motion_extract_end,
        output       [13:0]  max_corr_addr,
        
        input                filbuf_wren,
        input        [13:0]  filbuf_wraddr,
        input        [31:0]  filbuf_wrdata,
        
        output               fft_config_valid,
        output       [15:0]  fft_config_data,
        
        input                fft_0_data_ready,
        output               fft_0_data_valid,
        output               fft_0_data_last,
        output       [63:0]  fft_0_data_data,
        
        output               fft_0_result_ready,
        input                fft_0_result_valid,
        input                fft_0_result_last,
        input        [63:0]  fft_0_result_data,
        
        input                fft_1_data_ready,
        output               fft_1_data_valid,
        output               fft_1_data_last,
        output       [63:0]  fft_1_data_data,
        
        output               fft_1_result_ready,
        input                fft_1_result_valid,
        input                fft_1_result_last,
        input        [63:0]  fft_1_result_data,
        
        input                fft_2_data_ready,
        output               fft_2_data_valid,
        output               fft_2_data_last,
        output       [63:0]  fft_2_data_data,
        
        output               fft_2_result_ready,
        input                fft_2_result_valid,
        input                fft_2_result_last,
        input        [63:0]  fft_2_result_data,
        
        input                fft_3_data_ready,
        output               fft_3_data_valid,
        output               fft_3_data_last,
        output       [63:0]  fft_3_data_data,
        
        output               fft_3_result_ready,
        input                fft_3_result_valid,
        input                fft_3_result_last,
        input        [63:0]  fft_3_result_data,
        
        input                s_axi_aclk,
		input                s_axi_aresetn
		// User ports ends
	);
	
	// Add user logic here
	wire          fft_2ndR_config;
	wire          fft_2ndR_start;
	wire          fft_3rdR_config;
	wire          fft_3rdR_start;
	wire          fft_4thR_config;
	wire          fft_4thR_start;
	
	wire  [1:0]   fft_state;
	
	wire          roi_bram_0_wren;
	wire  [11:0]  roi_bram_0_wraddr;
	wire  [63:0]  roi_bram_0_wrdata;
	wire          roi_bram_0_rden;
	wire  [11:0]  roi_bram_0_rdaddr;
	wire  [63:0]  roi_bram_0_rddata;
	
	wire          roi_bram_1_wren;
    wire  [11:0]  roi_bram_1_wraddr;
    wire  [63:0]  roi_bram_1_wrdata;
    wire          roi_bram_1_rden;
    wire  [11:0]  roi_bram_1_rdaddr;
    wire  [63:0]  roi_bram_1_rddata;
	
	wire          roi_bram_2_wren;
    wire  [11:0]  roi_bram_2_wraddr;
    wire  [63:0]  roi_bram_2_wrdata;
    wire          roi_bram_2_rden;
    wire  [11:0]  roi_bram_2_rdaddr;
    wire  [63:0]  roi_bram_2_rddata;
	
	wire          roi_bram_3_wren;
    wire  [11:0]  roi_bram_3_wraddr;
    wire  [63:0]  roi_bram_3_wrdata;
    wire          roi_bram_3_rden;
    wire  [11:0]  roi_bram_3_rdaddr;
    wire  [63:0]  roi_bram_3_rddata;

	// 1stR
	wire          fft_1stR_data_ready;
	wire          fft_1stR_data_valid;
	wire          fft_1stR_data_last;
	wire  [63:0]  fft_1stR_data_data;
	
	wire          fft_1stR_result_ready;
	wire          fft_1stR_result_valid;
	wire          fft_1stR_result_last;
	wire  [63:0]  fft_1stR_result_data;
	
	wire          roi_bram_1stR_0_wren;
	wire  [11:0]  roi_bram_1stR_0_wraddr;
	wire  [63:0]  roi_bram_1stR_0_wrdata;
	
	wire          roi_bram_1stR_1_wren;
    wire  [11:0]  roi_bram_1stR_1_wraddr;
    wire  [63:0]  roi_bram_1stR_1_wrdata;

	wire          roi_bram_1stR_2_wren;
	wire  [11:0]  roi_bram_1stR_2_wraddr;
	wire  [63:0]  roi_bram_1stR_2_wrdata;

	wire          roi_bram_1stR_3_wren;
	wire  [11:0]  roi_bram_1stR_3_wraddr;
	wire  [63:0]  roi_bram_1stR_3_wrdata;
	
	// 2ndR
	wire          fft_2ndR_0_data_ready;
    wire          fft_2ndR_0_data_valid;
    wire          fft_2ndR_0_data_last;
    wire  [63:0]  fft_2ndR_0_data_data;

	wire          fft_2ndR_0_result_ready;
    wire          fft_2ndR_0_result_valid;
    wire          fft_2ndR_0_result_last;
    wire  [63:0]  fft_2ndR_0_result_data;

    wire          fft_2ndR_1_data_ready;
	wire          fft_2ndR_1_data_valid;
    wire          fft_2ndR_1_data_last;
    wire  [63:0]  fft_2ndR_1_data_data;

    wire          fft_2ndR_1_result_ready;
    wire          fft_2ndR_1_result_valid;
    wire          fft_2ndR_1_result_last;
    wire  [63:0]  fft_2ndR_1_result_data;

    wire          fft_2ndR_2_data_ready;
	wire          fft_2ndR_2_data_valid;
    wire          fft_2ndR_2_data_last;
    wire  [63:0]  fft_2ndR_2_data_data;

    wire          fft_2ndR_2_result_ready;
    wire          fft_2ndR_2_result_valid;
    wire          fft_2ndR_2_result_last;
    wire  [63:0]  fft_2ndR_2_result_data;

    wire          fft_2ndR_3_data_ready;
	wire          fft_2ndR_3_data_valid;
    wire          fft_2ndR_3_data_last;
    wire  [63:0]  fft_2ndR_3_data_data;

    wire          fft_2ndR_3_result_ready;
    wire          fft_2ndR_3_result_valid;
    wire          fft_2ndR_3_result_last;
    wire  [63:0]  fft_2ndR_3_result_data;

	wire          roi_bram_2ndR_0_wren;
	wire  [11:0]  roi_bram_2ndR_0_wraddr;
	wire  [31:0]  roi_bram_2ndR_0_wrdata;
	wire          roi_bram_2ndR_0_rden;
	wire  [11:0]  roi_bram_2ndR_0_rdaddr;
	wire  [63:0]  roi_bram_2ndR_0_rddata;
	
	wire          roi_bram_2ndR_1_wren;
    wire  [11:0]  roi_bram_2ndR_1_wraddr;
    wire  [31:0]  roi_bram_2ndR_1_wrdata;
    wire          roi_bram_2ndR_1_rden;
    wire  [11:0]  roi_bram_2ndR_1_rdaddr;
    wire  [63:0]  roi_bram_2ndR_1_rddata;

	wire          roi_bram_2ndR_2_wren;
	wire  [11:0]  roi_bram_2ndR_2_wraddr;
	wire  [31:0]  roi_bram_2ndR_2_wrdata;
	wire          roi_bram_2ndR_2_rden;
	wire  [11:0]  roi_bram_2ndR_2_rdaddr;
	wire  [63:0]  roi_bram_2ndR_2_rddata;

	wire          roi_bram_2ndR_3_wren;
	wire  [11:0]  roi_bram_2ndR_3_wraddr;
	wire  [31:0]  roi_bram_2ndR_3_wrdata;
	wire          roi_bram_2ndR_3_rden;
	wire  [11:0]  roi_bram_2ndR_3_rdaddr;
	wire  [63:0]  roi_bram_2ndR_3_rddata;
    
	// 3rdR
	wire          fft_3rdR_0_data_ready;
    wire          fft_3rdR_0_data_valid;
    wire          fft_3rdR_0_data_last;
    wire  [63:0]  fft_3rdR_0_data_data;

    wire          fft_3rdR_0_result_ready;
    wire          fft_3rdR_0_result_valid;
    wire          fft_3rdR_0_result_last;
    wire  [63:0]  fft_3rdR_0_result_data;

    wire          fft_3rdR_1_data_ready;
    wire          fft_3rdR_1_data_valid;
    wire          fft_3rdR_1_data_last;
    wire  [63:0]  fft_3rdR_1_data_data;

    wire          fft_3rdR_1_result_ready;
    wire          fft_3rdR_1_result_valid;
    wire          fft_3rdR_1_result_last;
    wire  [63:0]  fft_3rdR_1_result_data;

    wire          fft_3rdR_2_data_ready;
    wire          fft_3rdR_2_data_valid;
    wire          fft_3rdR_2_data_last;
    wire  [63:0]  fft_3rdR_2_data_data;

    wire          fft_3rdR_2_result_ready;
    wire          fft_3rdR_2_result_valid;
    wire          fft_3rdR_2_result_last;
    wire  [63:0]  fft_3rdR_2_result_data;

    wire          fft_3rdR_3_data_ready;
    wire          fft_3rdR_3_data_valid;
    wire          fft_3rdR_3_data_last;
    wire  [63:0]  fft_3rdR_3_data_data;

    wire          fft_3rdR_3_result_ready;
    wire          fft_3rdR_3_result_valid;
    wire          fft_3rdR_3_result_last;
    wire  [63:0]  fft_3rdR_3_result_data;

    wire          roi_bram_3rdR_0_wren;
    wire  [11:0]  roi_bram_3rdR_0_wraddr;
    wire  [63:0]  roi_bram_3rdR_0_wrdata;
    wire          roi_bram_3rdR_0_rden;
    wire  [11:0]  roi_bram_3rdR_0_rdaddr;
    wire  [31:0]  roi_bram_3rdR_0_rddata;
    
    wire          roi_bram_3rdR_1_wren;
    wire  [11:0]  roi_bram_3rdR_1_wraddr;
    wire  [63:0]  roi_bram_3rdR_1_wrdata;
    wire          roi_bram_3rdR_1_rden;
    wire  [11:0]  roi_bram_3rdR_1_rdaddr;
    wire  [31:0]  roi_bram_3rdR_1_rddata;

    wire          roi_bram_3rdR_2_wren;
    wire  [11:0]  roi_bram_3rdR_2_wraddr;
    wire  [63:0]  roi_bram_3rdR_2_wrdata;
    wire          roi_bram_3rdR_2_rden;
    wire  [11:0]  roi_bram_3rdR_2_rdaddr;
    wire  [31:0]  roi_bram_3rdR_2_rddata;

    wire          roi_bram_3rdR_3_wren;
    wire  [11:0]  roi_bram_3rdR_3_wraddr;
    wire  [63:0]  roi_bram_3rdR_3_wrdata;
    wire          roi_bram_3rdR_3_rden;
    wire  [11:0]  roi_bram_3rdR_3_rdaddr;
    wire  [31:0]  roi_bram_3rdR_3_rddata;
	
	// 4thR
	wire          fft_4thR_0_data_ready;
    wire          fft_4thR_0_data_valid;
    wire          fft_4thR_0_data_last;
    wire  [63:0]  fft_4thR_0_data_data;

    wire          fft_4thR_0_result_ready;
    wire          fft_4thR_0_result_valid;
    wire          fft_4thR_0_result_last;
    wire  [63:0]  fft_4thR_0_result_data;

    wire          fft_4thR_1_data_ready;
    wire          fft_4thR_1_data_valid;
    wire          fft_4thR_1_data_last;
    wire  [63:0]  fft_4thR_1_data_data;

    wire          fft_4thR_1_result_ready;
    wire          fft_4thR_1_result_valid;
    wire          fft_4thR_1_result_last;
    wire  [63:0]  fft_4thR_1_result_data;

    wire          fft_4thR_2_data_ready;
    wire          fft_4thR_2_data_valid;
    wire          fft_4thR_2_data_last;
    wire  [63:0]  fft_4thR_2_data_data;

    wire          fft_4thR_2_result_ready;
    wire          fft_4thR_2_result_valid;
    wire          fft_4thR_2_result_last;
    wire  [63:0]  fft_4thR_2_result_data;

    wire          fft_4thR_3_data_ready;
    wire          fft_4thR_3_data_valid;
    wire          fft_4thR_3_data_last;
    wire  [63:0]  fft_4thR_3_data_data;

    wire          fft_4thR_3_result_ready;
    wire          fft_4thR_3_result_valid;
    wire          fft_4thR_3_result_last;
    wire  [63:0]  fft_4thR_3_result_data;

    wire          roi_bram_4thR_0_wren;
    wire  [11:0]  roi_bram_4thR_0_wraddr;
    wire  [63:0]  roi_bram_4thR_0_wrdata;
    wire          roi_bram_4thR_0_rden;
    wire  [11:0]  roi_bram_4thR_0_rdaddr;
    wire  [63:0]  roi_bram_4thR_0_rddata;
    
    wire          roi_bram_4thR_1_wren;
    wire  [11:0]  roi_bram_4thR_1_wraddr;
    wire  [63:0]  roi_bram_4thR_1_wrdata;
    wire          roi_bram_4thR_1_rden;
    wire  [11:0]  roi_bram_4thR_1_rdaddr;
    wire  [63:0]  roi_bram_4thR_1_rddata;

    wire          roi_bram_4thR_2_wren;
    wire  [11:0]  roi_bram_4thR_2_wraddr;
    wire  [63:0]  roi_bram_4thR_2_wrdata;
    wire          roi_bram_4thR_2_rden;
    wire  [11:0]  roi_bram_4thR_2_rdaddr;
    wire  [63:0]  roi_bram_4thR_2_rddata;

    wire          roi_bram_4thR_3_wren;
    wire  [11:0]  roi_bram_4thR_3_wraddr;
    wire  [63:0]  roi_bram_4thR_3_wrdata;
    wire          roi_bram_4thR_3_rden;
    wire  [11:0]  roi_bram_4thR_3_rdaddr;
    wire  [63:0]  roi_bram_4thR_3_rddata;

    wire          tml_bram_0_wren;
    wire  [11:0]  tml_bram_0_wraddr;
    wire  [31:0]  tml_bram_0_wrdata;
    wire          tml_bram_0_rden;
    wire  [11:0]  tml_bram_0_rdaddr;
    wire  [31:0]  tml_bram_0_rddata;
    
    wire          tml_bram_1_wren;
    wire  [11:0]  tml_bram_1_wraddr;
    wire  [31:0]  tml_bram_1_wrdata;
    wire          tml_bram_1_rden;
    wire  [11:0]  tml_bram_1_rdaddr;
    wire  [31:0]  tml_bram_1_rddata;

    wire          tml_bram_2_wren;
    wire  [11:0]  tml_bram_2_wraddr;
    wire  [31:0]  tml_bram_2_wrdata;
    wire          tml_bram_2_rden;
    wire  [11:0]  tml_bram_2_rdaddr;
    wire  [31:0]  tml_bram_2_rddata;

    wire          tml_bram_3_wren;
    wire  [11:0]  tml_bram_3_wraddr;
    wire  [31:0]  tml_bram_3_wrdata;
    wire          tml_bram_3_rden;
    wire  [11:0]  tml_bram_3_rdaddr;
    wire  [31:0]  tml_bram_3_rddata;

    fft_ctrl U_fft_ctrl(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),

        .fft_config_start(fft_config_start),

        .fft_config_valid(fft_config_valid),
        .fft_config_data(fft_config_data),

        .fft_2ndR_config(fft_2ndR_config),
        .fft_2ndR_start(fft_2ndR_start),

        .fft_3rdR_config(fft_3rdR_config),
        .fft_3rdR_start(fft_3rdR_start),

        .fft_4thR_config(fft_4thR_config),
        .fft_4thR_start(fft_4thR_start),

        .fft_state(fft_state),

        .fft_0_data_ready(fft_0_data_ready),
        .fft_0_data_valid(fft_0_data_valid),
        .fft_0_data_last(fft_0_data_last),
        .fft_0_data_data(fft_0_data_data),

        .fft_0_result_ready(fft_0_result_ready),
        .fft_0_result_valid(fft_0_result_valid),
        .fft_0_result_last(fft_0_result_last),
        .fft_0_result_data(fft_0_result_data),

        .fft_1_data_ready(fft_1_data_ready),
        .fft_1_data_valid(fft_1_data_valid),
        .fft_1_data_last(fft_1_data_last),
        .fft_1_data_data(fft_1_data_data),

        .fft_1_result_ready(fft_1_result_ready),
        .fft_1_result_valid(fft_1_result_valid),
        .fft_1_result_last(fft_1_result_last),
        .fft_1_result_data(fft_1_result_data),

        .fft_2_data_ready(fft_2_data_ready),
        .fft_2_data_valid(fft_2_data_valid),
        .fft_2_data_last(fft_2_data_last),
        .fft_2_data_data(fft_2_data_data),

        .fft_2_result_ready(fft_2_result_ready),
        .fft_2_result_valid(fft_2_result_valid),
        .fft_2_result_last(fft_2_result_last),
        .fft_2_result_data(fft_2_result_data),

        .fft_3_data_ready(fft_3_data_ready),
        .fft_3_data_valid(fft_3_data_valid),
        .fft_3_data_last(fft_3_data_last),
        .fft_3_data_data(fft_3_data_data),
        
        .fft_3_result_ready(fft_3_result_ready),
        .fft_3_result_valid(fft_3_result_valid),
        .fft_3_result_last(fft_3_result_last),
        .fft_3_result_data(fft_3_result_data),
        
        // 1stR
        .fft_1stR_data_ready(fft_1stR_data_ready),
        .fft_1stR_data_valid(fft_1stR_data_valid),
        .fft_1stR_data_last(fft_1stR_data_last),
        .fft_1stR_data_data(fft_1stR_data_data),
        
        .fft_1stR_result_ready(fft_1stR_result_ready),
        .fft_1stR_result_valid(fft_1stR_result_valid),
        .fft_1stR_result_last(fft_1stR_result_last),
        .fft_1stR_result_data(fft_1stR_result_data),
        
        // 2ndR
        .fft_2ndR_0_data_ready(fft_2ndR_0_data_ready),
        .fft_2ndR_0_data_valid(fft_2ndR_0_data_valid),
        .fft_2ndR_0_data_last(fft_2ndR_0_data_last),
        .fft_2ndR_0_data_data(fft_2ndR_0_data_data),
        
        .fft_2ndR_0_result_ready(fft_2ndR_0_result_ready),
        .fft_2ndR_0_result_valid(fft_2ndR_0_result_valid),
        .fft_2ndR_0_result_last(fft_2ndR_0_result_last),
        .fft_2ndR_0_result_data(fft_2ndR_0_result_data),
        
        .fft_2ndR_1_data_ready(fft_2ndR_1_data_ready),
        .fft_2ndR_1_data_valid(fft_2ndR_1_data_valid),
        .fft_2ndR_1_data_last(fft_2ndR_1_data_last),
        .fft_2ndR_1_data_data(fft_2ndR_1_data_data),
        
        .fft_2ndR_1_result_ready(fft_2ndR_1_result_ready),
        .fft_2ndR_1_result_valid(fft_2ndR_1_result_valid),
        .fft_2ndR_1_result_last(fft_2ndR_1_result_last),
        .fft_2ndR_1_result_data(fft_2ndR_1_result_data),
        
        .fft_2ndR_2_data_ready(fft_2ndR_2_data_ready),
        .fft_2ndR_2_data_valid(fft_2ndR_2_data_valid),
        .fft_2ndR_2_data_last(fft_2ndR_2_data_last),
        .fft_2ndR_2_data_data(fft_2ndR_2_data_data),
        
        .fft_2ndR_2_result_ready(fft_2ndR_2_result_ready),
        .fft_2ndR_2_result_valid(fft_2ndR_2_result_valid),
        .fft_2ndR_2_result_last(fft_2ndR_2_result_last),
        .fft_2ndR_2_result_data(fft_2ndR_2_result_data),

        .fft_2ndR_3_data_ready(fft_2ndR_3_data_ready),
        .fft_2ndR_3_data_valid(fft_2ndR_3_data_valid),
        .fft_2ndR_3_data_last(fft_2ndR_3_data_last),
        .fft_2ndR_3_data_data(fft_2ndR_3_data_data),
        
        .fft_2ndR_3_result_ready(fft_2ndR_3_result_ready),
        .fft_2ndR_3_result_valid(fft_2ndR_3_result_valid),
        .fft_2ndR_3_result_last(fft_2ndR_3_result_last),
        .fft_2ndR_3_result_data(fft_2ndR_3_result_data),
        
        // 3rdR
        .fft_3rdR_0_data_ready(fft_3rdR_0_data_ready),
        .fft_3rdR_0_data_valid(fft_3rdR_0_data_valid),
        .fft_3rdR_0_data_last(fft_3rdR_0_data_last),
        .fft_3rdR_0_data_data(fft_3rdR_0_data_data),

        .fft_3rdR_0_result_ready(fft_3rdR_0_result_ready),
        .fft_3rdR_0_result_valid(fft_3rdR_0_result_valid),
        .fft_3rdR_0_result_last(fft_3rdR_0_result_last),
        .fft_3rdR_0_result_data(fft_3rdR_0_result_data),

        .fft_3rdR_1_data_ready(fft_3rdR_1_data_ready),
        .fft_3rdR_1_data_valid(fft_3rdR_1_data_valid),
        .fft_3rdR_1_data_last(fft_3rdR_1_data_last),
        .fft_3rdR_1_data_data(fft_3rdR_1_data_data),

        .fft_3rdR_1_result_ready(fft_3rdR_1_result_ready),
        .fft_3rdR_1_result_valid(fft_3rdR_1_result_valid),
        .fft_3rdR_1_result_last(fft_3rdR_1_result_last),
        .fft_3rdR_1_result_data(fft_3rdR_1_result_data),

        .fft_3rdR_2_data_ready(fft_3rdR_2_data_ready),
        .fft_3rdR_2_data_valid(fft_3rdR_2_data_valid),
        .fft_3rdR_2_data_last(fft_3rdR_2_data_last),
        .fft_3rdR_2_data_data(fft_3rdR_2_data_data),

        .fft_3rdR_2_result_ready(fft_3rdR_2_result_ready),
        .fft_3rdR_2_result_valid(fft_3rdR_2_result_valid),
        .fft_3rdR_2_result_last(fft_3rdR_2_result_last),
        .fft_3rdR_2_result_data(fft_3rdR_2_result_data),

        .fft_3rdR_3_data_ready(fft_3rdR_3_data_ready),
        .fft_3rdR_3_data_valid(fft_3rdR_3_data_valid),
        .fft_3rdR_3_data_last(fft_3rdR_3_data_last),
        .fft_3rdR_3_data_data(fft_3rdR_3_data_data),

        .fft_3rdR_3_result_ready(fft_3rdR_3_result_ready),
        .fft_3rdR_3_result_valid(fft_3rdR_3_result_valid),
        .fft_3rdR_3_result_last(fft_3rdR_3_result_last),
        .fft_3rdR_3_result_data(fft_3rdR_3_result_data),
        
        // 4thR
        .fft_4thR_0_data_ready(fft_4thR_0_data_ready),
        .fft_4thR_0_data_valid(fft_4thR_0_data_valid),
        .fft_4thR_0_data_last(fft_4thR_0_data_last),
        .fft_4thR_0_data_data(fft_4thR_0_data_data),
        
        .fft_4thR_0_result_ready(fft_4thR_0_result_ready),
        .fft_4thR_0_result_valid(fft_4thR_0_result_valid),
        .fft_4thR_0_result_last(fft_4thR_0_result_last),
        .fft_4thR_0_result_data(fft_4thR_0_result_data),
        
        .fft_4thR_1_data_ready(fft_4thR_1_data_ready),
        .fft_4thR_1_data_valid(fft_4thR_1_data_valid),
        .fft_4thR_1_data_last(fft_4thR_1_data_last),
        .fft_4thR_1_data_data(fft_4thR_1_data_data),
        
        .fft_4thR_1_result_ready(fft_4thR_1_result_ready),
        .fft_4thR_1_result_valid(fft_4thR_1_result_valid),
        .fft_4thR_1_result_last(fft_4thR_1_result_last),
        .fft_4thR_1_result_data(fft_4thR_1_result_data),
        
        .fft_4thR_2_data_ready(fft_4thR_2_data_ready),
        .fft_4thR_2_data_valid(fft_4thR_2_data_valid),
        .fft_4thR_2_data_last(fft_4thR_2_data_last),
        .fft_4thR_2_data_data(fft_4thR_2_data_data),
        
        .fft_4thR_2_result_ready(fft_4thR_2_result_ready),
        .fft_4thR_2_result_valid(fft_4thR_2_result_valid),
        .fft_4thR_2_result_last(fft_4thR_2_result_last),
        .fft_4thR_2_result_data(fft_4thR_2_result_data),

        .fft_4thR_3_data_ready(fft_4thR_3_data_ready),
        .fft_4thR_3_data_valid(fft_4thR_3_data_valid),
        .fft_4thR_3_data_last(fft_4thR_3_data_last),
        .fft_4thR_3_data_data(fft_4thR_3_data_data),
        
        .fft_4thR_3_result_ready(fft_4thR_3_result_ready),
        .fft_4thR_3_result_valid(fft_4thR_3_result_valid),
        .fft_4thR_3_result_last(fft_4thR_3_result_last),
        .fft_4thR_3_result_data(fft_4thR_3_result_data)
    );

    fft_1stR_ctrl U_fft_1stR_ctrl(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),

        .fft_2ndR_config(fft_2ndR_config),
        
        .fft_data_ready(fft_1stR_data_ready),
        .fft_data_valid(fft_1stR_data_valid),
        .fft_data_last(fft_1stR_data_last),
        .fft_data_data(fft_1stR_data_data),
        
        .fft_result_ready(fft_1stR_result_ready),
        .fft_result_valid(fft_1stR_result_valid),
        .fft_result_last(fft_1stR_result_last),
        .fft_result_data(fft_1stR_result_data),
        
        .filbuf_wren(filbuf_wren),
        .filbuf_wraddr(filbuf_wraddr),
        .filbuf_wrdata(filbuf_wrdata),
        
        .roi_bram_0_wren(roi_bram_1stR_0_wren),
        .roi_bram_0_wraddr(roi_bram_1stR_0_wraddr),
        .roi_bram_0_wrdata(roi_bram_1stR_0_wrdata),
        
        .roi_bram_1_wren(roi_bram_1stR_1_wren),
        .roi_bram_1_wraddr(roi_bram_1stR_1_wraddr),
        .roi_bram_1_wrdata(roi_bram_1stR_1_wrdata),

        .roi_bram_2_wren(roi_bram_1stR_2_wren),
        .roi_bram_2_wraddr(roi_bram_1stR_2_wraddr),
        .roi_bram_2_wrdata(roi_bram_1stR_2_wrdata),

        .roi_bram_3_wren(roi_bram_1stR_3_wren),
        .roi_bram_3_wraddr(roi_bram_1stR_3_wraddr),
        .roi_bram_3_wrdata(roi_bram_1stR_3_wrdata)
    );

    fft_2ndR_ctrl U_fft_2ndR_ctrl(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        
        .fft_2ndR_start(fft_2ndR_start),
        .fft_3rdR_config(fft_3rdR_config),

        .template_mode(template_mode),
        .upd_template_end(upd_template_end),

        .fft_0_data_ready(fft_2ndR_0_data_ready),
        .fft_0_data_valid(fft_2ndR_0_data_valid),
        .fft_0_data_last(fft_2ndR_0_data_last),
        .fft_0_data_data(fft_2ndR_0_data_data),

        .fft_0_result_ready(fft_2ndR_0_result_ready),
        .fft_0_result_valid(fft_2ndR_0_result_valid),
        .fft_0_result_last(fft_2ndR_0_result_last),
        .fft_0_result_data(fft_2ndR_0_result_data),

        .fft_1_data_ready(fft_2ndR_1_data_ready),
        .fft_1_data_valid(fft_2ndR_1_data_valid),
        .fft_1_data_last(fft_2ndR_1_data_last),
        .fft_1_data_data(fft_2ndR_1_data_data),

        .fft_1_result_ready(fft_2ndR_1_result_ready),
        .fft_1_result_valid(fft_2ndR_1_result_valid),
        .fft_1_result_last(fft_2ndR_1_result_last),
        .fft_1_result_data(fft_2ndR_1_result_data),

        .fft_2_data_ready(fft_2ndR_2_data_ready),
        .fft_2_data_valid(fft_2ndR_2_data_valid),
        .fft_2_data_last(fft_2ndR_2_data_last),
        .fft_2_data_data(fft_2ndR_2_data_data),

        .fft_2_result_ready(fft_2ndR_2_result_ready),
        .fft_2_result_valid(fft_2ndR_2_result_valid),
        .fft_2_result_last(fft_2ndR_2_result_last),
        .fft_2_result_data(fft_2ndR_2_result_data),

        .fft_3_data_ready(fft_2ndR_3_data_ready),
        .fft_3_data_valid(fft_2ndR_3_data_valid),
        .fft_3_data_last(fft_2ndR_3_data_last),
        .fft_3_data_data(fft_2ndR_3_data_data),

        .fft_3_result_ready(fft_2ndR_3_result_ready),
        .fft_3_result_valid(fft_2ndR_3_result_valid),
        .fft_3_result_last(fft_2ndR_3_result_last),
        .fft_3_result_data(fft_2ndR_3_result_data),

        .roi_bram_0_wren(roi_bram_2ndR_0_wren),
        .roi_bram_0_wraddr(roi_bram_2ndR_0_wraddr),
        .roi_bram_0_wrdata(roi_bram_2ndR_0_wrdata),
        .roi_bram_0_rden(roi_bram_2ndR_0_rden),
        .roi_bram_0_rdaddr(roi_bram_2ndR_0_rdaddr),
        .roi_bram_0_rddata(roi_bram_2ndR_0_rddata),

        .roi_bram_1_wren(roi_bram_2ndR_1_wren),
        .roi_bram_1_wraddr(roi_bram_2ndR_1_wraddr),
        .roi_bram_1_wrdata(roi_bram_2ndR_1_wrdata),
        .roi_bram_1_rden(roi_bram_2ndR_1_rden),
        .roi_bram_1_rdaddr(roi_bram_2ndR_1_rdaddr),
        .roi_bram_1_rddata(roi_bram_2ndR_1_rddata),

        .roi_bram_2_wren(roi_bram_2ndR_2_wren),
        .roi_bram_2_wraddr(roi_bram_2ndR_2_wraddr),
        .roi_bram_2_wrdata(roi_bram_2ndR_2_wrdata),
        .roi_bram_2_rden(roi_bram_2ndR_2_rden),
        .roi_bram_2_rdaddr(roi_bram_2ndR_2_rdaddr),
        .roi_bram_2_rddata(roi_bram_2ndR_2_rddata),

        .roi_bram_3_wren(roi_bram_2ndR_3_wren),
        .roi_bram_3_wraddr(roi_bram_2ndR_3_wraddr),
        .roi_bram_3_wrdata(roi_bram_2ndR_3_wrdata),
        .roi_bram_3_rden(roi_bram_2ndR_3_rden),
        .roi_bram_3_rdaddr(roi_bram_2ndR_3_rdaddr),
        .roi_bram_3_rddata(roi_bram_2ndR_3_rddata),
        
        .tml_bram_0_wren(tml_bram_0_wren),
        .tml_bram_0_wraddr(tml_bram_0_wraddr),
        .tml_bram_0_wrdata(tml_bram_0_wrdata),
        
        .tml_bram_1_wren(tml_bram_1_wren),
        .tml_bram_1_wraddr(tml_bram_1_wraddr),
        .tml_bram_1_wrdata(tml_bram_1_wrdata),
        
        .tml_bram_2_wren(tml_bram_2_wren),
        .tml_bram_2_wraddr(tml_bram_2_wraddr),
        .tml_bram_2_wrdata(tml_bram_2_wrdata),
        
        .tml_bram_3_wren(tml_bram_3_wren),
        .tml_bram_3_wraddr(tml_bram_3_wraddr),
        .tml_bram_3_wrdata(tml_bram_3_wrdata)
    );

    fft_3rdR_ctrl U_fft_3rdR_ctrl(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),

        .fft_3rdR_start(fft_3rdR_start),
        .fft_4thR_config(fft_4thR_config),

        .fft_0_data_ready(fft_3rdR_0_data_ready),
        .fft_0_data_valid(fft_3rdR_0_data_valid),
        .fft_0_data_last(fft_3rdR_0_data_last),
        .fft_0_data_data(fft_3rdR_0_data_data),

        .fft_0_result_ready(fft_3rdR_0_result_ready),
        .fft_0_result_valid(fft_3rdR_0_result_valid),
        .fft_0_result_last(fft_3rdR_0_result_last),
        .fft_0_result_data(fft_3rdR_0_result_data),

        .fft_1_data_ready(fft_3rdR_1_data_ready),
        .fft_1_data_valid(fft_3rdR_1_data_valid),
        .fft_1_data_last(fft_3rdR_1_data_last),
        .fft_1_data_data(fft_3rdR_1_data_data),

        .fft_1_result_ready(fft_3rdR_1_result_ready),
        .fft_1_result_valid(fft_3rdR_1_result_valid),
        .fft_1_result_last(fft_3rdR_1_result_last),
        .fft_1_result_data(fft_3rdR_1_result_data),

        .fft_2_data_ready(fft_3rdR_2_data_ready),
        .fft_2_data_valid(fft_3rdR_2_data_valid),
        .fft_2_data_last(fft_3rdR_2_data_last),
        .fft_2_data_data(fft_3rdR_2_data_data),

        .fft_2_result_ready(fft_3rdR_2_result_ready),
        .fft_2_result_valid(fft_3rdR_2_result_valid),
        .fft_2_result_last(fft_3rdR_2_result_last),
        .fft_2_result_data(fft_3rdR_2_result_data),

        .fft_3_data_ready(fft_3rdR_3_data_ready),
        .fft_3_data_valid(fft_3rdR_3_data_valid),
        .fft_3_data_last(fft_3rdR_3_data_last),
        .fft_3_data_data(fft_3rdR_3_data_data),

        .fft_3_result_ready(fft_3rdR_3_result_ready),
        .fft_3_result_valid(fft_3rdR_3_result_valid),
        .fft_3_result_last(fft_3rdR_3_result_last),
        .fft_3_result_data(fft_3rdR_3_result_data),

        .roi_bram_0_wren(roi_bram_3rdR_0_wren),
        .roi_bram_0_wraddr(roi_bram_3rdR_0_wraddr),
        .roi_bram_0_wrdata(roi_bram_3rdR_0_wrdata),
        .roi_bram_0_rden(roi_bram_3rdR_0_rden),
        .roi_bram_0_rdaddr(roi_bram_3rdR_0_rdaddr),
        .roi_bram_0_rddata(roi_bram_3rdR_0_rddata),

        .roi_bram_1_wren(roi_bram_3rdR_1_wren),
        .roi_bram_1_wraddr(roi_bram_3rdR_1_wraddr),
        .roi_bram_1_wrdata(roi_bram_3rdR_1_wrdata),
        .roi_bram_1_rden(roi_bram_3rdR_1_rden),
        .roi_bram_1_rdaddr(roi_bram_3rdR_1_rdaddr),
        .roi_bram_1_rddata(roi_bram_3rdR_1_rddata),

        .roi_bram_2_wren(roi_bram_3rdR_2_wren),
        .roi_bram_2_wraddr(roi_bram_3rdR_2_wraddr),
        .roi_bram_2_wrdata(roi_bram_3rdR_2_wrdata),
        .roi_bram_2_rden(roi_bram_3rdR_2_rden),
        .roi_bram_2_rdaddr(roi_bram_3rdR_2_rdaddr),
        .roi_bram_2_rddata(roi_bram_3rdR_2_rddata),

        .roi_bram_3_wren(roi_bram_3rdR_3_wren),
        .roi_bram_3_wraddr(roi_bram_3rdR_3_wraddr),
        .roi_bram_3_wrdata(roi_bram_3rdR_3_wrdata),
        .roi_bram_3_rden(roi_bram_3rdR_3_rden),
        .roi_bram_3_rdaddr(roi_bram_3rdR_3_rdaddr),
        .roi_bram_3_rddata(roi_bram_3rdR_3_rddata),
        
        .tml_bram_0_rden(tml_bram_0_rden),
        .tml_bram_0_rdaddr(tml_bram_0_rdaddr),
        .tml_bram_0_rddata(tml_bram_0_rddata),
        
        .tml_bram_1_rden(tml_bram_1_rden),
        .tml_bram_1_rdaddr(tml_bram_1_rdaddr),
        .tml_bram_1_rddata(tml_bram_1_rddata),
        
        .tml_bram_2_rden(tml_bram_2_rden),
        .tml_bram_2_rdaddr(tml_bram_2_rdaddr),
        .tml_bram_2_rddata(tml_bram_2_rddata),
        
        .tml_bram_3_rden(tml_bram_3_rden),
        .tml_bram_3_rdaddr(tml_bram_3_rdaddr),
        .tml_bram_3_rddata(tml_bram_3_rddata)
    );

    fft_4thR_ctrl U_fft_4thR_ctrl(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),

        .fft_4thR_start(fft_4thR_start),
        
        .motion_extract_end(motion_extract_end),
        .max_corr_addr(max_corr_addr),

        .fft_0_data_ready(fft_4thR_0_data_ready),
        .fft_0_data_valid(fft_4thR_0_data_valid),
        .fft_0_data_last(fft_4thR_0_data_last),
        .fft_0_data_data(fft_4thR_0_data_data),

        .fft_0_result_ready(fft_4thR_0_result_ready),
        .fft_0_result_valid(fft_4thR_0_result_valid),
        .fft_0_result_last(fft_4thR_0_result_last),
        .fft_0_result_data(fft_4thR_0_result_data),

        .fft_1_data_ready(fft_4thR_1_data_ready),
        .fft_1_data_valid(fft_4thR_1_data_valid),
        .fft_1_data_last(fft_4thR_1_data_last),
        .fft_1_data_data(fft_4thR_1_data_data),

        .fft_1_result_ready(fft_4thR_1_result_ready),
        .fft_1_result_valid(fft_4thR_1_result_valid),
        .fft_1_result_last(fft_4thR_1_result_last),
        .fft_1_result_data(fft_4thR_1_result_data),

        .fft_2_data_ready(fft_4thR_2_data_ready),
        .fft_2_data_valid(fft_4thR_2_data_valid),
        .fft_2_data_last(fft_4thR_2_data_last),
        .fft_2_data_data(fft_4thR_2_data_data),

        .fft_2_result_ready(fft_4thR_2_result_ready),
        .fft_2_result_valid(fft_4thR_2_result_valid),
        .fft_2_result_last(fft_4thR_2_result_last),
        .fft_2_result_data(fft_4thR_2_result_data),

        .fft_3_data_ready(fft_4thR_3_data_ready),
        .fft_3_data_valid(fft_4thR_3_data_valid),
        .fft_3_data_last(fft_4thR_3_data_last),
        .fft_3_data_data(fft_4thR_3_data_data),

        .fft_3_result_ready(fft_4thR_3_result_ready),
        .fft_3_result_valid(fft_4thR_3_result_valid),
        .fft_3_result_last(fft_4thR_3_result_last),
        .fft_3_result_data(fft_4thR_3_result_data),

        .roi_bram_0_wren(roi_bram_4thR_0_wren),
        .roi_bram_0_wraddr(roi_bram_4thR_0_wraddr),
        .roi_bram_0_wrdata(roi_bram_4thR_0_wrdata),
        .roi_bram_0_rden(roi_bram_4thR_0_rden),
        .roi_bram_0_rdaddr(roi_bram_4thR_0_rdaddr),
        .roi_bram_0_rddata(roi_bram_4thR_0_rddata),

        .roi_bram_1_wren(roi_bram_4thR_1_wren),
        .roi_bram_1_wraddr(roi_bram_4thR_1_wraddr),
        .roi_bram_1_wrdata(roi_bram_4thR_1_wrdata),
        .roi_bram_1_rden(roi_bram_4thR_1_rden),
        .roi_bram_1_rdaddr(roi_bram_4thR_1_rdaddr),
        .roi_bram_1_rddata(roi_bram_4thR_1_rddata),

        .roi_bram_2_wren(roi_bram_4thR_2_wren),
        .roi_bram_2_wraddr(roi_bram_4thR_2_wraddr),
        .roi_bram_2_wrdata(roi_bram_4thR_2_wrdata),
        .roi_bram_2_rden(roi_bram_4thR_2_rden),
        .roi_bram_2_rdaddr(roi_bram_4thR_2_rdaddr),
        .roi_bram_2_rddata(roi_bram_4thR_2_rddata),

        .roi_bram_3_wren(roi_bram_4thR_3_wren),
        .roi_bram_3_wraddr(roi_bram_4thR_3_wraddr),
        .roi_bram_3_wrdata(roi_bram_4thR_3_wrdata),
        .roi_bram_3_rden(roi_bram_4thR_3_rden),
        .roi_bram_3_rdaddr(roi_bram_4thR_3_rdaddr),
        .roi_bram_3_rddata(roi_bram_4thR_3_rddata)
    );
    
    roibuf_ctrl U_roibuf_ctrl(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),

        .fft_state(fft_state),
    
        .roi_bram_0_wren(roi_bram_0_wren),
        .roi_bram_0_wraddr(roi_bram_0_wraddr),
        .roi_bram_0_wrdata(roi_bram_0_wrdata),
        .roi_bram_0_rden(roi_bram_0_rden),
        .roi_bram_0_rdaddr(roi_bram_0_rdaddr),
        .roi_bram_0_rddata(roi_bram_0_rddata),
        
        .roi_bram_1_wren(roi_bram_1_wren),
        .roi_bram_1_wraddr(roi_bram_1_wraddr),
        .roi_bram_1_wrdata(roi_bram_1_wrdata),
        .roi_bram_1_rden(roi_bram_1_rden),
        .roi_bram_1_rdaddr(roi_bram_1_rdaddr),
        .roi_bram_1_rddata(roi_bram_1_rddata),

        .roi_bram_2_wren(roi_bram_2_wren),
        .roi_bram_2_wraddr(roi_bram_2_wraddr),
        .roi_bram_2_wrdata(roi_bram_2_wrdata),
        .roi_bram_2_rden(roi_bram_2_rden),
        .roi_bram_2_rdaddr(roi_bram_2_rdaddr),
        .roi_bram_2_rddata(roi_bram_2_rddata),

        .roi_bram_3_wren(roi_bram_3_wren),
        .roi_bram_3_wraddr(roi_bram_3_wraddr),
        .roi_bram_3_wrdata(roi_bram_3_wrdata),
        .roi_bram_3_rden(roi_bram_3_rden),
        .roi_bram_3_rdaddr(roi_bram_3_rdaddr),
        .roi_bram_3_rddata(roi_bram_3_rddata),
        
        // 1stR Ctrl
        .roi_bram_1stR_0_wren(roi_bram_1stR_0_wren),
        .roi_bram_1stR_0_wraddr(roi_bram_1stR_0_wraddr),
        .roi_bram_1stR_0_wrdata(roi_bram_1stR_0_wrdata),

        .roi_bram_1stR_1_wren(roi_bram_1stR_1_wren),
        .roi_bram_1stR_1_wraddr(roi_bram_1stR_1_wraddr),
        .roi_bram_1stR_1_wrdata(roi_bram_1stR_1_wrdata),

        .roi_bram_1stR_2_wren(roi_bram_1stR_2_wren),
        .roi_bram_1stR_2_wraddr(roi_bram_1stR_2_wraddr),
        .roi_bram_1stR_2_wrdata(roi_bram_1stR_2_wrdata),

        .roi_bram_1stR_3_wren(roi_bram_1stR_3_wren),
        .roi_bram_1stR_3_wraddr(roi_bram_1stR_3_wraddr),
        .roi_bram_1stR_3_wrdata(roi_bram_1stR_3_wrdata),

        // 2ndR Ctrl
        .roi_bram_2ndR_0_wren(roi_bram_2ndR_0_wren),
        .roi_bram_2ndR_0_wraddr(roi_bram_2ndR_0_wraddr),
        .roi_bram_2ndR_0_wrdata(roi_bram_2ndR_0_wrdata),
        .roi_bram_2ndR_0_rden(roi_bram_2ndR_0_rden),
        .roi_bram_2ndR_0_rdaddr(roi_bram_2ndR_0_rdaddr),
        .roi_bram_2ndR_0_rddata(roi_bram_2ndR_0_rddata),

        .roi_bram_2ndR_1_wren(roi_bram_2ndR_1_wren),
        .roi_bram_2ndR_1_wraddr(roi_bram_2ndR_1_wraddr),
        .roi_bram_2ndR_1_wrdata(roi_bram_2ndR_1_wrdata),
        .roi_bram_2ndR_1_rden(roi_bram_2ndR_1_rden),
        .roi_bram_2ndR_1_rdaddr(roi_bram_2ndR_1_rdaddr),
        .roi_bram_2ndR_1_rddata(roi_bram_2ndR_1_rddata),

        .roi_bram_2ndR_2_wren(roi_bram_2ndR_2_wren),
        .roi_bram_2ndR_2_wraddr(roi_bram_2ndR_2_wraddr),
        .roi_bram_2ndR_2_wrdata(roi_bram_2ndR_2_wrdata),
        .roi_bram_2ndR_2_rden(roi_bram_2ndR_2_rden),
        .roi_bram_2ndR_2_rdaddr(roi_bram_2ndR_2_rdaddr),
        .roi_bram_2ndR_2_rddata(roi_bram_2ndR_2_rddata),

        .roi_bram_2ndR_3_wren(roi_bram_2ndR_3_wren),
        .roi_bram_2ndR_3_wraddr(roi_bram_2ndR_3_wraddr),
        .roi_bram_2ndR_3_wrdata(roi_bram_2ndR_3_wrdata),
        .roi_bram_2ndR_3_rden(roi_bram_2ndR_3_rden),
        .roi_bram_2ndR_3_rdaddr(roi_bram_2ndR_3_rdaddr),
        .roi_bram_2ndR_3_rddata(roi_bram_2ndR_3_rddata),
        
        // 3rdR Ctrl
        .roi_bram_3rdR_0_wren(roi_bram_3rdR_0_wren),
        .roi_bram_3rdR_0_wraddr(roi_bram_3rdR_0_wraddr),
        .roi_bram_3rdR_0_wrdata(roi_bram_3rdR_0_wrdata),
        .roi_bram_3rdR_0_rden(roi_bram_3rdR_0_rden),
        .roi_bram_3rdR_0_rdaddr(roi_bram_3rdR_0_rdaddr),
        .roi_bram_3rdR_0_rddata(roi_bram_3rdR_0_rddata),

        .roi_bram_3rdR_1_wren(roi_bram_3rdR_1_wren),
        .roi_bram_3rdR_1_wraddr(roi_bram_3rdR_1_wraddr),
        .roi_bram_3rdR_1_wrdata(roi_bram_3rdR_1_wrdata),
        .roi_bram_3rdR_1_rden(roi_bram_3rdR_1_rden),
        .roi_bram_3rdR_1_rdaddr(roi_bram_3rdR_1_rdaddr),
        .roi_bram_3rdR_1_rddata(roi_bram_3rdR_1_rddata),

        .roi_bram_3rdR_2_wren(roi_bram_3rdR_2_wren),
        .roi_bram_3rdR_2_wraddr(roi_bram_3rdR_2_wraddr),
        .roi_bram_3rdR_2_wrdata(roi_bram_3rdR_2_wrdata),
        .roi_bram_3rdR_2_rden(roi_bram_3rdR_2_rden),
        .roi_bram_3rdR_2_rdaddr(roi_bram_3rdR_2_rdaddr),
        .roi_bram_3rdR_2_rddata(roi_bram_3rdR_2_rddata),

        .roi_bram_3rdR_3_wren(roi_bram_3rdR_3_wren),
        .roi_bram_3rdR_3_wraddr(roi_bram_3rdR_3_wraddr),
        .roi_bram_3rdR_3_wrdata(roi_bram_3rdR_3_wrdata),
        .roi_bram_3rdR_3_rden(roi_bram_3rdR_3_rden),
        .roi_bram_3rdR_3_rdaddr(roi_bram_3rdR_3_rdaddr),
        .roi_bram_3rdR_3_rddata(roi_bram_3rdR_3_rddata),

        // 4thR Ctrl
        .roi_bram_4thR_0_wren(roi_bram_4thR_0_wren),
        .roi_bram_4thR_0_wraddr(roi_bram_4thR_0_wraddr),
        .roi_bram_4thR_0_wrdata(roi_bram_4thR_0_wrdata),
        .roi_bram_4thR_0_rden(roi_bram_4thR_0_rden),
        .roi_bram_4thR_0_rdaddr(roi_bram_4thR_0_rdaddr),
        .roi_bram_4thR_0_rddata(roi_bram_4thR_0_rddata),

        .roi_bram_4thR_1_wren(roi_bram_4thR_1_wren),
        .roi_bram_4thR_1_wraddr(roi_bram_4thR_1_wraddr),
        .roi_bram_4thR_1_wrdata(roi_bram_4thR_1_wrdata),
        .roi_bram_4thR_1_rden(roi_bram_4thR_1_rden),
        .roi_bram_4thR_1_rdaddr(roi_bram_4thR_1_rdaddr),
        .roi_bram_4thR_1_rddata(roi_bram_4thR_1_rddata),

        .roi_bram_4thR_2_wren(roi_bram_4thR_2_wren),
        .roi_bram_4thR_2_wraddr(roi_bram_4thR_2_wraddr),
        .roi_bram_4thR_2_wrdata(roi_bram_4thR_2_wrdata),
        .roi_bram_4thR_2_rden(roi_bram_4thR_2_rden),
        .roi_bram_4thR_2_rdaddr(roi_bram_4thR_2_rdaddr),
        .roi_bram_4thR_2_rddata(roi_bram_4thR_2_rddata),

        .roi_bram_4thR_3_wren(roi_bram_4thR_3_wren),
        .roi_bram_4thR_3_wraddr(roi_bram_4thR_3_wraddr),
        .roi_bram_4thR_3_wrdata(roi_bram_4thR_3_wrdata),
        .roi_bram_4thR_3_rden(roi_bram_4thR_3_rden),
        .roi_bram_4thR_3_rdaddr(roi_bram_4thR_3_rdaddr),
        .roi_bram_4thR_3_rddata(roi_bram_4thR_3_rddata)
    );

    blk_mem_roibuf U_blk_mem_roibuf_0(
        .clka(s_axi_aclk),
        .ena(roi_bram_0_wren),
        .wea(1'b1),
        .addra(roi_bram_0_wraddr),
        .dina(roi_bram_0_wrdata),
        .clkb(s_axi_aclk),
        .enb(roi_bram_0_rden),
        .addrb(roi_bram_0_rdaddr),
        .doutb(roi_bram_0_rddata)
    );

    blk_mem_roibuf U_blk_mem_roibuf_1(
        .clka(s_axi_aclk),
        .ena(roi_bram_1_wren),
        .wea(1'b1),
        .addra(roi_bram_1_wraddr),
        .dina(roi_bram_1_wrdata),
        .clkb(s_axi_aclk),
        .enb(roi_bram_1_rden),
        .addrb(roi_bram_1_rdaddr),
        .doutb(roi_bram_1_rddata)
    );

    blk_mem_roibuf U_blk_mem_roibuf_2(
        .clka(s_axi_aclk),
        .ena(roi_bram_2_wren),
        .wea(1'b1),
        .addra(roi_bram_2_wraddr),
        .dina(roi_bram_2_wrdata),
        .clkb(s_axi_aclk),
        .enb(roi_bram_2_rden),
        .addrb(roi_bram_2_rdaddr),
        .doutb(roi_bram_2_rddata)
    );
    
    blk_mem_roibuf U_blk_mem_roibuf_3(
        .clka(s_axi_aclk),
        .ena(roi_bram_3_wren),
        .wea(1'b1),
        .addra(roi_bram_3_wraddr),
        .dina(roi_bram_3_wrdata),
        .clkb(s_axi_aclk),
        .enb(roi_bram_3_rden),
        .addrb(roi_bram_3_rdaddr),
        .doutb(roi_bram_3_rddata)
    );
    
    blk_mem_tmlbuf U_blk_mem_tmlbuf_0(
        .clka(s_axi_aclk),
        .ena(1'b1),
        .wea(tml_bram_0_wren),
        .addra(tml_bram_0_wraddr),
        .dina(tml_bram_0_wrdata),
        .clkb(s_axi_aclk),
        .enb(tml_bram_0_rden),
        .addrb(tml_bram_0_rdaddr),
        .doutb(tml_bram_0_rddata)
    );
    
    blk_mem_tmlbuf U_blk_mem_tmlbuf_1(
        .clka(s_axi_aclk),
        .ena(1'b1),
        .wea(tml_bram_1_wren),
        .addra(tml_bram_1_wraddr),
        .dina(tml_bram_1_wrdata),
        .clkb(s_axi_aclk),
        .enb(tml_bram_1_rden),
        .addrb(tml_bram_1_rdaddr),
        .doutb(tml_bram_1_rddata)
    );

    blk_mem_tmlbuf U_blk_mem_tmlbuf_2(
        .clka(s_axi_aclk),
        .ena(1'b1),
        .wea(tml_bram_2_wren),
        .addra(tml_bram_2_wraddr),
        .dina(tml_bram_2_wrdata),
        .clkb(s_axi_aclk),
        .enb(tml_bram_2_rden),
        .addrb(tml_bram_2_rdaddr),
        .doutb(tml_bram_2_rddata)
    );

    blk_mem_tmlbuf U_blk_mem_tmlbuf_3(
        .clka(s_axi_aclk),
        .ena(1'b1),
        .wea(tml_bram_3_wren),
        .addra(tml_bram_3_wraddr),
        .dina(tml_bram_3_wrdata),
        .clkb(s_axi_aclk),
        .enb(tml_bram_3_rden),
        .addrb(tml_bram_3_rdaddr),
        .doutb(tml_bram_3_rddata)
    );
	// User logic ends

	endmodule
