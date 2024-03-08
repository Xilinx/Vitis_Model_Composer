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


#ifndef __CHOLESKY_32X32_H__
#define __CHOLESKY_32X32_H__

#include <utils.h>

#define     SHIFT_IN    0
#define     SHIFT_OUT   30

#define     Lidx 	0x76543210
#define     Aidx 	0x76543210

#define     SHIFT       16
#define     SHIFT_S     14
#define     NMAT        32

#ifdef __clang__
#define INLINE inline __attribute__((always_inline))
#else
#define INLINE inline
#endif

INLINE unsigned long long chol_loop_4 (v8cint16 chess_storage(DM_bankA) * pA, v8cint16 chess_storage(DM_bankA) * pL, unsigned int row, cint16_t * diag_arr);
INLINE unsigned long long chol_loop_3 (v8cint16 chess_storage(DM_bankA) * pA, v8cint16 chess_storage(DM_bankA) * pL, unsigned int row);
INLINE unsigned long long chol_loop_2 (v8cint16 chess_storage(DM_bankA) * pA, v8cint16 chess_storage(DM_bankA) * pL, unsigned int row);
INLINE unsigned long long chol_loop_1 (v8cint16 chess_storage(DM_bankA) * pA, v8cint16 chess_storage(DM_bankA) * pL, unsigned int row, unsigned int inc_pA);


/* Add the value to a v8cint16 pointer which refers to byte addresses.
 * Such values are calculated by the calc_pX_post_inc functions below for efficient adding
 */
INLINE v8cint16 chess_storage(DM_bankA) * add_to_pointer (v8cint16 chess_storage(DM_bankA) * p, unsigned int i) {
    return (v8cint16 chess_storage(DM_bankA) *)(((unsigned char chess_storage(DM_bankA) *) p) + i);
}


/* Do the calculation for the post increment for Pointer pA. Equivalent calculation with if:
 *      if ( row % 8 < 4 )
 *          return 2 * sizeof(v4cint16);
 *      else
 *          return 1 * sizeof(v4cint16);
 * The returned value can be added to a pointer addressed in Bytes. This is done to get directly 
 * the modifier value which is added to the pointer by the core. sizeof(v4cint16) secures the 
 * alignment to 128 bit addresses.  
 */ 
INLINE unsigned int calc_pA_post_inc (unsigned int row) {
    return (2 - (row / 4 & 1))  * sizeof(v4cint16);
}


/* Do the calculation for the post increment for Pointer pL. Equivalent calculation with if:
 *      if (row & 4-step) == 4-step)
 *          return sizeof(v4cint16);
 *      else
 *          return 0;
 * The step parameter is used to set the number of colums processed in parallel in 2^(step-1)
 * The returned value can be added to a pointer addressed in Bytes. This is done to get directly 
 * the modifier value which is added to the pointer by the core. sizeof(v4cint16) secures the 
 * alignment to 128 bit addresses.  
 */ 
INLINE unsigned int calc_pL_post_inc (unsigned int row, const int step) {
    return ((row & 4-step) == 4-step) * sizeof(v4cint16);
}


/* Increment the Pointer pL inside the inner loop. 
 * Depending on the starting value of inc_p4 the correct post adding is applied to pL.
 * For a propper starting value of inc_p4 can be calculated with
 * inc_p4 = (2 * floor(row / 8) + 3) * sizeof(v4cint16) - 1;
 * Taking this into account, the complete pointer increment can be calculated also
 * with the following code in a more readable way but less efficient. The used code take only 2 cycles.
 * unsigned int inc_p4 = 2 * (row / 8);
 * for (unsigned int i=0; i<row; i++) { //loop as reference
 *      if ((i % 4) == 3)
 *          inc_p4--;
 *      pL += inc_p4; //pointer here of type v4cint16. In application v8cint16. has to be casted correctly
 * }
 * To understand the code below it helps to iterprete inc_p4 as a fixed point value
 * with 4 fractional bits applying to a v4cint16 pointer. inc_p4 & 0xF0 perform a floor rounding of this value.
 * inc_p -= 4 reduces the value by 0.25. Because of the rounding a decrement occur every 4 iteration.
 */
