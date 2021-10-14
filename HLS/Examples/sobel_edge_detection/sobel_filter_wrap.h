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
#include "imgproc/xf_sobel.hpp"
#include "common/xf_structs.hpp"
#include "common/xf_common.hpp"

#pragma XMC INPORT in
#pragma XMC OUTPORT video_out
#pragma XMC SUPPORTS_STREAMING

template<int ROWS, int COLS, int NPC=1>
void SobelFilter(uint8_t in[ROWS][COLS],  
                     uint16_t outX[ROWS][COLS],
                     uint16_t outY[ROWS][COLS]
                    )
{  
     ap_uint<16> data_in;
     ap_uint<16> data_outX;
     ap_uint<16> data_outY;
   
    
     const int FILTER_TYPE = XF_FILTER_3X3;
     const int BORDER_TYPE = XF_BORDER_CONSTANT;
     const int TYPE_IN = XF_8UC1;
     const int TYPE_OUT = XF_16SC1;
     const int height = ROWS;
     const int width = COLS;
     //const bool USE_URAM = false;
      
    xf::cv::Mat<TYPE_IN,ROWS,COLS,XF_NPPC1> src_obj;
    #pragma HLS stream variable=src_obj dim=1 depth=1
    
 
    xf::cv::Mat<TYPE_OUT,ROWS,COLS,XF_NPPC1> dstx_obj;
    #pragma HLS stream variable=dstx_obj dim=1 depth=1
    
    
    xf::cv::Mat<TYPE_OUT,ROWS,COLS,XF_NPPC1> dsty_obj;
    #pragma HLS stream variable=dsty_obj dim=1 depth=1
    
    
    #pragma HLS dataflow
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
        #pragma HLS pipeline II=1
            data_in = in[i][j];
            src_obj.write(i * COLS + j,(data_in));
        }
    }
    
     xf::cv::Sobel<BORDER_TYPE, FILTER_TYPE,XF_8UC1,XF_16SC1,height, width,NPC> (src_obj, dstx_obj, dsty_obj);

      for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
        #pragma HLS pipeline II=1
            data_outX = dstx_obj.read(i * COLS + j);
            data_outY = dsty_obj.read(i * COLS + j);
            outX[i][j] = data_outX;
            outY[i][j] = data_outY;
        }
      }
     
  }