///////////////////////////////////////////////////////////////////////////
// Copyright 2020 Xilinx
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
///////////////////////////////////////////////////////////////////////////

#include "fft_ifft_dit_1ch_graph.hpp"

//////////////////////////////////////////////////////////
// Modifly the line below to change the FFT specificaiton
// instantiate adf dataflow graph
//////////////////////////////////////////////////////////

xf::dsp::aie::fft::dit_1ch::fft_ifft_dit_1ch_graph<cint16, cint16, 512, 1> mygraph;

// connect dataflow graph to simulation platform
// To generate input and expected_output data files,
// select 'Create and execute testbench' option on the Model Composer Hub block.
adf::simulation::platform<1,1> platform("~", "~");
adf::connect<> net1(platform.src[0], mygraph.in);
adf::connect<> net2(mygraph.out, platform.sink[0]);

// initialize and run the dataflow graph
#ifdef __AIESIM__
int main(void) {
   mygraph.init();
   mygraph.run();
   mygraph.end();
   return 0;
}
#endif
