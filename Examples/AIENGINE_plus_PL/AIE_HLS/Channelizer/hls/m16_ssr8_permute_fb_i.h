// /**********
// © Copyright 2022 Advanced Micro Devices (AMD), Inc.
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

#pragma once

#include <complex>
#include <ap_fixed.h>
#include <hls_stream.h>

class m16_ssr8_permute_fb_i {
public:
  static constexpr unsigned LATENCY = 3; // To align to 8-cycle AIE filterbank
  static constexpr unsigned M = 16;
  static constexpr unsigned NSTATE = 8; // Set based on P/Q and M
  static constexpr unsigned SSR_I = 7;  // Only 7 inputs with P/Q = 8/7 setting
  static constexpr unsigned SSR_O = 8;
  static constexpr unsigned NBITS_SAMP = 32; // For cint16 samples
  static constexpr unsigned NBITS_AXI = 128;
  typedef ap_uint<NBITS_SAMP>     TT_DATA;
  typedef ap_uint<NBITS_AXI>      TT_AXI4;
  typedef hls::stream<TT_AXI4>    TT_STREAM;

  // Constructor:
  m16_ssr8_permute_fb_i( void );

private:
  void unpack_samples( TT_DATA (&data_i_0)[M], TT_DATA (&data_i_1)[M], TT_STREAM sig_i[SSR_I] );

  void apply_permutation( TT_DATA (&data_i)[M], TT_DATA (&data_o)[M], ap_uint<3> state );

  void align_latency( TT_DATA (&data_i_0)[M], TT_DATA (&data_i_1)[M],
                      TT_DATA (&data_o_0)[M], TT_DATA (&data_o_1)[M] );

  void format_streams( TT_DATA (&data_o_0)[M], TT_DATA (&data_o_1)[M], TT_AXI4 streams_o[SSR_O] );

  void write_streams( TT_AXI4 streams_o[SSR_O], TT_STREAM sig_o[SSR_O] );

public:
  // Run:
  // Assume 250 MHz clock.
  // We have eight 32-bit I/O's @ 1000 MHz AIE clock or eight 128-bit I/O's @ 250 MHz
  // We get four samples per PL clock representing consecutive time samples
  // This routine needs to be II=1
  void run( TT_STREAM sig_i[SSR_I],
            TT_STREAM sig_o[SSR_O] );
};

using TT_DUT = m16_ssr8_permute_fb_i;

// void m16_ssr8_permute_fb_i_wrapper( TT_DUT::TT_STREAM sig_i[TT_DUT::SSR_I],
//                                     TT_DUT::TT_STREAM sig_o[TT_DUT::SSR_O] );

void m16_ssr8_permute_fb_i_wrapper( TT_DUT::TT_STREAM &sig0_i,
                                    TT_DUT::TT_STREAM &sig1_i,
                                    TT_DUT::TT_STREAM &sig2_i,
                                    TT_DUT::TT_STREAM &sig3_i,
                                    TT_DUT::TT_STREAM &sig4_i,
                                    TT_DUT::TT_STREAM &sig5_i,
                                    TT_DUT::TT_STREAM &sig6_i,
                                    TT_DUT::TT_STREAM &sig0_o,
                                    TT_DUT::TT_STREAM &sig1_o,
                                    TT_DUT::TT_STREAM &sig2_o,
                                    TT_DUT::TT_STREAM &sig3_o,
                                    TT_DUT::TT_STREAM &sig4_o,
                                    TT_DUT::TT_STREAM &sig5_o,
                                    TT_DUT::TT_STREAM &sig6_o,
                                    TT_DUT::TT_STREAM &sig7_o );


