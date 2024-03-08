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
#include <utils.h>
#ifdef USER_PARAMS
#include "user_params.h"
#endif

#ifdef __clang__
#define INLINE inline __attribute__((always_inline))
#else
#define INLINE inline
#endif

#include "trimat_inv_32x32_const.h"

/* Initialize the variables
 */
#define INIT_OFFSETS				                                \
      L_offs = 0x7654321F;                                                      \
      L_offs_deselect = 0xF0;                                                   \
      inc_pL = 2 * 16 + 15; 

/* Initialize the required registers 
 */		
#define INIT                                                                    \      
      v16cint16 Lbuff = null_v16cint16();                                       \
      v16int32  Dbuff = undef_v16int32();                                       \
      Dbuff = upd_elem(Dbuff, 0, 32768);                                        \
      b_buff = null_v8cint16();                                                 \
      b_buff = upd_elem(b_buff,k,as_cint16(SCL_FAC));                                      
	
/* Initialize accumulators  
 */          
#define INIT_ACC_0_3			                                        \
      acc0 = ups(b_buff, TRIMAT_INV_SHIFT);                                     \
      acc1 = null_v8cacc48();                                                   \
      acc2 = null_v8cacc48();                                                   \
      acc3 = null_v8cacc48(); 
      
#define INIT_ACC_1_3			                                        \
      acc1 = ups(b_buff, TRIMAT_INV_SHIFT);                                     \
      acc2 = null_v8cacc48();                                                   \
      acc3 = null_v8cacc48();
      
#define INIT_ACC_2_3			                                        \
      acc2 = ups(b_buff, TRIMAT_INV_SHIFT);                                     \
      acc3 = null_v8cacc48(); 
      
#define INIT_ACC_3			                                        \
      acc3 = ups(b_buff, TRIMAT_INV_SHIFT); 

/* Write the output 
 */    
#define WRITE_OUTPUT(acc)                                                       \
      window_writeincr(w_out, srs(acc,TRIMAT_INV_SHIFT));    


/* 	Process the first set of 8 rows
	Diagonal values are read as 32bit real values (computed from Cholesky).
	Pointer is adjusted to get an alignment of '8'. 
	On processing, acc0 contains results of output[0:7] of respective row. 
	acc1, acc2 and acc3 contains intermediate results of respective row.
 */  
#define PROCESS_1_8                                                             \
      for (int i=0; i<8; i++)                                                   \
      chess_prepare_for_pipelining                                              \
      {                                                                         \
        Lbuff = upd_w(Lbuff, 0, window_readincr_v8(L_in));                      \
        /* Extract 'i'th element (i.e,inverse computed from Cholesky module) */ \
        scale = ext_elem(shuffle16( as_v16int32(Lbuff), 0, 0, i),8);        	\
        Dbuff = upd_elem(Dbuff, 1, scale);                                      \
        Xbuff = srs(acc0,TRIMAT_INV_SHIFT);                                     \
        acc0 = mul8(Dbuff, 0, (1<<(4*i)), Xbuff, 0, 0x76543210);                \
        Xbuff = srs(acc0,TRIMAT_INV_SHIFT);                                     \
        /* Estimate X_offs (0x0, 0x11111111,...0x77777777) for different 'i' */ \
        X_offs = fft_zoffs(i, 3, 1, 1);                                         \
        acc0 = msc8(acc0, Lbuff, 0, L_offs,     Xbuff, 0, X_offs);              \
        Lbuff = upd_w(Lbuff, 0, window_readincr_v8(L_in));                      \
        acc1 = msc8(acc1, Lbuff, 0, 0x76543210, Xbuff, 0, X_offs);              \
        Lbuff = upd_w(Lbuff, 0, window_readincr_v8(L_in));                      \
        acc2 = msc8(acc2, Lbuff, 0, 0x76543210, Xbuff, 0, X_offs);              \
        Lbuff = upd_w(Lbuff, 0, window_read_v8(L_in));                          \
        acc3 = msc8(acc3, Lbuff, 0, 0x76543210, Xbuff, 0, X_offs);              \
        /* Adjust L_offs based on iteration (0x765432F0,,....0xFFFFFFF0) */     \
        L_offs |= L_offs_deselect;                                              \
        /* Adjust L_offs_deselect to mask L_offs in next iteration */           \
        L_offs_deselect <<= 4;                                                  \
	/* Align the pointer to '8' (due to step nature of input)*/             \
        inc_pL -= 4;                                                            \
	window_incr(L_in, (inc_pL & ~0xF)>>2);					\
      } 
      	
