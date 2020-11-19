#include <adf.h>
#include "window_in_window_out_fixed_size.h"
void add_kernel(input_window_int16 * inw1,input_window_int16 * inw2, output_window_int16 * outw)
{
	int16 temp1,temp2,temp_out;
	for (unsigned i=0; i<NUM_SAMPLES; i++) {
		window_readincr(inw1,temp1);
		window_readincr(inw2,temp2);
		temp_out = temp1 + temp2;
		window_writeincr(outw,temp_out);
	}
}