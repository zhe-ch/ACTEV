/*
 * Copyright (C) 2018 - 2019 Xilinx, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 */

#include "freertos_tcp_perf_server.h"
#include "xil_io.h"
#include "xil_cache.h"

extern struct netif server_netif;
static struct perf_stats server;

/* Interval time in seconds */
#define REPORT_INTERVAL_TIME (INTERIM_REPORT_INTERVAL * 1000)

#define CELL_NUM 1024
#define CLASS_NUM 24
#define LEARNER_NUM 23

static char bypassTemplate = 0;

static char selectModeIsMCorre = 0;

static int arm_recv_cnt = 0;
static int recv_blk_cnt = 0;

static u16 crop_row_start = 204;
static u16 crop_row_end = 715;
static u16 crop_col_start = 649;
static u16 crop_col_end = 1160;

/*
// Default 1: Tile Case.
static u16 last_row_1 = 63;
static u16 last_row_2 = 127;
static u16 last_row_3 = 191;
static u16 last_row_4 = 255;
static u16 last_row_5 = 319;
static u16 last_row_6 = 383;
static u16 last_row_7 = 447;
static u16 last_row_8 = 510;
*/

/*
// Default 2: Hipp18
static u16 last_row_1 = 114;
static u16 last_row_2 = 154;
static u16 last_row_3 = 193;
static u16 last_row_4 = 228;
static u16 last_row_5 = 273;
static u16 last_row_6 = 318;
static u16 last_row_7 = 373;
static u16 last_row_8 = 504;
*/

static u16 last_row[8];

static int init_frame = 0;

static int selcell_n;
//static float beta[CELL_NUM][LEARNER_NUM];
//static float bias[LEARNER_NUM];
//static int coding_matrix[CLASS_NUM][LEARNER_NUM];
//static int contourSize[CELL_NUM];

