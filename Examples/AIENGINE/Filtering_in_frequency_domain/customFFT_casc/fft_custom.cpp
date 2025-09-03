/*  (c) Copyright 2025 AMD, Inc. All rights reserved.
   
    This file contains confidential and proprietary information
    of AMD, Inc. and is protected under U.S. and
    international copyright and other intellectual property
    laws.
   
    DISCLAIMER
    This disclaimer is not a license and does not grant any
    rights to the materials distributed herewith. Except as
    otherwise provided in a valid license issued to you by
    AMD, and to the maximum extent permitted by applicable
    law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
    WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
    AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
    BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
    INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
    (2) AMD shall not be liable (whether in contract or tort,
    including negligence, or under any other theory of
    liability) for any loss or damage of any kind or nature
    related to, arising under or in connection with these
    materials, including for any direct, or any indirect,
    special, incidental, or consequential loss or damage
    (including loss of data, profits, goodwill, or any type of
    loss or damage suffered as a result of any action brought
    by a third party) even if such damage or loss was
    reasonably foreseeable or AMD had been advised of the
    possibility of the same.
   
    CRITICAL APPLICATIONS
    AMD products are not designed or intended to be fail-
    safe, or for use in any application requiring fail-safe
    performance, such as life-support or safety devices or
    systems, Class III medical devices, nuclear facilities,
    applications related to the deployment of airbags, or any
    other applications that could lead to death, personal
    injury, or severe property or environmental damage
    (individually and collectively, "Critical
    Applications"). Customer assumes the sole risk and
    liability of any use of AMD products in Critical
    Applications, subject only to applicable laws and
    regulations governing limitations on product liability.
   
    THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
    PART OF THIS FILE AT ALL TIMES.                       */


#include <adf.h>
#include <aie_api/aie.hpp>

#include "fft_custom.h"
#include "fft256_twiddle.h"

void fft_custom_init()
{
aie::set_rounding(aie::rounding_mode::symmetric_inf);
aie::set_saturation(aie::saturation_mode::none); // saturate?
}

