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

// In this example, we create a block with matrix input and
// matrix output

#include <stdint.h>

void func3_a(const int16_t in1[3][5],
             const int16_t in2[3][5],
             int16_t out[3][5])
{
   for (int i = 0; i<3; i++) {
      for (int j = 0; j<5; j++) {
         out[i][j] = in1[i][j] + in2[i][j];
      }
   }
}


