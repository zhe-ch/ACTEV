
`timescale 1 ns / 1 ps

	module virtual_image_sensor_v1_0 (
		// Users to add ports here
        input              pixclk,
        input              reset,
        input              sensor_set_virtual,
        
        input              sensor_fv,
        input              sensor_lv,
        input      [7:0]   sensor_pix_data,
        
        output             out_fv,
        output             out_lv,
        output     [7:0]   out_pix_data
		// User ports ends
		// Do not modify the ports beyond this line
	);

	// Add user logic here
    virtual_image_sensor_ctrl U_virtual_image_sensor_ctrl(
        .pixclk(pixclk),
        .reset(reset),
        .sensor_set_virtual(sensor_set_virtual),

        .sensor_fv(sensor_fv),
        .sensor_lv(sensor_lv),
        .sensor_pix_data(sensor_pix_data),

        .out_fv(out_fv),
        .out_lv(out_lv),
        .out_pix_data(out_pix_data)
    );
	// User logic ends

	endmodule
