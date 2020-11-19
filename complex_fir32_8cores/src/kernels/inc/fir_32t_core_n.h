/*  (c) Copyright 2014 - 2019 Xilinx, Inc. All rights reserved.
   
    This file contains confidential and proprietary information
    of Xilinx, Inc. and is protected under U.S. and
    international copyright and other intellectual property
    laws.
   
    DISCLAIMER
    This disclaimer is not a license and does not grant any
    rights to the materials distributed herewith. Except as
    otherwise provided in a valid license issued to you by
    Xilinx, and to the maximum extent permitted by applicable
    law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
    WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
    AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING1
    BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
    INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
    (2) Xilinx shall not be liable (whether in contract or tort,
    including negligence, or under any other theory of
    liability) for any loss or damage of any kind or nature
    related to, arising under or in connection with these
    materials, including for any direct, or any indirect,
    special, incidental, or consequential loss or damage
    (including loss of data, profits, goodwill, or any type of
    loss or damage suffered as a result of any action brought
    by a third party) even if such damage or loss was
    reasonably foreseeable or Xilinx had been advised of the
    possibility of the same.
   
    CRITICAL APPLICATIONS
    Xilinx products are not designed or intended to be fail-
    safe, or for use in any application requiring fail-safe
    performance, such as life-support or safety devices or
    systems, Class III medical devices, nuclear facilities,
    applications related to the deployment of airbags, or any
    other applications that could lead to death, personal
    injury, or severe property or environmental damage
    (individually and collectively, "Critical
    Applications"). Customer assumes the sole risk and
    liability of any use of Xilinx products in Critical
    Applications, subject only to applicable laws and
    regulations governing limitations on product liability.
   
    THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
    PART OF THIS FILE AT ALL TIMES.                       */

#include <cardano.h>
#include "utils.h"
#include "fir_32t_8cores_const.h"


template <bool HasCascadeIn, bool HasCascadeOut>
struct fir_32t_coreN
{
    // buffer to keep state 
    v16cint16 chess_storage(%chess_alignof(v16cint16)) delay_line; 

    void run(input_stream_cint16 * sig_in, 
             input_stream_cacc48 * cascadein,
             output_stream_cacc48 * cascadeout,
             output_stream_cint16 * data_out,
             const cint16_t * restrict coeff)
    {
        const int shift = 0; //FIR_32T_8CORES_SHIFT15;
        const unsigned samples = FIR_32T_8CORES_IN_SAMPLES;
        const v8cint16 *coef_  =  (v8cint16 const*)coeff;
        const v8cint16 coe = *coef_;

        v16cint16 buff = delay_line;
        v4cacc48 acc;
        const unsigned LSIZE = (samples/4/4); // assuming samples is integer power of 2 and greater than 16

        for (unsigned int i = 0; i < LSIZE; ++i)
        chess_prepare_for_pipelining
        chess_loop_range(4,)
        {
            if (HasCascadeIn) {
                acc = readincr_v4(cascadein);
                acc  = mac4(acc, buff, 0 , 0x3210, 1,  coe, 0, 0x0000, 1);
            }
            else {
                acc  = mul4(buff, 0 , 0x3210, 1,  coe, 0, 0x0000, 1);
            }

            acc  = mac4(acc, buff, 2 , 0x3210, 1,  coe, 2, 0x0000, 1);
            buff = upd_v(buff, 2, readincr_v4(sig_in));
            acc  = mac4(acc, buff, 4 , 0x3210, 1,  coe, 4, 0x0000, 1);
            acc  = mac4(acc, buff, 6 , 0x3210, 1,  coe, 6, 0x0000, 1);

            if (HasCascadeOut)
            	writeincr_v4(cascadeout,acc);
            writeincr_v4(data_out,srs(acc,shift));

            if (HasCascadeIn) {
                acc = readincr_v4(cascadein);
                acc  = mac4(acc, buff, 4 , 0x3210, 1,  coe, 0, 0x0000, 1);
            }
            else {
                acc  = mul4(buff, 4 , 0x3210, 1,  coe, 0, 0x0000, 1);
            }

            acc  = mac4(acc, buff, 6 , 0x3210, 1,  coe, 2, 0x0000, 1);
            buff = upd_v(buff, 3, readincr_v4(sig_in));
            acc  = mac4(acc, buff, 8 , 0x3210, 1,  coe, 4, 0x0000, 1);
            acc  = mac4(acc, buff, 10, 0x3210, 1,  coe, 6, 0x0000, 1);
            if (HasCascadeOut)
                writeincr_v4(cascadeout,acc);
            writeincr_v4(data_out,srs(acc,shift));

            if (HasCascadeIn) {
                acc = readincr_v4(cascadein);
                acc  = mac4(acc, buff, 8  , 0x3210, 1,  coe, 0, 0x0000, 1);
            }
            else {
                acc  = mul4(buff, 8  , 0x3210, 1,  coe, 0, 0x0000, 1);
            }

            acc  = mac4(acc, buff, 10 , 0x3210, 1,  coe, 2, 0x0000, 1);
            buff = upd_v(buff, 0, readincr_v4(sig_in));
            acc  = mac4(acc, buff, 12 , 0x3210, 1,  coe, 4, 0x0000, 1);
            acc  = mac4(acc, buff, 14 , 0x3210, 1,  coe, 6, 0x0000, 1);
            if (HasCascadeOut)
                writeincr_v4(cascadeout,acc);
            writeincr_v4(data_out,srs(acc,shift));

            if (HasCascadeIn) {
                acc = readincr_v4(cascadein);
                acc  = mac4(acc, buff, 12 , 0x3210, 1,  coe, 0, 0x0000, 1);
            }
            else {
                acc  = mul4(buff, 12 , 0x3210, 1,  coe, 0, 0x0000, 1);
            }
            acc  = mac4(acc, buff, 14 , 0x3210, 1,  coe, 2, 0x0000, 1);
            buff = upd_v(buff, 1, readincr_v4(sig_in));
            acc  = mac4(acc, buff, 0  , 0x3210, 1,  coe, 4, 0x0000, 1);
            acc  = mac4(acc, buff, 2  , 0x3210, 1,  coe, 6, 0x0000, 1);
            if (HasCascadeOut)
                writeincr_v4(cascadeout,acc);
            writeincr_v4(data_out,srs(acc,shift));
        }

        delay_line = buff;
    }
};

template <unsigned Delay>
void fir_32t_coreN_init()
{
    // adjust delay by consuming samples from stream 
    for (int i = 0; i < Delay; ++i)
    {
        get_ss(0);
    }
};
