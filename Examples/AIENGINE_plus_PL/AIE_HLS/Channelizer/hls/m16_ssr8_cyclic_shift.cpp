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

#include "m16_ssr8_cyclic_shift.h"

// ------------------------------------------------------------
// Constructor
// ------------------------------------------------------------

m16_ssr8_cyclic_shift::m16_ssr8_cyclic_shift( void )
{
}

// ------------------------------------------------------------
// Unpack input samples
// ------------------------------------------------------------

void m16_ssr8_cyclic_shift::unpack_samples( TT_DATA (&data_i_0)[M], TT_DATA (&data_i_1)[M], TT_STREAM sig_i[SSR_I])
{
#pragma HLS INLINE

  // Unpack the new input samples:
 UNPACK: for (unsigned ss=0; ss < SSR_I; ss++) {
    TT_AXI4 val_i = sig_i[ss].read();
    data_i_0[ss]       = val_i(31,0);   // sample data 1
    data_i_0[ss+SSR_I] = val_i(63,32);  // sample data 2
    data_i_1[ss]       = val_i(95,64);  // sample data 3
    data_i_1[ss+SSR_I] = val_i(127,96); // sample data 4
 } // ss

}

// ------------------------------------------------------------
// Apply cyclic shift
// ------------------------------------------------------------
void m16_ssr8_cyclic_shift::cyclic_shift( TT_DATA (&data_i)[M], TT_DATA (&data_o)[M], ap_uint<3> fsm_state )
{
#pragma HLS INLINE

 CYCLIC_SHIFT: for (unsigned mm=0; mm < M; mm++) {
    data_o[(mm+2*fsm_state)&0xF] = data_i[mm];
  } // mm

}

// ------------------------------------------------------------
// Write Output Streams
// ------------------------------------------------------------
void m16_ssr8_cyclic_shift::write_streams(TT_DATA (&data_p_0)[M], TT_DATA (&data_p_1)[M], TT_STREAM sig_o[SSR_O])
{
#pragma HLS INLINE

 // write outputs to streams in permuted order for DFT
 PACK_AND_OUTPUT: for (unsigned ss=0; ss < SSR_O; ss++) {
    TT_AXI4 val_o;
    // Writing four samples instead of two samples for 250 MHz
    val_o(31,0)   = data_p_0[2*ss+0];
    val_o(63,32)  = data_p_0[2*ss+1];
    val_o(95,64)  = data_p_1[2*ss+0];
    val_o(127,96) = data_p_1[2*ss+1];
    sig_o[ss].write( val_o );
  }
}

// ------------------------------------------------------------
// Run
// ------------------------------------------------------------

void m16_ssr8_cyclic_shift::run( TT_STREAM sig_i[SSR_I], TT_STREAM sig_o[SSR_O] )
{
#pragma HLS INLINE
  // Need to declare as 'static' in Vitis HLS to allow resets to be applied:
  static ap_uint<3> fsm_state = 0;
#pragma HLS reset variable=fsm_state

  // Unpack the new input samples and combine with state history:
  TT_DATA data_i_0[M], data_i_1[M];
#pragma HLS ARRAY_PARTITION variable=data_i_0
#pragma HLS ARRAY_PARTITION variable=data_i_1
  unpack_samples( data_i_0, data_i_1, sig_i);

  // Apply cyclic shift:
  TT_DATA data_cs_0[M], data_cs_1[M];
#pragma HLS ARRAY_PARTITION variable=data_cs_0
#pragma HLS ARRAY_PARTITION variable=data_cs_1
  cyclic_shift( data_i_0, data_cs_0, fsm_state );

  // Update FSM & state:
  fsm_state++;

  cyclic_shift( data_i_1, data_cs_1, fsm_state );

  // Update FSM & state:
  fsm_state++;

  // write outputs to streams in permuted order for DFT
  write_streams( data_cs_0, data_cs_1, sig_o );
}

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
                                    TT_DUT::TT_STREAM &sig7_o )
{
#pragma HLS interface mode=ap_ctrl_none port=return
#pragma HLS pipeline II=1

  TT_DUT::TT_STREAM sig_i[TT_DUT::SSR_I];
  TT_DUT::TT_STREAM sig_o[TT_DUT::SSR_O];
  
  sig_i[0].write(sig0_i.read());
  sig_i[1].write(sig1_i.read());
  sig_i[2].write(sig2_i.read());
  sig_i[3].write(sig3_i.read());
  sig_i[4].write(sig4_i.read());
  sig_i[5].write(sig5_i.read());
  sig_i[6].write(sig6_i.read());
  sig_i[7].write(sig7_i.read());
  
  static TT_DUT dut;
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

