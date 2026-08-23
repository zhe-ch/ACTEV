
`timescale 1 ns / 1 ps

	module CImgEnhance_v1_0
	(
		// Users to add ports here
        input               pixclk,
        input               reset,

        input               s_axi_aclk,
        input               s_axi_aresetn,

        input               sensor_state,
        input   [7:0]       sensor_din,

        input               frame_begin,
        input               line_begin,
        input               frame_state,
        input               line_state,

        output              enhance_valid,
        output  [7:0]       enhance_dout
		// User ports ends
	);

	// Add user logic here
	wire         denoise_valid;
	wire  [7:0]  denoise_dout;
	
    wire         erosion_valid;
    wire  [7:0]  erosion_dout;
    
    wire         dilation_valid;
    wire  [7:0]  dilation_dout;
    
    background_subtractor U_background_subtractor(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
    
        .denoise_valid(denoise_valid),
        .denoise_dout(denoise_dout),
    
        .dilation_valid(dilation_valid),
        .dilation_dout(dilation_dout),
    
        .enhance_valid(enhance_valid),
        .enhance_dout(enhance_dout)
    );
    
    denoise_kernel U_denoise_kernel(
        .pixclk(pixclk),
        .reset_n(~reset),
        
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        
        .sensor_state(sensor_state),
        .sensor_din(sensor_din),
        
        .frame_begin(frame_begin),
        .line_begin(line_begin),
        .frame_state(frame_state),
        .line_state(line_state),
        
        .denoise_valid(denoise_valid),
        .denoise_dout(denoise_dout)
    );
    
    erosion_kernel U_erosion_kernel(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),

        .sensor_state(sensor_state),
    
        .denoise_valid(denoise_valid),
        .denoise_dout(denoise_dout),
    
        .erosion_valid(erosion_valid),
        .erosion_dout(erosion_dout)
    );

    dilation_kernel U_dilation_kernel(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),

        .sensor_state(sensor_state),

        .erosion_valid(erosion_valid),
        .erosion_dout(erosion_dout),

        .dilation_valid(dilation_valid),
        .dilation_dout(dilation_dout)
    );
    
	// User logic ends

	endmodule
