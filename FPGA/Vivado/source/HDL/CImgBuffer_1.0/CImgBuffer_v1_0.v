
`timescale 1 ns / 1 ps

	module CImgBuffer_v1_0
	(
		// Users to add ports here
        input                pixclk,
        input                reset,
        
        input                sensor_state,
        input   [7:0]        sensor_din,
        
        input                frame_begin,
        input                line_begin,
        input                frame_state,
        input                line_state,
        
        input   [13:0]       buffer_size,
        output               interrupt,
        output               miss_state,
        
        input                bram_clk,
        input                bram_rst,
        input                bram_ena,
        input   [3:0]        bram_wea,
        input   [31:0]       bram_addr,
        input   [31:0]       bram_din,
        output  [31:0]       bram_dout
		// User ports ends
	);
	// Add user logic here
    wire             buf_wren;
    wire   [13:0]    buf_wraddr;
    wire   [31:0]    buf_wrdata;
    
    wire             imgbuf_wren    =  buf_wren;
    wire   [31:0]    imgbuf_wraddr  =  {16'd0, buf_wraddr, 2'd0};
    wire   [31:0]    imgbuf_wrdata  =  buf_wrdata;

    CImgBuffer_ctrl U_CImgBuffer_ctrl(
        .clock(pixclk),
        .reset_n(~reset),
        
        .sensor_state(sensor_state),
        .sensor_din(sensor_din),
        
        .frame_begin(frame_begin),
        .line_begin(line_begin),
        .frame_state(frame_state),
        .line_state(line_state),
        
        .miss_state(miss_state),
        
        .buf_wren(buf_wren),
        .buf_wraddr(buf_wraddr),
        .buf_wrdata(buf_wrdata),
        
        .buffer_size(buffer_size),
        .interrupt(interrupt)
    );

    blk_mem_stripebuf U_blk_mem_stripebuf(
        .clka(pixclk),
        .rsta(reset),
        .ena(imgbuf_wren),
        .wea(4'b1111),
        .addra(imgbuf_wraddr),
        .dina(imgbuf_wrdata),
        .douta(),
        .clkb(bram_clk),
        .rstb(bram_rst),
        .enb(bram_ena),
        .web(bram_wea),
        .addrb(bram_addr),
        .dinb(bram_din),
        .doutb(bram_dout)
    );

	// User logic ends

	endmodule