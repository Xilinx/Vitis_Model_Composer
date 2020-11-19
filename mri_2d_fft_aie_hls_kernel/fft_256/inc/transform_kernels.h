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


#ifndef __TRANSFORM_KERNELS_H__
#define __TRANSFORM_KERNELS_H__


    void fft_128pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_256pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_384pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_512pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_640pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_1024pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_1200pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_1024pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_1536pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_2048pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_3072pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_4096pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_896pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_128pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_256pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_384pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_512pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_640pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_1024pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_1200pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_1536pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_2048pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_3072pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_4096pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_896pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );	
    void fft_12pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );	
    void fft_12pt_32b_dit(       
        input_window_cint32 * restrict inputx,
        output_window_cint32 * restrict outputy
    );
    void fft_12pt_batch_dit(
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_12pt_32b_batch_dit(
        input_window_cint32 * restrict inputx,
        output_window_cint32 * restrict outputy
    );
    void fft_24pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_24pt_32b_dit(
        input_window_cint32 * restrict inputx,
        output_window_cint32 * restrict outputy
    );
    void fft_36pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_36pt_32b_dit(
        input_window_cint32 * restrict inputx,
        output_window_cint32 * restrict outputy
    );
    void fft_300pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_300pt_32b_dit(
        input_window_cint32 * restrict inputx,
        output_window_cint32 * restrict outputy
    );
    void fft_600pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void fft_600pt_32b_dit(
        input_window_cint32 * restrict inputx,
        output_window_cint32 * restrict outputy
    );
    void ifft_12pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_12pt_32b_dit(       
        input_window_cint32 * restrict inputx,
        output_window_cint32 * restrict outputy
    );	
    void ifft_12pt_batch_dit(
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_12pt_32b_batch_dit(
        input_window_cint32 * restrict inputx,
        output_window_cint32 * restrict outputy
    );
    void ifft_24pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_24pt_32b_dit(
        input_window_cint32 * restrict inputx,
        output_window_cint32 * restrict outputy
    );
    void ifft_36pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_36pt_32b_dit(
        input_window_cint32 * restrict inputx,
        output_window_cint32 * restrict outputy
    );
    void ifft_300pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_300pt_32b_dit(
        input_window_cint32 * restrict inputx,
        output_window_cint32 * restrict outputy
    );
    void ifft_600pt_dit(       
        input_window_cint16 * restrict inputx,
        output_window_cint16 * restrict outputy
    );
    void ifft_600pt_32b_dit(
        input_window_cint32 * restrict inputx,
        output_window_cint32 * restrict outputy
    );


#endif //__TRANSFORM_KERNELS_H__
