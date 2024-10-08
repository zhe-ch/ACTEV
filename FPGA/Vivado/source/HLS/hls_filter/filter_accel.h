/*******************************
 * FileName: filter_accel.h
 * Designer: Zhe
 * Modified: 08/17/2018
 * Describe: Header file of the filter_accel.c
 ************************************************/

#ifndef _CONV_FILTER_H_
#define _CONV_FILTER_H_

#include <stdio.h>
#include "ap_cint.h"

void filter_accel(
		uint8 in0, uint8 in1, uint8 in2, uint8 in3,
		uint8 in4, uint8 in5, uint8 in6, uint8 in7,
		uint8 in8, uint8 in9, uint8 in10, uint8 in11,
		uint8 in12, uint8 in13, uint8 in14, uint8 in15,
		uint8 in16,
		int *out);

#endif
