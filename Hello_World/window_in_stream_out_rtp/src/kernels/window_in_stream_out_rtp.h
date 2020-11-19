#include <cardano.h>

#ifndef __RTP_KERNEL_H__
#define __RTP_KERNEL_H__

void simple_w2s(input_window_int16 * in1,int8 &io_rtp, const int8 (&coeff)[4],output_stream_int32 * out);

#endif //__RTP_KERNEL_H
