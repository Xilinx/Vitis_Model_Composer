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

// In this example, the non-void function return type will
// result in an extra output port from the block

#include <stdint.h>

#pragma XMC INPORT in
#pragma XMC OUTPORT out

int16_t func5_a(int16_t in[5], int16_t out[5])
{
   int16_t acc=0;
   for (int i=0; i<5; i++) {
      out[i] = in[i]*2;
      acc = acc + in[i];
   }
   return acc;
}


