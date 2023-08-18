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

// You can also define a function template that uses a fixed-point data type
// of variable word length and integer length using function templates.
// The word length and integer length will be inherited from the input
// signal to the block.

#include <stdint.h>
#include <ap_fixed.h>

#pragma XMC OUTPORT out
template <int WordLen, int IntLen, int SIZE>
void func2_d(const ap_fixed<WordLen,IntLen> in1[SIZE],
             ap_fixed<WordLen+1,IntLen> &out)
{
   ap_fixed<WordLen,IntLen> acc = 0;
   for (int i=0; i<SIZE; i++) {
      acc = acc + in1[i];
   }
   out = acc;
}