void IMG_INTERRUPT_Handler() {

	int fetch_status;
	int rdaddr;
	int wraddr;

	static int cnt_frame = 0;
	int8_t mot_x = 0;
	int8_t mot_y = 0;
	static int avr_mot_x = 0;
	static int avr_mot_y = 0;
	static u8 slow_drift_x = 0;
	static u8 slow_drift_y = 0;
	u32 config_value;

	static int trace[CELL_NUM];
	static int pre_trace[CELL_NUM];
	static int fil_trace[CELL_NUM];
	float score[LEARNER_NUM];
	float loss[CLASS_NUM];
	float min_loss = 0;
	int predict_output = 0;
	int c, i;
	float v;

	// Transfer image from BRAM buffer to DRAM
	rdaddr = 0x0F000000 + ((arm_recv_cnt % 32) * 266400);
	wraddr = rdaddr + recv_blk_cnt * 16384 + 8;

	if ((recv_blk_cnt % 2) == 0) {
		Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x18, 0xC0000000);
		Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x20, wraddr);
		Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x28, 0x4000);
	}
	else {
		Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x18, 0xC0004000);
		Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x20, wraddr);
		Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x28, 0x4000);
	}
	fetch_status = Xil_In32(XPAR_AXI_CDMA_0_BASEADDR + 0x04);
	while (fetch_status != 0x00001002) {
		fetch_status = Xil_In32(XPAR_AXI_CDMA_0_BASEADDR + 0x04);
	}
	Xil_DCacheFlushRange(wraddr, 0x4000);

	if (recv_blk_cnt == 15) {

		// Data[3:0]: Frame ID.
		wraddr = 0x0F000000 + ((arm_recv_cnt % 32) * 266400);
		Xil_Out32(wraddr, (arm_recv_cnt + 1));

		// Data[5:4]: Motion vector.
		mot_x = (int8_t)Xil_In8(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x10);
		mot_y = (int8_t)Xil_In8(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x11);

		if (mot_x > 64)
			mot_x = mot_x - 128;
		if (mot_y > 64)
			mot_y = mot_y - 128;

		Xil_Out8(wraddr + 0x04, mot_x);
		Xil_Out8(wraddr + 0x05, mot_y);

		//xil_printf("%d, %d\n\r", mot_x, mot_y);

		if (selectModeIsMCorre == 1)
		{
			// Wait for trace end signal.
			fetch_status = Xil_In32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x1C);
			while (fetch_status == 0)
			{
				fetch_status = Xil_In32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x1C);
			}
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x1C, 0);

			// Receive cell fluorescence.
			wraddr = wraddr + 262156;
			Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x18, 0xC4015100);
			Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x20, wraddr);
			Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x28, 0x800);
			fetch_status = Xil_In32(XPAR_AXI_CDMA_0_BASEADDR + 0x04);
			while (fetch_status != 0x00001002) {
				fetch_status = Xil_In32(XPAR_AXI_CDMA_0_BASEADDR + 0x04);
			}
			Xil_DCacheFlushRange(wraddr, 0x800);
		}

		// Transfer image from BRAM buffer to DRAM (Last piece).
		/*
		rdaddr = 0x0F000000 + ((arm_recv_cnt % 32) * 266400);
		wraddr = rdaddr + recv_blk_cnt * 16384 + 8;

		Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x18, 0xC0004000);
		Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x20, wraddr);
		Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x28, 0x4000);

		fetch_status = Xil_In32(XPAR_AXI_CDMA_0_BASEADDR + 0x04);
		while (fetch_status != 0x00001002) {
			fetch_status = Xil_In32(XPAR_AXI_CDMA_0_BASEADDR + 0x04);
		}
		Xil_DCacheFlushRange(wraddr, 0x4000);
		*/

		// Slow motion drift correction mechanism
		if (cnt_frame == 0) {
			cnt_frame = cnt_frame + 1;
			avr_mot_x = mot_x;
			avr_mot_y = mot_y;
		}
		else if (cnt_frame == 199) {
			cnt_frame = 0;
			avr_mot_x += mot_x;
			avr_mot_y += mot_y;
			slow_drift_x = (u8)(avr_mot_x / 200);
			slow_drift_y = (u8)(avr_mot_y / 200);
			//xil_printf("slx = %d, sly = %d\n\r", slow_drift_x, slow_drift_y);
			config_value = (slow_drift_y << 24) + (slow_drift_x << 16);
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x10, config_value);
		}
		else {
			cnt_frame = cnt_frame + 1;
			avr_mot_x += mot_x;
			avr_mot_y += mot_y;
		}

		recv_blk_cnt = 0;
		arm_recv_cnt++;
	}
	else {
		recv_blk_cnt++;
	}

	return;
}

void print_app_header(void)
{
	xil_printf("TCP server listening on port %d\r\n",
			TCP_CONN_PORT);
#if LWIP_IPV6==1
	xil_printf("On Host: Run $iperf -V -c %s%%<interface> -i %d -t 300 -w 2M\r\n",
			inet6_ntoa(server_netif.ip6_addr[0]),
			INTERIM_REPORT_INTERVAL);
#else
	xil_printf("On Host: Run $iperf -c %s -i %d -t 300 -w 2M\r\n",
			inet_ntoa(server_netif.ip_addr),
			INTERIM_REPORT_INTERVAL);
#endif /* LWIP_IPV6 */
}

static void print_tcp_conn_stats(int sock)
{
#if LWIP_IPV6==1
	struct sockaddr_in6 local, remote;
#else
	struct sockaddr_in local, remote;
#endif /* LWIP_IPV6 */
	int size;

	size = sizeof(local);
	getsockname(sock, (struct sockaddr *)&local, (socklen_t *)&size);
	getpeername(sock, (struct sockaddr *)&remote, (socklen_t *)&size);
#if LWIP_IPV6==1
	xil_printf("[%3d] local %s port %d connected with ", server.client_id,
			inet6_ntoa(local.sin6_addr), ntohs(local.sin6_port));
	xil_printf("%s port %d\r\n", inet6_ntoa(remote.sin6_addr),
			ntohs(local.sin6_port));
#else
	xil_printf("[%3d] local %s port %d connected with ", server.client_id,
			inet_ntoa(local.sin_addr), ntohs(local.sin_port));
	xil_printf("%s port %d\r\n", inet_ntoa(remote.sin_addr),
			ntohs(local.sin_port));
#endif /* LWIP_IPV6 */
	xil_printf("[ ID] Interval    Transfer     Bandwidth\n\r");
}

