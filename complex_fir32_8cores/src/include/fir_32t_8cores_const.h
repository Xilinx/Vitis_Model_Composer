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
    AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
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

#ifndef __FIR_32T_8CORES_CONST_H__
#define __FIR_32T_8CORES_CONST_H__

#define FIR_32T_8CORES_IN_SAMPLES 	    256

#define FIR_32T_8CORES_COEFFICIENTS          32
#define FIR_32T_8CORES_SHIFT15               15

/*------------------------------------------------------------------------------------------------
 *
 *  Filter coefficients in matlab are used in the standard way  yn = sum ck * x(n-k)
 *  In the AIE they are used in the opposite way                yn = sum ck * x(n+k)
 *
 *  Matlab coefficients
 *  	coe = [
 *  		-6947-1i*299	-2978-1i*110
 *  		-1895-1i*58 	-1390-1i*34
 *  		-1098-1i*20 	-907-1i*11
 *  		-773-1i*5 		-673
 *  		716+1i*66 		831+1i*72
 *  		990+1i*79  		1224+1i*90
 *  		1601+1i*108 	2313+1i*142
 *  		4166+1i*230 	20835+1i*1024
 *  		20838+1i*960 	4169+1i*166
 *  		2316+1i*78 		1604+1i*44
 *  		1227+1i*26 		993+1i*15
 *  		834+1i*8 		719+1i*2
 *  		-670-1i*64 		-770-1i*69
 *  		-904-1i*75 		-1095-1i*84
 *  		-1387-1i*98 	-1892-1i*122
 *  		-2975-1i*174 	-6944-1i*362];
 *
 *
 *  		AI Engine coefficient for a parity of 2 (2 output streams: Even, Odd) and 2 chunks of coefficients)
 *  		Output of function: Matlab2AIE_Order(coe,2,2);
 *

 // Parity: 0     Chunck: 0
{{-6944,  -362},{-1892,  -122},{-1095,   -84},{ -770,   -69},{  719,     2},{  993,    15},{ 1604,    44},{ 4169,   166}}

// Parity: 0     Chunck: 1
{{20835,  1024},{ 2313,   142},{ 1224,    90},{  831,    72},{ -673,     0},{ -907,   -11},{-1390,   -34},{-2978,  -110}}

// Parity: 1     Chunck: 0
{{-2975,  -174},{-1387,   -98},{ -904,   -75},{ -670,   -64},{  834,     8},{ 1227,    26},{ 2316,    78},{20838,   960}}

// Parity: 1     Chunck: 1
{{ 4166,   230},{ 1601,   108},{  990,    79},{  716,    66},{ -773,    -5},{-1098,   -20},{-1895,   -58},{-6947,  -299}}

 *
 --------------------------------------------------------------------------------------------------*/


 alignas(32) static cint16_t  eq_coef0_0[8] =
   //{{-6944,  -362},{-1892,  -122},{-1095,   -84},{ -770,   -69},{  719,     2},{  993,    15},{ 1604,    44},{ 4169,   166}};
   {{ 0, 0},{ 2, 0},{ 4, 0},{ 6, 0},{ 8, 0},{10, 0},{12, 0},{14, 0}};


alignas(32) static cint16_t  eq_coef0_1[8] =
	//{{20835,  1024},{ 2313,   142},{ 1224,    90},{  831,    72},{ -673,     0},{ -907,   -11},{-1390,   -34},{-2978,  -110}};
	{{16, 0},{18, 0},{20, 0},{22, 0},{24, 0},{26, 0},{28, 0},{30, 0}};
  

alignas(32) static cint16_t  eq_coef1_0[8] =
	//{{-2975,  -174},{-1387,   -98},{ -904,   -75},{ -670,   -64},{  834,     8},{ 1227,    26},{ 2316,    78},{20838,   960}};
	{{ 1, 0},{ 3, 0},{ 5, 0},{ 7, 0},{ 9, 0},{11, 0},{13, 0},{15, 0}};

alignas(32) static cint16_t  eq_coef1_1[8] =
	//{{ 4166,   230},{ 1601,   108},{  990,    79},{  716,    66},{ -773,    -5},{-1098,   -20},{-1895,   -58},{-6947,  -299}};
	{{17, 0},{19, 0},{21, 0},{23, 0},{25, 0},{27, 0},{29, 0},{31, 0}};
	
#endif /* __FIR_32T_8CORES_CONST_H__ */
