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

#include "m16_ssr8_permute_fb_o.h"

// ------------------------------------------------------------
// Constructor
// ------------------------------------------------------------

m16_ssr8_permute_fb_o::m16_ssr8_permute_fb_o( void )
{
}

// ------------------------------------------------------------
// Unpack samples
// ------------------------------------------------------------

void m16_ssr8_permute_fb_o::unpack_samples( TT_STREAM sig_i[SSR], TT_DATA (data_i_0)[M], TT_DATA (data_i_1)[M] )
{
  static bool           odd_cycle = 0;
  static bool                pong = 0;
  static TT_AXI4 bot_streams[SSR] = { TT_AXI4(0) };
  static TT_DATA      data0[2][M] = { TT_DATA(0) };
  static TT_DATA      data1[2][M] = { TT_DATA(0) };
  static TT_DATA      data2[2][M] = { TT_DATA(0) };
  static TT_DATA      data3[2][M] = { TT_DATA(0) };
#pragma HLS reset           variable=odd_cycle
#pragma HLS reset           variable=pong
#pragma HLS array_partition variable=bot_streams
#pragma HLS array_partition variable=data0   dim=0
#pragma HLS array_partition variable=data1   dim=0
#pragma HLS array_partition variable=data2   dim=0
#pragma HLS array_partition variable=data3   dim=0
#pragma HLS INLINE

  TT_AXI4 top_streams[SSR];
#pragma HLS array_partition variable=top_streams

  // Read the streams into 'top' or 'bottom' based on even vs. odd cycle:
 READ: for (int ss=0; ss < SSR; ss++) {
    TT_AXI4 val_i = sig_i[ss].read();
    if ( odd_cycle == 0 )
      top_streams[ss] = val_i;
    else
      bot_streams[ss] = val_i;
  } // ss

  // Unpack streams into appropriate buffers:
 UNPACK: for (int ss=0; ss < SSR; ss++) {
    if (odd_cycle==0) (data3[pong][2*ss  ],data2[pong][2*ss  ],data1[pong][2*ss  ],data0[pong][2*ss  ] ) = top_streams[ss];
    else              (data3[pong][2*ss+1],data2[pong][2*ss+1],data1[pong][2*ss+1],data0[pong][2*ss+1] ) = bot_streams[ss];
  } // ss

  // Copy outputs based on 'pong' and 'odd_cycle' states:
 COPY: for (int mm=0; mm < M; mm++) {
    if ( odd_cycle == 0 ) {
      data_i_0[mm] = data0[!pong][mm];
      data_i_1[mm] = data1[!pong][mm];
    }
    else {
      data_i_0[mm] = data2[!pong][mm];
      data_i_1[mm] = data3[!pong][mm];
    }
  } // mm

  // Update 'pong' state:
  if ( odd_cycle == 1 ) pong = 1 - pong;

  // Update cycle:
  odd_cycle = 1 - odd_cycle;
}

// ------------------------------------------------------------
// Align Latency
// ------------------------------------------------------------

void m16_ssr8_permute_fb_o::align_latency( TT_DATA (&data_i_0)[M], TT_DATA (&data_i_1)[M],
                                           TT_DATA (&data_o_0)[M], TT_DATA (&data_o_1)[M] )
{
  // AIE filterbank kernel is aligned to 8-cycle period (due to tap assignments).
  // So we introduce 4 cycles additional latency to compliment the 4 cycles added during stream unpacking
  static TT_DATA buff0[M][LATENCY] = { TT_DATA(0) };
  static TT_DATA buff1[M][LATENCY] = { TT_DATA(0) };
  static ap_uint<2> cnt = 0;

#pragma HLS array_partition variable=buff0 dim=0
#pragma HLS array_partition variable=buff1 dim=0
 DELAY: for (unsigned mm=0; mm < M; mm++) {
    data_o_0[mm] = buff0[mm][cnt];
    data_o_1[mm] = buff1[mm][cnt];
    buff0[mm][cnt] = data_i_0[mm];
    buff1[mm][cnt] = data_i_1[mm];
  }
  cnt = ( cnt == ap_uint<2>(LATENCY-1) ) ? ap_uint<2>(0) : ap_uint<2>(cnt + 1);
}

