#ifndef __ADD_KERNEL_H__
#define __ADD_KERNEL_H__

#include <adf.h>

template <int NUM_SAMPLES>
void pass_through_kernel(input_window_int32 * inw, output_window_int32 * outw);

#endif //__ADD_KERNEL_H__
