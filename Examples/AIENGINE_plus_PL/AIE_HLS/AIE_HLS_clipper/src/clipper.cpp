///////////////////////////////////////////////////////////////////////////
// Copyright 2020 Xilinx
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

#include <hls_stream.h>
#include <complex>

#define MSIZE 32

void clipper(hls::stream<std::complex<short> >& vin, int threshold, hls::stream<std::complex<short> >& vout) {

#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis port=vin
#pragma HLS INTERFACE axis port=vout
    
    
    std::complex<short> vin_temp;
    
    // copy array of input data
    for(short m=0; m < MSIZE; m++) {
#pragma HLS PIPELINE
        //vin_tmp[m] = vin.read()*(short)5;
        vin_temp = vin.read();
        
        if (vin_temp.real() > threshold)
            vin_temp.real(threshold);
        else if (vin_temp.real() < -threshold)
            vin_temp.real(-threshold);
        
        vout.write(vin_temp);       
    };    
};
