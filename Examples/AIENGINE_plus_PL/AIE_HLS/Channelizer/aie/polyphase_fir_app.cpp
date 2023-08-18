// /**********
// © Copyright 2022 Advanced Micro Devices, Inc.
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

#include "polyphase_fir_graph.h"
#include "taps_M16_init.h"

class my_graph : public graph {
public:
  std::array<input_plio,2>  sig_i;
  std::array<output_plio,2> sig_o;
  polyphase_fir_graph dut;
  my_graph( void )
    : dut( tile0_tapsA, tile0_tapsB, tile0_tapsC, tile0_tapsD )
  {
    for (int ii=0; ii < 2; ii++) {
      sig_i[ii] =
        input_plio::create("PLIO_i_"+std::to_string(ii),plio_32_bits,"data/sig"+std::to_string(ii)+"_i.txt");
      sig_o[ii] =
        output_plio::create("PLIO_o_"+std::to_string(ii),plio_32_bits,"data/sig"+std::to_string(ii)+"_o.txt");
      connect<stream>( sig_i[ii].out[0], dut.sig_i[ii]   );
      connect<stream>( dut.sig_o[ii],    sig_o[ii].in[0] );
    }
  }
};


// Instantiate AIE graph:
my_graph aie_dut;

// Initialize and run the graph:
int main(void)
{
  aie_dut.init();
  aie_dut.run(-1); // Infinite run
  aie_dut.end();

  return 0;
}
