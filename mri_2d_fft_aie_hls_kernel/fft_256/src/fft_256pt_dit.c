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

#include <adf.h>

#include "fft_256pt_inc.h"
#include "fft_twiddle_lut_dit.h"
#include "fft_stages.h"

void fft256_init()
{
    set_rnd(rnd_pos_inf);
    set_sat();
};

void fft_256pt_dit(       
    input_window_cint16 * restrict inputx,
    output_window_cint16 * restrict outputy
)
{
    cint16_t *xbuff =  (cint16_t *)inputx->ptr;

    cint16_t * restrict tw1 = fft_lut_tw1;
    cint16_t * restrict tw2 = fft_lut_tw2;
    cint16_t * restrict tw4 = fft_lut_tw4;
    cint16_t * restrict tw8 = fft_lut_tw8;
    cint16_t * restrict tw16 = fft_lut_tw16;
    cint16_t * restrict tw32 = fft_lut_tw32;
    cint16_t * restrict tw64 = fft_lut_tw64;
    cint16_t * restrict tw128 = fft_lut_tw128;

    cint32_t * restrict tmp1_buf = fft_256_tmp1;
    cint32_t * restrict tmp2_buf = fft_256_tmp2;
   
    bool inv = false; 
    /*
    256pt FFT: 4 stages - 4 Radix4 stages.
    Input to the 1st stage is 16-bit and output is 32bit. Rest of the 
    stages operate on 32bit I/O and the last stage input is 32bit and output is 16bit.
	Note: Output of this FFT is matlab_output/4
    */
    stage0_radix4_up_dit(     xbuff,  tw1,   tw2, FFT256_SIZE, FFT_64, FFT_SHIFT15, tmp1_buf, inv);
    stage0_radix4_dit(     tmp1_buf,  tw4,   tw8, FFT256_SIZE, FFT_16, FFT_SHIFT15, tmp2_buf, inv);
    stage0_radix4_dit(     tmp2_buf, tw16,  tw32, FFT256_SIZE, FFT_4,  FFT_SHIFT15, tmp1_buf, inv);
    stage1_radix4_down_dit(tmp1_buf, tw64, tw128, FFT256_SIZE,         (FFT_SHIFT17+FFT256_FINAL_SHIFT), outputy, inv);
}
