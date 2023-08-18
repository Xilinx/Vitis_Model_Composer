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

// You can create a block that accepts arrays of different dimensions

#include <stdint.h>
template <int SIZE>
void func3_c(const int16_t in1[SIZE],
             const int16_t in2[SIZE],
             int16_t out[SIZE])
{
   int16_t temp = 0;
   for (int i = 0; i < SIZE; i++) {
      out[i] = temp + in1[i] + in2[i];
      temp = temp + 1;
   }
}


