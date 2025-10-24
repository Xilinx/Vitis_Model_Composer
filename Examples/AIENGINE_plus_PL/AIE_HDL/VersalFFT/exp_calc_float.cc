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

#include "phase_rotators_float.h"

// floating point using scalar processor sincos table
template<unsigned int phase_index> 
void exp_calc_float(       
    adf::input_buffer<cfloat> & restrict cb_input0,
    adf::output_buffer<cfloat> & restrict cb_output0)
{

unsigned int phase_acc = 0x00000000 ; // note: only upper 20 bits of phase accumulator are used
    unsigned int phase_offset = phase_index; // starts at 0x1000; // phase offset start is 0x1000 as only upper 20 bits are used 0x0000x000
//first 1024 samples in a 1024*1024 size table / (32*1024) = 32 address / step increment

    cint16 phRotInt16;
    cfloat opa;
    aie::vector<cfloat,4> opa_float;
    aie::vector<cfloat,4> opb;
    aie::vector<cfloat,4> acc;

    auto pIn  = aie::begin_vector<4>(cb_input0);
    auto pOut  = aie::begin_vector<4>(cb_output0);

	for (unsigned l=0; l<256; ++l)
	chess_prepare_for_pipelining
	chess_loop_range(256,) 
    {   
       opb = *pIn++; // window_readincr_v<4>(cb_input0);
       phRotInt16 = aie::sincos_complex(phase_acc);
       opa.real = (float)phRotInt16.real; 
       opa.imag = (float)phRotInt16.imag; 
	   opa_float=upd_elem(opa_float, 0, opa); // update vector

	   phase_acc += phase_offset;
       phRotInt16 = aie::sincos_complex(phase_acc);
       opa.real = (float)phRotInt16.real;
       opa.imag = (float)phRotInt16.imag;
	   opa_float=upd_elem(opa_float, 1, opa);

	   phase_acc += phase_offset;
       phRotInt16 = aie::sincos_complex(phase_acc);
       opa.real = (float)phRotInt16.real;
       opa.imag = (float)phRotInt16.imag;
	   opa_float=upd_elem(opa_float, 2, opa);

	   phase_acc += phase_offset;
       phRotInt16 = aie::sincos_complex(phase_acc);
       opa.real = (float)phRotInt16.real;
       opa.imag = (float)phRotInt16.imag;
	   opa_float=upd_elem(opa_float, 3, opa);

	   phase_acc += phase_offset;
       opa_float = aie::mul(cfloat({0.000030517578125, 0}), opa_float); // int16/2^15 aka normalize sincos data
       acc = aie::mul(aie::op_conj(opa_float), opb); // sin needs to be inverted
       *pOut++ = acc; // window_writeincr(cb_output0, opb); // opa_float);

    } // end of for loop
} // end of exp_calc_float


template<unsigned int PHASE_INDEX>
void exp_calc_float_lookup(       
    adf::input_buffer<cfloat> & restrict cb_input1,
    output_stream<cfloat> * restrict cb_output1)
{
    aie::vector<cfloat,4> opa, opb, acc;

    auto pIn  = aie::begin_vector<4>(cb_input1);
    v4cfloat * restrict pR; // = (v4cfloat * restrict) tw1;


    if constexpr (PHASE_INDEX == 1) pR = (v4cfloat * restrict) tw1;

    if constexpr (PHASE_INDEX == 2) pR = (v4cfloat * restrict) tw2;

    if constexpr (PHASE_INDEX == 3) pR = (v4cfloat * restrict) tw3;

    if constexpr (PHASE_INDEX == 4) pR = (v4cfloat * restrict) tw4;

    if constexpr (PHASE_INDEX == 5) pR = (v4cfloat * restrict) tw5;

    if constexpr (PHASE_INDEX == 6) pR = (v4cfloat * restrict) tw6;

    if constexpr (PHASE_INDEX == 7) pR = (v4cfloat * restrict) tw7;

    if constexpr (PHASE_INDEX == 8) pR = (v4cfloat * restrict) tw8;
 
    if constexpr (PHASE_INDEX == 9) pR = (v4cfloat * restrict) tw9;

    if constexpr (PHASE_INDEX == 10) pR = (v4cfloat * restrict) tw10;

    if constexpr (PHASE_INDEX == 11) pR = (v4cfloat * restrict) tw11;

    if constexpr (PHASE_INDEX == 12) pR = (v4cfloat * restrict) tw12;

    if constexpr (PHASE_INDEX == 13) pR = (v4cfloat * restrict) tw13;

    if constexpr (PHASE_INDEX == 14) pR = (v4cfloat * restrict) tw14;

    if constexpr (PHASE_INDEX == 15) pR = (v4cfloat * restrict) tw15;

    if constexpr (PHASE_INDEX == 16) pR = (v4cfloat * restrict) tw16;
  
    if constexpr (PHASE_INDEX == 17) pR = (v4cfloat * restrict) tw17;

    if constexpr (PHASE_INDEX == 18) pR = (v4cfloat * restrict) tw18;

    if constexpr (PHASE_INDEX == 19) pR = (v4cfloat * restrict) tw19;

    if constexpr (PHASE_INDEX == 20) pR = (v4cfloat * restrict) tw20;

    if constexpr (PHASE_INDEX == 21) pR = (v4cfloat * restrict) tw21;

    if constexpr (PHASE_INDEX == 22) pR = (v4cfloat * restrict) tw22;

    if constexpr (PHASE_INDEX == 23) pR = (v4cfloat * restrict) tw23;

    if constexpr (PHASE_INDEX == 24) pR = (v4cfloat * restrict) tw24;

    if constexpr (PHASE_INDEX == 25) pR = (v4cfloat * restrict) tw25;

    if constexpr (PHASE_INDEX == 26) pR = (v4cfloat * restrict) tw26;

    if constexpr (PHASE_INDEX == 27) pR = (v4cfloat * restrict) tw27;

    if constexpr (PHASE_INDEX == 28) pR = (v4cfloat * restrict) tw28;

    if constexpr (PHASE_INDEX == 29) pR = (v4cfloat * restrict) tw29;

    if constexpr (PHASE_INDEX == 30) pR = (v4cfloat * restrict) tw30;

    if constexpr (PHASE_INDEX == 31) pR = (v4cfloat * restrict) tw31;

	for (unsigned l=0; l<256; ++l)
	chess_prepare_for_pipelining
	chess_loop_range(256,) 
    { 
       opb = *pIn++;
       opa = *pR++;
       acc = aie::mul(opa, opb);
       writeincr(cb_output1, acc); // write out axi stream

    } // end of for loop
} // end exp_calc_float_lookup