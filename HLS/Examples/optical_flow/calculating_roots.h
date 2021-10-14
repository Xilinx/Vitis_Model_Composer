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

#include <stdint.h>
#include "hls_math.h"

void
calculating_roots(int16_t aPix, int16_t bPix, int16_t cPix,
                  int16_t txPix, int16_t tyPix, int16_t IxPix, int16_t IyPix,
                  int16_t dtPix, float &VxPix, float &VyPix)
{
#pragma HLS pipeline

   int16_t r = aPix + cPix;
   float s = hls::sqrtf(4 * bPix * bPix + (aPix - cPix) * (aPix - cPix));

   int16_t eig1 = (r + s);
   int16_t eig2 = (r - s);

   float vx = 0;
   float vy = 0;
   float d = 0;
   float const thresh = 196.6;  //98.3040*2
   float const thresh2 = 98.304;

   if (eig1 > thresh && eig2 > thresh) {
      d = aPix * cPix - bPix * bPix;
      vx =  - (txPix * cPix - tyPix * bPix)/d;
      vy =  - (aPix * tyPix - txPix * bPix)/d;
   } else if (eig1 > thresh && eig2 < thresh) {
      d = IxPix * IxPix + IyPix * IyPix;

      if (d > thresh2) {
         vx =  - dtPix * IxPix/d;
         vy =  - dtPix * IyPix/d;
      }
   }

   VxPix = vx;
   VyPix = vy;
}


