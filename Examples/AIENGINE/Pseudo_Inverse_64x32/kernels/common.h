/*  (c) Copyright 2014 - 2023 AMD, Inc. All rights reserved.
   
    This file contains confidential and proprietary information
    of AMD, Inc. and is protected under U.S. and
    international copyright and other intellectual property
    laws.
   
    DISCLAIMER
    This disclaimer is not a license and does not grant any
    rights to the materials distributed herewith. Except as
    otherwise provided in a valid license issued to you by
    AMD, and to the maximum extent permitted by applicable
    law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
    WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
    AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
    BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
    INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
    (2) AMD shall not be liable (whether in contract or tort,
    including negligence, or under any other theory of
    liability) for any loss or damage of any kind or nature
    related to, arising under or in connection with these
    materials, including for any direct, or any indirect,
    special, incidental, or consequential loss or damage
    (including loss of data, profits, goodwill, or any type of
    loss or damage suffered as a result of any action brought
    by a third party) even if such damage or loss was
    reasonably foreseeable or AMD had been advised of the
    possibility of the same.
   
    CRITICAL APPLICATIONS
    AMD products are not designed or intended to be fail-
    safe, or for use in any application requiring fail-safe
    performance, such as life-support or safety devices or
    systems, Class III medical devices, nuclear facilities,
    applications related to the deployment of airbags, or any
    other applications that could lead to death, personal
    injury, or severe property or environmental damage
    (individually and collectively, "Critical
    Applications"). Customer assumes the sole risk and
    liability of any use of AMD products in Critical
    Applications, subject only to applicable laws and
    regulations governing limitations on product liability.
   
    THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
    PART OF THIS FILE AT ALL TIMES.                       */


#ifndef __COMMON_H__
#define __COMMON_H__


		
void window_copy_1in_2out(
	adf::input_circular_buffer<cint16> & restrict cb_input, 
     adf::output_circular_buffer<cint16> & restrict cb_output0,
     adf::output_circular_buffer<cint16> & restrict cb_output1
);

	
void demultiplexor(
	adf::input_circular_buffer<cint16> & in0,
	adf::input_circular_buffer<cint16> & in1, 
	adf::input_circular_buffer<cint16> & in2, 
	int32 from_ps, 
	adf::output_circular_buffer<cint16> &  leg0, 
	int32& leg0_size, 
	adf::output_circular_buffer<cint16> &leg1, 
	int32& leg1_size, 
	adf::output_circular_buffer<cint16> &leg2, 
	int32& leg2_size, 
	int32& to_bypass
);



void win_merge_2in_2out(
	adf::input_circular_buffer<cint16> & restrict in0, 
	adf::input_circular_buffer<cint16> & restrict in1, 
	adf::output_circular_buffer<cint16> & restrict out0, 
	adf::output_circular_buffer<cint16> & restrict out1
);

void win_merge_2in_1out(adf::input_circular_buffer<cint16> &  restrict input0, adf::input_circular_buffer<cint16> & restrict in1, adf::output_circular_buffer<cint16> &  restrict out);

void split_merge_2in_1out(adf::input_circular_buffer<cint16> & restrict inp0, adf::input_circular_buffer<cint16> &restrict inp1, adf::output_circular_buffer<cint16> & restrict outp0);


void dyn_rtp_handler(
        const int32_t  (&header)[2],       
        int& rtp_out_lte20,
        int& rtp_out_ltesw,
        int& rtp_out_lte10,
        int& flag);

void aie_stream_copy_data(
    input_stream_cint16 * datain, 
    output_stream_cint16 * dataout
   );

#endif //__COMMON_H__
