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

#include <adf.h>
#include "twiddle_m16_ssr8_dft.h"
#include "dft_1xN_widget_graph.h"

using namespace adf;

// ------------------------------------------------------------
// Top Level Graph
// ------------------------------------------------------------

class m16_ssr8_dft_graph : public graph {
  static constexpr unsigned NSAMP = 8192;
public:
  std::array<port<input>,8>  sig_i;
  std::array<port<output>,8> sig_o;

  using GRAPH = dft_1xN_widget_graph<NSAMP>;

  // DUT graph:
  GRAPH dut_graphA;
  GRAPH dut_graphB;
  GRAPH dut_graphC;
  GRAPH dut_graphD;

  // Constructor:
  m16_ssr8_dft_graph( void ) : dut_graphA(std::vector<std::vector<cint16>>{A_TWID0},std::vector<std::vector<cint16>>{A_TWID1}),
                               dut_graphB(std::vector<std::vector<cint16>>{B_TWID0},std::vector<std::vector<cint16>>{B_TWID1}),
                               dut_graphC(std::vector<std::vector<cint16>>{C_TWID0},std::vector<std::vector<cint16>>{C_TWID1}),
                               dut_graphD(std::vector<std::vector<cint16>>{D_TWID0},std::vector<std::vector<cint16>>{D_TWID1})
  {

    for (int ii=0; ii < 8; ii++) {
      connect<stream>( sig_i[ii],    dut_graphA.sig_i[ii] );
      connect<stream>( sig_i[ii],    dut_graphB.sig_i[ii] );
      connect<stream>( sig_i[ii],    dut_graphC.sig_i[ii] );
      connect<stream>( sig_i[ii],    dut_graphD.sig_i[ii] );
      if ( ii < 2 ) {
        connect<stream>( dut_graphA.sig_o[ii  ], sig_o[ii] );
      }
      else if ( ii < 4 ) {
        connect<stream>( dut_graphB.sig_o[ii-2], sig_o[ii] );
      }
      else if ( ii < 6 ) {
        connect<stream>( dut_graphC.sig_o[ii-4], sig_o[ii] );
      }
      else {
        connect<stream>( dut_graphD.sig_o[ii-6], sig_o[ii] );
      }
    } // ii
  }
};

