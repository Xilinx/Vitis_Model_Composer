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


#ifndef __FFT_256PT_GRAPH_H__
#define __FFT_256PT_GRAPH_H__

#include <adf.h>
#include "transform_kernels.h"
#include "fft_params.h"
#include "fft_bufs.h"

using namespace adf ;

class fft_256pt_graph : public graph {
   

    public:
        parameter fft_buf1;
        parameter fft_buf2;
        parameter fft_tw32;
        
        kernel fft;
        port<input> in;
        port<output> out;

    fft_256pt_graph() {

        // Create FFT kernels
        fft = kernel::create(fft_256pt_dit) ;

        //Call Init function to set_rnd and set_sat
        initialization_function(fft) = "fft256_init";

        // Temporary buffers for FFT stages
        fft_buf1 = parameter::array(fft_256_tmp1);
        fft_buf2 = parameter::array(fft_256_tmp2);
        fft_tw32 = parameter::array(fft_lut_tw32);
        connect<>(fft_buf1, fft);
        connect<>(fft_buf2, fft);
        connect<>(fft_tw32, fft);

        // Make connections
        connect<window<FFT256_INPUT_SAMPLES*4, FFT256_INPUT_MARGIN*4> >(in, fft.in[0]) ;
        connect<window<FFT256_OUTPUT_SAMPLES*4> >(fft.out[0], out) ;

    };

};
#endif /* __FFT_256PT_GRAPH_H__ */
