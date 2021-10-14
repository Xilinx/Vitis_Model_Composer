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

#include <stdint.h>
#include "ap_int.h"
#include "imgproc/xf_warp_transform.hpp"
#include "common/xf_structs.hpp"
#include "common/xf_common.hpp"

#pragma XMC INPORT video_in,T_matrix
#pragma XMC OUTPORT video_out
#pragma XMC SUPPORTS_STREAMING

template<int ROWS, int COLS, int NPC>
void WarpTransform(uint8_t video_in[ROWS][COLS], 
                       float T_matrix[9], 
                       uint8_t video_out[ROWS][COLS]
                      )
{  
     ap_uint<8> data_in;
     ap_uint<8> data_out;
   
    
     const int TYPE = XF_8UC1;
     const int height = ROWS;
     const int width = COLS;
     const bool USE_URAM = false;
     const int bufferSize = 100;
     const int bufferPrefetch = 50;
  
    const int TRANSFORM= 0; //affine
    const bool INTERPOLATION_TYPE = 0; // 0-Nearest neighbor interpolation 
  
    xf::cv::Mat<TYPE,ROWS,COLS,XF_NPPC1> src_obj;
    #pragma HLS stream variable=src_obj dim=1 depth=1
    
 
    xf::cv::Mat<TYPE,ROWS,COLS,XF_NPPC1> dst_obj;
    #pragma HLS stream variable=dst_obj dim=1 depth=1
    
    
    #pragma HLS dataflow
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
        #pragma HLS pipeline II=1
            data_in = video_in[i][j];
            src_obj.write(i * COLS + j,(data_in));
        }
    }
    
     xf::cv::warpTransform<bufferSize, bufferPrefetch, TRANSFORM, INTERPOLATION_TYPE, XF_8UC1, 
      height, width, NPC , USE_URAM> (src_obj, dst_obj, T_matrix);


      for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
        #pragma HLS pipeline II=1
            data_out = dst_obj.read(i * COLS + j);
            video_out[i][j] = data_out;
        }
      }
     
  }