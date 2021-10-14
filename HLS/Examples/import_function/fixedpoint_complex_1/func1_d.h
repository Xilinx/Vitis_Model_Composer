///////////////////////////////////////////////////////////////////////////
// Copyright 2021 Xilinx
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

// simple example to define the usage of fixed point signals

#include <stdint.h>
#include <ap_fixed.h>
#pragma XMC OUTPORT out

void func1_d(const ap_fixed<16,11> in1,
             const ap_fixed<16,11> in2,
             ap_fixed<17,11> &out)
{
   out = in1+in2;
}


