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
#include "utils.h"

#include "cholesky_32x32.h"
#include "cholesky_32x32_inc.h"

void chol_init()
{
	set_sat();
        set_rnd(rnd_sym_zero);
}


void cholesky_32x32(         // left looking complex cholesky factorization
    input_window_cint16 * restrict A_inx,   // input matrix assumed to be 16x16 column major
    output_window_cint16 * restrict L_outx   // output matrix assumed to be 16x16 column major packed lower triangular
    )   
{

    v8cint16      * restrict A_in = (v8cint16 * restrict)  GET_WINDOW_PTR(A_inx) ;	
    v8cint16      * restrict L_out = (v8cint16 * restrict) GET_WINDOW_PTR(L_outx) ;

    int * restrict diag_arr = (int * restrict) cholesky_32x32_diag;

    //    io mem pointers, the 8 refers to the vectorsize because increment is done by v4cint16 in some cases
    v8cint16 chess_storage(DM_bankA) * restrict pA8;
    v8cint16 chess_storage(DM_bankA) * restrict pL8 = (v8cint16 chess_storage(DM_bankA) *) L_out;
    int * pL8t = (int * restrict ) pL8; // for writing to output

    //    registers
    v8cacc48   acc0;
    v8cacc48   acc1;
    v8cacc48   acc2;
    v8cacc48   acc3;

    //    buffers
    v32cint16 chess_storage(ya) Lbuff;
    v8cint16  chess_storage(wc1) Lbuff2;
    v8cint16  chess_storage(wd1) Lbuff3;
    v8int32   rscale;                       // column scale factor (note int32)
    v8cint16  cscale;                       // pointer to complex scale for last stage
    v8cint16 tmp;


    //  scalars
    int     shift = SHIFT; 
    int     shift_s = SHIFT_S;	      // shift for the scale operation w/ int32 in invsqrt
    int     shift_in = 0;
    int     shift_out = SHIFT_OUT;    
    int     diag_val;
    unsigned long long inc_p;

    
    int diag0, diag1, diag2, diag3;

    //---- Row 0 invsqrt ----

    tmp = A_in[0];

    diag_val = ext_elem(as_v16int16(tmp),0) << shift;
    rscale = upd_elem(undef_v8int32(),0, invsqrt(diag_val, shift_in, shift_out));
    //extract from rscale
    diag0 = ext_elem(rscale, 0);

    Lbuff = upd_w(undef_v32cint16(), 0, tmp);
    acc0 = mul8(Lbuff,  0, Lidx, rscale, 0, 0);
    Lbuff = upd_w(undef_v32cint16(), 3, A_in[1]);
    acc1 = mul8(Lbuff, 24, Lidx, rscale, 0, 0);
    Lbuff = upd_w(undef_v32cint16(), 2, A_in[2]);
    acc2 = mul8(Lbuff, 16, Lidx, rscale, 0, 0);
    Lbuff = upd_w(undef_v32cint16(), 1, A_in[3]);
    acc3 = mul8(Lbuff,  8, Lidx, rscale, 0, 0);


    //---- Row 1 complex scale ----

    Lbuff = upd_w(undef_v32cint16(), 0, srs(acc0,shift_s));
    acc0 = ups(A_in[4],shift);
    acc0 = msc8_nc(acc0, Lbuff,  0, Lidx, 0, 0x11111111 );
    
    Lbuff = upd_w(Lbuff, 3, srs(acc1,shift_s));
    Lbuff = upd_w(Lbuff, 2, srs(acc2,shift_s));
    acc1 = ups(A_in[5],shift);
    acc1 = msc8_nc(acc1, Lbuff, 24, Lidx, 0, 0x11111111 );
    Lbuff2 = ext_w(Lbuff, 2); 
    acc2 = ups(A_in[6],shift);
    acc2 = msc8_nc(acc2, Lbuff, 16, Lidx, 0, 0x11111111 );
    L_out[2] = ext_w(Lbuff, 2);
    Lbuff = upd_w(Lbuff, 1, srs(acc3,shift_s));
    acc3 = ups(A_in[7],shift);
    acc3 = msc8_nc(acc3, Lbuff,  8, Lidx, 0, 0x11111111 );
        
    diag_val = ext_elem(lsrs(ext_lo(as_v16acc48(acc0)),0),2);
    rscale = upd_elem(undef_v8int32(),0,invsqrt(diag_val, shift_in, shift_out));
    //rscale 0 has invsqrt 
    diag1 = ext_elem(rscale, 0);

    //---- Row 0 store + Row 1 invsqrt ----

    L_out[3] = ext_w(Lbuff, 1);  
    Lbuff = upd_w(Lbuff, 2, srs(acc0,shift));
    Lbuff3 = ext_w(Lbuff, 1);
    Lbuff = upd_w(Lbuff, 1, srs(acc1,shift));
    acc0 = mul8(Lbuff, 16, Lidx, rscale, 0, 0);
    // push rscale col0 as 0th element in Lbuff.
    v8cint16 Lbuff_t = ext_w(Lbuff, 0);
    Lbuff_t = upd_elem(Lbuff_t, 0, as_cint16(diag0));
    L_out[0] = Lbuff_t;


    acc1 = mul8(Lbuff,  8, Lidx, rscale, 0, 0);
    L_out[1] = ext_w(Lbuff, 3);
    Lbuff = upd_w(Lbuff, 2, srs(acc2,shift));
    Lbuff = upd_w(Lbuff, 1, srs(acc3,shift));
    acc2 = mul8(Lbuff, 16, Lidx, rscale, 0, 0);
    acc3 = mul8(Lbuff,  8, Lidx, rscale, 0, 0);

    //---- Row 1 store + Row 2 complex scale ----

    Lbuff = upd_w(Lbuff, 1, srs(acc0,shift_s));    

    acc0 = ups(A_in[8],shift);
    acc0 = msc8_nc(acc0, Lbuff,  0, Lidx,  0, 0x22222222 );
    acc0 = msc8_nc(acc0, Lbuff,  8, Lidx,  8, 0x22222222 );
    Lbuff_t = ext_w(Lbuff, 1);
    Lbuff_t = upd_elem(Lbuff_t, 1, as_cint16(diag1));
    L_out[4] = Lbuff_t; 

    Lbuff = upd_w(Lbuff, 2, srs(acc1,shift_s));
    L_out[5] = ext_w(Lbuff, 2);

    acc1 = ups(A_in[9],shift);
    acc1 = msc8_nc(acc1, Lbuff, 24, Lidx,  0, 0x22222222 );
    acc1 = msc8_nc(acc1, Lbuff, 16, Lidx,  8, 0x22222222 );
    
    Lbuff = upd_w(Lbuff, 3, Lbuff2);
    Lbuff = upd_w(Lbuff, 2, srs(acc2,shift_s));
    L_out[6] = ext_w(Lbuff, 2);
    acc2 = ups(A_in[10],shift);
    acc2 = msc8_nc(acc2, Lbuff,  24, Lidx,  0, 0x22222222 );
    acc2 = msc8_nc(acc2, Lbuff,  16, Lidx,  8, 0x22222222 );
        
    diag_val = ext_elem(lsrs(ext_lo(as_v16acc48(acc0)),0),4);
    
    Lbuff = upd_w(Lbuff, 3, Lbuff3);
    Lbuff = upd_w(Lbuff, 2, srs(acc3,shift_s));
    L_out[7] = ext_w(Lbuff,2);    
    acc3 = ups(A_in[11],shift);
    acc3 = msc8_nc(acc3, Lbuff, 24, Lidx,  0, 0x22222222 );
    acc3 = msc8_nc(acc3, Lbuff, 16, Lidx,  8, 0x22222222 );
        
    //---- Row 2 invsqrt ----

    rscale = upd_elem(undef_v8int32(),0,invsqrt(diag_val, shift_in, shift_out));

    // extract diag elem 2
    diag2 = ext_elem(rscale, 0);
	
    Lbuff = upd_w(Lbuff, 3, srs(acc0,shift));
    Lbuff = upd_w(Lbuff, 2, srs(acc1,shift));
    acc0 = mul8(Lbuff, 24, Lidx, rscale, 0, 0);
    acc1 = mul8(Lbuff, 16, Lidx, rscale, 0, 0);
    Lbuff = upd_w(Lbuff, 3, srs(acc2,shift));
    Lbuff = upd_w(Lbuff, 2, srs(acc3,shift));
    acc2 = mul8(Lbuff, 24, Lidx, rscale, 0, 0);
    acc3 = mul8(Lbuff, 16, Lidx, rscale, 0, 0);
    
    
    //---- Row 2 store + Row 3 complex scale ----
        
    cscale = as_v8cint16(ext_w(shuffle16(as_v32int32(Lbuff), 0, 0xBA983210, 0), 0));
    Lbuff = upd_w(Lbuff, 3, srs(acc0,shift_s));
    Lbuff = upd_w(Lbuff, 2, srs(acc1,shift_s));
        
    acc0 = ups(A_in[12],shift);
    acc0 = msc8_nc(acc0, Lbuff,  0, Lidx,  0, 0x33333333);
    acc0 = msc8_nc(acc0, Lbuff,  8, Lidx,  8, 0x33333333);
    acc0 = msc8_nc(acc0, Lbuff, 24, Lidx, 24, 0x33333333);
    L_out[9] = ext_w(Lbuff, 2);
    Lbuff = upd_w(Lbuff, 0, srs(acc2,shift_s)); 
    Lbuff = upd_w(Lbuff, 1, srs(acc3,shift_s));
    
    acc1 = ups(A_in[13],shift);
    acc1 = msc8_nc(acc1, Lbuff, 16, Lidx, 24, 0x33333333); 
    Lbuff = upd_w(Lbuff, 2, pL8[1]);
    acc1 = msc8_nc(acc1, Lbuff, 16, Lidx, cscale, 0, 0x33333333);
    Lbuff = upd_w(Lbuff, 2, pL8[5]);
    acc1 = msc8_nc(acc1, Lbuff, 16, Lidx, cscale, 0, 0x77777777); 
        
    acc2 = ups(A_in[14],shift);
    acc2 = msc8_nc(acc2, Lbuff,  0, Lidx, 24, 0x33333333);    
    Lbuff_t = ext_w(Lbuff, 3);
    Lbuff_t = upd_elem(Lbuff_t, 2, as_cint16(diag2)); 
    L_out[8] = Lbuff_t;

    Lbuff = upd_w(Lbuff, 2, pL8[2]);
    acc2 = msc8_nc(acc2, Lbuff, 16, Lidx, cscale, 0, 0x33333333); 
    L_out[10] = ext_w(Lbuff, 0); 
    Lbuff = upd_w(Lbuff, 2, pL8[6]);
    acc2 = msc8_nc(acc2, Lbuff, 16, Lidx, cscale, 0, 0x77777777);  
    L_out[11] = ext_w(Lbuff, 1);  
    
    acc3 = ups(A_in[15],shift);
    acc3 = msc8_nc(acc3, Lbuff,  8, Lidx, 24, 0x33333333);
    Lbuff = upd_w(Lbuff, 2, pL8[3]);
    acc3 = msc8_nc(acc3, Lbuff, 16, Lidx, cscale, 0, 0x33333333);
    Lbuff = upd_w(Lbuff, 2, pL8[7]);
    acc3 = msc8_nc(acc3, Lbuff, 16, Lidx, cscale, 0, 0x77777777); 
                 
    
    //---- Row 3 invsqrt ----
        
    diag_val = ext_elem(lsrs(ext_lo(as_v16acc48(acc0)),0),6);
    rscale = upd_elem(undef_v8int32(),0,invsqrt(diag_val, shift_in, shift_out));
    // extract diag elem 3
    diag3 = ext_elem(rscale, 0);

    Lbuff = upd_w(undef_v32cint16(), 0, srs(acc0,shift)); 
    acc0 = mul8(Lbuff, 0, Lidx, rscale, 0, 0);
    Lbuff = upd_w(undef_v32cint16(), 0, srs(acc1,shift)); 
    acc1 = mul8(Lbuff, 0, Lidx, rscale, 0, 0);
    Lbuff = upd_w(undef_v32cint16(), 0, srs(acc2,shift)); 
    acc2 = mul8(Lbuff, 0, Lidx, rscale, 0, 0);
    Lbuff = upd_w(undef_v32cint16(), 0, srs(acc3,shift)); 
    acc3 = mul8(Lbuff, 0, Lidx, rscale, 0, 0);
    
    Lbuff_t = srs(acc0,shift_s);
    Lbuff_t = upd_elem(Lbuff_t, 3, as_cint16(diag3));
    L_out[12] = Lbuff_t; 

    L_out[13] = srs(acc1,shift_s);
    L_out[14] = srs(acc2,shift_s);
    L_out[15] = srs(acc3,shift_s);
    
    pA8 = ((v8cint16 chess_storage(DM_bankA) *)A_in) + 16;
    pL8 = add_to_pointer((v8cint16 chess_storage(DM_bankA) *)L_out, sizeof(v4cint16));
        
    //---- Row 4 to 7 ----    
    for (unsigned int i=4; i<8; i++) {
        inc_p = chol_loop_4(pA8, pL8, i, &(diag_arr[0]) );
        pA8 += 3;        
	pA8 = add_to_pointer(pA8, inc_p);
        pL8 = add_to_pointer(pL8, inc_p >> 32);
    }           

    //---- Row 8 to 15 ----
    for (unsigned int i=8; i<16; i++) { 
        inc_p = chol_loop_3(pA8, pL8, i, &(diag_arr[0]) );
        pA8 += 2;
	pA8 = add_to_pointer(pA8, inc_p);
        pL8 = add_to_pointer(pL8, inc_p >> 32);
    }  
          
    
    //---- Row 16 to 23 ----
    for (unsigned int i=16; i<24; i++) {
        inc_p = chol_loop_2(pA8, pL8, i, &(diag_arr[0]) );
        pA8 += 1;        
	pA8 = add_to_pointer(pA8, inc_p);
        pL8 = add_to_pointer(pL8, inc_p >> 32);
    } 
     
     
    //---- Row 24 to 31 ----
    // Do 2 Columns in parallel, therefore we need have to inc pA while loading and 2 times after a iteration
    unsigned int inc_pA_next = 2 * 2 * sizeof(v4cint16);
    
    for (unsigned int chess_storage(r5) i=24; i<30; i+=2) {
        inc_p = chol_loop_1(pA8, pL8, i, inc_pA_next/2, &(diag_arr[0]) );  
        pA8 = add_to_pointer(pA8, inc_pA_next);
	pL8 = add_to_pointer(pL8, inc_p >> 32);
        inc_pA_next = inc_p;
    }
	inc_p = chol_loop_last(pA8, pL8, 30, inc_pA_next/2, &(diag_arr[0]) );
    pA8 = add_to_pointer(pA8, inc_pA_next);
    pL8 = add_to_pointer(pL8, inc_p >> 32);
    inc_pA_next = inc_p;
	
   pL8t = byte_incr(pL8t, 4*128); // '4' bytes for cint16 datatype, '128' for 32*4 elem of first four cols; 
   int col_sz = 28; // reduces in step of 4 as follows: 28, 24, 20, 16, 12, 8, 4.
   for ( unsigned int i=1; i<8; i++ )
   {
        *pL8t = diag_arr[i*4 + 0];
         pL8t = byte_incr(pL8t, col_sz*4 + 1*4);

        *pL8t = diag_arr[i*4 + 1];
         pL8t = byte_incr(pL8t, (col_sz*4 + 1*4));

        *pL8t = diag_arr[i*4 + 2];
         pL8t = byte_incr(pL8t, (col_sz*4 + 1*4)) ;

        *pL8t = diag_arr[i*4 + 3];
         // update col size and pointer for next iteration.
         col_sz -= 4;
         pL8t = byte_incr(pL8t, (col_sz*4 + 1*4));
   }
}