// ------------------------------------------------------------
// Apply Permutation:
// ------------------------------------------------------------

void m16_ssr8_permute_fb_o::apply_permutation( TT_DATA (&data_i)[M], TT_DATA (&data_o)[M], ap_uint<3> state )
{
  static ap_uint<4> permute[NSTATE][M] = { { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15},
                                           { 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15, 0, 1},
                                           { 4, 5, 6, 7, 8, 9,10,11,12,13,14,15, 0, 1, 2, 3},
                                           { 6, 7, 8, 9,10,11,12,13,14,15, 0, 1, 2, 3, 4, 5},
                                           { 8, 9,10,11,12,13,14,15, 0, 1, 2, 3, 4, 5, 6, 7},
                                           {10,11,12,13,14,15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
                                           {12,13,14,15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11},
                                           {14,15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13} };
#pragma HLS INLINE
 PERMUTE: for (unsigned mm=0; mm < M; mm++) {
    unsigned pp = permute[state][mm];
    data_o[mm] = data_i[pp];
  } // mm
}

// ------------------------------------------------------------
// Run
// ------------------------------------------------------------

void m16_ssr8_permute_fb_o::run( TT_STREAM sig_i[SSR], TT_STREAM sig_o[SSR] )
{
#pragma HLS inline

  // Need to declare as 'static' in Vitis HLS to allow resets to be applied:
  static ap_uint<3> fsm_state = 0;
#pragma HLS reset variable=fsm_state

  // Unpack the new input samples and combine with state history:
  TT_DATA data_i_0[M];
  TT_DATA data_i_1[M];
#pragma HLS array_partition variable=data_i_0
#pragma HLS array_partition variable=data_i_1
  unpack_samples( sig_i, data_i_0, data_i_1 );

  // Align latency:
  TT_DATA data_d_0[M];
  TT_DATA data_d_1[M];
#pragma HLS array_partition variable=data_d_0
#pragma HLS array_partition variable=data_d_1
  align_latency( data_i_0, data_i_1, data_d_0, data_d_1 );

  // Apply output permutation:
  TT_DATA data_o_0[M];
  TT_DATA data_o_1[M];
#pragma HLS array_partition variable=data_o_0
#pragma HLS array_partition variable=data_o_1

  apply_permutation( data_d_0, data_o_0, fsm_state ); fsm_state++;
  apply_permutation( data_d_1, data_o_1, fsm_state ); fsm_state++;

  // Write outputs to streams:
 WRITE: for (unsigned ii=0; ii < SSR; ii++) {
    // Concat four samples into a 128-bit bus:
    TT_AXI4 val_o = ( data_o_1[ii+SSR], data_o_1[ii], data_o_0[ii+SSR], data_o_0[ii]);
    sig_o[ii].write( val_o );
  }
}

// ------------------------------------------------------------
// Wrapper
// ------------------------------------------------------------

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
                                    TT_DUT::TT_STREAM &sig7_o )
{
#pragma HLS interface mode=ap_ctrl_none port=return
#pragma HLS pipeline II=1
  
    TT_DUT::TT_STREAM sig_i[TT_DUT::SSR];
  TT_DUT::TT_STREAM sig_o[TT_DUT::SSR];
  
  sig_i[0].write(sig0_i.read());
  sig_i[1].write(sig1_i.read());
  sig_i[2].write(sig2_i.read());
  sig_i[3].write(sig3_i.read());
  sig_i[4].write(sig4_i.read());
  sig_i[5].write(sig5_i.read());
  sig_i[6].write(sig6_i.read());
  sig_i[7].write(sig7_i.read());
  
  static m16_ssr8_permute_fb_o dut;
  dut.run( sig_i, sig_o );
  
  sig0_o.write(sig_o[0].read());
  sig1_o.write(sig_o[1].read());
  sig2_o.write(sig_o[2].read());
  sig3_o.write(sig_o[3].read());
  sig4_o.write(sig_o[4].read());
  sig5_o.write(sig_o[5].read());
  sig6_o.write(sig_o[6].read());
  sig7_o.write(sig_o[7].read());
}

