/*  (c[FFT] Copyright 2014 - 2019 Xilinx, Inc. All rights reserved.
   
    This file contains confidential and proprietary information
    of Xilinx, Inc. and is protected under U.S. and
    international copyright and other intellectual property
    laws.
   
    DISCLAIMER
    This disclaimer is not a license and does not grant any
    rights to the materials distributed herewith. Except as
    otherwise provided in a valid license issued to you by
    Xilinx, and to the maximum extent permitted by applicable
    law: (1[FFT] THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
    WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
    AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
    BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
    INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
    (2[FFT] Xilinx shall not be liable (whether in contract or tort,
    including negligence, or under any other theory of
    liability[FFT] for any loss or damage of any kind or nature
    related to, arising under or in connection with these
    materials, including for any direct, or any indirect,
    special, incidental, or consequential loss or damage
    (including loss of data, profits, goodwill, or any type of
    loss or damage suffered as a result of any action brought
    by a third party[FFT] even if such damage or loss was
    reasonably foreseeable or Xilinx had been advised of the
    possibility of the same.
   
    CRITICAL APPLICATIONS
    Xilinx products are not designed or intended to be fail-
    safe, or for use in any application requiring fail-safe
    performance, such as life-support or safety devices or
    systems, Class III medical devices, nuclear facilities,
    applications related to the deployment of airbags, or any
    other applications that could lead to death, personal
    injury, or severe property or environmental damage
    (individually and collectively, "Critical
    Applications"[FFT]. Customer assumes the sole risk and
    liability of any use of Xilinx products in Critical
    Applications, subject only to applicable laws and
    regulations governing limitations on product liability.
   
    THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
    PART OF THIS FILE AT ALL TIMES.                       */

#ifndef __FFT_BUFS_H__
#define __FFT_BUFS_H__

#include "fft_com_inc.h"

