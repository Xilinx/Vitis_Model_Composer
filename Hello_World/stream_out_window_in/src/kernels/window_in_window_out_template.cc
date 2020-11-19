#include <adf.h>
#include "window_in_window_out_template.h"

template <int NUM_SAMPLES>
void pass_through_kernel(input_window_int32 * inw, output_window_int32 * outw)
{
	int32 temp,temp_out;
	for (unsigned i=0; i<NUM_SAMPLES; i++) {
		window_readincr(inw,temp);
		window_writeincr(outw,temp);
	}
}