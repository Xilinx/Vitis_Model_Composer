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

#include "imgproc/xf_erosion.hpp"
#include "common/xf_common.hpp"

#include <stdint.h>
#include <ap_int.h>

#pragma XMC INPORT src
#pragma XMC OUTPORT dst
#pragma XMC SUPPORTS_STREAMING
#pragma XMC PARAMETER kernel

#define K_ROWS_EROSION 3
#define K_COLS_EROSION 3
#define ITERATIONS_EROSION 1
//#define NPC XF_NPPC1

template<int ROWS,int COLS>
void EROSION_XMC(
        uint8_t src[ROWS][COLS],
        uint8_t dst[ROWS][COLS],
        unsigned char kernel[K_ROWS_EROSION*K_COLS_EROSION])
{
    uint8_t data_in;
    uint8_t data_out;
    
    xf::cv::Mat<XF_8UC1,ROWS,COLS,XF_NPPC1> src_obj;
#pragma HLS stream variable=src_obj dim=2 depth=1
    
    xf::cv::Mat<XF_8UC1,ROWS,COLS,XF_NPPC1> dst_obj;
#pragma HLS stream variable=dst_obj dim=2 depth=1
    
    
#pragma HLS dataflow
    for (int i = 0;i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
#pragma HLS pipeline II=1
            data_in = src[i][j];
            src_obj.write(i * COLS + j,(data_in));
        }
    }
    
    
    xf::cv::erode<XF_BORDER_CONSTANT, XF_8UC1, ROWS, COLS, XF_SHAPE_RECT, K_ROWS_EROSION, K_COLS_EROSION, ITERATIONS_EROSION, XF_NPPC1>(
        src_obj, dst_obj, kernel);
    
    
    for (int i = 0;i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
#pragma HLS pipeline II=1
            data_out = dst_obj.read(i * COLS + j);
            dst[i][j] = data_out;
        }
    }
    
}