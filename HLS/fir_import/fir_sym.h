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