/* 	Process the second set of 8 rows
	Diagonal values are read as 32bit real values (computed from Cholesky).
	Pointer is adjusted to get an alignment of '8'. 
	On processing, acc1 contains results of output[8:15] of respective row. 
	acc2 and acc3 contains intermediate results of respective row.
 */
#define PROCESS_9_16                                                            \
      for (int i=0; i<8; i++)                                                   \
      chess_prepare_for_pipelining                                              \
      {                                                                         \
        Lbuff = upd_w(Lbuff, 0, window_readincr_v8(L_in));                      \
        /* Extract 'i'th element (i.e,inverse computed from Cholesky module) */ \
        scale = ext_elem( shuffle16( as_v16int32(Lbuff), 0, 0, i),8);      	\
        Dbuff = upd_elem(Dbuff, 1, scale);                                      \
        Xbuff = srs(acc1,TRIMAT_INV_SHIFT);                                     \
        acc1 = mul8(Dbuff, 0, (1<<(4*i)), Xbuff, 0, 0x76543210);                \
        Xbuff = srs(acc1,TRIMAT_INV_SHIFT);                                     \
        /* Estimate X_offs (0x0, 0x11111111,...0x77777777) for different 'i' */ \
        X_offs = fft_zoffs(i, 3, 1, 1);                                         \
        acc1 = msc8(acc1, Lbuff, 0, L_offs, 	Xbuff, 0, X_offs);              \
        Lbuff = upd_w(Lbuff, 0, window_readincr_v8(L_in));                      \
        acc2 = msc8(acc2, Lbuff, 0, 0x76543210, Xbuff, 0, X_offs);              \
        Lbuff = upd_w(Lbuff, 0, window_read_v8(L_in));                          \
        acc3 = msc8(acc3, Lbuff, 0, 0x76543210, Xbuff, 0, X_offs);              \
        /* Adjust L_offs based on iteration (0x765432F0,,....0xFFFFFFF0) */     \
        L_offs |= L_offs_deselect;                                              \
        /* Adjust L_offs_deselect to mask L_offs in next iteration */           \
        L_offs_deselect <<= 4;                                                  \
	/* Align the pointer to '8' (due to step nature of input)*/             \
        inc_pL -= 4;                                                            \
	window_incr(L_in, (inc_pL & ~0xF)>>2);					\
      } 
	
/* 	Process the third set of 8 rows
	Diagonal values are read as 32bit real values (computed from Cholesky).
	Pointer is adjusted to get an alignment of '8'. 
	On processing, acc2 contains results of output[16:23] of respective row. 
	acc3 contains intermediate results of respective row.
 */ 	
#define PROCESS_17_24                                                           \
      for (int i=0; i<8; i++)                                                   \
      chess_prepare_for_pipelining                                              \
      {                                                                         \
        Lbuff = upd_w(Lbuff, 0, window_readincr_v8(L_in));                      \
        /* Extract 'i'th element (i.e,inverse computed from Cholesky module) */ \
        scale = ext_elem( shuffle16( as_v16int32(Lbuff), 0, 0, i),8);      	\
        Dbuff = upd_elem(Dbuff, 1, scale);                                      \
        Xbuff = srs(acc2,TRIMAT_INV_SHIFT);                                     \
        acc2 = mul8(Dbuff, 0, (1<<(4*i)), Xbuff, 0, 0x76543210);                \
        Xbuff = srs(acc2,TRIMAT_INV_SHIFT);                                     \
        /* Estimate X_offs (0x0, 0x11111111,...0x77777777) for different 'i' */ \
        X_offs = fft_zoffs(i, 3, 1, 1);                                         \
        acc2 = msc8(acc2, Lbuff, 0, L_offs, Xbuff, 0, X_offs);                  \
        Lbuff = upd_w(Lbuff, 0, window_read_v8(L_in));                          \
        acc3 = msc8(acc3, Lbuff, 0, 0x76543210, Xbuff, 0, X_offs);              \
        /* Adjust L_offs based on iteration (0x765432F0,,....0xFFFFFFF0) */     \
        L_offs |= L_offs_deselect;                                              \
        /* Adjust L_offs_deselect to mask L_offs in next iteration */           \
        L_offs_deselect <<= 4;                                                  \
	/* Align the pointer to '8' (due to step nature of input)*/             \
        inc_pL -= 4;                                                            \
        window_incr(L_in, (inc_pL & ~0xF)>>2);					\
      } 
     