#define pL_post_inc_loop(pL, inc_p)       \
    inc_p -= 4;                           \
    pL = add_to_pointer(pL, inc_p & 0xF0) 


INLINE unsigned long long chol_loop_4 (v8cint16 chess_storage(DM_bankA) * pA, v8cint16 chess_storage(DM_bankA) * pL, unsigned int row, int * diag_arr )
{
    //  scalars
    int     shift = SHIFT; 
    int     shift_s = SHIFT_S;        // shift for the scale operation w/ int32 in invsqrt
    int     shift_in = 0;
    int     shift_out = SHIFT_OUT; 

    int     row_idx = fft_zoffs(row & 3, 3, 1, 1); // make 0xaaaaaaaa out of a=row%4
    unsigned int inc_pL = 2 * 16 + 15;  //see description of pL_post_inc_loop

    v8cacc48 acc0 = ups(*(pA++),shift);
    v8cacc48 acc1 = ups(*(pA++),shift);
    v8cacc48 acc2 = ups(*(pA++),shift);
    v8cacc48 acc3 = ups( *pA   ,shift);

    v32cint16 buf = undef_v32cint16();

    int diag0; 
    int ZERO = 0; 
    v8cint16 Lbuff_t = null_v8cint16();
    int loc = row - 4;


    for (unsigned int i=0; i<row; i++)
        chess_prepare_for_pipelining
        chess_loop_range(4,)
    {
        buf = upd_w(buf, 0, *(pL++));
        acc0 = msc8_nc(acc0, buf, 0, Lidx, 0, row_idx );
        buf = upd_w(buf, 1, *(pL++));
        acc1 = msc8_nc(acc1, buf, 8, Lidx, 0, row_idx );
        buf = upd_w(buf, 1, *(pL++));
        acc2 = msc8_nc(acc2, buf, 8, Lidx, 0, row_idx );
        buf = upd_w(buf, 1, *pL);
        acc3 = msc8_nc(acc3, buf, 8, Lidx, 0, row_idx );
        pL_post_inc_loop(pL, inc_pL);
    }


    v16int32 extract = upd_w(undef_v16int32(), 0, lsrs(ext_lo(as_v16acc48(acc0)),0));
    extract = shuffle16(extract, 0, 0, row_idx*2);

    v8int32 rscale = upd_elem(undef_v8int32(),0,invsqrt(ext_elem(extract,8), shift_in, shift_out));


    // extract invsqrt value.
    diag0 = ext_elem(rscale, 0);
    diag_arr[row] = diag0; 

    buf = upd_w(undef_v32cint16(), 0, srs(acc0,shift));
    buf = upd_w(buf, 1, srs(acc1,shift));
    buf = upd_w(buf, 2, srs(acc2,shift));
    buf = upd_w(buf, 3, srs(acc3,shift));

    acc0 = mul8(buf,  0, Lidx, rscale, 0, 0);
    acc1 = mul8(buf,  8, Lidx, rscale, 0, 0);
    acc2 = mul8(buf, 16, Lidx, rscale, 0, 0);
    acc3 = mul8(buf, 24, Lidx, rscale, 0, 0);

    // push invsqrt value for first elem.
    *(pL++) = srs(acc0,shift_s);
    *(pL++) = srs(acc1,shift_s);
    *(pL++) = srs(acc2,shift_s);
     *pL    = srs(acc3,shift_s);

    //calculate pointer modifier for next iteration
    unsigned long long inc_p = calc_pA_post_inc(row);
    inc_p |= ((unsigned long long) calc_pL_post_inc(row, 1)) << 32;


    return inc_p;
}




