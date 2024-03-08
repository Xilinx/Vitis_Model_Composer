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

#include "adf.h"
#include "matmul_right_herm_const.h"

// output --> A*B'
//generalized matrix multiplication [M_MATxN_MAT] x [N_MATxL_MAT]
// Idea
// load A[8x4] and B[4x4] whole operation taking 4 cycles 
// permute and multiply producing 8 outputs (4 cycles)
// for next iteration sweep A row wise and B column wise, lc for innermost loop = N/4
// middle loop lc = N_MAT/4 or M_MAT/8
// outer loop lc = M_MAT/8 or N_MAT/4
//


void matmul_right_herm(input_window_cint16* restrict matA, input_window_cint16* restrict matB, output_window_cint16* restrict matC){
   v8cint16  buf_matA0 = undef_v8cint16();           // holds 16 elements of matA
   v8cint16  buf_matA1 = undef_v8cint16();           // holds 16 elements of matA
   v16cint16  buf_matB0 = undef_v16cint16();
   v16cint16  buf_matB1 = undef_v16cint16();         // holds 8 elements of matB, only 4 are used
   const unsigned shift = MAT_MUL_SHIFT;	

    #define MATITER(buf_matA, buf_matB)                                                   \
      buf_matA = upd_v(undef_v8cint16(),  0, window_read_v4(matA)); window_incr(matA,M_MAT);  \
      buf_matA = upd_v(buf_matA, 	  1, window_read_v4(matA)); window_incr(matA,M_MAT);  \
      buf_matB = upd_v(undef_v16cint16(), 0, window_read_v4(matB)); window_incr(matB,N1_MAT); \
      buf_matB = upd_v(buf_matB,	  1, window_read_v4(matB)); window_incr(matB,N1_MAT); \
      acc0 =  mac4_cn(acc0,buf_matB,0,0x0,4,buf_matA,0,0x3210,4);                         \
      acc1 =  mac4_cn(acc1,buf_matB,1,0x0,4,buf_matA,0,0x3210,4);                         \
      acc2 =  mac4_cn(acc2,buf_matB,2,0x0,4,buf_matA,0,0x3210,4);                         \
      acc3 =  mac4_cn(acc3,buf_matB,3,0x0,4,buf_matA,0,0x3210,4);                         \
      buf_matB = upd_v(undef_v16cint16(), 2, window_read_v4(matB)); window_incr(matB,N1_MAT); \
      buf_matB = upd_v(buf_matB, 	  3, window_read_v4(matB)); window_incr(matB,N1_MAT); \
      buf_matA = upd_v(undef_v8cint16(),  0, window_read_v4(matA)); window_incr(matA,M_MAT);  \
      buf_matA = upd_v(buf_matA, 	  1, window_read_v4(matA)); window_incr(matA,M_MAT);  \
      acc0 =  mac4_cn(acc0,buf_matB,8,0x0,4,buf_matA,0,0x3210,4);                         \
      acc1 =  mac4_cn(acc1,buf_matB,9,0x0,4,buf_matA,0,0x3210,4);                         \
      acc2 =  mac4_cn(acc2,buf_matB,10,0x0,4,buf_matA,0,0x3210,4);                        \
      acc3 =  mac4_cn(acc3,buf_matB,11,0x0,4,buf_matA,0,0x3210,4); 

	v4cacc48 acc0 = null_v4cacc48();    
        v4cacc48 acc1 = null_v4cacc48();   
        v4cacc48 acc2 = null_v4cacc48();    
        v4cacc48 acc3 = null_v4cacc48();     

    #define ITER 				\
	 acc0 = null_v4cacc48();		\
         acc1 = null_v4cacc48();		\
         acc2 = null_v4cacc48();		\
         acc3 = null_v4cacc48();		\
         for(int k=0; k<N0_MAT/4; k++){           	\
            MATITER(buf_matA0, buf_matB0) ;   	\
         } 					\
         window_write(matC,srs(acc0,shift)); window_incr(matC,M_MAT); \
         window_write(matC,srs(acc1,shift)); window_incr(matC,M_MAT); \
         window_write(matC,srs(acc2,shift)); window_incr(matC,M_MAT); \
         window_write(matC,srs(acc3,shift)); window_incr(matC,M_MAT); \
	 window_incr(matB,4);
 

   for(int i=0; i<M_MAT/4; i++){	     
      for(int j=0; j<(N1_MAT/4/4); j++)    // 14 cycle per loop so 128*14 ~ 2k
         chess_prepare_for_pipelining
	 chess_loop_range(8,){
	    ITER;
	    ITER;
	    ITER;
	    ITER;
      	 }
      window_decr(matB,N1_MAT);    //back to the starting col
      window_incr(matA,4);     //move to next 4 rows
      window_incr(matC,4);     //move to next 4 rows
   }

 }

