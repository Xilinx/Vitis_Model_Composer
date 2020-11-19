#include <ap_int.h>
#include <hls_stream.h>
//#include <ap_axi_sdata.h>
//#include <stdint.h>

extern "C" void hls_pass_through(hls::stream<ap_axis<32, 0, 0, 0> > &in_sample, hls::stream<ap_axis<32, 0, 0, 0> > &out_sample) {
//#pragma HLS PIPELINE II=1
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis port=out_sample
#pragma HLS INTERFACE axis port=in_sample

  ap_axis<32, 0, 0, 0> out_x;
  ap_axis<32, 0, 0, 0> in_x = in_sample.read();

  out_x.data = in_x.data;
  out_sample.write(out_x);
};