/* 	Process the fourth set of 7 rows
	Diagonal values are read as 32bit real values (computed from Cholesky).
	Pointer is adjusted to get an alignment of '8'. 
	On processing, acc3 contains results of output[24:30] of respective row.
 */       
#define PROCESS_25_31                                                           \
      for (int i=0; i<7; i++)                                                   \
      chess_prepare_for_pipelining                                              \
      {                                                                         \
        Lbuff = upd_w(Lbuff, 0, window_read_v8(L_in));                          \
        /* Extract 'i'th element (i.e,inverse computed from Cholesky module) */ \
        scale = ext_elem( shuffle16( as_v16int32(Lbuff), 0, 0, i),8);       	\
        Dbuff = upd_elem(Dbuff, 1, scale);                                      \
        Xbuff = srs(acc3,TRIMAT_INV_SHIFT);                                     \
        acc3 = mul8(Dbuff, 0, (1<<(4*i)), Xbuff, 0, 0x76543210);                \
        Xbuff = srs(acc3,TRIMAT_INV_SHIFT);                                     \
        /* Estimate X_offs (0x0, 0x11111111,...0x77777777) for different 'i' */ \
        X_offs = fft_zoffs(i, 3, 1, 1);                                         \
        /* Perform multiplication and subtraction of result from acc3 */        \
        acc3 = msc8(acc3, Lbuff, 0, L_offs, Xbuff, 0, X_offs);                  \
        /* Adjust L_offs based on iteration (0x765432F0,,....0xFFFFFFF0) */     \
        L_offs |= L_offs_deselect;                                              \
        /* Adjust L_offs_deselect to mask L_offs in next iteration */           \
        L_offs_deselect <<= 4;                                                  \
	/* Align the pointer to '8' (due to step nature of input)*/             \
        inc_pL -= 4;                                                            \
	window_incr(L_in, (inc_pL & ~0xF)>>2);					\
      }       		 		
	
/* Process the last sample (32nd row) 
 */    
#define PROCESS_LAST(i)				                                \
      scale = ext_elem( as_v8int32(window_read_v8(L_in)),7);                	\
      Dbuff = upd_elem(Dbuff, 1, scale);                                        \
      Xbuff = srs(acc3,TRIMAT_INV_SHIFT);                                       \
      acc3 = mul8(Dbuff, 0, (1<<(4*7)), Xbuff, 0, 0x76543210);                  \
      window_decr(L_in, i);  


// Compute Columns 1-8 of triangular matrix inverse, as per forward substitution 	
INLINE void fwd_solver_32_1 (    
    input_window_cint16 * L_in, 
    output_window_cint16 * w_out
    )                                   
{
    // registers
    v8cacc48 acc0;
    v8cacc48 acc1;
    v8cacc48 acc2;
    v8cacc48 acc3;
    v8cint16 Xbuff, b_buff; 

    // scalars
    int L_offs, L_offs_deselect, inc_pL, X_offs, scale;   
      
    // Process 8 columns
    for (int k=0; k<8; k++) 
    {  
      INIT                   // Declare and define registers required 
      INIT_OFFSETS     
      INIT_ACC_0_3	
      PROCESS_1_8            // Process 1:8 rows    
      INIT_OFFSETS            
      window_incr_v8(L_in, 1);               
      PROCESS_9_16           // Process 9:16 rows  
      INIT_OFFSETS            
      window_incr_v8(L_in, 1);               
      PROCESS_17_24          // Process 17:24 rows  
      INIT_OFFSETS                                                                  
      window_incr_v8(L_in, 1);              
      PROCESS_25_31          // Process 25:31 rows  
      PROCESS_LAST(568)        
	        
      WRITE_OUTPUT(acc0)     // Write processed rows 
      WRITE_OUTPUT(acc1)       
      WRITE_OUTPUT(acc2)       
      WRITE_OUTPUT(acc3)       
    }
}

