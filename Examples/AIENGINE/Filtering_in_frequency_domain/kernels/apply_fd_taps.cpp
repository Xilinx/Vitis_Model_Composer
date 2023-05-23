// /**********
// © Copyright 2020 Xilinx, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// **********/

#include <aie_api/aie.hpp>
#include <adf.h>

#include "kernels_common.h"
#include "kernels.h"

// Set # bits downshift after multiplication:
// --> Assume: data <s,16,1> x coeff <s,16,1> = <s,32,2> --> result <s,16,15>
#define DN_SHIFT 15

template <int NUM_OF_FRAMES>
void __attribute__ ((noinline)) ApplyFdTaps<NUM_OF_FRAMES>::apply_fd_taps(adf::input_buffer<cint16 > & restrict win_i,
                                                           adf::output_buffer<cint16> & restrict win_o )
{
    // Use 'iterator' to walk through coefficients:
    auto it = aie::begin_vector<8>( (const cint16*) coeff );
    auto wi = aie::begin_vector<8>( win_i );
    auto wo = aie::begin_vector<8>( win_o );

    aie::set_saturation(aie::saturation_mode::saturate);
    aie::set_rounding(aie::rounding_mode::conv_even);

    for (unsigned int ii=0; ii<NUM_OF_FRAMES; ii++) 
    {
        // Loop over frequency, performing 8 multiplications at a time
        for (unsigned int ll=0; ll < FFT_SIZE / 8; ll++)
        chess_loop_range(4,)
        chess_prepare_for_pipelining
        {

            aie::vector<cint16,8> taps = *it++;
            aie::vector<cint16,8> data = *wi++;
            aie::accum<cacc48,8> acc = aie::mul<cacc48>( data, taps );
            *wo++ = acc.to_vector<cint16>( DN_SHIFT );
        }
        it-=FFT_SIZE/8;
    }
}