// FFT + complex multiplication (e.g.: filtering)
void fft_custom(input_buffer<TT_DATA,extents<FFT_PTS> >& __restrict sig_i, 
                     output_cascade<cacc48> *sig_o ) 
{

  // Set pointers to buffers:
  TT_DATA* ibuff = sig_i.data(); // input buffer for FFT
  auto pI = aie::begin_vector<4>(sig_i); // input pointer for complex multiply
  alignas(aie::vector_decl_align) TT_DATA tbuff[256]; // FFT buffer data

  // setup variables for complex multiply
  aie::vector<cint32,4> FFT_data, data;
  aie::vector<cint16,4> coeff_data; // coeff data vector

  // complex FIR coeffs array
  alignas(aie::vector_decl_align) const cint16 coeff[256] = { {16383,0},{0,-16384},{-16385,-1},{0,16384},{16383,0},{0,-16384},{-16385,0},{0,16384},{16383,0},{0,-16384},{-16385,-1},{0,16384},{16383,0},{0,-16384},{-16385,0},{0,16384},{16383,-1},{0,-16384},{-16385,-1},{-1,16384},{16383,0},{0,-16384},{-16385,0},{0,16384},{16383,0},{0,-16384},{-16385,-1},{-1,16384},{16383,0},{0,-16384},{-16385,0},{0,16384},{16383,0},{0,-16384},{-16385,-1},{-1,16384},{16383,0},{0,-16384},{-16385,-1},{0,16383},{16383,-1},{0,-16385},{-16385,0},{-1,16383},{16383,0},{0,-16385},{-16385,-1},{0,16383},{16384,0},{0,-16385},{-16384,0},{-1,16384},{16350,0},{0,-16109},{-15313,-1},{-1,13610},{10944,0},{0,-7719},{-4636,0},{-1,2293},{894,0},{0,-257},{-48,-1},{-1,4},{0,0},{0,-1},{0,0},{-1,0},{-1,0},{0,0},{-1,-1},{0,-1},{-1,0},{-1,-1},{0,0},{-1,-1},{0,0},{0,-1},{0,-1},{-1,-1},{0,0},{-1,-1},{0,0},{-1,0},{0,0},{0,0},{0,-1},{-1,0},{0,-1},{-1,0},{0,0},{-1,0},{0,0},{-1,0},{0,0},{-1,0},{0,0},{-1,0},{0,0},{-1,0},{0,0},{-1,0},{0,0},{-1,0},{0,0},{-1,0},{-1,-1},{-1,0},{-1,0},{0,0},{-1,0},{-1,0},{-1,-1},{-1,0},{-1,0},{-1,0},{-1,0},{-1,0},{-1,-1},{-1,0},{-1,0},{-1,0},{0,0},{-1,0},{0,0},{-1,0},{0,-1},{-1,0},{0,0},{-1,-1},{0,0},{-1,-1},{0,0},{-1,-1},{0,-1},{-1,-1},{-1,-1},{-1,-1},{-1,0},{-1,-1},{-1,0},{-1,-1},{-1,-1},{-1,-1},{-1,0},{-1,-1},{-1,-1},{0,-1},{-1,0},{-1,-1},{-1,0},{-1,-1},{0,-1},{-1,-1},{0,-1},{-1,-1},{0,0},{-1,-1},{0,-1},{-1,-1},{0,-1},{-1,-1},{0,-1},{-1,-1},{0,0},{-1,-1},{0,-1},{-1,-1},{0,0},{-1,-1},{0,0},{0,-1},{0,0},{-1,-1},{0,-1},{-1,0},{0,0},{-1,0},{0,0},{0,0},{0,0},{-1,0},{0,-1},{-1,0},{-1,-1},{0,0},{-1,0},{0,-1},{-1,0},{-1,-1},{0,-1},{0,0},{0,0},{-1,-5},{-48,0},{0,256},{894,0},{-1,-2294},{-4636,-1},{0,7718},{10944,-1},{-1,-13611},{-15313,0},{0,16108},{16350,0},{-1,-16385},{-16384,-1},{0,16384},{16384,0},{0,-16384},{-16385,0},{0,16384},{16383,0},{-1,-16384},{-16385,-1},{0,16384},{16383,0},{0,-16384},{-16385,0},{0,16383},{16383,0},{-1,-16385},{-16385,0},{0,16383},{16383,-1},{0,-16385},{-16385,-1},{0,16383},{16383,0},{-1,-16385},{-16385,0},{0,16383},{16383,-1},{0,-16385},{-16385,-1},{0,16383},{16383,0},{-1,-16385},{-16385,0},{0,16383},{16383,0},{0,-16385},{-16385,-1},{0,16383},{16383,0},{0,-16385},{-16385,0},{0,16383},{16383,-1},{0,-16385},{-16385,-1},{0,16383},{16383,0},{0,-16385},{-16385,0},{0,16383} };
  aie::accum<cacc48,4> acc; // accumulator register
  auto pCoeff = aie::cbegin_vector<4>(coeff); // setup pointer to coeff

  aie::fft_dit_r4_stage<64>(ibuff, tw4a_1, tw4a_0, tw4a_2, FFT_PTS, SHIFT_FFT, SHIFT_FFT, FFTn, tbuff);
  aie::fft_dit_r4_stage<16>(tbuff, tw4b_1, tw4b_0, tw4b_2, FFT_PTS, SHIFT_FFT, SHIFT_FFT, FFTn, ibuff);
  aie::fft_dit_r4_stage< 4>(ibuff, tw4c_1, tw4c_0, tw4c_2, FFT_PTS, SHIFT_FFT, SHIFT_FFT, FFTn, tbuff);
  aie::fft_dit_r4_stage< 1>(tbuff, tw4d_1, tw4d_0, tw4d_2, FFT_PTS, SHIFT_FFT, SHIFT_FFT, FFTn, ibuff);

  // complex filtering loop...
  for (unsigned lp=0; lp<32; lp++) // process 32*4*2=256 samples
    chess_prepare_for_pipelining
    { 
        FFT_data = *pI++; // 32 bit complex data * 4 = 256 bits
        coeff_data = *pCoeff++; // 16 bit complex data * 4 = 128 bits
        acc = aie::mul(FFT_data, coeff_data);
        writeincr(sig_o, acc); // write out 4, cacc48 samples
        
        FFT_data = *pI++;
        coeff_data = *pCoeff++;
        acc = aie::mul(FFT_data, coeff_data);
        writeincr(sig_o, acc);
        
    } // end of lp for loop

}
