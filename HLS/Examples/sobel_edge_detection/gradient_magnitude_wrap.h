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
#include "imgproc/xf_magnitude.hpp"
#include "common/xf_structs.hpp"
#include "common/xf_common.hpp"

#pragma XMC INPORT inX,inY
#pragma XMC OUTPORT out
#pragma XMC SUPPORTS_STREAMING

template<int ROWS, int COLS, int NPC=1>
void GradientMag(uint16_t inX[ROWS][COLS], 
                     uint16_t inY[ROWS][COLS],
                     uint16_t Out[ROWS][COLS]
                    )
{  
     ap_uint<16> dataX_in;
     ap_uint<16> dataY_in;
     ap_uint<16> data_out;
   
     const int NORM_TYPE = XF_L1NORM;
     const int TYPE = XF_16SC1;
     const int height = ROWS;
     const int width = COLS;
     const bool USE_URAM = false;
     const int bufferSize = 100;
     const int bufferPrefetch = 50;
 
  
    xf::cv::Mat<TYPE,ROWS,COLS,XF_NPPC1> srcX_obj;
    #pragma HLS stream variable=srcX_obj dim=1 depth=1
    
    xf::cv::Mat<TYPE,ROWS,COLS,XF_NPPC1> srcY_obj;
    #pragma HLS stream variable=srcY_obj dim=1 depth=1
    
 
    xf::cv::Mat<TYPE,ROWS,COLS,XF_NPPC1> dst_obj;
    #pragma HLS stream variable=dst_obj dim=1 depth=1
    
    
    #pragma HLS dataflow
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
        #pragma HLS pipeline II=1
            dataX_in = inX[i][j];
            dataY_in = inY[i][j];
            srcX_obj.write(i * COLS + j,(dataX_in));
            srcY_obj.write(i * COLS + j,(dataY_in));
        }
    }
    
     xf::cv::magnitude<NORM_TYPE,XF_16SC1,XF_16SC1,height, width,NPC> (srcX_obj,srcY_obj,dst_obj);


      for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
        #pragma HLS pipeline II=1
            data_out = dst_obj.read(i * COLS + j);
            Out[i][j] = data_out;
        }
      }
     
  }