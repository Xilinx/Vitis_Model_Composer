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

#include <adf.h>
#include <aie_api/aie.hpp>

#include "kernels_common.h"
#include "kernels.h"

// Overlap save buffer:
// cint16 chess_storage(%chess_alignof(v8cint16)) overlap_state [TAP_NUM];

void __attribute__ ((noinline)) OverlapSave::overlap_save( adf::input_buffer<cint16,adf::extents<WIN_SIZE> > & restrict win_i,
                                              adf::output_buffer<cint16,adf::extents<FFT_SIZE> > & restrict win_o )
{
  // Use 'iterators' to walk through state buffer and I/O buffers:
  auto state_it = aie::begin_vector<8>( overlap_state );
  auto state_ut = aie::begin_vector<8>( overlap_state );
  auto win_ot = aie::begin_vector<8>( win_o );
  auto win_it = aie::begin_vector<8>( win_i );
  auto win_ut = aie::begin_vector<8>( win_i );
  win_ut += (WIN_SIZE-TAP_NUM) / 8;

  // Loop over existing state, copy to output window:
  for (unsigned ll = 0; ll < TAP_NUM / 8; ll++)
    chess_loop_range(4,)
    chess_prepare_for_pipelining
  {
    aie::vector<cint16, 8> v = *state_it++;
    *win_ot++ = v;
  }

  // Loop over input window, copy to output window:
  for ( unsigned int ll=0; ll < WIN_SIZE / 8; ll++)
    chess_loop_range(4,)
    chess_prepare_for_pipelining
  {
    aie::vector<cint16, 8> w = *win_it++;
    *win_ot++ = w;
  }

  // Loop over input window, update state for next time:
  for ( unsigned int ll=0; ll < TAP_NUM / 8; ll++)
    chess_loop_range(4,)
    chess_prepare_for_pipelining
  {
    aie::vector<cint16, 8> w = *win_ut++;
    *state_ut++ = w;
  }
}
