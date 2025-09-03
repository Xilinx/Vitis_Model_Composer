//
// Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: MIT
//

#pragma once

#include <adf.h>
#include <aie_api/aie.hpp>

using namespace adf;

typedef cint32 TT_DATA;
typedef cint16 TT_TWID;
static constexpr unsigned     iFFT_PTS = 256; // iFFT point size
static constexpr bool      iFFT = true; // false for FFT, true for iFFT
static constexpr unsigned SHIFT_iFFT = 15;

    void ifft_custom_init();

    void ifft_custom(input_cascade<cacc48> *sig_i,
             output_buffer<TT_DATA,extents<iFFT_PTS> >& __restrict sig_o);
