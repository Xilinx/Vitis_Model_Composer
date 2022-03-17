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

// You can also pass arrays or matices as parameters

#include <stdint.h>

#pragma XMC PARAMETER P1, P2
void func3_b(int16_t in, double out[3], double P1[2][3], int8_t P2[3])
{
   // Calculate P1*P2
   double product[3];
   for (int i = 0; i < 3; i++) {
      double row_sum = 0;
      for (int j=0; j<2; j++) {
         row_sum += P1[j][i] * (double)P2[i];
      }
      product[i] = row_sum;
   }

   // Add input to the result
   for (int i = 0; i < 3; i++) {
      out[i] = product[i] + in;
   }
}