INLINE unsigned long long chol_loop_3 (v8cint16 chess_storage(DM_bankA) * pA, v8cint16 chess_storage(DM_bankA) * pL, unsigned int row, int * diag_arr)
{
    //  scalars
    int     shift = SHIFT; 
    int     shift_s = SHIFT_S;        // shift for the scale operation w/ int32 in invsqrt
    int     shift_in = 0;
    int     shift_out = SHIFT_OUT; 
    int     row_idx = fft_zoffs(row & 3, 3, 1, 1); // make 0xaaaaaaaa out of a=row%4
    unsigned int inc_pL = 4 * 16 + 15;      //see description of pL_post_inc_loop

    v32cint16 chess_storage(ya) buf = undef_v32cint16();

    int diag0;
    v8cint16 Lbuff_t;
    int ZERO = 0;
    int loc = row - 8;
    loc = loc & 3;

    v8cacc48 acc0 = ups(*(pA++),shift);
    v8cacc48 acc1 = ups(*(pA++),shift);
    v8cacc48 acc2 = ups( *pA   ,shift);  

    for (unsigned int i=0; i<row; i++)
        chess_prepare_for_pipelining
        chess_loop_range(8,)
    {
        buf = upd_w(buf, 0, *(pL++));
        acc0 = msc8_nc(acc0, buf, 0, Lidx, 0, row_idx );
        buf = upd_w(buf, 1, *(pL++));
        acc1 = msc8_nc(acc1, buf, 8, Lidx, 0, row_idx );
        buf = upd_w(buf, 1, *pL);
        acc2 = msc8_nc(acc2, buf, 8, Lidx, 0, row_idx );
        pL_post_inc_loop(pL, inc_pL);
    }
    
        
    v16int32 extract = upd_w(undef_v16int32(),0, lsrs(ext_lo(as_v16acc48(acc0)),0));
    extract = shuffle16(extract, 0, 0, row_idx*2);
    
    v8int32 rscale = upd_elem(undef_v8int32(),0,invsqrt(ext_elem(extract,8), shift_in, shift_out));

    // extract invsert 
    diag_arr[row] = ext_elem(rscale, 0);

    buf = upd_w(undef_v32cint16(), 0, srs(acc0,shift));
    buf = upd_w(buf, 1, srs(acc1,shift)); 
    buf = upd_w(buf, 2, srs(acc2,shift)); 
    acc0 = mul8(buf,  0, Lidx, rscale, 0, 0);
    acc1 = mul8(buf,  8, Lidx, rscale, 0, 0);
    acc2 = mul8(buf, 16, Lidx, rscale, 0, 0);
    
    *(pL++) = srs(acc0,shift_s);
    *(pL++) = srs(acc1,shift_s);
     *pL    = srs(acc2,shift_s);
     
    //calculate pointer modifier for next iteration
    unsigned long long inc_p = calc_pA_post_inc(row);
    inc_p |= ((unsigned long long) calc_pL_post_inc(row, 1)) << 32;
    
    return inc_p;
}




INLINE unsigned long long chol_loop_2 (v8cint16 chess_storage(DM_bankA) * pA, v8cint16 chess_storage(DM_bankA) * pL, unsigned int row,  int * diag_arr )
{
    //  scalars
    int     shift = SHIFT; 
    int     shift_s = SHIFT_S;        // shift for the scale operation w/ int32 in invsqrt
    int     shift_in = 0;
    int     shift_out = SHIFT_OUT; 
    int     row_idx = fft_zoffs(row & 3, 3, 1, 1); // make 0xaaaaaaaa out of a=row%4
    unsigned int inc_pL = 6 * 16 + 15;          //see description of pL_post_inc_loop
        
    v8cacc48 acc0 = ups(*(pA++),shift);    
    v8cacc48 acc1 = ups( *pA   ,shift);
    v32cint16 buf = undef_v32cint16();

    int diag0;
    v8cint16 Lbuff_t;
    int ZERO = 0;
    int loc = row - 16;
    loc = loc & 3;

    for (unsigned int i=0; i<row; i++)
        chess_prepare_for_pipelining
        chess_loop_range(5,)
    {
        buf = upd_w(buf, 0, *(pL++));
        acc0 = msc8_nc(acc0, buf, 0, Lidx, 0, row_idx );
        buf = upd_w(buf, 1, *pL);
        acc1 = msc8_nc(acc1, buf, 8, Lidx, 0, row_idx );
        pL_post_inc_loop(pL, inc_pL);
    }
        
    v16int32 extract = upd_w(undef_v16int32(), 0, lsrs(ext_lo(as_v16acc48(acc0)),0));
    extract = shuffle16(extract, 0, 0, row_idx*2);
    
    v8int32 rscale = upd_elem(undef_v8int32(),0,invsqrt(ext_elem(extract,8), shift_in, shift_out));

    // extract invsqrt
    diag_arr[row] = ext_elem(rscale, 0);

    buf = upd_w(undef_v32cint16(), 0, srs(acc0,shift));
    buf = upd_w(buf, 1, srs(acc1,shift)); 
    acc0 = mul8(buf, 0, Lidx, rscale, 0, 0);
    acc1 = mul8(buf, 8, Lidx, rscale, 0, 0);
    
    *(pL++) = srs(acc0,shift_s);
     *pL    = srs(acc1,shift_s);
     
    //calculate pointer modifier for next iteration
    unsigned long long inc_p = calc_pA_post_inc(row);
    inc_p |= ((unsigned long long) calc_pL_post_inc(row, 1)) << 32;
    
    return inc_p;
}



