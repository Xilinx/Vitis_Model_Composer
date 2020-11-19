#include "stream_in_stream_out.h"

void simple_square(input_stream_int32 * in, output_stream_int32 * out) {
  for (unsigned i=0; i<16; i++) {
    int32 val = readincr(in);
    int32 squaring = val * val;
    writeincr(out,squaring);
  }
} 