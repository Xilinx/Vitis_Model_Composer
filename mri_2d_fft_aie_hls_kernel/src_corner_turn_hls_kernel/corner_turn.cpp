#include "ap_fixed.h"
#include <ap_int.h>
#include <hls_x_complex.h>

typedef ap_int<64>  ap_int64;
typedef ap_int<32>  ap_int32;

#define MSIZE 256

/******************************************************************************
 * // Function name - CornerTurn_func
 * //
 * // This function takes the input vector of size 256 and stores in ping pong
 * // buffer to generate a matrix of size 256x256. Then, corner turning operation
 * // is performed to flip rows and columns and finally outputs a vector of size
 * // 256.
 *******************************************************************************/

extern "C" void CornerTurn_func(hls::stream<ap_axis<64, 0, 0, 0> > & in_sample,
        hls::stream<ap_axis<64, 0, 0, 0> > & out_sample) {
    
    
#pragma HLS PIPELINE II=1
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE axis register both port=out_sample
#pragma HLS INTERFACE axis register both port=in_sample
    
    
    static short incr_cnt = 0;
    static bool ping_pong = false;
    //This counter counts for 256 32 bit or 128 64 bit input samples
    static short count_256 = 0;
    static ap_int32 ping[MSIZE][MSIZE];
    static ap_int32 pong[MSIZE][MSIZE];
    
    ap_axis<64, 0, 0, 0> out_axis64;
    
    ap_int64 in;
    ap_int32 *temp_in = (ap_int32 *)&in;
    
    ap_int64 out;
    ap_int32 *temp_out = (ap_int32 *)&out;
    
    if (count_256 <256) {
        if (ping_pong == false) {
            // write to ping, read from pong
            // copy array input to ping row
            // read return data from pong col
            in = in_sample.read().data;
            
            ping[count_256][incr_cnt] = temp_in[0];
            ping[count_256+1][incr_cnt] = temp_in[1];
            
            temp_out[0] = pong[incr_cnt][count_256];
            temp_out[1] = pong[incr_cnt][count_256+1];
            
            out_axis64.data = out;
            out_sample.write(out_axis64);
        }
        else {
            // copy array input to pong row
            // read return data from ping col
            in = in_sample.read().data;
            
            pong[count_256][incr_cnt] = temp_in[0];
            pong[count_256+1][incr_cnt] = temp_in[1];
            
            temp_out[0] = ping[incr_cnt][count_256];
            temp_out[1] = ping[incr_cnt][count_256+1];
            
            out_axis64.data = out;
            out_sample.write(out_axis64);
        }
        count_256+=2;
    }
    else {
        count_256 = 0;
        // check increment count
        short t = incr_cnt;
        (incr_cnt == MSIZE - 1) ? incr_cnt = 0 : incr_cnt ++;
        (t == MSIZE -1) ? ((ping_pong == false) ? ping_pong = true :
            ping_pong = false):ping_pong = ping_pong;
    }
}