// Compute Columns 9-16 of triangular matrix inverse, as per forward substitution 
INLINE void fwd_solver_32_2 (    
    input_window_cint16 * L_in, 
    output_window_cint16 * w_out
    )                                   
{
    // registers
    v8cacc48  acc1;
    v8cacc48  acc2;
    v8cacc48  acc3;
    v8cint16 Xbuff, b_buff; 

    // scalars
    int L_offs, L_offs_deselect, inc_pL, X_offs, scale;  
      
    // Process 8 columns
    for (int k=0; k<8; k++) 
    {       
      INIT                    // Declare and define registers required 
      INIT_OFFSETS            
      INIT_ACC_1_3             
    
      PROCESS_9_16            // Process 9:16 rows  
      INIT_OFFSETS                                                          
      window_incr_v8(L_in, 1);                
      PROCESS_17_24           // Process 17:24 rows 
      INIT_OFFSETS                                                               
      window_incr_v8(L_in, 1);   
      PROCESS_25_31           // Process 25:31 rows 
      PROCESS_LAST(328)
	          
      WRITE_OUTPUT(acc1)      // Write processed rows 
      WRITE_OUTPUT(acc2)
      WRITE_OUTPUT(acc3)
    }
}

// Compute Columns 17-24 of triangular matrix inverse, as per forward substitution 
INLINE void fwd_solver_32_3 (    
    input_window_cint16 * L_in, 
    output_window_cint16 * w_out
    )                                   
{
    v8cacc48 acc2;
    v8cacc48 acc3;
    v8cint16 Xbuff, b_buff; 

    // scalars
    int L_offs, L_offs_deselect, inc_pL, X_offs, scale;  
          
    // Process 8 columns
    for (int k=0; k<8; k++) 
    { 
      INIT                    // Declare and define registers required 
      INIT_OFFSETS            
      INIT_ACC_2_3                    
    
      PROCESS_17_24           // Process 17:24 rows 
      INIT_OFFSETS                                                             
      window_incr_v8(L_in, 1);   
      PROCESS_25_31  	      // Process 25:31 rows 
      PROCESS_LAST(152)      	
     
      WRITE_OUTPUT(acc2)      // Write processed rows 
      WRITE_OUTPUT(acc3)
  }
}

// Compute Columns 25-32 of triangular matrix inverse, as per forward substitution          
INLINE void fwd_solver_32_4 (    
    input_window_cint16 * L_in, 
    output_window_cint16 * w_out
    )                                   
{    
    // registers
    v8cacc48   acc3;
    v8cint16 Xbuff, b_buff; 

    // scalars
    int L_offs, L_offs_deselect, inc_pL, X_offs, scale;  
      
    // Process 8 columns
    for (int k=0; k<8; k++) 
    { 
      INIT                    // Declare and define registers required 
      INIT_OFFSETS             
      INIT_ACC_3                 
      
      PROCESS_25_31           // Process 25:31 rows 
      PROCESS_LAST(40)
      	    	    
      WRITE_OUTPUT(acc3)      // Write processed rows 
    }
}	

/* Initialization function
 */	
void trimat_inv_32x32_init()
{
    set_rnd(rnd_conv_even); // rounding mode for computations 
    set_sat();
};

/* Inverse computation of triangular matrix (32x32) using forward substitution 
 * Input is triangular matrix form with step size '8'
 * Computed in 4 stages
 * Stage-1, processes columns 1-8
 * Stage-2, processes columns 9-16
 * Stage-3, processes columns 17-24
 * Stage-4, processes columns 25-32 
 */	
void trimat_inv_32x32 (input_window_cint16 * L_in, output_window_cint16 * x_out)
{
    // Stage - 1
    fwd_solver_32_1(L_in, x_out);  
    window_incr_v8(L_in, 30); // Increment window pointer by '30' of v8cint16 values, to process next stage.
    
    // Stage - 2
    fwd_solver_32_2(L_in, x_out);  
    window_incr_v8(L_in, 22); // Increment window pointer by '22' of v8cint16 values, to process next stage.
    
    // Stage - 3
    fwd_solver_32_3(L_in, x_out);      
    window_incr_v8(L_in, 14); // Increment window pointer by '14' of v8cint16 values, to process next stage.
    
    // Stage - 4
    fwd_solver_32_4(L_in, x_out);  	
}
