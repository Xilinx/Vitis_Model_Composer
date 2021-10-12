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
#ifndef FIR_NOSYM_H
#define FIR_NOSYM_H

#include "fir.h"

using namespace std;

const int L_WHOLE = 103; // length of FIR
const int L_HALF  = 52;  // half length of FIR
const int II_GOAL = 1;   // throughput goal

const int L_INPUT  = 100;
const int L_OUTPUT = 100;

#pragma XMC INPORT din
#pragma XMC OUTPORT dout
#pragma XMC SUPPORTS_STREAMING
void fir_sym (ap_fixed<17,3,AP_TRN,AP_WRAP> din[100],
        ap_fixed<17,3,AP_TRN,AP_WRAP> dout[100]);

// fir_sym class
const COEF_T cin_half[L_HALF] = {
#include "coef_halfof103.inc"
};

class fir_sym_class {
    
public:
    
    sym_class<L_WHOLE, L_INPUT, II_GOAL> f0;
    
    void process (DATA_T din[L_INPUT], DATA_T dout[L_OUTPUT] ) {
#pragma HLS INLINE
        f0.process_frame(din, dout);
    }
    
    fir_sym_class(void) {
        f0.init(cin_half);
    }
    
    ~fir_sym_class(void) {
    }
    
};
#endif




