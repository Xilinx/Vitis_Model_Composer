/*  (c) Copyright 2014 - 2019 Xilinx, Inc. All rights reserved.
   
    This file contains confidential and proprietary information
    of Xilinx, Inc. and is protected under U.S. and
    international copyright and other intellectual property
    laws.
   
    DISCLAIMER
    This disclaimer is not a license and does not grant any
    rights to the materials distributed herewith. Except as
    otherwise provided in a valid license issued to you by
    Xilinx, and to the maximum extent permitted by applicable
    law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
    WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
    AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
    BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
    INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
    (2) Xilinx shall not be liable (whether in contract or tort,
    including negligence, or under any other theory of
    liability) for any loss or damage of any kind or nature
    related to, arising under or in connection with these
    materials, including for any direct, or any indirect,
    special, incidental, or consequential loss or damage
    (including loss of data, profits, goodwill, or any type of
    loss or damage suffered as a result of any action brought
    by a third party) even if such damage or loss was
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
    Applications"). Customer assumes the sole risk and
    liability of any use of Xilinx products in Critical
    Applications, subject only to applicable laws and
    regulations governing limitations on product liability.
   
    THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
    PART OF THIS FILE AT ALL TIMES.                       */

#ifndef __FFT_PARAMS_H__
#define __FFT_PARAMS_H__

