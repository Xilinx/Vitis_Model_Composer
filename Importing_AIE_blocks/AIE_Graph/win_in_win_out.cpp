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

#include "win_in_win_out.h"

// Mapping inputs to PLIO
adf::PLIO in1("In1", adf::plio_32_bits, "In1.txt");
adf::PLIO in2("In2", adf::plio_32_bits, "In2.txt");

// Mapping outputs to PLIO
adf::PLIO out1("Out1", adf::plio_32_bits, "Out1.txt");

// instantiate cardano dataflow graph
Win_in_win_out mygraph;

// connect dataflow graph to simulation platform
adf::simulation::platform<2,1> platform(&in1, &in2, &out1);
adf::connect<> net1(platform.src[0], mygraph.In1);
adf::connect<> net2(platform.src[1], mygraph.In2);
adf::connect<> net3(mygraph.Out1, platform.sink[0]);

// initialize and run the dataflow graph
#ifdef __AIESIM__
int main(void) {
   mygraph.init();
   mygraph.run();
   mygraph.end();
   return 0;
}
#endif