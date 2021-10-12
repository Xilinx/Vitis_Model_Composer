// ============================================================================
// (c) Copyright 2017-2017 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information of Xilinx, Inc.
// and is protected under U.S. and international copyright and other
// intellectual property laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any rights to the
// materials distributed herewith. Except as otherwise provided in a valid
// license issued to you by Xilinx, and to the maximum extent permitted by
// applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH
// ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS,
// EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES
// OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
// PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of liability) for any
// loss or damage of any kind or nature related to, arising under or in
// connection with these materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage (including loss of
// data, profits, goodwill, or any type of loss or damage suffered as a
// result of any action brought by a third party) even if such damage or loss
// was reasonably foreseeable or Xilinx had been advised of the possibility
// of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-safe, or for use
// in any application requiring fail-safe performance, such as life-support
// or safety devices or systems, Class III medical devices, nuclear
// facilities, applications related to the deployment of airbags, or
// any other applications that could lead to death, personal injury, or
// severe property or environmental damage (individually and collectively,
// "Critical Applications"). Customer assumes the sole risk and liability
// of any use of Xilinx products in Critical Applications, subject only to
// applicable laws and regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF
// THIS FILE AT ALL TIMES.
// ============================================================================
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


