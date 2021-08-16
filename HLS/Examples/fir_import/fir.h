// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
// fir.h:
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

#ifndef _FIR_H
#define _FIR_H

//______________________________________________________________________________
// filter precision
// - precisions used by all the FIR class
//______________________________________________________________________________

#include <ap_fixed.h>

static const int NFRAC = 14;
typedef ap_fixed<3+NFRAC,  3, AP_TRN, AP_WRAP> DATA_T;
typedef ap_fixed<4+NFRAC,  4, AP_TRN, AP_WRAP> DATA2_T;
typedef ap_fixed<2+NFRAC,  2, AP_RND_CONV, AP_WRAP> COEF_T;
typedef ap_fixed<5+NFRAC,  5, AP_RND_CONV, AP_WRAP> PROD_T; // rounding helps ~20db dc offset
typedef ap_fixed<10+NFRAC, 10, AP_TRN, AP_WRAP> ACC_T;


//______________________________________________________________________________
// single rate, symmetric fir classs
//
// - parameter: 
//    -l_WHOLE:  number of taps
//    -l_SAMPLE: number of data sample
//    -II_GOAL:  initiation interval goal
//______________________________________________________________________________

template<int l_WHOLE, int l_SAMPLE, int II_GOAL>
class sym_class {

static const int odd    = l_WHOLE % 2;
static const int l_HALF = l_WHOLE/2;
static const int l_COEF = l_WHOLE/2 + odd;  // number of unique coefficients

DATA_T sr[l_WHOLE];
ACC_T  acc;
COEF_T coeff[l_COEF];

public:

//_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
// MAC engine
ACC_T MAC_preadd( DATA_T din0, DATA_T din1, COEF_T coef, ACC_T acc ) {

    DATA2_T preadd = din0 + din1; 
    PROD_T  prod   = preadd * coef;      
    ACC_T   sum    = prod + acc;      

    return sum;
};


//_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
// filter
void process ( DATA_T din, DATA_T* dout) {

#pragma HLS INLINE

// using 'factor' instead of 'complete' uses BRAM instead of FF
#pragma HLS array_reshape variable=sr  complete
#pragma HLS array_reshape variable=coeff complete dim=0

acc = 0;

LOOP_MAC: 
for (int i=0; i<l_HALF; i++) {
    acc = MAC_preadd (sr[i], sr[l_WHOLE-1-i], coeff[i], acc);
}

if (odd)
    acc = MAC_preadd (sr[l_HALF], 0, coeff[l_HALF], acc);

LOOP_SR:  for (int i=l_WHOLE-1; i>0 ; i--) {
            sr[i] = sr[i-1];
}

sr[0] = din;

*dout = acc;

}


//_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
// filter frame
void process_frame(const DATA_T din[l_SAMPLE], DATA_T dout[l_SAMPLE]) {

   DATA_T tout;

   L_FRAME: for (int i=0; i<l_SAMPLE; i++ ) {
   #pragma HLS pipeline II=II_GOAL rewind
           process (din[i], &tout);
		   dout[i] = tout;
       }

}


//_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
// initialize coeff
void init(const COEF_T cin[l_COEF]) {
L_COEFF_INIT : for (int i=0; i<l_COEF;i++) 
                coeff[i] = cin[i];
}

//constructor
sym_class(const COEF_T cin[l_COEF]) {
    init(cin);
}

//constructor
sym_class(void) {
}

//destructor
~sym_class(void) {
}



};


#endif