extern cint32_t fft_1024_tmp1[FFT1024_SIZE];
extern cint32_t fft_1024_tmp2[FFT1024_SIZE];
extern cint32_t fft_1200_tmp1[FFT1200_SIZE];
extern cint32_t fft_1200_tmp2[FFT1200_SIZE];
extern cint32_t fft_128_tmp1[FFT128_SIZE];
extern cint32_t fft_128_tmp2[FFT128_SIZE];
extern cint32_t fft_12_tmp1[FFT12_SIZE+4];
extern cint32_t fft_12_tmp2[FFT12_SIZE+4];
extern cint32_t fft_12_32b_tmp1[FFT12_SIZE+4];
extern cint32_t fft_12_32b_tmp2[FFT12_SIZE+4];
extern cint32_t fft_12_x128_tmp1[FFT12_X128_SIZE+4];
extern cint32_t fft_12_x128_tmp2[FFT12_X128_SIZE+4];
extern cint32_t fft_12_x128_16b_tmp1[FFT12_X128_16B_SIZE+4];
extern cint32_t fft_12_x128_16b_tmp2[FFT12_X128_16B_SIZE+4];
extern cint32_t fft_1536_tmp1[FFT1536_SIZE];
extern cint32_t fft_1536_tmp2[FFT1536_SIZE];
extern cint32_t fft_2048_tmp1[FFT2048_SIZE];
extern cint32_t fft_2048_tmp2[FFT2048_SIZE];
extern cint32_t fft_24_tmp1[FFT24_SIZE+8];
extern cint32_t fft_24_tmp2[FFT24_SIZE+8];
extern cint32_t fft_24_32b_tmp1[FFT24_SIZE+8];
extern cint32_t fft_24_32b_tmp2[FFT24_SIZE+8];
extern cint32_t fft_256_tmp1[FFT256_SIZE];
extern cint32_t fft_256_tmp2[FFT256_SIZE];
extern cint32_t fft_300_tmp1[FFT300_SIZE+4];
extern cint32_t fft_300_tmp2[FFT300_SIZE+4];
extern cint32_t fft_300_32b_tmp1[FFT300_SIZE+4];
extern cint32_t fft_300_32b_tmp2[FFT300_SIZE+4];
extern cint32_t fft_3072_tmp1[FFT3072_SIZE];
extern cint32_t fft_3072_tmp2[FFT3072_SIZE];
extern cint32_t fft_36_tmp1[FFT36_SIZE+12];
extern cint32_t fft_36_tmp2[FFT36_SIZE+12];
extern cint32_t fft_36_32b_tmp1[FFT36_SIZE+12];
extern cint32_t fft_36_32b_tmp2[FFT36_SIZE+12];
extern cint32_t fft_384_tmp1[FFT384_SIZE];
extern cint32_t fft_384_tmp2[FFT384_SIZE];
extern cint32_t fft_4096_tmp1[FFT4096_SIZE];
extern cint32_t fft_4096_tmp2[FFT4096_SIZE];
extern cint32_t fft_512_tmp1[FFT512_SIZE];
extern cint32_t fft_512_tmp2[FFT512_SIZE];
extern cint32_t fft_600_tmp1[FFT600_SIZE+8];
extern cint32_t fft_600_tmp2[FFT600_SIZE+8];
extern cint32_t fft_600_32b_tmp1[FFT600_SIZE+8];
extern cint32_t fft_600_32b_tmp2[FFT600_SIZE+8];
extern cint32_t fft_640_tmp1[FFT640_SIZE];
extern cint32_t fft_640_tmp2[FFT640_SIZE];
extern cint32_t fft_896_tmp1[FFT896_SIZE];
extern cint32_t fft_896_tmp2[FFT896_SIZE];
extern cint32_t ifft_1024_tmp1[IFFT1024_SIZE];
extern cint32_t ifft_1024_tmp2[IFFT1024_SIZE];
extern cint32_t ifft_1200_tmp1[IFFT1200_SIZE];
extern cint32_t ifft_1200_tmp2[IFFT1200_SIZE];
extern cint32_t ifft_128_tmp1[IFFT128_SIZE];
extern cint32_t ifft_128_tmp2[IFFT128_SIZE];
extern cint32_t ifft_12_tmp1[IFFT12_SIZE+4];
extern cint32_t ifft_12_tmp2[IFFT12_SIZE+4];
extern cint32_t ifft_12_32b_tmp1[IFFT12_SIZE+4];
extern cint32_t ifft_12_32b_tmp2[IFFT12_SIZE+4];
extern cint32_t ifft_12_batch_tmp1[IFFT12_BATCH_INPUT_SIZE+4];
extern cint32_t ifft_12_batch_tmp2[IFFT12_BATCH_INPUT_SIZE+4];
extern cint32_t ifft_1536_tmp1[IFFT1536_SIZE];
extern cint32_t ifft_1536_tmp2[IFFT1536_SIZE];
extern cint32_t ifft_2048_tmp1[IFFT2048_SIZE];
extern cint32_t ifft_2048_tmp2[IFFT2048_SIZE];
extern cint32_t ifft_24_tmp1[IFFT24_SIZE+8];
extern cint32_t ifft_24_tmp2[IFFT24_SIZE+8];
extern cint32_t ifft_24_32b_tmp1[IFFT24_SIZE+8];
extern cint32_t ifft_24_32b_tmp2[IFFT24_SIZE+8];
extern cint32_t ifft_256_tmp1[IFFT256_SIZE];
extern cint32_t ifft_256_tmp2[IFFT256_SIZE];
extern cint32_t ifft_300_tmp1[IFFT300_SIZE+4];
extern cint32_t ifft_300_tmp2[IFFT300_SIZE+4];
extern cint32_t ifft_300_32b_tmp1[IFFT300_SIZE+4];
extern cint32_t ifft_300_32b_tmp2[IFFT300_SIZE+4];
extern cint32_t ifft_3072_tmp1[IFFT3072_SIZE];
extern cint32_t ifft_3072_tmp2[IFFT3072_SIZE];
extern cint32_t ifft_36_tmp1[IFFT36_SIZE+12];
extern cint32_t ifft_36_tmp2[IFFT36_SIZE+12];
extern cint32_t ifft_36_32b_tmp1[IFFT36_SIZE+12];
extern cint32_t ifft_36_32b_tmp2[IFFT36_SIZE+12];
extern cint32_t ifft_384_tmp1[IFFT384_SIZE];
extern cint32_t ifft_384_tmp2[IFFT384_SIZE];
extern cint32_t ifft_4096_tmp1[IFFT4096_SIZE];
extern cint32_t ifft_4096_tmp2[IFFT4096_SIZE];
extern cint32_t ifft_512_tmp1[IFFT512_SIZE];
extern cint32_t ifft_512_tmp2[IFFT512_SIZE];
extern cint32_t ifft_600_tmp1[IFFT600_SIZE+8];
extern cint32_t ifft_600_tmp2[IFFT600_SIZE+8];
extern cint32_t ifft_600_32b_tmp1[IFFT600_SIZE+8];
extern cint32_t ifft_600_32b_tmp2[IFFT600_SIZE+8];
extern cint32_t ifft_640_tmp1[IFFT640_SIZE];
extern cint32_t ifft_640_tmp2[IFFT640_SIZE];
extern cint32_t ifft_896_tmp1[IFFT896_SIZE];
extern cint32_t ifft_896_tmp2[IFFT896_SIZE];
extern cint16_t fft_lut_tw150[FFT_150];
extern cint16_t fft_lut_tw160[FFT_160];
extern cint16_t fft_lut_tw192[FFT_192];
extern cint16_t fft_lut_tw224[FFT_224];
extern cint16_t fft_lut_tw256[FFT_256];
extern cint16_t fft_lut_tw300[FFT_300];
extern cint16_t fft_lut_tw320[FFT_320];
extern cint16_t fft_lut_tw32[FFT_32];
extern cint16_t fft_lut_tw300o2[FFT_300];
extern cint16_t fft_lut_tw300o4[FFT_300];
extern cint16_t fft_lut_tw384[FFT_384];
extern cint16_t fft_lut_tw448[FFT_448];
extern cint16_t fft_lut_tw512[FFT_512];
extern cint16_t fft_lut_tw600[FFT_600];
extern cint16_t fft_lut_tw768[FFT_768];
extern cint16_t fft_lut_tw1024[FFT_1024];
extern cint16_t fft_lut_tw1536[FFT_1536];
extern cint16_t fft_lut_tw2048[FFT_2048];

#endif /* __FFT_BUFS_H__ */
