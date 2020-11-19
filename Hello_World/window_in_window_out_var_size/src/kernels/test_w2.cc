#include "test_w2.h"
void CompMul_kernel(input_window_cint16 * in,output_window_cint16 * out)
{
	cint16 temp_in,temp_out;
	for (unsigned i=0; i<window_size(out); i++) {
		window_readincr(in,temp_in);
		temp_out.real = temp_in.real *2;
        temp_out.imag = temp_in.imag *2;
		window_writeincr(out,temp_out);
	}
}