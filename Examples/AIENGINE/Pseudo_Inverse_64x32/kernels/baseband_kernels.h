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


#ifndef __BASEBAND_KERNELS_H__
#define __BASEBAND_KERNELS_H__

	
void cholesky_4x4_batch(
                input_window_cint16 * restrict inpkt,
                output_window_cint16 * restrict outpkt
        );

void cholesky_4x4_batch_spfp(
                input_window_cfloat * restrict inpkt,
               output_window_cfloat * restrict outpkt
      );

void cholesky_8x8_batch(
                input_window_cint16 * restrict inpkt,
                output_window_cint16 * restrict outpkt
        );

void cholesky_16x16(
                input_window_cint16 * restrict inpkt,
                output_window_cint16 * restrict outpkt
        );

void cholesky_16x16_batch(
		input_window_cint16 * restrict inpkt,	  
                output_window_cint16 * restrict outpkt
	);		

void cholesky_32x32(
                input_window_cint16 * restrict inpkt,
                output_window_cint16 * restrict outpkt
        );

void fbsolver_nxn_batch(
		output_window_cint16 * x_out, 
		input_window_cint16 * L_in, 
		input_window_cint16 * y_in
	);
	
void fbsolver_32x32(
		output_window_cint16 * x_out, 
		input_window_cint16 * L_in, 
		input_window_cint16 * L_in_T, 
		input_window_cint16 * b_in
	);	
		
void fbsolver_16x16(
		output_window_cint16 * x_out, 
		input_window_cint16 * L_in, 
		input_window_cint16 * L_in_T, 
		input_window_cint16 * b_in
	);
		
void pinv_64x8(
	input_window_cint16  * restrict X_in,
    output_window_cint16 * restrict Y_out
);

void pinv_32x16_A(
	input_window_cint16  * restrict X_in,
    output_window_cint16 * restrict Y_out
);

void pinv_32x16_B(
	input_window_cint16  * restrict X_in,
    output_window_cint16 * restrict Y_out
);

void pinv_32x8(
	input_window_cint16  * restrict X_in,
    output_window_cint16 * restrict Y_out
);

void pinv_16x16_A(
	input_window_cint16  * restrict X_in,
    output_window_cint16 * restrict Y_out
);

void pinv_16x16_B(
	input_window_cint16  * restrict X_in,
    output_window_cint16 * restrict Y_out
);

void pinv_16x8(
	input_window_cint16  * restrict X_in,
    output_window_cint16 * restrict Y_out
);

void pinv_64x16_A(
	input_window_cint16  * restrict X_in,
    output_window_cint16 * restrict Y_out
);

void pinv_64x16_B(
	input_window_cint16  * restrict X_in,
    output_window_cint16 * restrict Y_out
);

void cholesky_16x16_2out(         
    		input_window_cint16 * restrict A_inx,    
    		output_window_cint16 * restrict L_outx0, 
		output_window_cint16 * restrict L_outx1
	);	

void precoder(
		input_window_cint16 * restrict inpkt,
		output_window_cint16 * restrict outpkt0,
		output_window_cint16 * restrict outpkt1,
		output_window_cint16 * restrict outpkt2,
		output_window_cint16 * restrict outpkt3
	);
	
void tx_beamformer(       
		input_window_cint16 * restrict inpkt,
		output_window_cint16 * restrict outpkt
	);

void projection_4x4_4x1(
		input_window_cint16 * C_in, 
		input_window_cint16 *  y_in, 
		output_window_cint16 *  r_out
	);

void beamformer_rx_16x16_16x12_core0(
		input_window_cint16 * restrict inpkt,
		output_stream_cacc48 * cascadeout
	);

void beamformer_rx_16x16_16x12_core1(
		input_window_cint16 * restrict inpkt, 
		input_stream_cacc48 * cascadein,
		output_stream_cacc48 * cascadeout
	);

void beamformer_rx_16x16_16x12_core2(
		input_window_cint16 * restrict inpkt,
		input_stream_cacc48 * cascadein,
		output_stream_cacc48 * cascadeout
	);
			  
void beamformer_rx_16x16_16x12_core3(
		input_window_cint16 * restrict inpkt,
		input_stream_cacc48 * cascadein,
		output_window_cint16 * cb_output
	);	

// Include kernels related to AINV module
#include "ainv_kernels.h"


#endif //__BASEBAND_KERNELS_H__
