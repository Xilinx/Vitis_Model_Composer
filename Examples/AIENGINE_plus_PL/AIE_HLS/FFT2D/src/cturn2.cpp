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


#include<iostream>

#define CFR_THRESHOLD (11626)
#define SIGN(x) (x>0 ? 0.5 : -0.5)

#include <ap_int.h>
#include <hls_stream.h>
#include <ap_axi_sdata.h>
#include <stdint.h>
#include <complex.h>

#define MSIZE 256

template <typename ELEMENT> struct complex_types {
  ELEMENT real;
  ELEMENT imag;
};

// Bit accurate data types used for HLS synthesis
typedef complex_types<ap_int<16> > ap_cint16;
typedef ap_int<32>                 ap_int32;
typedef ap_int<16>                 ap_int16;
typedef ap_int<64>                 ap_int64;


void cturn2(hls::stream<std::complex<short>> &vin, hls::stream<std::complex<short>> &vout) {
//#pragma HLS PIPELINE II=1
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis port=vout
#pragma HLS INTERFACE axis port=vin

  static short incr_cnt = 0; // col/row location for write/read
  static bool ping_pong = false; // ping or pong buffer indication
  static std::complex<ap_int16> ping[MSIZE][MSIZE];
  static std::complex<ap_int16> pong[MSIZE][MSIZE];
  std::complex<ap_int16> vin_tmp[MSIZE], vout_tmp[MSIZE];

  // copy array of input data
  vin_tmp_cpy: for(short m=0; m < MSIZE; m++) {
  #pragma HLS PIPELINE
      //vin_tmp[m] = vin.read()*(short)5;
      vin_tmp[m] = vin.read();
  } // end of vin_tmp_cpy

  cturn_label0: for (short j = 0; j < MSIZE; j++) {
  #pragma HLS PIPELINE
  	if (ping_pong == false) { // write to ping, read from pong
  		ping[j][incr_cnt] = vin_tmp[j]; // copy array input to ping row
  		vout_tmp[j] = pong[incr_cnt][j]; // read return data from pong col
  	} // ping_pong == false
  	else {
  		pong[j][incr_cnt] = vin_tmp[j]; // copy array input to pong row
  		vout_tmp[j] = ping[incr_cnt][j]; // read return data from ping col
  	} // ping_pong == true
  } // cturn_label0

  	// check increment count
  	if (incr_cnt == MSIZE - 1) {
  		if (ping_pong == false)
  			ping_pong = true;
  		else ping_pong = false;
  		incr_cnt = 0;
  	}
  	else incr_cnt++;

  // copy array of input data
  vout_tmp_cpy: for(short n=0; n < MSIZE; n++) {
  #pragma HLS PIPELINE
      vout.write(vout_tmp[n]);
  } // end of vout_tmp_cpy

};