static void stats_buffer(char* outString, double data, enum measure_t type)
{
	int conv = KCONV_UNIT;
	const char *format;
	double unit = 1024.0;

	if (type == SPEED)
		unit = 1000.0;

	while (data >= unit && conv <= KCONV_GIGA) {
		data /= unit;
		conv++;
	}

	/* Fit data in 4 places */
	if (data < 9.995) { /* 9.995 rounded to 10.0 */
		format = "%4.2f %c"; /* #.## */
	} else if (data < 99.95) { /* 99.95 rounded to 100 */
		format = "%4.1f %c"; /* ##.# */
	} else {
		format = "%4.0f %c"; /* #### */
	}
	sprintf(outString, format, data, kLabel[conv]);
}

/* The report function of a TCP server session */
static void tcp_conn_report(u64_t diff, enum report_type report_type)
{
	u64_t total_len;
	double duration, bandwidth = 0;
	char data[16], perf[16], time[64];

	if (report_type == INTER_REPORT) {
		total_len = server.i_report.total_bytes;
	} else {
		server.i_report.last_report_time = 0;
		total_len = server.total_bytes;
	}

	/* Converting duration from milliseconds to secs,
	 * and bandwidth to bits/sec .
	 */
	duration = diff / 1000.0; /* secs */
	if (duration)
		bandwidth = (total_len / duration) * 8.0;

	stats_buffer(data, total_len, BYTES);
	stats_buffer(perf, bandwidth, SPEED);
	/* On 32-bit platforms, xil_printf is not able to print
	 * u64_t values, so converting these values in strings and
	 * displaying results
	 */
	sprintf(time, "%4.1f-%4.1f sec",
			(double)server.i_report.last_report_time,
			(double)(server.i_report.last_report_time + duration));
	xil_printf("[%3d] %s  %sBytes  %sbits/sec\n\r", server.client_id,
			time, data, perf);

	if (report_type == INTER_REPORT)
		server.i_report.last_report_time += duration;
}

/* thread spawned for each connection */
void tcp_recv_perf_traffic(void *p)
{
	char recv_buf[RECV_BUF_SIZE];
	int read_bytes;
	int sock = *((int *)p);

	server.start_time = sys_now();
	server.client_id++;
	server.i_report.last_report_time = 0;
	server.i_report.start_time = 0;
	server.i_report.total_bytes = 0;
	server.total_bytes = 0;

	print_tcp_conn_stats(sock);

	while (1) {
		/* read a max of RECV_BUF_SIZE bytes from socket */
		if ((read_bytes = lwip_recvfrom(sock, recv_buf, RECV_BUF_SIZE,
						0, NULL, NULL)) < 0) {
			u64_t now = sys_now();
			u64_t diff_ms = now - server.start_time;
			tcp_conn_report(diff_ms, TCP_ABORTED_REMOTE);
			break;
		}

		/* break if client closed connection */
		if (read_bytes == 0) {
			u64_t now = sys_now();
			u64_t diff_ms = now - server.start_time;
			tcp_conn_report(diff_ms, TCP_DONE_SERVER);
			xil_printf("TCP test passed Successfully\n\r");
			break;
		}

		if (REPORT_INTERVAL_TIME) {
			u64_t now = sys_now();
			server.i_report.total_bytes += read_bytes;
			if (server.i_report.start_time) {
				u64_t diff_ms = now - server.i_report.start_time;

				if (diff_ms >= REPORT_INTERVAL_TIME) {
					tcp_conn_report(diff_ms, INTER_REPORT);
					server.i_report.start_time = 0;
					server.i_report.total_bytes = 0;
				}
			} else {
				server.i_report.start_time = now;
			}
		}
		/* Record total bytes for final report */
		server.total_bytes += read_bytes;
	}

	/* close connection */
	close(sock);
	vTaskDelete(NULL);
}

