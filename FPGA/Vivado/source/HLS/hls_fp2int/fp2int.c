/*******************************
 * FileName: fp2int.c
 * Designer: Zhe
 * Modified: 12/21/2017
 * Describe: This module converts 32-bit floating point value into
 *           32-bit integer value.
 **********************************************************************/
#include "fp2int.h"

void fp2int(float input, int *output) {

//#pragma HLS interface ap_vld port=output register

    *output = (int) input;
}
