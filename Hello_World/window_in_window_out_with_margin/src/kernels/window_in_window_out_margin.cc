#include "window_in_window_out_margin.h"

void win_margin(input_window_int32 * inw,output_window_int32 * outw)
{
	int32 temp_in;
    int32 temp_out;
	for (unsigned i=0; i<NUM_SAMPLES + MARGIN_SIZE; i++) {
		window_readincr(inw,temp_in);
		temp_out = temp_in;
        window_writeincr(outw,temp_out);
	}
}