INLINE unsigned long long chol_loop_1 (v8cint16 chess_storage(DM_bankA) * pA, v8cint16 chess_storage(DM_bankA) * pL, unsigned int row, unsigned int inc_pA, int * diag_arr)
{
    //  scalars
    int     shift = SHIFT; 
    int     shift_s = SHIFT_S;        // shift for the scale operation w/ int32 in invsqrt
    int     shift_in = 0;
    int     shift_out = SHIFT_OUT; 

    int     row_idx = fft_zoffs(row & 3, 3, 1, 1); // make 0xaaaaaaaa out of a=row%4  
    unsigned int inc_pL = 8 * 16 + 15;          //see description of pL_post_inc_loop
    
    v8cacc48 acc_even = ups(*pA,shift); 
    pA = add_to_pointer(pA, inc_pA); 
    v8cacc48 acc_odd = ups(*pA,shift);
    
    v32cint16 buf;        
    v16int32 extract;
    v8int32 rscale;

    int diag0, diag1;
    int ZERO = 0;
    v8cint16 Lbuff_t;   
    int loc = row - 24;
    loc = loc&3;

    buf = upd_w(undef_v32cint16(), 0, *pL);
    acc_even = msc8_nc(acc_even, buf, 0, Lidx, 0, row_idx );
    acc_odd  = msc8_nc(acc_odd,  buf, 0, Lidx, 1, row_idx );
    pL_post_inc_loop(pL, inc_pL);

    for (unsigned int i=1; i<row; i++)
        chess_prepare_for_pipelining
        chess_loop_range(8,)
    {
        buf = upd_w(undef_v32cint16(), 0, *pL);
        acc_even = msc8_nc(acc_even, buf, 0, Lidx, 0, row_idx );
        acc_odd  = msc8_nc(acc_odd,  buf, 0, Lidx, 1, row_idx );
        pL_post_inc_loop(pL, inc_pL);
    }
        
    //first column
    extract = upd_w(undef_v16int32(), 0, lsrs(ext_lo(as_v16acc48(acc_even)),0)); 
    extract = shuffle16(extract, 0, 0, row_idx*2);
    
    rscale = upd_elem(undef_v8int32(),0,invsqrt(ext_elem(extract,8), shift_in, shift_out)); 
    // extract invsqrt in diag0
    diag_arr[row]  = ext_elem(rscale, 0);
       
    buf = upd_w(undef_v32cint16(), 0, srs(acc_even,shift));
    acc_even = mul8(buf, 0, Lidx, rscale, 0, 0);
        
    //second column
    buf = upd_w(undef_v32cint16(), 0, srs(acc_even,shift_s));    
    acc_odd  = msc8_nc(acc_odd, buf, 0, Lidx, 1, row_idx );
    
    extract = upd_w(undef_v16int32(), 0, lsrs(ext_lo(as_v16acc48(acc_odd)),0));  
    extract = shuffle16(extract, 2, 0, row_idx*2);
        
    rscale = upd_elem(undef_v8int32(),0,invsqrt(ext_elem(extract,8), shift_in, shift_out));
    //extract invsqrt
    diag_arr[row+1] = ext_elem(rscale, 0); 
         
    buf = upd_w(undef_v32cint16(), 0, srs(acc_odd,shift));
    acc_odd = mul8(buf, 0, Lidx, rscale, 0, 0);
        
     *pL = srs(acc_even,shift_s);
     pL_post_inc_loop(pL, inc_pL); 
     *pL = srs(acc_odd, shift_s);
    
    //calculate pointer modifier for next iteration
    unsigned long long inc_p = 2 * calc_pA_post_inc(row+2);
    inc_p |= ((unsigned long long) calc_pL_post_inc(row, 2)) << 32;
    
    return inc_p;
}

