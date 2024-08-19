/*******************************
 * FileName: erosion_accel.c
 * Designer: Zhe
 * Modified: 10/26/2017
 * Describe: This module perform 19x19 grayscale erosion
 *           based on ones(19) template.
 *           2D systolic array architecture is utilized to
 *           achieve maximized throughput.
 ****************************************************************/

#include "erosion_accel.h"

void erosion_accel(
		uint1 init, uint8 in0, uint8 in1, uint8 in2, uint8 in3,
		uint8 in4, uint8 in5, uint8 in6, uint8 in7,
		uint8 in8, uint8 in9, uint8 in10, uint8 in11,
		uint8 in12, uint8 in13, uint8 in14, uint8 in15,
		uint8 in16, uint8 in17, uint8 in18, uint8 *out) {

	static uint8 regCol0[16];
	static uint8 regCol1[8];
	static uint8 regCol2[4];
	static uint8 regCol3[2];
    static uint8 regRow0[19];
    static uint8 regRow1[16];
    static uint8 regRow2[8];
    static uint8 regRow3[4];
    static uint8 regRow4[2];

    int i;

    if (init == 1) {
    	*out = 255;

    	for (i = 0; i < 2; ++i) {
#pragma HLS UNROLL
    		regRow4[i] = 255;
    	}

    	for (i = 0; i < 4; ++i) {
#pragma HLS UNROLL
    		regRow3[i] = 255;
    	}

    	for (i = 0; i < 8; ++i) {
#pragma HLS UNROLL
    		regRow2[i] = 255;
    	}

    	for (i = 0; i < 16; ++i) {
#pragma HLS UNROLL
    		regRow1[i] = 255;
    	}

    	for (i = 0; i < 19; ++i) {
#pragma HLS UNROLL
    		regRow0[i] = 255;
    	}

    	for (i = 0; i < 2; ++i) {
#pragma HLS UNROLL
    		regCol3[i] = 255;
    	}

    	for (i = 0; i < 4; ++i) {
#pragma HLS UNROLL
    		regCol2[i] = 255;
    	}

    	for (i = 0; i < 8; ++i) {
#pragma HLS UNROLL
    		regCol1[i] = 255;
    	}
    }
    else {

    	if (regRow4[0] < regRow4[1]) {
    		*out = regRow4[0];
    	}
    	else {
    		*out = regRow4[1];
    	}

		// Reduction: Layer Row3 -> Layer Row4 (1x2)
		for (i = 0; i < 2; ++i) {
#pragma HLS UNROLL
			if (regRow3[i*2] < regRow3[i*2+1]) {
				regRow4[i] = regRow3[i*2];
			}
			else {
				regRow4[i] = regRow3[i*2+1];
			}
		}

		// Reduction: Layer Row2 -> Layer Row3 (1x4)
		for (i = 0; i < 4; ++i) {
#pragma HLS UNROLL
			if (regRow2[i*2] < regRow2[i*2+1]) {
				regRow3[i] = regRow2[i*2];
			}
			else {
				regRow3[i] = regRow2[i*2+1];
			}
		}

		// Reduction: Layer Row1 -> Layer Row2 (1x8)
		for (i = 0; i < 8; ++i) {
#pragma HLS UNROLL
			if (regRow1[i*2] < regRow1[i*2+1]) {
				regRow2[i] = regRow1[i*2];
			}
			else {
				regRow2[i] = regRow1[i*2+1];
			}
		}

    	regRow1[0] = regRow0[0];
    	regRow1[1] = regRow0[1];
    	regRow1[2] = regRow0[2];
    	regRow1[3] = regRow0[3];
    	regRow1[4] = regRow0[4];
    	regRow1[5] = regRow0[5];
    	regRow1[6] = regRow0[6];
    	regRow1[7] = regRow0[7];
    	regRow1[8] = regRow0[8];
    	regRow1[9] = regRow0[9];
    	regRow1[10] = regRow0[10];
    	regRow1[11] = regRow0[11];
    	regRow1[12] = regRow0[12];

    	if (regRow0[13] < regRow0[14]) {
    		regRow1[13] = regRow0[13];
    	}
    	else {
    		regRow1[13] = regRow0[14];
    	}

    	if (regRow0[15] < regRow0[16]) {
    		regRow1[14] = regRow0[15];
    	}
    	else {
    		regRow1[14] = regRow0[16];
    	}

    	if (regRow0[17] < regRow0[18]) {
    		regRow1[15] = regRow0[17];
    	}
    	else {
    		regRow1[15] = regRow0[18];
    	}

    	for (i = 18; i > 0; --i) {
#pragma HLS UNROLL
    		regRow0[i] = regRow0[i-1];
    	}

		if (regCol3[0] < regCol3[1]) {
			regRow0[0] = regCol3[0];
		}
		else {
			regRow0[0] = regCol3[1];
		}

		// Reduction: Layer Col2 -> Layer Col3 (1x2)
		for (i = 0; i < 2; ++i) {
#pragma HLS UNROLL
			if (regCol2[i*2] < regCol2[i*2+1]) {
				regCol3[i] = regCol2[i*2];
			}
			else {
				regCol3[i] = regCol2[i*2+1];
			}
		}

		// Reduction: Layer Col1 -> Layer Col2 (1x4)
		for (i = 0; i < 4; ++i) {
#pragma HLS UNROLL
			if (regCol1[i*2] < regCol1[i*2+1]) {
				regCol2[i] = regCol1[i*2];
			}
			else {
				regCol2[i] = regCol1[i*2+1];
			}
		}

		// Reduction: Layer Col0 -> Layer Col1 (1x8)
		for (i = 0; i < 8; ++i) {
#pragma HLS UNROLL
			if (regCol0[i*2] < regCol0[i*2+1]) {
				regCol1[i] = regCol0[i*2];
			}
			else {
				regCol1[i] = regCol0[i*2+1];
			}
		}
    }

	// Reduction: Layer in -> Layer 1 (1x8)
	regCol0[0] = in0;
	regCol0[1] = in1;
	regCol0[2] = in2;
	regCol0[3] = in3;
	regCol0[4] = in4;
	regCol0[5] = in5;
	regCol0[6] = in6;
	regCol0[7] = in7;
	regCol0[8] = in8;
	regCol0[9] = in9;
	regCol0[10] = in10;
	regCol0[11] = in11;
	regCol0[12] = in12;

	if (in13 < in14) {
		regCol0[13] = in13;
	}
	else {
		regCol0[13] = in14;
	}

	if (in15 < in16) {
		regCol0[14] = in15;
	}
	else {
		regCol0[14] = in16;
	}

    if (in17 < in18) {
    	regCol0[15] = in17;
    }
    else {
    	regCol0[15] = in18;
    }

    return;
}
