
`timescale 1 ns / 1 ps

	module CImgSensorIF_v1_0
	(
		// Users to add ports here
        input                pixclk,
        input                reset,
        
        input                sensor_state,
        
        input                sensor_fv,
        input                sensor_lv,
        input   [7:0]        sensor_din,
        
        input   [9:0]        crop_row_start,
        input   [9:0]        crop_row_end,
        input   [10:0]       crop_col_start,
        input   [10:0]       crop_col_end,
        
        output               frame_begin,
        output               frame_end,
        output               line_begin,
        output               line_end,
        
        output               frame_state,
        output               line_state,
        
        output  [9:0]        cnt_line,
        output  [10:0]       cnt_pixel,
        
        output               sensor_state_sync,
        output               sensor_fv_sync,
        output               sensor_lv_sync,
        output  [7:0]        sensor_din_sync
		// User ports ends
	);

	// Add user logic here
    frame_indication_gen U_frame_indication_gen(
        .clock(pixclk),
        .reset_n(~reset),
        
        .sensor_state(sensor_state_sync),
        .sensor_fv(sensor_fv_sync),
        .sensor_lv(sensor_lv_sync),
        
        .crop_row_start(crop_row_start),
        .crop_row_end(crop_row_end),
        .crop_col_start(crop_col_start),
        .crop_col_end(crop_col_end),
        
        .frame_begin(frame_begin),
        .frame_end(frame_end),
        .roi_line_begin(line_begin),
        .roi_line_end(line_end),
        
        .cnt_line(cnt_line),
        .cnt_pixel(cnt_pixel),
        
        .frame_state(frame_state),
        .roi_line_state(line_state)
    );
    
    // synchronize sensor state
    synchronize_bit U_sensor_state_sync(
        .clock(pixclk),
        .datain(sensor_state),
        .result(sensor_state_sync)
    );
    
    // synchronize frame valid
    synchronize_bit U_sensor_fv_sync(
        .clock(pixclk),
        .datain(sensor_fv),
        .result(sensor_fv_sync)
    );
    
    // synchronize line valid
    synchronize_bit U_sensor_lv_sync(
        .clock(pixclk),
        .datain(sensor_lv),
        .result(sensor_lv_sync)
    );

    // synchronize datain[7:0]
    synchronize_bit U_sensor_din_0_sync(
        .clock(pixclk),
        .datain(sensor_din[0]),
        .result(sensor_din_sync[0])
    );

    synchronize_bit U_sensor_din_1_sync(
        .clock(pixclk),
        .datain(sensor_din[1]),
        .result(sensor_din_sync[1])
    );

    synchronize_bit U_sensor_din_2_sync(
        .clock(pixclk),
        .datain(sensor_din[2]),
        .result(sensor_din_sync[2])
    );

    synchronize_bit U_sensor_din_3_sync(
        .clock(pixclk),
        .datain(sensor_din[3]),
        .result(sensor_din_sync[3])
    );

    synchronize_bit U_sensor_din_4_sync(
        .clock(pixclk),
        .datain(sensor_din[4]),
        .result(sensor_din_sync[4])
    );

    synchronize_bit U_sensor_din_5_sync(
        .clock(pixclk),
        .datain(sensor_din[5]),
        .result(sensor_din_sync[5])
    );

    synchronize_bit U_sensor_din_6_sync(
        .clock(pixclk),
        .datain(sensor_din[6]),
        .result(sensor_din_sync[6])
    );

    synchronize_bit U_sensor_din_7_sync(
        .clock(pixclk),
        .datain(sensor_din[7]),
        .result(sensor_din_sync[7])
    );
	// User logic ends

	endmodule