INLINE unsigned long long chol_loop_last (v8cint16 chess_storage(DM_bankA) * pA, v8cint16 chess_storage(DM_bankA) * pL, unsigned int row, unsigned int inc_pA, int * diag_arr)
{
    //  scalars
    int     shift = SHIFT; 
    int     shift_s = SHIFT_S;        // shift for the scale operation w/ int32 in invsqrt
    int     shift_in = 0;
    int     shift_out = SHIFT_OUT; 

    int     row_idx = fft_zoffs(row & 3, 3, 1, 1); // make 0xaaaaaaaa out of a=row%4  
    unsigned int inc_pL = 8 * 16 + 15;          //see description of pL_post_inc_loop
    
    v8cacc48 acc_even = ups(*pA,shift); 
    pA = add_to_pointer(pA, inc_pA); 
    v8cacc48 acc_odd = ups(*pA,shift);
    
    v32cint16 buf;        
    v16int32 extract;
    v8int32 rscale;

    int diag0, diag1;
    int ZERO = 0;
    v8cint16 Lbuff_t;   
    int loc = row - 24;
    loc = loc&3;


    buf = upd_w(undef_v32cint16(), 0, *pL);
    acc_even = msc8_nc(acc_even, buf, 0, Lidx, 0, row_idx );
    acc_odd  = msc8_nc(acc_odd,  buf, 0, Lidx, 1, row_idx );
    pL_post_inc_loop(pL, inc_pL);

    for (unsigned int i=1; i<row; i++)
        chess_prepare_for_pipelining
        chess_loop_range(8,)
    {
        buf = upd_w(undef_v32cint16(), 0, *pL);
        acc_even = msc8_nc(acc_even, buf, 0, Lidx, 0, row_idx );
        acc_odd  = msc8_nc(acc_odd,  buf, 0, Lidx, 1, row_idx );
        pL_post_inc_loop(pL, inc_pL);
    }
        
    //first column
    extract = upd_w(undef_v16int32(), 0, lsrs(ext_lo(as_v16acc48(acc_even)),0)); 
    extract = shuffle16(extract, 0, 0, row_idx*2);
    
    rscale = upd_elem(undef_v8int32(),0,invsqrt(ext_elem(extract,8), shift_in, shift_out)); 
    // extract invsqrt in diag0
    diag_arr[row]  = ext_elem(rscale, 0);
       
    buf = upd_w(undef_v32cint16(), 0, srs(acc_even,shift));
    acc_even = mul8(buf, 0, Lidx, rscale, 0, 0);
        
    //second column
    buf = upd_w(undef_v32cint16(), 0, srs(acc_even,shift_s));    
    acc_odd  = msc8_nc(acc_odd, buf, 0, Lidx, 1, row_idx );
    
    extract = upd_w(undef_v16int32(), 0, lsrs(ext_lo(as_v16acc48(acc_odd)),0));  
    extract = shuffle16(extract, 2, 0, row_idx*2);
        
    rscale = upd_elem(undef_v8int32(),0,invsqrt(ext_elem(extract,8), shift_in, shift_out));
    //extract invsqrt
    diag_arr[row+1] = ext_elem(rscale, 0); 
         
    buf = upd_w(undef_v32cint16(), 0, srs(acc_odd,shift));
    acc_odd = mul8(buf, 0, Lidx, rscale, 0, 0);
        
     *pL = srs(acc_even,shift_s);
     pL_post_inc_loop(pL, inc_pL);     
    *(v4cint16 chess_storage(DM_bankA) *)pL = srs(ext_lo(acc_odd), shift_s);

    //calculate pointer modifier for next iteration
    unsigned long long inc_p = 2 * calc_pA_post_inc(row+2);
    inc_p |= ((unsigned long long) calc_pL_post_inc(row, 2)) << 32;
    
    return inc_p;
}

#endif // __CHOLESKY_32X32_H__




