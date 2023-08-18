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

// In this example, all the function arguments are scalar. 
// Feeding matrices or vectors of the same dimensions to 
// the block will result in element wise operation.

#include <stdint.h>

#pragma XMC INPORT in1,in2
#pragma XMC OUTPORT out

void func6_a(int16_t in1, int16_t in2, int16_t &out)
{
   out = in1 + in2;
}

