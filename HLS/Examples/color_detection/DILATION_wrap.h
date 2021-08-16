// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
#include "imgproc/xf_dilation.hpp"
#include "common/xf_common.hpp"

#include <stdint.h>
#include <ap_int.h>

#pragma XMC INPORT src
#pragma XMC OUTPORT dst
#pragma XMC SUPPORTS_STREAMING
#pragma XMC PARAMETER kernel


#define K_ROWS 3
#define K_COLS 3
#define ITERATIONS 1
//#define NPC_D XF_NPPC1

template<int ROWS,int COLS>
void DILATION_XMC(
        uint8_t src[ROWS][COLS],
        uint8_t dst[ROWS][COLS],
        unsigned char kernel[K_ROWS*K_COLS])
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
    
    
    xf::cv::dilate<XF_BORDER_CONSTANT, XF_8UC1, ROWS, COLS, XF_SHAPE_RECT, K_ROWS, K_COLS, ITERATIONS, XF_NPPC1>(
        src_obj, dst_obj, kernel);
    
    
    for (int i = 0;i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
#pragma HLS pipeline II=1
            data_out = dst_obj.read(i * COLS + j);
            dst[i][j] = data_out;
        }
    }
    
}