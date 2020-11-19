#include "stream_in_stream_out.h"

void simple_square(input_stream_int32 * in, output_stream_int32 * out) {
  while(1) {
    int32 val = readincr(in);
    int32 squaring  = val * val;
    writeincr(out,squaring);
  }
}