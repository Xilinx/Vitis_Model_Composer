/*  (c) Copyright 2023 AMD, Inc. All rights reserved.
   
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

#include <aie_api/aie.hpp>
#include <aie_api/aie_adf.hpp>

#include "phase_rotators_fixed.h"

// fixed point look up table
template<unsigned int PHASE_INDEX>
void exp_calc_fixed(       
    adf::input_buffer<cint16> & restrict cb_input1,
    adf::output_buffer<cint16> & restrict cb_output1)
{
    aie::vector<cint16,4> opb, opa;
    aie::accum<cacc48,4> acc;

    auto pIn  = aie::begin_vector<4>(cb_input1);
    auto pOut  = aie::begin_vector<4>(cb_output1);
    v4cint16 * restrict pR; 

    if constexpr (PHASE_INDEX == 1) pR = (v4cint16 * restrict) tw1_fp;

    if constexpr (PHASE_INDEX == 2) pR = (v4cint16 * restrict) tw2_fp;

    if constexpr (PHASE_INDEX == 3) pR = (v4cint16 * restrict) tw3_fp;

    if constexpr (PHASE_INDEX == 4) pR = (v4cint16 * restrict) tw4_fp;

    if constexpr (PHASE_INDEX == 5) pR = (v4cint16 * restrict) tw5_fp;

    if constexpr (PHASE_INDEX == 6) pR = (v4cint16 * restrict) tw6_fp;

    if constexpr (PHASE_INDEX == 7) pR = (v4cint16 * restrict) tw7_fp;

    if constexpr (PHASE_INDEX == 8) pR = (v4cint16 * restrict) tw8_fp;
 
    if constexpr (PHASE_INDEX == 9) pR = (v4cint16 * restrict) tw9_fp;

    if constexpr (PHASE_INDEX == 10) pR = (v4cint16 * restrict) tw10_fp;

    if constexpr (PHASE_INDEX == 11) pR = (v4cint16 * restrict) tw11_fp;

    if constexpr (PHASE_INDEX == 12) pR = (v4cint16 * restrict) tw12_fp;

    if constexpr (PHASE_INDEX == 13) pR = (v4cint16 * restrict) tw13_fp;

    if constexpr (PHASE_INDEX == 14) pR = (v4cint16 * restrict) tw14_fp;

    if constexpr (PHASE_INDEX == 15) pR = (v4cint16 * restrict) tw15_fp;

// set rounding to match FFT 
// needed in case the runtime ratio (FFT+exp_calc_win) < 1
// otherwise a mismatch in x86 and System C simulation will happen
aie::set_rounding(aie::rounding_mode::symmetric_inf); // you can comment this out or change if runtime ratio (FFT+exp_calc_win) > 1

	for (unsigned l=0; l<512; ++l)
	chess_prepare_for_pipelining
	chess_loop_range(512,) 
    { 
       opb = *pIn++;
       opa = *pR++;
       acc = aie::mul(opb, opa);
       aie::vector<cint16,4> vc=acc.to_vector<cint16>(14);
       *pOut++ = vc;

    } // end of for loop

} // end of exp_calc_fixed