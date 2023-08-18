///////////////////////////////////////////////////////////////////////////
// Copyright 2021 Xilinx
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
///////////////////////////////////////////////////////////////////////////

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




