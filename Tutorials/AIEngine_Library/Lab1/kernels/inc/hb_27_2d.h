#ifndef __DECIMATOR_H__
#define __DECIMATOR_H__

#include <adf.h>

void fir_27taps_symm_hb_dec2(input_window_cint16 * restrict cb_input, output_window_cint16 * restrict cb_output);

#endif //__DECIMATOR_H__