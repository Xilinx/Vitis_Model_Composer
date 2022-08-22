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


// You can create a block that accepts matrics of different dimensions

#include <stdint.h>
template <int R1 , int C1 , int R2 , int C2>
void func4_c(const int16_t in1[R1][C1],
             const int16_t in2[R2][C2],
             int16_t out[R1][C2])
{
   int16_t result[R1][C2];
   int16_t i, j, k;
   for (i = 0; i < R1; i++) {
      for (j = 0; j < C2; j++) {
         result[i][j] = 0;
      }
   }
   for (i = 0; i < R1; i++) {
      for (j = 0; j < C2; j++) {
         for (k = 0; k < C1 ; k++) {
            result[i][j] += in1[i][k] * in2[k][j];
         }
      }
   }
   for (i = 0; i < R1; i++) {
      for (j = 0; j < C2; j++) {
         out[i][j] = result[i][j];
      }
   }
}


