/*******************************
 * FileName: int2fp.c
 * Designer: Zhe
 * Modified: 12/20/2017
 * Describe: This module converts 32-bit integer value into
 *           32-bit floating point value.
 **********************************************************************/
#include "int2fp.h"

void int2fp(int input, float *output) {

//#pragma HLS interface ap_vld port=output register

	*output = (float) input;
}
