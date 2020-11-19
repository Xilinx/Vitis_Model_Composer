#include "window_in_stream_out_rtp.h"

void simple_w2s(input_window_int16 * in1,int8 &io_rtp, const int8 (&coeff)[4],output_stream_int32 * out) {
  int16 val;
  for (unsigned i=0; i<16; i++) {
    window_readincr(in1,val);
    int32 squaring = val * val;
    io_rtp = coeff[0]+coeff[1]+coeff[2]+coeff[3];
    writeincr(out,squaring);
  }
}