void start_application(void)
{
	int sock, new_sd;
#if LWIP_IPV6==1
	struct sockaddr_in6 address, remote;
#else
	struct sockaddr_in address, remote;
#endif /* LWIP_IPV6 */
	int size;

	char send_buf[1440];
	char recv_buf[1446];

	int wraddr = 0;
	int rdaddr = 0;
	int fetch_status = 0;
	int cpu_recv_cnt = 0;
	int curr_cnt = 0;
	int val;
	int i, j, t;

	union {
		float f32_val;
		int int_val;
	} f32_data;

	u16 roi_row_start = 192;
	u16 roi_col_start = 192;
	u32 config_value = 0;

	/* set up address to connect to */
        memset(&address, 0, sizeof(address));
#if LWIP_IPV6==1
	if ((sock = lwip_socket(AF_INET6, SOCK_STREAM, 0)) < 0) {
		xil_printf("TCP server: Error creating Socket\r\n");
		return;
	}
	address.sin6_family = AF_INET6;
	address.sin6_port = htons(TCP_CONN_PORT);
	address.sin6_len = sizeof(address);
#else
	if ((sock = lwip_socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		xil_printf("TCP server: Error creating Socket\r\n");
		return;
	}
	address.sin_family = AF_INET;
	address.sin_port = htons(TCP_CONN_PORT);
	address.sin_addr.s_addr = INADDR_ANY;
#endif /* LWIP_IPV6 */

	if (bind(sock, (struct sockaddr *)&address, sizeof (address)) < 0) {
		xil_printf("TCP server: Unable to bind to port %d\r\n",
				TCP_CONN_PORT);
		close(sock);
		return;
	}

	if (listen(sock, 1) < 0) {
		xil_printf("TCP server: tcp_listen failed\r\n");
		close(sock);
		return;
	}

	size = sizeof(remote);

	//xil_printf("Wait for new INPUT Command:\r\n");

	if ((new_sd = accept(sock, (struct sockaddr *)&remote,
		(socklen_t *)&size)) > 0)
	{
		xil_printf("[Info] Ethernet connection established.\n\r");
	}

	while (1) {
		lwip_read(new_sd, recv_buf, 20);
		xil_printf("[Info] Received CMD = %d\n\r", recv_buf[0]);

		for (i = 0; i < 4; ++i) {
			send_buf[i] = 0;
		}
		if (lwip_write(new_sd, send_buf, 4) == -1) {
			xil_printf("[Info] Exit the terminal program.\n\r");
			break;
		}

		if (recv_buf[0] == 1)
		{
			// Receive download image files. DRAM address offset: 0x10000000 - 0x1FA00000
			wraddr = 0x10000000;
			for (t = 0; t < 1000; ++t) {
				for (i = 0; i < 181; ++i) {
					if (lwip_read(new_sd, recv_buf, 1446) <= 0)
						break;
					memcpy((void *) (uint64_t) wraddr, recv_buf, 1446);
					wraddr += 1446;
				}
				if (lwip_read(new_sd, recv_buf, 418) <= 0)
					break;
				memcpy((void *) (uint64_t) wraddr, recv_buf, 418);
				wraddr += 418;
				xil_printf("[Info] Download image file %d/1000\n\r", (t + 1));
				for (i = 0; i < 4; ++i) {
					send_buf[i] = 0;
				}
				lwip_write(new_sd, send_buf, 4);
			}
		}
		else if (recv_buf[0] == 2)
		{
			curr_cnt = 0;
			arm_recv_cnt = 0;
			recv_blk_cnt = 0;

			selectModeIsMCorre = 0;

			// Set configurable parameters
			xil_printf("[Info] Configure the crop image region.\n\r");
			// Set crop_row_start = 204; crop_row_end = 715.
			val = (crop_row_end << 16) + crop_row_start;
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x08, val);
			// Set crop_col_start = 650; crop_col_end = 1161.
			val = (crop_col_end << 16) + crop_col_start;
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x0C, val);
			// Set buffer_size = 4096.
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x18, 4096);

			// Send Sync Signal: [3:0] = 0.0.0.255
			send_buf[0] = 255;
			for (i = 1; i < 4; ++i) {
				send_buf[i] = 0;
			}
			lwip_write(new_sd, send_buf, 4);

			// Start image sensor
			xil_printf("[Info] Start image sensor.\n\r");
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR, 1);

			for (cpu_recv_cnt = 0; cpu_recv_cnt < 1000; ++cpu_recv_cnt) {

				while (curr_cnt <= cpu_recv_cnt) {
					curr_cnt = arm_recv_cnt;
				}
				xil_printf("fpga_cnt = %d | host_cnt = %d\n\r", curr_cnt, cpu_recv_cnt);

				rdaddr = 0x0F000000 + ((cpu_recv_cnt % 32) * 266400);

				for (i = 0; i < 185; ++i)
				{
					memcpy(send_buf, (void *) (uint64_t) rdaddr, 1440);
					lwip_write(new_sd, send_buf, 1440);
					rdaddr = rdaddr + 1440;
				}
			}

			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR, 0);
			xil_printf("[Info] Stop image sensor.\n\r");
		}
		else if (recv_buf[0] == 3)
		{
			curr_cnt = 0;
			arm_recv_cnt = 0;
			recv_blk_cnt = 0;

			selectModeIsMCorre = 1;

			// Reset motion correction and slow drift vector registers
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x10, 0);
			// Retrieve and set parameters: roi_row/col_start
			roi_row_start = (u8)recv_buf[2] + (((u8)recv_buf[3]) << 8);
			roi_col_start = (u8)recv_buf[4] + (((u8)recv_buf[5]) << 8);
			config_value = roi_row_start + (roi_col_start << 16);
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x14, config_value);
			xil_printf("[Info] roi_row_start = %d, roi_col_start = %d\n\r", roi_row_start, roi_col_start);
			bypassTemplate = (u8)recv_buf[6];

			// Send Sync Signal: [3:0] = 0.0.0.255
			send_buf[0] = 255;
			for (i = 1; i < 4; ++i) {
				send_buf[i] = 0;
			}
			lwip_write(new_sd, send_buf, 4);

			// Step 1: Download template for motion correction.
			if (bypassTemplate == 0)
			{
				// Receive template[20736] over TCP/IP
				wraddr = 0x0E000000;
				for (i = 0; i < 14; ++i) {
					if (lwip_read(new_sd, recv_buf, 1446) <= 0)
						break;
					memcpy((void *) (uint64_t) wraddr, recv_buf, 1446);
					wraddr += 1446;
				}
				if (lwip_read(new_sd, recv_buf, 492) <= 0)
					break;
				memcpy((void *) (uint64_t) wraddr, recv_buf, 492);
				wraddr += 492;
				xil_printf("[Info] Load template file completed.\n\r");

				for (i = 0; i < 4; ++i) {
					send_buf[i] = 0;
				}
				lwip_write(new_sd, send_buf, 4);

				wraddr = 0x0E000000;
				Xil_DCacheFlushRange(wraddr, 0x5100);
				xil_printf("[Info] Receive template file completed.\n\r");
				Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x18, 0x0E000000);
				Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x20, 0xC2000000);
				Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x28, 0x5100);
				fetch_status = Xil_In32(XPAR_AXI_CDMA_0_BASEADDR + 0x04);
				while (fetch_status != 0x00001002) {
					fetch_status = Xil_In32(XPAR_AXI_CDMA_0_BASEADDR + 0x04);
				}

				// Start template update
				Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x04, 1);

				// Wait for template update to finish
				while (fetch_status != 0) {
					fetch_status = Xil_In8(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x04);
				}
				xil_printf("[Info] Download template file completed.\n\r");
			}

			// Step 2: Receive download contour file. DRAM address offset: 0x20000000
			wraddr = 0x20000000;
			for (i = 0; i < 59; ++i) {
				if (lwip_read(new_sd, recv_buf, 1446) <= 0)
					break;
				memcpy((void *) (uint64_t) wraddr, recv_buf, 1446);
				wraddr += 1446;
			}
			if (lwip_read(new_sd, recv_buf, 974) <= 0)
				break;
			memcpy((void *) (uint64_t) wraddr, recv_buf, 974);
			wraddr += 974;
			xil_printf("[Info] Load contour file completed.\n\r");

			for (i = 0; i < 4; ++i) {
				send_buf[i] = 0;
			}
			lwip_write(new_sd, send_buf, 4);

			// Download contour parameters: 21568x4 bytes (0x15100)
			wraddr = 0x20000000;
			Xil_DCacheFlushRange(wraddr, 0x15100);
			Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x18, 0x20000000);
			Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x20, 0xC4000000);
			Xil_Out32(XPAR_AXI_CDMA_0_BASEADDR + 0x28, 0x15100);
			fetch_status = Xil_In32(XPAR_AXI_CDMA_0_BASEADDR + 0x04);
			while (fetch_status != 0x00001002) {
				fetch_status = Xil_In32(XPAR_AXI_CDMA_0_BASEADDR + 0x04);
			}
			xil_printf("[Info] Download contour file completed.\n\r");

			// Load contour sizes.
			rdaddr = 0x20015100;
			for (i = 0; i < 8; ++i) {
				last_row[i] = (int) Xil_In16(rdaddr + i * 2);
			}

		    selcell_n = CELL_NUM;

			// Step 4: Set configurable parameters
			xil_printf("[Info] Configure the crop image region.\n\r");

			// Set crop_row_start = 204; crop_row_end = 715.
			val = (crop_row_end << 16) + crop_row_start;
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x08, val);
			// Set crop_col_start = 650; crop_col_end = 1161.
			val = (crop_col_end << 16) + crop_col_start;
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x0C, val);
			// Set buffer_size = 4096.
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x18, 4096);

			// Set last row indices for region segmentation
			// last_row_1 = 124; last_row_2 = 180.
			val = (last_row[1] << 16) + last_row[0];
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x20, val);
			// last_row_3 = 231; last_row_4 = 282.
			val = (last_row[3] << 16) + last_row[2];
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x24, val);
			// last_row_5 = 328; last_row_6 = 367.
			val = (last_row[5] << 16) + last_row[4];
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x28, val);
			// last_row_7 = 416; last_row_8 = 501.
			val = (last_row[7] << 16) + last_row[6];
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR + 0x2C, val);

			init_frame = 0;

			// Step 5: Start image sensor
			xil_printf("[Info] Start image sensor.\n\r");
			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR, 1);

			for (cpu_recv_cnt = 0; cpu_recv_cnt < 1000; ++cpu_recv_cnt) {

				while (curr_cnt <= cpu_recv_cnt) {
				    curr_cnt = arm_recv_cnt;
				}
				xil_printf("fpga_cnt = %d | host_cnt = %d\n\r", curr_cnt, cpu_recv_cnt);

				rdaddr = 0x0F000000 + ((cpu_recv_cnt % 32) * 266400);

				for (i = 0; i < 185; ++i)
				{
					memcpy(send_buf, (void *) (uint64_t) rdaddr, 1440);
					lwip_write(new_sd, send_buf, 1440);
					rdaddr = rdaddr + 1440;
				}
			}

			Xil_Out32(XPAR_CIMGPROCCTRL_0_S00_AXI_BASEADDR, 0);
			xil_printf("[Info] Stop image sensor.\n\r");
		}
		else if (recv_buf[0] == 4)
		{
			xil_printf("Wait for new INPUT Command:\n\r");
		}
	}
}
