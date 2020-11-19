#ifndef HLS_KERNELS_H
#define HLS_KERNELS_H

#include "hls_stream.h"
#include <adf.h>

////// This header file is for cardano only. HLS cpp does NOT include this header. //////

void hls_pass_through(adf::dir::in<hls::stream<ap_axis<32,0,0,0> >&> in_sample, adf::dir::out<hls::stream<ap_axis<32,0,0,0> >&> out_sample);

#endif
