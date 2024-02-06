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

#include <adf.h>
#ifdef USER_PARAMS
#include "user_params.h"
#endif
#include "trimatmul_32x32_32x32_const.h"

void trimatmul_32x32_32x32(input_window_cint16* restrict matA, input_window_cint16* restrict matB, output_window_cint16* restrict matC){
          
   v16cint16 chess_storage(xa) buf_matA0 = undef_v16cint16();           // holds 16 elements of matA
   v16cint16 chess_storage(xb) buf_matA1 = undef_v16cint16();           // holds 16 elements of matA
   v8cint16 chess_storage(wc0) buf_matB0, chess_storage(wc1) buf_matB1; // holds 8 elements of matB, only 4 are used
   int jumpc = 32 ;                                    // 32-4*i jump for matC writing in col major 
   int backc8 = 220 ;                                  // for row sweep
   int backc4 = 92 ;
   int jumpfull = 32 ;
   int backfull = 220 ;
   int cumul_jumpc = 0 ;
   int jumpincr =  232 ;                               // 7*jumpfull+8
 
   #define MATITER(buf_matA, buf_matB, decrr, decrc)                                \
      buf_matA = upd_v(buf_matA, 0, window_read_v4(matA)); window_incr(matA,jumpr); \
      buf_matA = upd_v(buf_matA, 1, window_read_v4(matA)); window_incr(matA,jumpr); \
      buf_matA = upd_v(buf_matA, 2, window_read_v4(matA)); window_incr(matA,jumpr); \
      buf_matA = upd_v(buf_matA, 3, window_read_v4(matA)); window_decr(matA,decrr); \
      buf_matB = window_read_v8(matB); window_incr(matB,jumpc);                     \
      acc0 =  mac4_cn(acc0,buf_matA,0,0xc840,1,buf_matB,0,0x0,1);                   \
      acc0 =  mac4_cn(acc0,buf_matA,2,0xc840,1,buf_matB,2,0x0,1);                   \
      buf_matB = window_read_v8(matB); window_incr(matB,jumpc);                     \
      acc1 =  mac4_cn(acc1,buf_matA,0,0xc840,1,buf_matB,0,0x0,1);                   \
      acc1 =  mac4_cn(acc1,buf_matA,2,0xc840,1,buf_matB,2,0x0,1);                   \
      buf_matB = window_read_v8(matB); window_incr(matB,jumpc);                     \
      acc2 =  mac4_cn(acc2,buf_matA,0,0xc840,1,buf_matB,0,0x0,1);                   \
      acc2 =  mac4_cn(acc2,buf_matA,2,0xc840,1,buf_matB,2,0x0,1);                   \
      buf_matB = window_read_v8(matB); window_incr(matB,jumpc);                     \
      acc3 =  mac4_cn(acc3,buf_matA,0,0xc840,1,buf_matB,0,0x0,1);                   \
      acc3 =  mac4_cn(acc3,buf_matA,2,0xc840,1,buf_matB,2,0x0,1);                   \
      buf_matB = window_read_v8(matB); window_incr(matB,jumpc);                     \
      acc4 =  mac4_cn(acc4,buf_matA,0,0xc840,1,buf_matB,0,0x0,1);                   \
      acc4 =  mac4_cn(acc4,buf_matA,2,0xc840,1,buf_matB,2,0x0,1);                   \
      buf_matB = window_read_v8(matB); window_incr(matB,jumpc);                     \
      acc5 =  mac4_cn(acc5,buf_matA,0,0xc840,1,buf_matB,0,0x0,1);                   \
      acc5 =  mac4_cn(acc5,buf_matA,2,0xc840,1,buf_matB,2,0x0,1);                   \
      buf_matB = window_read_v8(matB); window_incr(matB,jumpc);                     \
      acc6 =  mac4_cn(acc6,buf_matA,0,0xc840,1,buf_matB,0,0x0,1);                   \
      acc6 =  mac4_cn(acc6,buf_matA,2,0xc840,1,buf_matB,2,0x0,1);                   \
      buf_matB = window_read_v8(matB); window_decr(matB,decrc);                     \
      acc7 =  mac4_cn(acc7,buf_matA,0,0xc840,1,buf_matB,0,0x0,1);                   \
      acc7 =  mac4_cn(acc7,buf_matA,2,0xc840,1,buf_matB,2,0x0,1);                   \
      

   #define MATWRITE \
         window_write(matC,srs(acc0,TRIMATMUL_SHIFT)); window_incr(matC,jumpfull); \
         window_write(matC,srs(acc1,TRIMATMUL_SHIFT)); window_incr(matC,jumpfull); \
         window_write(matC,srs(acc2,TRIMATMUL_SHIFT)); window_incr(matC,jumpfull); \
         window_write(matC,srs(acc3,TRIMATMUL_SHIFT)); window_incr(matC,jumpfull); \
         window_write(matC,srs(acc4,TRIMATMUL_SHIFT)); window_incr(matC,jumpfull); \
         window_write(matC,srs(acc5,TRIMATMUL_SHIFT)); window_incr(matC,jumpfull); \
         window_write(matC,srs(acc6,TRIMATMUL_SHIFT)); window_incr(matC,jumpfull); \
         window_write(matC,srs(acc7,TRIMATMUL_SHIFT)); window_decr(matC,backfull); 
         

   #define LOOPINIT \
         v4cacc48  acc0 = null_v4cacc48();   \
         v4cacc48  acc1 = null_v4cacc48();   \
         v4cacc48  acc2 = null_v4cacc48();   \
         v4cacc48 acc3 = null_v4cacc48();    \
         v4cacc48 acc4 = null_v4cacc48();    \
         v4cacc48 acc5 = null_v4cacc48();    \
         v4cacc48 acc6 = null_v4cacc48();    \
         v4cacc48 acc7 = null_v4cacc48();    

  for(int i=0; i<2; i++){
     int jumpr = jumpc; 
     int backr = backc4;
     int jumpc7x = 7*jumpc;
     cumul_jumpc = cumul_jumpc + 8*jumpc ;
     //int jumpc3x = 3*jumpc ;
     for(int j=0; j<(3-i); j++)
         chess_prepare_for_pipelining
	 chess_loop_range(2,){
	 //First 4 cols	 
	 int jumpr3x = 3*jumpr ;
	 {LOOPINIT 
         for(int k=0; k<(4-i-j); k++)
         chess_prepare_for_pipelining
	 chess_loop_range(2,)
         {
            MATITER(buf_matA0, buf_matB0, backr, backc8)
            MATITER(buf_matA1, buf_matB1, backr, backc8)	   
         }
         MATWRITE}
         window_incr(matA,jumpr3x);   //move to next 4 rows 
         window_decr(matB,jumpr);     //back to the starting col
         
	 {LOOPINIT        
	 for(int k=0; k<(4-i-j); k++)
         chess_prepare_for_pipelining
	 chess_loop_range(2,){
            MATITER(buf_matA0, buf_matB0, backr, backc8)
            MATITER(buf_matA1, buf_matB1, backr, backc8)	   
         }
         MATWRITE}
	 jumpr = jumpr-8;
         backr = backr-24;
         window_incr(matA,jumpr3x);   //move to next 4 rows 
         window_decr(matB,jumpr);     //back to the starting col
      }
      //j=3
      {int jumpr3x = 24;  //jumpr = 8 now
       {LOOPINIT	      
       MATITER(buf_matA0, buf_matB0, backr, backc8)
       MATITER(buf_matA1, buf_matB1, backr, backc8)
       MATWRITE}
       window_incr(matA,jumpr3x);   //move to next 4 rows 
       window_decr(matB,jumpr);     //back to the starting col
       {LOOPINIT
       MATITER(buf_matA0, buf_matB0, backr, backc8)
       MATITER(buf_matA1, buf_matB1, backr, backc8)
       MATWRITE}
       window_incr(matA,jumpr3x);   //move to next 4 rows 
      }
      window_incr(matA,cumul_jumpc);       //starting 8 rows
      window_incr(matB,jumpc7x);           //move to next 8 cols
      window_incr(matC,jumpincr);          //move to next 8 cols + offset 8
      jumpc = jumpc-8;
      backc8 = backc8-56;
      backc4 = backc4-24; 
      jumpincr = jumpincr-8; // matC to start from GR(0,2)
   }

   //Reset matA pointer to start from GR(0,2) of 4x4 of granularity 8
   window_incr(matA,208) ; // from GR(2,2) to GR(0,2), 16*8 + 8*8 + 16 = 192 + 16 
   int jumpr = 32 ; 
   int backr = 92 ;
   int offset = 16 ;
   for(int j=0; j<3; j++)
      chess_prepare_for_pipelining
      chess_loop_range(3,){
      //First 4 cols	 
      int jumpr3x = 3*jumpr + offset ;
	 {LOOPINIT 
         for(int k=0; k<2; k++)
         chess_prepare_for_pipelining
	 chess_loop_range(2,)
         {
            MATITER(buf_matA0, buf_matB0, backr, backc8)
            MATITER(buf_matA1, buf_matB1, backr, backc8)	   
         }
         MATWRITE}
         window_incr(matA,jumpr3x);   //move to next 4 rows 
         window_decr(matB,jumpc);     //back to the starting col
         jumpr3x = jumpr3x - 8;       // For next 4 rows 

	 {LOOPINIT        
	 for(int k=0; k<2; k++)
         chess_prepare_for_pipelining
	 chess_loop_range(2,)
         {
            MATITER(buf_matA0, buf_matB0, backr, backc8)
            MATITER(buf_matA1, buf_matB1, backr, backc8)	   
         }
         MATWRITE}
	 jumpr = jumpr-8;
         backr = backr-24;
	 offset = offset-8;
         window_incr(matA,jumpr3x);       //move to next 4 rows 
         window_decr(matB,jumpc);         //back to the starting col
      }
    window_incr(matA,8); 
    window_incr(matB,jumpr); 
    {int jumpr3x = 24;     //jumpr = 8 now
       {LOOPINIT	      
       MATITER(buf_matA0, buf_matB0, backr, backc8)
       MATITER(buf_matA1, buf_matB1, backr, backc8)
       MATWRITE}
       window_incr(matA,jumpr3x);   //move to next 4 rows 
       window_decr(matB,jumpr);     //back to the starting col
       {LOOPINIT
       MATITER(buf_matA0, buf_matB0, backr, backc8)
       MATITER(buf_matA1, buf_matB1, backr, backc8)
       MATWRITE}
       window_incr(matA,jumpr3x);   //move to next 4 rows 
      }
    window_incr(matA,24);
    window_incr(matB,112);
    window_incr(matC,224); 
    
    jumpc  = 8 ;
    backc8 = 52 ;
    jumpr  = 32 ;
    backr  = 92 ;
    offset = 24 ;  
    
    for(int j=0; j<4; j++)
      chess_prepare_for_pipelining
      chess_loop_range(4,)
      {
      //First 4 cols	 
      int jumpr3x = 3*jumpr + offset ;
	 {LOOPINIT 
            MATITER(buf_matA0, buf_matB0, backr, backc8)
            MATITER(buf_matA1, buf_matB1, backr, backc8)	   
         MATWRITE}
         window_incr(matA,jumpr3x);   //move to next 4 rows 
         window_decr(matB,jumpc);     //back to the starting col
         jumpr3x = jumpr3x - 8;       // For next 4 rows 

	 {LOOPINIT        
            MATITER(buf_matA0, buf_matB0, backr, backc8)
            MATITER(buf_matA1, buf_matB1, backr, backc8)	   
         MATWRITE}
	 jumpr = jumpr-8;
         backr = backr-24;
	 offset = offset-8;
         window_incr(matA,jumpr3x);       //move to next 4 rows 
         window_decr(matB,jumpc);         //back to the starting col
      }
   //Last GR(0,1)
   jumpr = 32 ; 
   backr = 92 ;
   offset = 8 ;
   jumpc = 24 ;
   backc8 = 164 ;
   int jumpr3x = 3*jumpr + offset ;
   window_incr(matA,16);
   window_incr(matB,320);
   window_incr(matC,480); 
	 {LOOPINIT 
         for(int k=0; k<3; k++)
         chess_prepare_for_pipelining
	 chess_loop_range(2,)
         {
            MATITER(buf_matA0, buf_matB0, backr, backc8)
            MATITER(buf_matA1, buf_matB1, backr, backc8)	   
         }
         MATWRITE}
         window_incr(matA,jumpr3x);   //move to next 4 rows 
         window_decr(matB,jumpc);     //back to the starting col

	 {LOOPINIT        
	 for(int k=0; k<3; k++)
         chess_prepare_for_pipelining
	 chess_loop_range(2,)
         {
            MATITER(buf_matA0, buf_matB0, backr, backc8)
            MATITER(buf_matA1, buf_matB1, backr, backc8)	   
         }
         MATWRITE}
  //End
  }
    
         
  
