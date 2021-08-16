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


// Using the XMC_SUPPORTS_STREAMING below, we speficy that create_transform_matrix 
// function supports streaming. Therefore, the elements of non-scalar arguments 
// of create_transform_matrix must be accessed in strict sequential order. 
// So in this case, first assign transform_matrix[0][0], 
// then transform_matrix[0][1], ... and finally assign transform_matrix[2][2].

#include <stdint.h>
#include "hls_math.h"

#pragma XMC SUPPORTS_STREAMING
void create_transform_matrix(const float angle, const float center_x, 
        const float center_y, float transform_matrix[9])
{ 
    const float scale = 1;
    
    float a = scale * hls::cosf(angle);
    float b = scale * hls::sinf(angle);
    
    
    transform_matrix[0] = a;
    transform_matrix[1] = b;
    transform_matrix[2] = (1-a)*center_x-b*center_y;
    
    transform_matrix[3] = -b;
    transform_matrix[4] = a;
    transform_matrix[5] = b*center_x +(1-a)*center_y;
    
    transform_matrix[6] = 0;
    transform_matrix[7] = 0;
    transform_matrix[8] = 0;
    
    
}


