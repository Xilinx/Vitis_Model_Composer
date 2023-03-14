#include <aie_api/aie.hpp>
#include <adf.h>
#include <mul.h>

void aie_mul(adf::input_buffer<cint16,adf::extents<8> > & restrict win_i1,
             adf::input_buffer<cint16,adf::extents<8> > & restrict win_i2,
             output_stream_cacc48 *cout)
{
    // Use 'iterator' to walk through coefficients:
    auto wi1 = aie::begin_vector<8>( win_i1 );
    auto wi2 = aie::begin_vector<8>( win_i2 );

    aie::accum<cacc48,8> acc = aie::mul<cacc48>( *wi1, *wi2 );

void writeincr_v8(output_stream_acc48 *w, v8acc48 v);
    writeincr_v8(cout,acc);
}
