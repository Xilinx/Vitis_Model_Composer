//
// Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: MIT
//

#include <adf.h>
#include <aie_api/aie.hpp>

#include "ifft_custom.h"
#include "fft256_twiddle.h"
void ifft_custom_init()
{
aie::set_rounding(aie::rounding_mode::symmetric_inf);
aie::set_saturation(aie::saturation_mode::none); // saturate?
}

void ifft_custom(input_cascade<cacc48> *sig_i,
                     output_buffer<TT_DATA,extents<iFFT_PTS> >& __restrict sig_o)
{
    alignas(aie::vector_decl_align) TT_DATA ibuff[256]; 
    alignas(aie::vector_decl_align) TT_DATA tbuff[256];

    // Set pointers to windows:
    auto pI = aie::begin_vector<4>(ibuff);
    TT_DATA *obuff = sig_o.data();

    aie::accum<cacc48,4> temp;

    // *** convert from cascade to ibuff array of data ***
    for (unsigned l=0; l<32; l++) // read 32*8=256 samples
    chess_prepare_for_pipelining
    { 
        temp = readincr_v<4>(sig_i); // read 4, cacc48 samples
        *pI++ = temp.to_vector<cint32>(18); // right shift by 1/2^18 , convert to v4cint32 data type

        temp = readincr_v<4>(sig_i);
        *pI++ = temp.to_vector<cint32>(18);
    } 

    // 256 pt iFFT_PTS
    aie::fft_dit_r4_stage<64>(ibuff, tw4a_1, tw4a_0, tw4a_2, iFFT_PTS, SHIFT_iFFT, SHIFT_iFFT, iFFT, tbuff); // was tbuff
    aie::fft_dit_r4_stage<16>(tbuff, tw4b_1, tw4b_0, tw4b_2, iFFT_PTS, SHIFT_iFFT, SHIFT_iFFT, iFFT, ibuff);
    aie::fft_dit_r4_stage< 4>(ibuff, tw4c_1, tw4c_0, tw4c_2, iFFT_PTS, SHIFT_iFFT, SHIFT_iFFT, iFFT, tbuff);
    aie::fft_dit_r4_stage< 1>(tbuff, tw4d_1, tw4d_0, tw4d_2, iFFT_PTS, SHIFT_iFFT, SHIFT_iFFT, iFFT, obuff);

}
