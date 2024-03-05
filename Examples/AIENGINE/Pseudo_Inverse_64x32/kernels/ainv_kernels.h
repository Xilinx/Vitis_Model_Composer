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


#ifndef __AINV_KERNELS_H__
#define __AINV_KERNELS_H__

void ainv_chol(
    	input_window_cint16 * restrict A_inx,      // input matrix assumed to be 16x16 column major
    	output_window_cint16 * restrict L_outx0,   // output matrix assumed to be 16x16 column major packed lower triangular
    	output_window_cint16 * restrict L_outx1,    // output matrix assumed to be 16x16 column major packed lower triangular
   	output_window_cint16 * restrict L_outx1_8x8    // output matrix assumed to be 8x8 column major packed lower triangular
);	

void ainv_trimat_inv_16x16_core0 (
	input_window_cint16 * restrict L_in, 
	output_window_cint16 *restrict x_out
);

void ainv_trimat_inv_16x16_core1 (
	input_window_cint16 * restrict L_in, 
	output_window_cint16 *restrict x_out
);
	
void ainv_win_merge_2i_2o(
	input_window_cint16* restrict in0, 
	input_window_cint16* restrict in1, 
	output_window_cint16* restrict out0, 
	output_window_cint16* restrict out1
);

void ainv_trimatmul(
	input_window_cint16* restrict in0, 
	input_window_cint16* restrict in1, 
	input_window_cint16* restrict in2, 
	output_window_cint16* restrict out
);

void ainv_win_merge(
	input_window_cint16* restrict in0, 
	input_window_cint16* restrict in1, 
	output_window_cint16* restrict out0, 
	output_window_cint16* restrict out1
);
	
void ainv_linvtmm (
	input_window_cint16 * restrict L_in, 
	output_window_cint16 *restrict x_out0, 
	output_window_cint16 *restrict x_out1
);

void ainv_linvtmm_m(
	input_window_cint16 * restrict L_in, 
	output_window_cint16 *restrict x_out
);

void ainv_trimatmul_8x8(input_window_cint16* restrict in, output_window_cint16* restrict out);
void ainv_chol_8x8(
    input_window_cint16 * restrict A_inx,      // input matrix assumed to be 16x16 column major
    output_window_cint16 * restrict L_outx_8x8   // output matrix assumed to be 8x8 column major packed lower triangular
);
	
#endif //__AINV_KERNELS_H__
