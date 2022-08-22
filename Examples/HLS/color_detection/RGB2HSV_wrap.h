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

#include "imgproc/xf_bgr2hsv.hpp"
#include "common/xf_common.hpp"

#include <stdint.h>
#include <ap_int.h>

#pragma XMC INPORT R,G,B
#pragma XMC OUTPORT H,S,V
#pragma XMC SUPPORTS_STREAMING


template<int ROWS,int COLS>
void RGB2HSV_XMC(
        uint8_t R[ROWS][COLS],
        uint8_t G[ROWS][COLS],
        uint8_t B[ROWS][COLS],
        uint8_t H[ROWS][COLS],
        uint8_t S[ROWS][COLS],
        uint8_t V[ROWS][COLS])
{
    ap_uint<24> data_in;
    ap_uint<24> data_out;
    
    xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1> src_obj;
#pragma HLS stream variable=src_obj dim=2 depth=1
    
    xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1> dst_obj;
#pragma HLS stream variable=dst_obj dim=2 depth=1
    
    
#pragma HLS dataflow
    for (int i = 0;i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
#pragma HLS pipeline II=1
            data_in = (((uint8_t) B[i][j] << 0)
                    | ((uint8_t) G[i][j] << 8)
                    | ((uint8_t) R[i][j] << 16));
            src_obj.write(i * COLS + j,(data_in));
        }
    }
    
    bgr2hsv(src_obj, dst_obj);
    
    for (int i = 0;i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
#pragma HLS pipeline II=1
            data_out = dst_obj.read(i * COLS + j);
            H[i][j] = data_out.range(7, 0);
            S[i][j] = data_out.range(15,8);
            V[i][j] = data_out.range(23,16);
        }
    }
}



