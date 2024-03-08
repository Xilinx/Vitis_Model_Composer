/*  (c) Copyright 2014 - 2023 AMD, Inc. All rights reserved.
   
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
    WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
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


#ifndef __BLAS_KERNELS_H__
#define __BLAS_KERNELS_H__


void matmul_64x16_16x1( 
	input_window_cint16 * restrict inputhb,
        input_window_cint16 * restrict inputxb,
        output_window_cint16 * restrict outputcb
);

void matmul_64x16_16x1_real(
  	input_window_int16* restrict matA, 
    	input_window_int16* restrict matB,
    	output_window_int16* restrict matC
);

void matmul_NxL_LxN(
    	input_window_cint16* restrict matA, 
    	input_window_cint16* restrict matB,
    	output_window_cint16* restrict matC
);

void trimatmul_32x32_32x32(
	input_window_cint16* restrict matA, 
	input_window_cint16* restrict matB, 
	output_window_cint16* restrict matC
);

void trimat_inv_32x32(
	input_window_cint16 * L_in, 
	output_window_cint16 * x_out
);

void matmul_right_herm(
	input_window_cint16* restrict matA, 
	input_window_cint16* restrict matB, 
	output_window_cint16* restrict matC
);

//---->

void matmul_NxL_LxN_core0(
    	input_window_cint16* restrict matA, 
    	input_window_cint16* restrict matB,
    	output_stream_cacc48 * restrict cascadeout
);

void matmul_NxL_LxN_core1(
    	input_window_cint16* restrict matA, 
    	input_window_cint16* restrict matB,
    	input_stream_cacc48 * restrict cascadein,
    	output_window_cint16* restrict matC
);

void matmul_16x64_64x16_core0(
    	input_window_cint16* restrict matA, 
    	input_window_cint16* restrict matB,
    	output_stream_cacc48 * restrict cascadeout
);

void matmul_16x64_64x16_core1(
	input_window_cint16* restrict matA, 
    	input_window_cint16* restrict matB,
    	input_stream_cacc48 * restrict cascadein,
    	output_window_cint16* restrict matC
);

void trimatmul_16x16_16x16(
	input_window_cint16* restrict matA, 
	input_window_cint16* restrict matB, 
	output_window_cint16* restrict matC
);

void trimat_inv_16x16_2p_core0(
	input_window_cint16 * restrict L_in, 
	output_window_cint16 *restrict x_out
);

void trimat_inv_16x16_2p_core1(
	input_window_cint16 * restrict L_in, 
	output_window_cint16 *restrict x_out
);

void matmul_right_herm_16x16_16x32(
	input_window_cint16* restrict matA, 
	input_window_cint16* restrict matB, 
	output_window_cint16* restrict matC
);

void trimatmul_16x16_16x16_4out(
	input_window_cint16* restrict matA, 
	input_window_cint16* restrict matB, 
	output_window_cint16* restrict matC0, 
	output_window_cint16* restrict matC1, 
	output_window_cint16* restrict matC2, 
	output_window_cint16* restrict matC3
);
 
void matmul_right_herm_16x16_16x32_blk0(
	input_window_cint16* restrict matA, 
	input_window_cint16* restrict matB, 
	output_window_cint16* restrict matC
	);

void matmul_right_herm_16x16_16x32_blk1(
	input_window_cint16* restrict matA, 
	input_window_cint16* restrict matB, 
	output_window_cint16* restrict matC
);

#endif //__BLAS_KERNELS_H__

