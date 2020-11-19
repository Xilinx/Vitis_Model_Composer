#ifndef FUNCTION_KERNELS_H
#define FUNCTION_KERNELS_H
#include <adf.h>
void fft_256pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
#endif