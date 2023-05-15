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
#include "polyphase_fir.h"

using namespace adf;

// ------------------------------------------------------------
// Top Level Graph
// ------------------------------------------------------------

template<unsigned PATTERN,unsigned NSAMP>
class polyphase_fir_graph : public graph {
private:
  kernel k_fir;

public:
  std::array<port<input>,1>  sig_i;
  std::array<port<output>,1> sig_o;

  using TT_KERNEL = polyphase_fir<PATTERN,NSAMP>;

  // Constructor:
  polyphase_fir_graph( std::vector<typename TT_KERNEL::TT_COEFF> tapsA_i,
                       std::vector<typename TT_KERNEL::TT_COEFF> tapsB_i )
  {
    k_fir = kernel::create_object<TT_KERNEL>( tapsA_i, tapsB_i );

    source(k_fir) = "polyphase_fir.cpp";
    runtime<ratio>(k_fir) = 0.9;

    connect<stream,stream>( sig_i[0],     k_fir.in[0] );
    connect<stream,stream>( k_fir.out[0], sig_o[0]    );
  }
};

