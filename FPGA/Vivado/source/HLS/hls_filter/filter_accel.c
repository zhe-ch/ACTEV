/*******************************
 * FileName: filter_accel.c
 * Designer: Zhe
 * Modified: 08/17/2017
 * Describe: This module perform 17x17 Gaussian filtering
 *           based on predefined coefficients.
 *           2D systolic array architecture is utilized to
 *           achieve maximized throughput.
 **********************************************************************/
#include "filter_accel.h"


void filter_accel(
		uint8 in0, uint8 in1, uint8 in2, uint8 in3,
		uint8 in4, uint8 in5, uint8 in6, uint8 in7,
		uint8 in8, uint8 in9, uint8 in10, uint8 in11,
		uint8 in12, uint8 in13, uint8 in14, uint8 in15,
		uint8 in16,
		int *out) {

	static uint9 reg0[9][17];
	static uint10 reg1[9][9];
	static uint11 reg2[8][4];

	static int19 prod[8][4];

	static int20 sum_l0[4][4];
	static int21 sum_l1[2][4];
	static int22 sum_l2[2][2];
	static int23 sum_l3[2];


	static int8 weight[8][4] = {
			-106,
			 -90, -76, -67, -64,
			 -98, -73, -52, -36, -26, -22,
			 -67, -39, -15,   3,  14,  18,
			  -8,  18,  37,  50,  54,
			  46,  67,  80,  84,
			  89, 103, 108,
			  117,122,
			  127
	};

	int i, j;

	*out = sum_l3[0] + sum_l3[1];

	// Reduction: Layer 2 -> Layer 3 (1x2)
	for (i = 0; i < 2; ++i) {
#pragma HLS UNROLL
		sum_l3[i] = sum_l2[i][0] + sum_l2[i][1];
	}

	// Reduction: Layer 1 -> Layer 2 (2x2)
	for (j = 0; j < 2; ++j) {
#pragma HLS UNROLL
		for (i = 0; i < 2; ++i) {
#pragma HLS unroll
			sum_l2[j][i] = sum_l1[j][i*2] + sum_l1[j][i*2+1];
		}
	}

	// Reduction: Layer 0 -> Layer 1 (2x4)
	for (j = 0; j < 2; ++j) {
#pragma HLS UNROLL
		for (i = 0; i < 4; ++i) {
#pragma HLS UNROLL
			sum_l1[j][i] = sum_l0[j*2][i] + sum_l0[j*2+1][i];
		}
	}

	// Reduction: Production -> Layer 0 (4x4)
	for (j = 0; j < 4; ++j) {
#pragma HLS UNROLL
		for (i = 0; i < 4; ++i) {
#pragma HLS UNROLL
			sum_l0[j][i] = prod[j*2][i] + prod[j*2+1][i];
		}
	}

	for (j = 0; j < 8; ++j) {
#pragma HLS UNROLL
		for (i = 0; i < 4; ++i) {
#pragma HLS UNROLL
			prod[j][i] = reg2[j][i] * weight[j][i];
		}
	}

	reg2[0][0] = reg1[0][8] + reg1[8][0];
	reg2[0][1] = reg1[1][5] + reg1[5][1];
	reg2[0][2] = reg1[1][6] + reg1[6][1];
	reg2[0][3] = reg1[1][7] + reg1[7][1];
	reg2[1][0] = reg1[1][8] + reg1[8][1];
	reg2[1][1] = reg1[2][3] + reg1[3][2];
	reg2[1][2] = reg1[2][4] + reg1[4][2];
	reg2[1][3] = reg1[2][5] + reg1[5][2];
	reg2[2][0] = reg1[2][6] + reg1[6][2];
	reg2[2][1] = reg1[2][7] + reg1[7][2];
	reg2[2][2] = reg1[2][8] + reg1[8][2];
	reg2[2][3] = reg1[3][3];
	reg2[3][0] = reg1[3][4] + reg1[4][3];
	reg2[3][1] = reg1[3][5] + reg1[5][3];
	reg2[3][2] = reg1[3][6] + reg1[6][3];
	reg2[3][3] = reg1[3][7] + reg1[7][3];
	reg2[4][0] = reg1[3][8] + reg1[8][3];
	reg2[4][1] = reg1[4][4];
	reg2[4][2] = reg1[4][5] + reg1[5][4];
	reg2[4][3] = reg1[4][6] + reg1[6][4];
	reg2[5][0] = reg1[4][7] + reg1[7][4];
	reg2[5][1] = reg1[4][8] + reg1[8][4];
	reg2[5][2] = reg1[5][5];
	reg2[5][3] = reg1[5][6] + reg1[6][5];
	reg2[6][0] = reg1[5][7] + reg1[7][5];
	reg2[6][1] = reg1[5][8] + reg1[8][5];
	reg2[6][2] = reg1[6][6];
	reg2[6][3] = reg1[6][7] + reg1[7][6];
	reg2[7][0] = reg1[6][8] + reg1[8][6];
	reg2[7][1] = reg1[7][7];
	reg2[7][2] = reg1[7][8] + reg1[8][7];
	reg2[7][3] = reg1[8][8];

	for (j = 0; j < 9; ++j) {
#pragma HLS UNROLL
		reg1[j][0] = reg0[j][0] + reg0[j][16];
		reg1[j][1] = reg0[j][1] + reg0[j][15];
		reg1[j][2] = reg0[j][2] + reg0[j][14];
		reg1[j][3] = reg0[j][3] + reg0[j][13];
		reg1[j][4] = reg0[j][4] + reg0[j][12];
		reg1[j][5] = reg0[j][5] + reg0[j][11];
		reg1[j][6] = reg0[j][6] + reg0[j][10];
		reg1[j][7] = reg0[j][7] + reg0[j][9];
		reg1[j][8] = reg0[j][8];
	}

	for (j = 0; j < 9; ++j) {
#pragma HLS UNROLL
		for (i = 16; i > 0; --i) {
#pragma HLS UNROLL
			reg0[j][i] = reg0[j][i-1];
		}
	}

	reg0[0][0] = in0 + in16;
	reg0[1][0] = in1 + in15;
	reg0[2][0] = in2 + in14;
	reg0[3][0] = in3 + in13;
	reg0[4][0] = in4 + in12;
	reg0[5][0] = in5 + in11;
	reg0[6][0] = in6 + in10;
	reg0[7][0] = in7 + in9;
	reg0[8][0] = in8;

	return;
}

