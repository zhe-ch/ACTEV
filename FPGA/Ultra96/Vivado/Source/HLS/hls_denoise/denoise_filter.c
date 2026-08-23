/*******************************
 * FileName: denoise_filter.c
 * Designer: Zhe
 * Modified: 06/03/2019
 * Describe: This module performs 3x3 filter function.
 *           2D systolic array architecture is utilized to
 *           achieve 1 pixel/cycle throughput.
 ****************************************************************/

#include "denoise_filter.h"

void denoise_filter(
		uint8 in0, uint8 in1, uint8 in2, uint8 *out) {

	static uint8 regCol0[2];
	static uint8 regRow0[3];
	static uint8 regRow1[2];

	int i;

	*out = (regRow1[0] + regRow1[1]) >> 1;

	regRow1[0] = (regRow0[0] + regRow0[1]) >> 1;
	regRow1[1] = regRow0[2];

	for (i = 2; i > 0; --i) {
#pragma HLS UNROLL
		regRow0[i] = regRow0[i-1];
	}

	regRow0[0] = (regCol0[0] + regCol0[1]) >> 1;

	regCol0[0] = (in0 + in1) >> 1;
	regCol0[1] = in2;

	return;
}
