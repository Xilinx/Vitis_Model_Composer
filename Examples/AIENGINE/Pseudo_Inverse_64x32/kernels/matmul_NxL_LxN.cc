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


#include<adf.h>
#include "matmul_NxL_LxN_const.h"

#ifdef USER_PARAMS
#include "user_params.h"
#endif

void matmul_NxL_LxN_init()
{
    set_rnd(rnd_sym_zero); // rounding mode for computations 
    set_sat();
};


void matmul_NxL_LxN(input_window_cint16* restrict matA, input_window_cint16* restrict matB, output_window_cint16* restrict matC){
          
   v16cint16 buf_matA0 = undef_v16cint16();           // holds 32 elements of matA
   v16cint16 buf_matA1 = undef_v16cint16();           // holds 32 elements of matA
   v8cint16 buf_matB0, buf_matB1;            	      // holds 8 elements of matA
   int jump = 32 ;
   int back = 92 ;
   
   v4cacc48 acc0, acc1, acc2, acc3;

   #define MATITER(buf_matA, buf_matB)                                                    \
      buf_matA = upd_v(buf_matA, 0, window_read_v4(matA)); window_incr(matA,64);          \
      buf_matA = upd_v(buf_matA, 1, window_read_v4(matA)); window_incr(matA,64);          \
      buf_matA = upd_v(buf_matA, 2, window_read_v4(matA)); window_incr(matA,64);          \
      buf_matA = upd_v(buf_matA, 3, window_read_v4(matA)); window_decr(matA,188);         \
      buf_matB = window_read_v8(matB); window_incr(matB,64);                              \
      acc0 =  mac4_cn(acc0,buf_matA,0,0xc840,1,buf_matB,0,0x0,1);                         \
      acc0 =  mac4_cn(acc0,buf_matA,2,0xc840,1,buf_matB,2,0x0,1);                         \
      buf_matB = window_read_v8(matB); window_incr(matB,64);                              \
      acc1 =  mac4_cn(acc1,buf_matA,0,0xc840,1,buf_matB,0,0x0,1);                         \
      acc1 =  mac4_cn(acc1,buf_matA,2,0xc840,1,buf_matB,2,0x0,1);                         \
      buf_matB = window_read_v8(matB); window_incr(matB,64);                              \
      acc2 =  mac4_cn(acc2,buf_matA,0,0xc840,1,buf_matB,0,0x0,1);                         \
      acc2 =  mac4_cn(acc2,buf_matA,2,0xc840,1,buf_matB,2,0x0,1);                         \
      buf_matB = window_read_v8(matB); window_decr(matB,188);                             \
      acc3 =  mac4_cn(acc3,buf_matA,0,0xc840,1,buf_matB,0,0x0,1);                         \
      acc3 =  mac4_cn(acc3,buf_matA,2,0xc840,1,buf_matB,2,0x0,1);
	  
      #define ITERBODY  								\
      acc0 = null_v4cacc48(); 								\
      acc1 = null_v4cacc48(); 								\
      acc2 = null_v4cacc48(); 								\
      acc3 = null_v4cacc48(); 								\
      for(int k=0; k<8; k++)								\
	 chess_prepare_for_pipelining                                           	\
	 chess_loop_range(2,){								\
            MATITER(buf_matA0, buf_matB0) ;	   					\
            MATITER(buf_matA1, buf_matB1) ;						\
      } 										\
      window_write(matC,srs(acc0,MAT_SHIFT)); window_incr(matC,jump);			\
      window_write(matC,srs(acc1,MAT_SHIFT)); window_incr(matC,jump);			\
      window_write(matC,srs(acc2,MAT_SHIFT)); window_incr(matC,jump);			\
      window_write(matC,srs(acc3,MAT_SHIFT)); window_decr(matC,back);			\
      window_incr(matA,192);   								\
      window_decr(matB,64);    																		
	  
      // First iteration un-roll the loop  
	  
      ITERBODY;
      ITERBODY;
      ITERBODY;
      ITERBODY;
      ITERBODY;
      ITERBODY;
      ITERBODY;
      ITERBODY;
		
      window_incr(matB,256);      //move to next 4 cols
      window_incr(matA,256);      //move to starting 4 rows	
      window_incr(matC,3*jump);   //move to next 4 cols
      jump = jump-4; 
      back = back-12;
	  
      // Iterations 2-8 are processed in loop
      for(int i=1; i<8; i++){
     	for(int j=0; j<(8-i); j++)
       	chess_prepare_for_pipelining
       	chess_loop_range(1,){
       	   v4cacc48 acc0 = null_v4cacc48(); 
       	   v4cacc48 acc1 = null_v4cacc48(); 
       	   v4cacc48 acc2 = null_v4cacc48(); 
       	   v4cacc48 acc3 = null_v4cacc48();
       	   for(int k=0; k<8; k++){
       		MATITER(buf_matA0, buf_matB0) ;	   
     		MATITER(buf_matA1, buf_matB1) ;	   
           } 
           window_write(matC,srs(acc0,MAT_SHIFT)); window_incr(matC,jump); //move to next col
           window_write(matC,srs(acc1,MAT_SHIFT)); window_incr(matC,jump); //move to next col
           window_write(matC,srs(acc2,MAT_SHIFT)); window_incr(matC,jump); //move to next col
           window_write(matC,srs(acc3,MAT_SHIFT)); window_decr(matC,back); //back to the starting col
           window_incr(matA,192);   //move to next 4 rows 
           window_decr(matB,64);    //back to the starting col
      	}
      	window_incr(matB,256);      //move to next 4 cols
	window_incr(matA,256*(i+1));   //starting 4 rows
      	window_incr(matC,3*jump);   //move to next 4 cols
      	jump = jump-4;
      	back = back-12;
   }
}
