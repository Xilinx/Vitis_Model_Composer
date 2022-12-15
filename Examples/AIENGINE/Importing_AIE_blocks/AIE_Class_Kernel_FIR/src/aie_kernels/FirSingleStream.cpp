/*
* (c) Copyright 2020 Xilinx, Inc. All rights reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
*/

#include "FirSingleStream.h"


template <int SAMPLES,int SHIFT>
void SingleStream::FIR_SingleStream<SAMPLES,SHIFT>::filter(input_stream_cint16* sig_in,output_stream_cint16* sig_out)
{

    const int LSIZE=(SAMPLES/32);
    aie::accum<cacc48,8> acc;
    const aie::vector<cint16,8> coe[4] = {aie::load_v<8>(eq_coef),aie::load_v<8>(eq_coef+8),aie::load_v<8>(eq_coef+16),aie::load_v<8>(eq_coef+24)};
    aie::vector<cint16,32> buff=delay_line;
    for(int i=0;i<LSIZE;i++){
        //performace 1st 8 samples
        acc = aie::sliding_mul<8,8>(coe[0],0,buff,0);
        acc = aie::sliding_mac<8,8>(acc,coe[1],0,buff,8);
        buff.insert(0,readincr_v<4>(sig_in));
        buff.insert(1,readincr_v<4>(sig_in));
        acc = aie::sliding_mac<8,8>(acc,coe[2],0,buff,16);
        acc = aie::sliding_mac<8,8>(acc,coe[3],0,buff,24);
        writeincr(sig_out,acc.to_vector<cint16>(SHIFT));

        //performace 2nd 8 samples
        acc = aie::sliding_mul<8,8>(coe[0],0,buff,8);
        acc = aie::sliding_mac<8,8>(acc,coe[1],0,buff,16);
        buff.insert(2,readincr_v<4>(sig_in));
        buff.insert(3,readincr_v<4>(sig_in));
        acc = aie::sliding_mac<8,8>(acc,coe[2],0,buff,24);
        acc = aie::sliding_mac<8,8>(acc,coe[3],0,buff,0);
        writeincr(sig_out,acc.to_vector<cint16>(SHIFT));

        //performace 3rd 8 samples
        acc = aie::sliding_mul<8,8>(coe[0],0,buff,16);
        acc = aie::sliding_mac<8,8>(acc,coe[1],0,buff,24);
        buff.insert(4,readincr_v<4>(sig_in));
        buff.insert(5,readincr_v<4>(sig_in));
        acc = aie::sliding_mac<8,8>(acc,coe[2],0,buff,0);
        acc = aie::sliding_mac<8,8>(acc,coe[3],0,buff,8);
        writeincr(sig_out,acc.to_vector<cint16>(SHIFT));

        //performace 4th 8 samples
        acc = aie::sliding_mul<8,8>(coe[0],0,buff,24);
        acc = aie::sliding_mac<8,8>(acc,coe[1],0,buff,0);
        buff.insert(6,readincr_v<4>(sig_in));
        buff.insert(7,readincr_v<4>(sig_in));
        acc = aie::sliding_mac<8,8>(acc,coe[2],0,buff,8);
        acc = aie::sliding_mac<8,8>(acc,coe[3],0,buff,16);
        writeincr(sig_out,acc.to_vector<cint16>(SHIFT));
    }
    delay_line=buff;
}

template <int SAMPLES,int SHIFT>
void SingleStream::FIR_SingleStream<SAMPLES,SHIFT>::filter_init(const cint16 (&taps)[32]) {

    for(int i=0;i<32;i++)
    {
        eq_coef[i] = taps[i];
    }

    delay_line = aie::zeros<cint16, 32>();
}
