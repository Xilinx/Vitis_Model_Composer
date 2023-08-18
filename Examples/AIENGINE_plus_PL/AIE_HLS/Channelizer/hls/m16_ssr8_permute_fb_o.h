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

class m16_ssr8_permute_fb_o {
public:
  static constexpr unsigned LATENCY = 2; // To align to 8-cycle AIE filterbank
  static constexpr unsigned M = 16;
  static constexpr unsigned NSTATE = 8; // Set based on P/Q and M
  static constexpr unsigned SSR = 8;
  static constexpr unsigned NBITS_SAMP = 32; // For cint16 samples
  static constexpr unsigned NBITS_AXI = 128;
  typedef ap_uint<NBITS_SAMP>     TT_DATA;
  typedef ap_uint<NBITS_AXI>      TT_AXI4;
  typedef hls::stream<TT_AXI4>    TT_STREAM;

private:
  void apply_permutation( TT_DATA (&data_i)[M], TT_DATA (&data_o)[M], ap_uint<3> state );
  void unpack_samples( TT_STREAM sig_i[SSR], TT_DATA (data_i_0)[M], TT_DATA (data_i_1)[M] );
  void align_latency( TT_DATA (&data_i_0)[M], TT_DATA (&data_i_1)[M],
                      TT_DATA (&data_o_0)[M], TT_DATA (&data_o_1)[M] );
public:
  // Constructor:
  m16_ssr8_permute_fb_o( void );

  // Run:
  void run( TT_STREAM sig_i[SSR], TT_STREAM sig_o[SSR] );
};

using TT_DUT = m16_ssr8_permute_fb_o;

void m16_ssr8_permute_fb_o_wrapper( TT_DUT::TT_STREAM &sig0_i,
                                    TT_DUT::TT_STREAM &sig1_i,
                                    TT_DUT::TT_STREAM &sig2_i,
                                    TT_DUT::TT_STREAM &sig3_i,
                                    TT_DUT::TT_STREAM &sig4_i,
                                    TT_DUT::TT_STREAM &sig5_i,
                                    TT_DUT::TT_STREAM &sig6_i,
                                    TT_DUT::TT_STREAM &sig7_i,
                                    TT_DUT::TT_STREAM &sig0_o,
                                    TT_DUT::TT_STREAM &sig1_o,
                                    TT_DUT::TT_STREAM &sig2_o,
                                    TT_DUT::TT_STREAM &sig3_o,
                                    TT_DUT::TT_STREAM &sig4_o,
                                    TT_DUT::TT_STREAM &sig5_o,
                                    TT_DUT::TT_STREAM &sig6_o,
                                    TT_DUT::TT_STREAM &sig7_o );
