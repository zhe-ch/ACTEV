/*******************************
 * FileName: erosion_accel.h
 * Designer: Zhe
 * Modified: 06/03/2019
 * Describe: Header file of the denoise_filter.c
 ************************************************/

#ifndef _DENOISE_FILTER_H_
#define _DENOISE_FILTER_H_

#include <stdio.h>
#include "ap_cint.h"

void denoise_filter(
		uint8 in0, uint8 in1, uint8 in2, uint8 *out);

#endif
