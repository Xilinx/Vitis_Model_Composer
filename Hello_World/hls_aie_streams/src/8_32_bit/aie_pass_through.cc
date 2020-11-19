#include "aie_pass_through.h"

void pass_through(input_stream_int8 * in, output_stream_int8 * out) {
  for (unsigned i=0; i<16; i++) {
    v16int8 val = readincr_v16(in);
    v16int8 squaring = val;
    writeincr_v16(out,squaring);
  }
}