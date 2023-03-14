#include <aie_api/aie.hpp>
#include <adf.h>

void aie_mul(adf::input_buffer<cint16,adf::extents<8> > & restrict win_i1,
             adf::input_buffer<cint16,adf::extents<8> > & restrict win_i2,
             output_stream_cacc48 *cout);