#include "fft_com_inc.h"
#define FFT1024_INPUT_SAMPLES            (FFT1024_SIZE)                        
#define FFT1024_INPUT_MARGIN             (0)
#define FFT1024_OUTPUT_SAMPLES           FFT1024_INPUT_SAMPLES
#define FFT2048_INPUT_SAMPLES            (FFT2048_SIZE)                        
#define FFT2048_INPUT_MARGIN             (0)
#define FFT2048_OUTPUT_SAMPLES           FFT2048_INPUT_SAMPLES
#define FFT1200_INPUT_SAMPLES            (FFT1200_SIZE)                        
#define FFT1200_INPUT_MARGIN             (0)
#define FFT1200_OUTPUT_SAMPLES           FFT1200_INPUT_SAMPLES
#define FFT128_INPUT_SAMPLES            (FFT128_SIZE)                        
#define FFT128_INPUT_MARGIN             (0)
#define FFT128_OUTPUT_SAMPLES           FFT128_INPUT_SAMPLES
#define FFT12_INPUT_SAMPLES            (2*FFT12_SIZE)                        
#define FFT12_INPUT_MARGIN             (0)
#define FFT12_OUTPUT_SAMPLES           (FFT12_INPUT_SAMPLES)
#define FFT12_X128_INPUT_SAMPLES            (2*FFT12_X128_SIZE)                        
#define FFT12_X128_INPUT_MARGIN             (0)
#define FFT12_X128_OUTPUT_SAMPLES           (FFT12_X128_INPUT_SAMPLES)
#define FFT12_X128_16B_INPUT_SAMPLES     (FFT12_X128_16B_SIZE)                        
#define FFT12_X128_16B_INPUT_MARGIN      (0)
#define FFT12_X128_16B_OUTPUT_SAMPLES    (FFT12_X128_16B_INPUT_SAMPLES)
#define FFT1536_INPUT_SAMPLES            (FFT1536_SIZE)                        
#define FFT1536_INPUT_MARGIN             (0)
#define FFT1536_OUTPUT_SAMPLES           FFT1536_INPUT_SAMPLES
#define FFT24_INPUT_SAMPLES            (2*FFT24_SIZE)                        
#define FFT24_INPUT_MARGIN             (0)
#define FFT24_OUTPUT_SAMPLES           FFT24_INPUT_SAMPLES
#define FFT256_INPUT_SAMPLES            (FFT256_SIZE)                        
#define FFT256_INPUT_MARGIN             (0)
#define FFT256_OUTPUT_SAMPLES           FFT256_INPUT_SAMPLES
#define FFT300_INPUT_SAMPLES            (2*FFT300_SIZE)                        
#define FFT300_INPUT_MARGIN             (0)
#define FFT300_OUTPUT_SAMPLES           FFT300_INPUT_SAMPLES
#define FFT3072_INPUT_SAMPLES            (FFT3072_SIZE)                        
#define FFT3072_INPUT_MARGIN             (0)
#define FFT3072_OUTPUT_SAMPLES           FFT3072_INPUT_SAMPLES
#define FFT36_INPUT_SAMPLES            (2*FFT36_SIZE)                        
#define FFT36_INPUT_MARGIN             (0)
#define FFT36_OUTPUT_SAMPLES           FFT36_INPUT_SAMPLES
#define FFT384_INPUT_SAMPLES            (FFT384_SIZE)                        
#define FFT384_INPUT_MARGIN             (0)
#define FFT384_OUTPUT_SAMPLES           FFT384_INPUT_SAMPLES
#define FFT4096_INPUT_SAMPLES            (FFT4096_SIZE)                        
#define FFT4096_INPUT_MARGIN             (0)
#define FFT4096_OUTPUT_SAMPLES           FFT4096_INPUT_SAMPLES
#define FFT512_INPUT_SAMPLES            (FFT512_SIZE)                        
#define FFT512_INPUT_MARGIN             (0)
#define FFT512_OUTPUT_SAMPLES           FFT512_INPUT_SAMPLES
#define FFT600_INPUT_SAMPLES            (2*FFT600_SIZE)                        
#define FFT600_INPUT_MARGIN             (0)
#define FFT600_OUTPUT_SAMPLES           FFT600_INPUT_SAMPLES
#define FFT640_INPUT_SAMPLES            (FFT640_SIZE)                        
#define FFT640_INPUT_MARGIN             (0)
#define FFT640_OUTPUT_SAMPLES           FFT640_INPUT_SAMPLES
#define FFT896_INPUT_SAMPLES            (FFT896_SIZE)                        
#define FFT896_INPUT_MARGIN             (0)
#define FFT896_OUTPUT_SAMPLES           FFT896_INPUT_SAMPLES
#define IFFT1024_INPUT_SAMPLES            (IFFT1024_SIZE)                        
#define IFFT1024_INPUT_MARGIN             (0)
#define IFFT1024_OUTPUT_SAMPLES           IFFT1024_INPUT_SAMPLES
#define IFFT1200_INPUT_SAMPLES            (IFFT1200_SIZE)                        
#define IFFT1200_INPUT_MARGIN             (0)
#define IFFT1200_OUTPUT_SAMPLES           IFFT1200_INPUT_SAMPLES
#define IFFT128_INPUT_SAMPLES            (IFFT128_SIZE)                        
#define IFFT128_INPUT_MARGIN             (0)
#define IFFT128_OUTPUT_SAMPLES           IFFT128_INPUT_SAMPLES
#define IFFT12_INPUT_SAMPLES            (2*IFFT12_SIZE)                        
#define IFFT12_INPUT_MARGIN             (0)
#define IFFT12_OUTPUT_SAMPLES           (IFFT12_INPUT_SAMPLES)
#define IFFT12_X128_INPUT_SAMPLES         (2*IFFT12_X128_SIZE)                        
#define IFFT12_X128_INPUT_MARGIN          (0)
#define IFFT12_X128_OUTPUT_SAMPLES        (IFFT12_X128_INPUT_SAMPLES)
#define IFFT12_X128_16B_INPUT_SAMPLES     (IFFT12_X128_16B_SIZE)                        
#define IFFT12_X128_16B_INPUT_MARGIN      (0)
#define IFFT12_X128_16B_OUTPUT_SAMPLES    (IFFT12_X128_16B_INPUT_SAMPLES)
#define IFFT12_BATCH_INPUT_SAMPLES     (IFFT12_BATCH_INPUT_SIZE)                        
#define IFFT12_BATCH_INPUT_MARGIN      (0)
#define IFFT12_BATCH_OUTPUT_SAMPLES    (IFFT12_BATCH_INPUT_SAMPLES)
#define IFFT1536_INPUT_SAMPLES            (IFFT1536_SIZE)                        
#define IFFT1536_INPUT_MARGIN             (0)
#define IFFT1536_OUTPUT_SAMPLES           IFFT1536_INPUT_SAMPLES
#define IFFT2048_INPUT_SAMPLES            (IFFT2048_SIZE)                        
#define IFFT2048_INPUT_MARGIN             (0)
#define IFFT2048_OUTPUT_SAMPLES           IFFT2048_INPUT_SAMPLES
#define IFFT24_INPUT_SAMPLES            (2*IFFT24_SIZE)                        
#define IFFT24_INPUT_MARGIN             (0)
#define IFFT24_OUTPUT_SAMPLES           IFFT24_INPUT_SAMPLES
#define IFFT256_INPUT_SAMPLES            (IFFT256_SIZE)                        
#define IFFT256_INPUT_MARGIN             (0)
#define IFFT256_OUTPUT_SAMPLES           IFFT256_INPUT_SAMPLES
#define IFFT300_INPUT_SAMPLES            (2*IFFT300_SIZE)                        
#define IFFT300_INPUT_MARGIN             (0)
#define IFFT300_OUTPUT_SAMPLES           IFFT300_INPUT_SAMPLES
#define IFFT3072_INPUT_SAMPLES            (IFFT3072_SIZE)                        
#define IFFT3072_INPUT_MARGIN             (0)
#define IFFT3072_OUTPUT_SAMPLES           IFFT3072_INPUT_SAMPLES
#define IFFT36_INPUT_SAMPLES            (2*IFFT36_SIZE)                        
#define IFFT36_INPUT_MARGIN             (0)
#define IFFT36_OUTPUT_SAMPLES           (IFFT36_INPUT_SAMPLES)
#define IFFT384_INPUT_SAMPLES            (IFFT384_SIZE)                        
#define IFFT384_INPUT_MARGIN             (0)
#define IFFT384_OUTPUT_SAMPLES           IFFT384_INPUT_SAMPLES
#define IFFT4096_INPUT_SAMPLES            (IFFT4096_SIZE)                        
#define IFFT4096_INPUT_MARGIN             (0)
#define IFFT4096_OUTPUT_SAMPLES           IFFT4096_INPUT_SAMPLES
#define IFFT512_INPUT_SAMPLES            (IFFT512_SIZE)                        
#define IFFT512_INPUT_MARGIN             (0)
#define IFFT512_OUTPUT_SAMPLES           IFFT512_INPUT_SAMPLES
#define IFFT600_INPUT_SAMPLES            (2*IFFT600_SIZE)                        
#define IFFT600_INPUT_MARGIN             (0)
#define IFFT600_OUTPUT_SAMPLES           IFFT600_INPUT_SAMPLES
#define IFFT640_INPUT_SAMPLES            (IFFT640_SIZE)                        
#define IFFT640_INPUT_MARGIN             (0)
#define IFFT640_OUTPUT_SAMPLES           IFFT640_INPUT_SAMPLES
#define IFFT896_INPUT_SAMPLES            (IFFT896_SIZE)                        
#define IFFT896_INPUT_MARGIN             (0)
#define IFFT896_OUTPUT_SAMPLES           IFFT896_INPUT_SAMPLES

#endif /* __FFT_PARAMS_H__ */
