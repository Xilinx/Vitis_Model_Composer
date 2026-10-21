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

class m16_ssr8_cyclic_shift {
public:
  static constexpr unsigned M = 16;
  static constexpr unsigned NSTATE = 8; //
  static constexpr unsigned SSR_I = 8;  //
  static constexpr unsigned SSR_O = 8;
  static constexpr unsigned FIFO = 4;
  static constexpr unsigned NBITS_SAMP = 32; // For cint16 samples
  static constexpr unsigned NBITS_AXI = 128; 
  typedef ap_uint<NBITS_SAMP>       TT_DATA;
  typedef ap_uint<NBITS_AXI>        TT_AXI4;
  typedef hls::stream<TT_AXI4> TT_STREAM;

  // Constructor:
  m16_ssr8_cyclic_shift( void );

private:
  void unpack_samples( TT_DATA (&data_i_0)[M], TT_DATA (&data_i_1)[M], TT_STREAM sig_i[SSR_I]);

  void cyclic_shift( TT_DATA (&data_i)[M], TT_DATA (&data_o)[M], ap_uint<3> fsm_state );

  void write_streams( TT_DATA (&data_p_0)[M], TT_DATA (&data_p_1)[M], TT_STREAM sig_o[SSR_O] );

public:
  // Library IDFT with TP_SSR=4 and TP_CASC_LEN=4: sixteen lanes
  // indexed as casc + rank*TP_CASC_LEN. Each lane is already
  // cascade-split so Simulink does not need CascDemux.
  static constexpr unsigned IDFT_SSR = 4;
  static constexpr unsigned IDFT_CASC = 4;
  static constexpr unsigned IDFT_LANES = IDFT_SSR * IDFT_CASC;
  // Words emitted per lane per run_idft() call:
  // 2 frames * (1 data word + 1 pad word). The library input window is
  // 8 samples per frame per lane (TP_POINT_SIZE/TP_CASC_LEN padded to the
  // cint16 vector granularity), independent of TP_SSR, so each lane needs
  // 4 valid samples followed by 4 zeros.
  static constexpr unsigned IDFT_WORDS_PER_CALL = 2 * 2;

private:
  void write_idft_streams( TT_DATA (&data_p_0)[M],
                           TT_DATA (&data_p_1)[M],
                           TT_STREAM sig_o[IDFT_LANES] );

public:
  // Run:
  // Assume 250 MHz clock.
  // We have eight 32-bit I/O's @ 1000 MHz AIE clock or eight 128-bit I/O's @ 250 MHz
  // We get four samples per PL clock representing consecutive time samples
  // This routine needs to be II=1
  void run( TT_STREAM sig_i[SSR_I],
           TT_STREAM sig_o[SSR_O] );

  // Produce the padded, cascade-dealt, SSR-duplicated streams consumed
  // directly by a 16-point IDFT with TP_CASC_LEN=4 and TP_SSR=4.
  void run_idft( TT_STREAM sig_i[SSR_I],
                 TT_STREAM sig_o[IDFT_LANES] );
  
};

// ------------------------------------------------------------
// Wrapper
// ------------------------------------------------------------

using TT_DUT = m16_ssr8_cyclic_shift;

void m16_ssr8_cyclic_shift_wrapper( TT_DUT::TT_STREAM &sig0_i,
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

void m16_ssr8_cyclic_shift_array(TT_DUT::TT_STREAM sig_i[TT_DUT::SSR_I],
                                         TT_DUT::TT_STREAM sig_o[TT_DUT::SSR_O]);

void m16_ssr8_cshift_idft_array(
    TT_DUT::TT_STREAM sig_i[TT_DUT::SSR_I],
    TT_DUT::TT_STREAM half0[TT_DUT::IDFT_LANES],
    TT_DUT::TT_STREAM half1[TT_DUT::IDFT_LANES]);


