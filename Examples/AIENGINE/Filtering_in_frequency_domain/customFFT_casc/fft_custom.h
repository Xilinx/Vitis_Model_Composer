//
// Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
// SPDX-License-Identifier: MIT
//

#pragma once

#include <adf.h>
#include <aie_api/aie.hpp>

using namespace adf;
  typedef cint32 TT_DATA;
  typedef cint16 TT_TWID;
  static constexpr unsigned     FFT_PTS = 256; // FFT point size
  static constexpr bool      FFTn = false; // false for FFT; true for iFFT;
  static constexpr unsigned SHIFT_FFT = 15;

void fft_custom_init();
  void fft_custom(input_buffer<TT_DATA,extents<FFT_PTS> >& __restrict sig_i, 
            output_cascade<cacc48> *sig_o );
