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


#ifndef __FFT_STAGES_H__
#define __FFT_STAGES_H__	

// -------------------------------------------------------------
// Radix 2
// -------------------------------------------------------------
//radix2 16bit to 32bit
INLINE_DECL void stage0_radix2_up_dit( cint16_t * x, 
                                    cint16_t * tw, 
                                    unsigned int n, unsigned int r, unsigned int shift, 
                                    cint32_t * restrict y, bool inv )
{
  set_rdx(2);
  const int upsft = FFT_UPSHIFT1;

  v4cint32 * restrict po1 = (v4cint32 *) y; 
  v4cint32 * restrict po2 = (v4cint32 *) (y+n/2); 
  v8cint16 * restrict pi1 = (v8cint16 *) x;
  v8cint16 * restrict pi2 = (v8cint16 *) (x+  r); 
  v8cint16 * px1 = (v8cint16 *) (x+  r); 
  v8cint16 * px2 = (v8cint16 *) (x+2*r); 
  v8cint16 * ptw = (v8cint16 *) tw;

  int zoffs = 0x00000000;   
  umod_t cnt1 = 0, cnt2 = 0;
  
  for (unsigned int j = 0; j < n/16; ++j)
    chess_prepare_for_pipelining
    chess_loop_range(1,)
  {
    v8cint16 xbuf = *pi1;  
    
    v16cint16 ybuf = undef_v16cint16();
    ybuf = upd_w(ybuf,0,*pi2); 
    
    v8cint16 zbuf = *ptw;
    
    v8cacc48 o0 = mac8(ups(xbuf,upsft), ybuf,0,0x76543210,0, zbuf,0,zoffs,inv);
    *po1++ = lsrs(ext_lo(o0),shift);
    *po1++ = lsrs(ext_hi(o0),shift);
    v8cacc48 o1 = msc8(ups(xbuf,upsft), ybuf,0,0x76543210,0, zbuf,0,zoffs,inv); 


    *po2++ = lsrs(ext_lo(o1),shift);
    *po2++ = lsrs(ext_hi(o1),shift);    
    
    pi1   = fft_data_incr(pi1,r/8,px1,cnt1);
    pi2   = fft_data_incr(pi2,r/8,px2,cnt2); 
    ptw   = fft_twiddle_incr(ptw,cnt2,3);
    zoffs = fft_zoffs(cnt1,3,1,1);
  }
}

//radix2 32bit to 32bit
INLINE_DECL void stage0_radix2_dit( cint32_t * restrict x, 
                                    cint16_t * restrict tw, 
                                    unsigned int n, unsigned int r, unsigned int shift, 
                                    cint32_t * restrict y, bool inv )
{
  set_rdx(2);

  v4cint32 * restrict po1 = (v4cint32 * restrict) y;
  v4cint32 * restrict po2 = (v4cint32 * restrict) (y + n/2); 
  v4cint32 * restrict pi1 = (v4cint32 * restrict) x;  
  v4cint32 * restrict pi2 = (v4cint32 * restrict) (x+r);  
  v4cint32 * restrict px1 = (v4cint32 * restrict) (x+r);  
  v4cint32 * restrict px2 = (v4cint32 * restrict) (x+2*r);  
  v8cint16 * restrict ptw = (v8cint16 * restrict) tw;
  
  umod_t cnt1 = 0, cnt2 = 0;

  for (unsigned int j = 0; j < n/8; ++j)
    chess_prepare_for_pipelining
    chess_loop_range(1,)
  {
    v8cint32 chess_storage(XA) xbuf = undef_v8cint32();
    xbuf = upd_w(xbuf, 0, pi1[0]);
    xbuf = upd_w(xbuf, 1, pi2[0]);
    
    int zoffs = fft_zoffs(cnt2,3,1,0);    

    v8cacc48 o = butterfly_dit(xbuf,undef_v8cint32(),0x3210,0x7654,ptw[0],0,zoffs,inv,15);
    *po1++ = lsrs(ext_lo(o),shift);
    *po2++ = lsrs(ext_hi(o),shift);     
    
    pi1   = fft_data_incr(pi1,r/4,px1,cnt1);
    pi2   = fft_data_incr(pi2,r/4,px2,cnt2); 
    ptw   = fft_twiddle_incr(ptw,cnt1,3);
  }
}

INLINE_DECL void stage1_radix2_dit ( cint32_t * restrict x, 
                                     cint16_t * restrict tw, 
                                     unsigned int n, unsigned int shift, 
                                     cint32_t * restrict y, bool inv)
{
  set_rdx(2);

  v4cint32 * restrict po1 = (v4cint32 * restrict) y;
  v4cint32 * restrict po2 = (v4cint32 * restrict) (y + n/2);  
  v4cint32 * restrict pi1 = (v4cint32 * restrict) x;  
  v4cint32 * restrict pi2 = (v4cint32 * restrict) (x+4);  
  v4cint32 * restrict px1 = (v4cint32 * restrict) (x+4);  
  v8cint16 * restrict ptw = (v8cint16 * restrict) tw;
     
  int zoffs = 0x1100;
  umod_t cnt = 0;

  for (int j = 0; j < n/8; ++j)
    chess_prepare_for_pipelining
    chess_loop_range(1,)
  {
    v8cint32 chess_storage(xa) xbuf = undef_v8cint32();
    xbuf = upd_w(xbuf,0,pi1[0]);
    xbuf = upd_w(xbuf,1,pi2[0]);
    
    v8cacc48 o = butterfly_dit(xbuf,undef_v8cint32(),0x5410,0x7632,ptw[0],0,zoffs,inv,15);
    *po1++ = lsrs(ext_lo(o),shift);
    *po2++ = lsrs(ext_hi(o),shift); 
        
    pi1   = fft_data_incr(pi1,1,px1,cnt);    
    pi2  += 2;
    ptw   = fft_twiddle_incr(ptw,cnt,2);    
    zoffs = fft_zoffs(cnt,2,1,0);    
  }
}

//radix2 32bit to 16bit
INLINE_DECL void stage2_radix2_down_dit ( cint32_t * x, 
                                     cint16_t * tw,
                                     unsigned int n, unsigned int output_shift, bool inv,
                                     cint16_t * restrict y )
{
  v4cint16 * restrict po1 = (v4cint16 *) y;
  v4cint16 * restrict po2 = (v4cint16 *) (y + n/2);  
  v4cint32 * restrict pi  = (v4cint32 *) x;  
  v4cint16 * ptw = (v4cint16 *) tw;

  for (unsigned int j = 0; j < n/8; ++j)
    chess_prepare_for_pipelining    
    chess_loop_range(1,)
  {
    v8cint32 xbuf = undef_v8cint32();
    xbuf = upd_w(xbuf,0,*pi++);
    xbuf = upd_w(xbuf,1,*pi++);
    
    v8cint16 zbuf = undef_v8cint16();
    zbuf = upd_v(zbuf,0,*ptw++);

    v8cacc48 o = butterfly_dit(xbuf,undef_v8cint32(),0x6420,0x7531,zbuf,0,0x3210,inv,15);
    *po1++ = srs(ext_lo(o),output_shift);
    *po2++ = srs(ext_hi(o),output_shift);      
  }
}

// -------------------------------------------------------------
// Radix 4
// -------------------------------------------------------------
INLINE_DECL void stage0_radix4_up_dit ( cint16_t * x, 
                                     cint16_t * tw1, 
                                     cint16_t * tw2,
                                     unsigned int n, unsigned int r, unsigned int shift, 
                                     cint32_t * restrict y, bool inv )
{  
  set_rdx(4);
  uint8_t upsft = FFT_UPSHIFT1;
  
  v4cint32 * restrict po   = (v4cint32 *) y;
  v4cint16 chess_storage(DM_bankA)* restrict pi0  = (v4cint16 chess_storage(DM_bankA)*) x;
  v4cint16 chess_storage(DM_bankA)* restrict pi1  = (v4cint16 chess_storage(DM_bankA)*) (x+1*r);
  v4cint16 * px0  = (v4cint16 *) (x+1*r);
  v4cint16 * px1  = (v4cint16 *) (x+2*r);
  v8cint16 * ptw1 = (v8cint16 *) tw1;
  v8cint16 * ptw2 = (v8cint16 *) tw2;
    
  int zoffs1 = 0x00000000;
  int zoffs2 = 0x00000000;

  umod_t cnt0 = 0, cnt1 = 0;
  umod_t cnt1d = 0;
  
  int poff2 = chess_copy(2*r/4);

  v8cint16 chess_storage(wd1) xbuf  = undef_v8cint16();
  v8cint16 chess_storage(wd0) init_buf  = undef_v8cint16();

  v8cint32 chess_storage(xb) ybuf  = undef_v8cint32();
  uint8_t shft = chess_copy(FFT_SHIFT1); //CRVO-1460

  for (unsigned int j = 0; j < n/16; ++j)
    chess_prepare_for_pipelining
    chess_loop_range(1,)
  {     
    // CRVO-943: This Loop schedules now in 5 cycles which is the optimum amount for this loop. 
    // 4 cycles is in a real system not possible because 4 loads at the beginning are from the same bank and therefore they 
    // have to be in 4 different cycles. This could only be reached if the next MAC and MSC are executed after each other. 
    // But this is standing in conflict which the following 2 butterfly operations because they can only be executed with 
    // 1 cycle in between. Reason therefore are the 2 SRS operations which has to be executed between these butterflies and 
    // only 1 can be executed at a cycle while the second SRS slot is used to store data. 
    
    zoffs1 = fft_zoffs(cnt1,3,1,1);  
    zoffs2 = fft_zoffs(cnt1d,3,1,0);    
    
    xbuf      = upd_v(xbuf    ,1, pi1[poff2]); 
    xbuf      = upd_v(xbuf    ,0, pi0[poff2]); 
    init_buf  = upd_v(init_buf,1, *pi1); 
    init_buf  = upd_v(init_buf,0, *pi0);
      
    pi1 = (v4cint16 chess_storage(DM_bankA)*) fft_data_incr((v4cint16*)pi1,r/4,px1,cnt1); 
    pi0 = (v4cint16 chess_storage(DM_bankA)*) fft_data_incr((v4cint16*)pi0,r/4,px0,cnt0); 
    
    v8cint16 zbuf1 = ptw1[0]; 
    v8cint16 zbuf2 = ptw2[0]; 
     

    v8cacc48 a0 = mac8(ups(init_buf, upsft), upd_w(undef_v16cint16(),1,xbuf) ,8,0x76543210,0,zbuf1,0,zoffs1,inv);    
    v8cacc48 a1 = msc8(ups(init_buf, upsft), upd_w(undef_v16cint16(),1,xbuf) ,8,0x76543210,0,zbuf1,0,zoffs1,inv);    
        
    ybuf = upd_w(ybuf,0,lsrs(ext_lo(a0),shft));
    ybuf = upd_w(ybuf,1,lsrs(ext_hi(a0),shft));

    v8cacc48 o0 = butterfly_dit(undef_v8cint32(),ybuf,0xBA98,0xFEDC,zbuf2,0,zoffs2,inv,15);

    ybuf = upd_w(ybuf,0,lsrs(ext_lo(a1),shft));
    ybuf = upd_w(ybuf,1,lsrs(ext_hi(a1),shft));  
    
    v8cacc48 o1 = butterfly_dit_minj(undef_v8cint32(),ybuf,0xBA98,0xFEDC,zbuf2,0,zoffs2,inv,15);

    po[0] = lsrs(ext_lo(o0),shift); po +=   n/16;
    po[0] = lsrs(ext_lo(o1),shift); po +=   n/16;
    po[0] = lsrs(ext_hi(o0),shift); po +=   n/16;
    po[0] = lsrs(ext_hi(o1),shift); po += -(3*(int)(n/16)-1);     
      
    ptw1 = fft_twiddle_incr(ptw1,cnt1, 3);
    
    cnt1d  = fft_mod_delay(cnt1);     
    ptw2 = fft_twiddle_incr(ptw2,cnt1d,3); 
  }
}

INLINE_DECL void stage0_radix4_dit ( cint32_t * x, 
                                     cint16_t * tw1, 
                                     cint16_t * tw2,
                                     unsigned int n, unsigned int r, unsigned int shift,
                                     cint32_t * restrict y, bool inv )
{  
  set_rdx(4);  
  v4cint32 * restrict po0  = (v4cint32 *)  y;
  v4cint32 * restrict po1  = (v4cint32 *) (y+n/2);
  v4cint32 * restrict pi0  = (v4cint32 *) (x+0*r);
  v4cint32 * restrict pi1  = (v4cint32 *) (x+1*r);
  v4cint32 * restrict pi3  = (v4cint32 *) (x+3*r);
  v4cint32 * px0  = (v4cint32 *) (x+1*r);
  v4cint32 * px1  = (v4cint32 *) (x+2*r);
  v4cint32 * px3  = (v4cint32 *) (x+4*r);
  v8cint16 * ptw1 = (v8cint16 *) tw1;
  v8cint16 * ptw2 = (v8cint16 *) tw2; 
 
  umod_t cnt1  = 0, cnt2 = 0, cnt3 = 0;
  umod_t cnt3d = 0;
  
  v8cint32 xbuf = undef_v8cint32();
  v8cint32 ybuf = undef_v8cint32();

  int      revert_offset = chess_copy(-(int)(r/4));
  uint8_t  shft          = chess_copy(FFT_SHIFT1); //CRVO-1460
  int      s             = chess_copy((-(int)(n/16)+1));

  for (unsigned int j = 0; j < n/16; ++j)
    chess_prepare_for_pipelining
    chess_loop_range(1,)
  {     
    xbuf  = upd_w(xbuf,0,pi0[0]);
    xbuf  = upd_w(xbuf,1,pi3[revert_offset]);  
    v8cint16 zbuf1 = ptw1[0];
  
    int zoffs1 = fft_zoffs(cnt2,3,1,0);    
    int zoffs2 = fft_zoffs(cnt3d,3,1,0);    
    
    v8cacc48 a0 = butterfly_dit(xbuf,undef_v8cint32(),0x3210,0x7654,zbuf1,0,zoffs1,inv,15);
    
    xbuf  = upd_w(xbuf,1,pi1[0]);
    xbuf  = upd_w(xbuf,0,pi3[0]);
    v8cint16 zbuf2 = ptw2[0];
    
    pi0  = fft_data_incr(pi0,r/4,px0,cnt1);    
    pi1  = fft_data_incr(pi1,r/4,px1,cnt2);    
    pi3  = fft_data_incr(pi3,r/4,px3,cnt3);    
    cnt3d= fft_mod_delay(cnt3);

    ptw1 = fft_twiddle_incr(ptw1,cnt1, 3);
    ptw2 = fft_twiddle_incr(ptw2,cnt3d,3);

    v8cacc48 a1 = butterfly_dit(xbuf,undef_v8cint32(),0x7654,0x3210,zbuf1,0,zoffs1,inv,15);
     
    ybuf = upd_w(ybuf,0,lsrs(ext_lo(a0),shft));
    ybuf = upd_w(ybuf,1,lsrs(ext_lo(a1),shft));   

    v8cacc48 o0 = butterfly_dit(ybuf,undef_v8cint32(),0x3210,0x7654,zbuf2,0,zoffs2,inv,15);

    ybuf = upd_w(ybuf,0,lsrs(ext_hi(a0),shft));
    ybuf = upd_w(ybuf,1,lsrs(ext_hi(a1),shft));   

    v8cacc48 o1 = butterfly_dit_minj(ybuf,undef_v8cint32(),0x3210,0x7654,zbuf2,0,zoffs2,inv,15);

    po0[0] = lsrs(ext_lo(o0),shift); po0 +=        n/16;
    po1[0] = lsrs(ext_hi(o0),shift); po1 +=        n/16; 
    po0 = chess_copy(po0); po1 = chess_copy(po1); // See CRVO-1587
    po1[0] = lsrs(ext_hi(o1),shift); po1 +=           s; //-(int)(n/16)+1;
    po0[0] = lsrs(ext_lo(o1),shift); po0 +=           s; //-(int)(n/16)+1;  
  }
}

INLINE_DECL void stage0_radix4_down_dit ( cint32_t * restrict x,
                                     cint16_t * restrict tw1,
                                     cint16_t * restrict tw2,
                                     unsigned int n, unsigned int r, unsigned int shift,
                                     cint16_t * restrict y, bool inv )
{
        set_rdx(4);

        uint8_t sft = chess_copy(FFT_SHIFT1) ;  //MEAPPS 146.
        v4cint16 * restrict po0  = (v4cint16 * restrict)  y;
        v4cint16 * restrict po1  = (v4cint16 * restrict) (y+n/2); 
        v4cint32 * restrict pi0  = (v4cint32 * restrict) (x+0*r);
        v4cint32 * restrict pi1  = (v4cint32 * restrict) (x+1*r);
        v4cint32 * restrict pi3  = (v4cint32 * restrict) (x+3*r);
        v4cint32 * restrict px0  = (v4cint32 * restrict) (x+1*r);
        v4cint32 * restrict px1  = (v4cint32 * restrict) (x+2*r);
        v4cint32 * restrict px3  = (v4cint32 * restrict) (x+4*r);
        v8cint16 * restrict ptw1 = (v8cint16 * restrict) tw1;
        v8cint16 * restrict ptw2 = (v8cint16 * restrict) tw2;

        umod_t cnt1  = 0, cnt2 = 0, cnt3 = 0;
        umod_t cnt3d = 0;

        v8cint32 chess_storage(XA) xbuf = undef_v8cint32();
        v8cint32 chess_storage(XD) ybuf = undef_v8cint32();

        int revert_offset=chess_copy(-(int)(r/4));

        for (unsigned int j = 0; j < n/16; ++j)
                chess_prepare_for_pipelining
                chess_loop_range(1,)
        {
                xbuf  = upd_w(xbuf, 0, pi0[0]);
                xbuf  = upd_w(xbuf, 1, pi3[revert_offset]);
                v8cint16 chess_storage(WC0) zbuf1 = ptw1[0];

                int zoffs1 = fft_zoffs(cnt2,3,1,0);
                int zoffs2 = fft_zoffs(cnt3d,3,1,0);

                v8cacc48 a0 = butterfly_dit(xbuf,undef_v8cint32(),0x3210,0x7654,zbuf1,0,zoffs1,inv,15);

                xbuf  = upd_w(xbuf, 1, pi1[0]);
                xbuf  = upd_w(xbuf, 0, pi3[0]);
                v8cint16 chess_storage(WC1) zbuf2 = ptw2[0];

                pi0  = fft_data_incr(pi0,r/4,px0,cnt1);
                pi1  = fft_data_incr(pi1,r/4,px1,cnt2);
                pi3  = fft_data_incr(pi3,r/4,px3,cnt3);
                cnt3d= fft_mod_delay(cnt3);

                ptw1 = fft_twiddle_incr(ptw1,cnt1, 3);
                ptw2 = fft_twiddle_incr(ptw2,cnt3d,3);

                v8cacc48 a1 = butterfly_dit(xbuf,undef_v8cint32(),0x7654,0x3210,zbuf1,0,zoffs1,inv,15);

                ybuf = upd_w(ybuf, 0, lsrs(ext_lo(a0),sft));
                ybuf = upd_w(ybuf, 1, lsrs(ext_lo(a1),sft));

                v8cacc48 o0 = butterfly_dit(ybuf,undef_v8cint32(),0x3210,0x7654,zbuf2,0,zoffs2,inv,15);

                ybuf = upd_w(ybuf, 0, lsrs(ext_hi(a0),sft));
                ybuf = upd_w(ybuf, 1, lsrs(ext_hi(a1),sft));

                v8cacc48 o1 = butterfly_dit_minj(ybuf,undef_v8cint32(),0x3210,0x7654,zbuf2,0,zoffs2,inv,15);

                po0[0] = srs(ext_lo(o0),shift); po0 +=        n/16;
                po1[0] = srs(ext_hi(o0),shift); po1 +=        n/16;
                po1[0] = srs(ext_hi(o1),shift); po1 += -(int)(n/16)+1; 
                po0[0] = srs(ext_lo(o1),shift); po0 += -(int)(n/16)+1;

        }
}

INLINE_DECL void stage1_radix4_down_dit ( cint32_t * x, cint16_t * tw1, cint16_t * tw2, unsigned int n, unsigned int shift, output_window_cint16 * restrict outputcb, bool inv )
{  
  output_window_cint16 * restrict po0_wb  = (output_window_cint16 * restrict) outputcb;  
  output_window_cint16 po1;
  output_window_cint16 * restrict po1_wb = &po1;
  window_copy(po1_wb, outputcb);
  window_incr(po1_wb, (n&~15)/2);
  
  v4cint32 * restrict pi   = (v4cint32 *) x;  
  v4cint16 * ptw1 = (v4cint16 *) tw1;
  v4cint16 * ptw2 = (v4cint16 *) tw2;
  uint8_t             shft = chess_copy(FFT_SHIFT1); //CRVO-1460
    
  v8cint32 xbuf = undef_v8cint32();
  v8cint32 ybuf = undef_v8cint32();
  
  for (unsigned int j = 0; j < n/16; ++j)
    chess_prepare_for_pipelining
    chess_loop_range(1,)
  {    
    v8cint16 zbuf1 = undef_v8cint16();
    zbuf1 = upd_v(zbuf1,0,ptw1[j]);
    
    xbuf  = upd_w(xbuf,0,*pi);      pi += 2;
    xbuf  = upd_w(xbuf,1,*pi);      pi +=-1;
    
    v8cacc48 a0 = butterfly_dit(xbuf,undef_v8cint32(),0x5410,0x7632,zbuf1,0,0x2200,inv,15);    
    
    xbuf  = upd_w(xbuf,0,*pi);      pi += 2;
    xbuf  = upd_w(xbuf,1,*pi);      pi += 1;

    v8cacc48 a1 = butterfly_dit(xbuf,undef_v8cint32(),0x5410,0x7632,zbuf1,0,0x3311,inv,15);
    
    v8cint16 zbuf2 = undef_v8cint16();
    zbuf2 = upd_v(zbuf2,0,ptw2[j]);
   
    ybuf = upd_w(ybuf,0,lsrs(ext_lo(a0),shft));
    ybuf = upd_w(ybuf,1,lsrs(ext_lo(a1),shft));
        
    v8cacc48 o0 = butterfly_dit(ybuf,undef_v8cint32(),0x6240,0x7351,zbuf2,0,0x3210,inv,15);

    ybuf = upd_w(ybuf,0,lsrs(ext_hi(a0),shft));
    ybuf = upd_w(ybuf,1,lsrs(ext_hi(a1),shft));

    v8cacc48 o1 = butterfly_dit_minj(ybuf,undef_v8cint32(),0x6240,0x7351,zbuf2,0,0x3210,inv,15);
		
	window_write(po0_wb, srs(ext_lo(o0),shift)); 	window_incr(po0_wb, 4*n/16);		
    window_write(po1_wb, srs(ext_hi(o0),shift)); 	window_incr(po1_wb, 4*n/16);	
    window_write(po1_wb, srs(ext_hi(o1),shift));	window_incr(po1_wb, -(4*(n/16))+4);	
    window_write(po0_wb, srs(ext_lo(o1),shift)); 	window_incr(po0_wb, -(4*(n/16))+4);
	
  }
}


INLINE_DECL void stage1_radix4_dit ( cint32_t * x, cint16_t * tw1, cint16_t * tw2, unsigned int n, unsigned int shift, cint32_t * restrict y, bool inv )
{
  n += 15; //ceil rounding in combination with n/16
  
  v4cint32 * restrict po0  = (v4cint32 *)  y;
  v4cint32 * restrict po1  = (v4cint32 *) chess_copy((y+(n&~15)/2));
  v4cint32 * restrict pi   = (v4cint32 *) x;  
  v4cint16 * ptw1 = (v4cint16 *) tw1;
  v4cint16 * ptw2 = (v4cint16 *) tw2;
  uint8_t             shft = chess_copy(15); //CRVO-1460
    
  v8cint32 xbuf = undef_v8cint32();
  v8cint32 ybuf = undef_v8cint32();
  
  for (unsigned int j = 0; j < n/16; ++j)
    chess_prepare_for_pipelining
    chess_loop_range(1,)
  {    
    v8cint16 zbuf1 = undef_v8cint16();
    zbuf1 = upd_v(zbuf1,0,ptw1[j]);
    
    xbuf  = upd_w(xbuf,0,*pi);      pi += 2;
    xbuf  = upd_w(xbuf,1,*pi);      pi +=-1;
    
    v8cacc48 a0 = butterfly_dit(xbuf,undef_v8cint32(),0x5410,0x7632,zbuf1,0,0x2200,inv,15);    
    
    xbuf  = upd_w(xbuf,0,*pi);      pi += 2;
    xbuf  = upd_w(xbuf,1,*pi);      pi += 1;

    v8cacc48 a1 = butterfly_dit(xbuf,undef_v8cint32(),0x5410,0x7632,zbuf1,0,0x3311,inv,15);
    
    v8cint16 zbuf2 = undef_v8cint16();
    zbuf2 = upd_v(zbuf2,0,ptw2[j]);
   
    ybuf = upd_w(ybuf,0,lsrs(ext_lo(a0),shft));
    ybuf = upd_w(ybuf,1,lsrs(ext_lo(a1),shft));
        
    v8cacc48 o0 = butterfly_dit(ybuf,undef_v8cint32(),0x6240,0x7351,zbuf2,0,0x3210,inv,15);

    ybuf = upd_w(ybuf,0,lsrs(ext_hi(a0),shft));
    ybuf = upd_w(ybuf,1,lsrs(ext_hi(a1),shft));

    v8cacc48 o1 = butterfly_dit_minj(ybuf,undef_v8cint32(),0x6240,0x7351,zbuf2,0,0x3210,inv,15);

    po0[0] = lsrs(ext_lo(o0),shift); po0 +=        n/16;
    po1[0] = lsrs(ext_hi(o0),shift); po1 +=        n/16; 
    po1[0] = lsrs(ext_hi(o1),shift); po1 += -(int)(n/16)+1;
    po0[0] = lsrs(ext_lo(o1),shift); po0 += -(int)(n/16)+1;  
  }
}

// -------------------------------------------------------------
// Radix 3
// -------------------------------------------------------------
#define ONE_BY_THREE		10923		//Q15 : 2^15 * 1/3

INLINE_DECL void stage0_radix3_dit( cint32_t * x, 
                                    cint16_t * twb, 
                                    cint16_t * twc,
                                    unsigned int n, unsigned int r, unsigned int shift, 
                                    cint32_t * restrict y, bool inv  )
{
  set_rdx(3);  
  unsigned int n_div_3 = (n * ONE_BY_THREE) >> 15; 
  const int upsft = FFT_UPSHIFT1;

  v4cint32 * restrict po0 = (v4cint32 *) y;
  v4cint32 * restrict po1 = (v4cint32 *) (y + 1*n_div_3); 
  v4cint32 * restrict po2 = (v4cint32 *) (y + 2*n_div_3); 
  
  v4cint32 * restrict pi0 = (v4cint32 *) x;  
  v4cint32 * restrict pi0d= (v4cint32 *) x;  
  v4cint32 * restrict pi1 = (v4cint32 *) (x+r);  
  v4cint32 * restrict pi2 = (v4cint32 *) (x+2*r);
    
  v4cint32 * px0 = (v4cint32 *) (x+r);  
  v4cint32 * px0d= (v4cint32 *) (x+r);  
  v4cint32 * px1 = (v4cint32 *) (x+2*r);  
  v4cint32 * px2 = (v4cint32 *) (x+3*r);  
  
  v4cint16 * ptwb = (v4cint16 *) twb;
  v4cint16 * ptwc = (v4cint16 *) twc;

  int twdiff = ptwb - ptwc;  
  umod_t cnt = 0;

  v8cint16 chess_storage(wc1) qbuf = undef_v8cint16();
  
  if ( inv == false ) //default case for fft kernels.
  	qbuf = upd_elem(qbuf, 0, as_cint16(16384 | (28378 << 16))); // 0.5 + 0.5j*sqrt(3)
  else 
	qbuf = upd_elem(qbuf, 0, as_cint16(16384 | (-28378 << 16))); // 0.5 + 0.5j*sqrt(3)


  for (unsigned int j = 0; j < n_div_3/4; ++j)
    chess_prepare_for_pipelining
    chess_loop_range(1,)
  {
    v8cint32 chess_storage(xb) ybuf = undef_v8cint32();    // use XB
    ybuf = upd_w(ybuf,0,pi0[0]);
    ybuf = upd_w(ybuf,1,pi1[0]);
  
    int zoffs = fft_zoffs(cnt,3,0,0);    
    v8cint16 zbuf = upd_v(undef_v8cint16(),0,ptwc[twdiff]); // use WC   


    v8cacc48 o0;
    o0 = half_butterfly_dit(   undef_v8cint32(),ybuf,0xBA98,0xFEDC,zbuf,0,zoffs,inv,15);
    v4cacc48 d = ext_hi(o0);
    
    ybuf = upd_w(ybuf,1,pi2[0]);                           // reuse XB
    zbuf = upd_v(zbuf,1,ptwc[0]);                          // use same WC as above
    o0 = half_butterfly_dit(o0,undef_v8cint32(),ybuf,       0xFEDC,zbuf,4,zoffs,inv);
    v4cacc48 e = ext_hi(o0);
        
    v8cint32 chess_storage(xa) ubuf = undef_v8cint32();   // use XA
    ubuf = upd_w(ubuf,0,lsrs(d,shift));
    ubuf = upd_w(ubuf,1,lsrs(e,shift));
    
    v4cint32 a = pi0d[0];                                 // use WD
    v4cacc48 o1 = msc4_conj_sym   (ups(a,15),ubuf,0,0x3210,4,qbuf,0,0x0000);
    v4cacc48 o2 = msc4_conj_sym_nc(ups(a,15),ubuf,0,0x3210,4,qbuf,0,0x0000);
    
    *po0++ = lsrs(ext_lo(o0),shift);
    *po1++ = lsrs(o1,        shift);
    *po2++ = lsrs(o2,        shift);
    
    pi0   = fft_data_incr(pi0, r/4,px0, cnt);
    pi0d  = fft_data_incr(pi0d,r/4,px0d    );
    pi1   = fft_data_incr(pi1, r/4,px1     );
    pi2   = fft_data_incr(pi2, r/4,px2     ); 
    ptwc  = fft_twiddle_incr(ptwc,cnt,2);
  }
}


#define one_third_Q15           10923

INLINE_DECL void stage0_radix3_up_dit( cint16_t * x,
                                    cint16_t * twb,
                                    cint16_t * twc,
                                    unsigned int n, unsigned int r, unsigned int shift, 
                                    cint32_t * restrict y, bool inv )
{
    set_rdx(3);
    int n_div_3 = (n * one_third_Q15) >> 15;

    v4cint32 * restrict po0 = (v4cint32 *) y;
    v4cint32 * restrict po1 = (v4cint32 *) (y + 1*n_div_3);
    v4cint32 * restrict po2 = (v4cint32 *) (y + 2*n_div_3);

    v4cint16 * restrict pi0 = (v4cint16 *) x;
    v4cint16 * restrict pi1 = (v4cint16 *) (x+r); 
    v4cint16 * restrict pi2 = (v4cint16 *) (x+2*r);

    v4cint16 * px0 = (v4cint16 *) (x+r);
    v4cint16 * px1 = (v4cint16 *) (x+2*r);
    v4cint16 * px2 = (v4cint16 *) (x+3*r);

    v4cint16 * ptwb = (v4cint16 *) twb;
    v4cint16 * ptwc = (v4cint16 *) twc;
    int twdiff = ptwb - ptwc;

    umod_t cnt  = 0;
    v8cint16  qbuf = undef_v8cint16();
         
    qbuf = upd_elem(qbuf, 0, as_cint16(16384 | (28378 << 16))); // 0.5 + 0.5j*sqrt(3)
    qbuf = upd_elem(qbuf, 4, as_cint16(-32768));               // 1.0 + 0.0j   //-32768

    for (int j = 0; j < n_div_3/4; ++j)
        chess_prepare_for_pipelining
        chess_loop_range(1,)
    {
        v8cint16 zbuf;
        v16cint16 ybuf;
        zbuf = wset_v(     0, ptwc[twdiff]);
        zbuf = upd_v(zbuf, 1, ptwc[0]);
        ybuf = xset_v(     0, pi1[0]);
        ybuf = upd_v(ybuf, 1, pi2[0]);

        //same as int zoffs = fft_zoffs(cnt,3,0,1) + 0x44440000;
        int zoffs = ((cnt & 3) + 0x40000) * 0x11111111;
        v8cacc48 wbc = mul8( concat(undef_v16cint16(), ybuf), 16, 0x76543210, 0, zbuf, 0, zoffs, inv);
                        
        v4cint16 a = pi0[0];
        v8cint32 ubuf = lsrs(wbc, 15); 

        // o = a + s + t.
        v4cacc48 o0 = msc4         (ups(a, 15), ubuf, 0, 0x3210, 4, 0, as_v16int16(qbuf), 8, 0x0000, 0);
        v4cacc48 o1 = msc4_conj_sym(ups(a, 15), ubuf, 0, 0x3210, 4, 0, qbuf, 0, 0x0000, inv);
        v4cacc48 o2 = msc4_conj_sym(ups(a, 15), ubuf, 0, 0x3210, 4, 0, qbuf, 0, 0x0000, !inv);
        
        *po0++ = lsrs(o0, shift);
        *po1++ = lsrs(o1, shift);
        *po2++ = lsrs(o2, shift);

        pi0   = fft_data_incr(pi0, r/4, px0     );
        pi1   = fft_data_incr(pi1, r/4, px1, cnt);
        pi2   = fft_data_incr(pi2, r/4, px2     );
        ptwc  = fft_twiddle_incr(ptwc, cnt, 2);
    }
}

// -------------------------------------------------------------
// Radix 5
// -------------------------------------------------------------

#define ONE_BY_FIVE 		6554 //Q15: 2^15 * 1/5

INLINE_DECL void stage0_radix5_dit( cint32_t * restrict x, 
                                    cint16_t * restrict tw1, 
                                    cint16_t * restrict tw2,
                                    cint16_t * restrict tw3, 
                                    cint16_t * restrict tw4,
                                    unsigned int n, unsigned int r, unsigned int shift, 
                                    cint32_t * restrict y, bool inv )
{
	set_rdx(5);
	unsigned int n_div_5 = (n * ONE_BY_FIVE) >> 15;

	const int upsft = FFT_UPSHIFT1;

	v4cint32 * restrict po   = (v4cint32 * restrict) y;
					   
	//v4cint32 * restrict pi   = (v4cint32 * restrict) (x+1*r);  
	//v4cint32 * restrict pid  = (v4cint32 * restrict) (x+0*r);  
	v4cint32 chess_storage(DM_bankA) * restrict pi   = (v4cint32 chess_storage(DM_bankA) * restrict) (x+1*r);  
	v4cint32 chess_storage(DM_bankA) * restrict pid  = (v4cint32 chess_storage(DM_bankA) * restrict) (x+0*r);  
					   
	v4cint32 * restrict px   = (v4cint32 * restrict) (x+3*r);  
	v4cint32 * restrict pxd  = (v4cint32 * restrict) (x+1*r);  

	v4cint16 * restrict ptw1 = (v4cint16 * restrict) tw1;
	v4cint16 * restrict ptw2 = (v4cint16 * restrict) tw2;
	v4cint16 * restrict ptw3 = (v4cint16 * restrict) tw3;
	v4cint16 * restrict ptw4 = (v4cint16 * restrict) tw4;

	umod_t cnt = 0;

	v8cint16 chess_storage(wc0) zbuf = undef_v8cint16();
	v8cint16 chess_storage(wc1) qbuf = undef_v8cint16();

        if ( inv == false ) // default case for fft.
        {       zbuf = upd_elem(zbuf, 0, as_cint16((-10126 & 0xFFFF) | (31164 << 16))); // -exp(-2j*pi/5)
                zbuf = upd_elem(zbuf, 1, as_cint16(  26510           | (19261 << 16))); // -(-exp(-2j*pi/5))^2
        }
        else    // for ifft.
        {       zbuf = upd_elem(zbuf, 0, as_cint16((-10126 & 0xFFFF) | (-31164 << 16))); // -exp(-2j*pi/5)
                zbuf = upd_elem(zbuf, 1, as_cint16(  26510           | (-19261 << 16))); // -(-exp(-2j*pi/5))^2
        }

	int os1 =    n_div_5/4;
	int os4 =   3*os1;
	int os2 =  -2*os1;
	int os3 =     os1;
	int os0 =    -os4+1;

	int od1 =   -(int)(r/4);
	int od0 =  4*(r/4);
	int od4 =   -(int)(r/4);
	int od3 =   -(int)(r/4);
	int od2 =   -(int)(r/4);

	int rq = r/4;

	int td1 = ptw1-ptw2;
	int td4 = ptw4-ptw2;
	int td3 = ptw3-ptw2;

	for (unsigned int j = 0; j < n_div_5/4; ++j)
		chess_prepare_for_pipelining
		chess_loop_range(1,)
	{
		int zoffs = fft_zoffs(cnt,3,0,0);
		v8cacc48 o0;
		v4cacc48 x1,x2,x3,x4;

		v8cint32 chess_storage(xb) ybuf = undef_v8cint32();  
		v8cint32 chess_storage(xa) ubuf;
		v8cint32 chess_storage(xd) vbuf;

		ybuf = upd_w(ybuf,1,*pi); pi += od1;
		ybuf = upd_w(ybuf,0,*pi); pi += od0; qbuf = upd_v(qbuf,1,ptw2[td1]); o0 = half_butterfly_dit(   undef_v8cint32(),ybuf,0xBA98,0xFEDC,qbuf,4,zoffs,inv,15); x1 = ext_hi(o0);
		ybuf = upd_w(ybuf,1,*pi); pi += od4; qbuf = upd_v(qbuf,1,ptw2[td4]); o0 = half_butterfly_dit(o0,undef_v8cint32(),ybuf,       0xFEDC,qbuf,4,zoffs,inv   ); x4 = ext_hi(o0); 
		ybuf = upd_w(ybuf,1,*pi); pi += od3; qbuf = upd_v(qbuf,1,ptw2[td3]); o0 = half_butterfly_dit(o0,undef_v8cint32(),ybuf,       0xFEDC,qbuf,4,zoffs,inv   ); x3 = ext_hi(o0);
		ybuf = upd_w(ybuf,1,*pi);            qbuf = upd_v(qbuf,1,ptw2[0]  ); o0 = half_butterfly_dit(o0,undef_v8cint32(),ybuf,       0xFEDC,qbuf,4,zoffs,inv   ); x2 = ext_hi(o0); 

		v4cint32 a = pid[0];
		ubuf = concat(lsrs(x1,shift),lsrs(x4,shift));
		v4cacc48 o1 = msc4_conj_sym   (ups(a,upsft),ubuf,0,0x3210,4,zbuf,0,0x0000);
		v4cacc48 o4 = msc4_conj_sym_nc(ups(a,upsft),ubuf,0,0x3210,4,zbuf,0,0x0000);
		v4cacc48 o2 = msc4_conj_sym   (ups(a,upsft),ubuf,0,0x3210,4,zbuf,1,0x0000);
		v4cacc48 o3 = msc4_conj_sym_nc(ups(a,upsft),ubuf,0,0x3210,4,zbuf,1,0x0000);

		vbuf = concat(lsrs(x2,shift),lsrs(x3,shift));
		o1 = msc4_conj_sym   (o1,vbuf,0,0x3210,4,zbuf,1,0x0000);
		o4 = msc4_conj_sym_nc(o4,vbuf,0,0x3210,4,zbuf,1,0x0000);
		o2 = msc4_conj_sym_nc(o2,vbuf,0,0x3210,4,zbuf,0,0x0000);
		o3 = msc4_conj_sym   (o3,vbuf,0,0x3210,4,zbuf,0,0x0000);

		*po = lsrs(ext_lo(o0),shift); po += os1;
		*po = lsrs(o1,        shift); po += os4;
		*po = lsrs(o4,        shift); po += os2;
		*po = lsrs(o2,        shift); po += os3;
		*po = lsrs(o3,        shift); po += os0;

		//pi   = fft_data_incr(pi, rq,px, cnt);  pi += od2;
		//pid  = fft_data_incr(pid,rq,pxd);
		pi   = (v4cint32 chess_storage(DM_bankA)*) fft_data_incr((v4cint32*) pi, rq,px, cnt);  pi += od2;
		pid  = (v4cint32 chess_storage(DM_bankA)*) fft_data_incr((v4cint32*) pid,rq,pxd);
		ptw2 = fft_twiddle_incr(ptw2,cnt,2);
	}
}

// -------------------------------------------------------------
// Radix 7
// -------------------------------------------------------------

#define one_seventh_Q15 4682

INLINE_DECL void stage0_radix7_dit( cint32_t * restrict x, 
                                    cint16_t * restrict tw1, 
                                    cint16_t * restrict tw2,
                                    cint16_t * restrict tw3, 
                                    cint16_t * restrict tw4,
                                    cint16_t * restrict tw5, 
                                    cint16_t * restrict tw6,
                                    unsigned int n, unsigned int r, unsigned int shift, 
                                    cint32_t * restrict y, bool inv )
{
	set_rdx(7);
	unsigned int n_div_7 = (n * one_seventh_Q15) >> 15; 
	const int upsft = FFT_UPSHIFT1;

	v4cint32 * restrict po   = (v4cint32 * restrict) y;
					   
	v4cint32 * restrict piu  = (v4cint32 * restrict) (x+3*r);  
	v4cint32 * restrict pid;
					   
	v4cint32 * restrict px   = (v4cint32 * restrict) (x+4*r);  

	v4cint16 * restrict ptw1 = (v4cint16 * restrict) tw1;
	v4cint16 * restrict ptw2 = (v4cint16 * restrict) tw2;
	v4cint16 * restrict ptw3 = (v4cint16 * restrict) tw3;
	v4cint16 * restrict ptw4 = (v4cint16 * restrict) tw4;
	v4cint16 * restrict ptw5 = (v4cint16 * restrict) tw5;
	v4cint16 * restrict ptw6 = (v4cint16 * restrict) tw6;

	umod_t cnt = 0;

	v8cint16 chess_storage(wc0) zbuf = undef_v8cint16();  
	v8cint16 chess_storage(wc1) qbuf = undef_v8cint16();  

	zbuf = upd_elem(zbuf, 0, as_cint16((-20431 & 0xFFFF) | (25619 << 16))); //   -exp(-2j*pi/7)
	zbuf = upd_elem(zbuf, 1, as_cint16(   7292           | (31946 << 16))); // -(-exp(-2j*pi/7))^2
	zbuf = upd_elem(zbuf, 2, as_cint16(  29523           | (14218 << 16))); //  (-exp(-2j*pi/7))^3

        if ( inv == false )
        {       zbuf = upd_elem(zbuf, 0, as_cint16((-20431 & 0xFFFF) | (25619 << 16))); //   -exp(-2j*pi/7)
                zbuf = upd_elem(zbuf, 1, as_cint16(   7292           | (31946 << 16))); // -(-exp(-2j*pi/7))^2
                zbuf = upd_elem(zbuf, 2, as_cint16(  29523           | (14218 << 16))); //  (-exp(-2j*pi/7))^3
        }
        else
        {       zbuf = upd_elem(zbuf, 0, as_cint16((-20431 & 0xFFFF) | (-25619 << 16))); //   -exp(-2j*pi/7)
                zbuf = upd_elem(zbuf, 1, as_cint16(   7292           | (-31946 << 16))); // -(-exp(-2j*pi/7))^2
                zbuf = upd_elem(zbuf, 2, as_cint16(  29523           | (-14218 << 16))); //  (-exp(-2j*pi/7))^3
        }


	int os1 = n_div_7/4;
	int os0 = -6*os1+1;

	int od0  = -3*(r/4);
	int od1  =  1*(r/4);
	int od5  = -1*(r/4);
	int od6  =  3*(r/4);

	int td1 = ptw1-ptw4;
	int td6 = ptw6-ptw4;
	int td2 = ptw2-ptw4;
	int td5 = ptw5-ptw4;
	int td3 = ptw3-ptw4;

	for (unsigned int j = 0; j < n_div_7/4; ++j)
	chess_prepare_for_pipelining
	chess_loop_range(1,)
	{   
		int zoffs = fft_zoffs(cnt,3,0,0);    
		v8cacc48 o0;
		v4cacc48 x1;
		v4cacc48 x2;
		v4cacc48 x3;
		v4cacc48 x4;
		v4cacc48 x5;
		v4cacc48 x6;    

		v8cint32 chess_storage(xb) ybuf = undef_v8cint32();   // XB
		v8cint32 chess_storage(xa) ubuf;   // XA
		v8cint32 chess_storage(xd) fbuf;   // XD

		pid = piu + chess_copy(od6); //see CRVO-1347
		piu += od0;

		ybuf = upd_w(ybuf,0,*piu); piu += od1;
		ybuf = upd_w(ybuf,1,*piu); piu += od1; qbuf = upd_v(qbuf,1,ptw4[td1]); o0 = half_butterfly_dit(   undef_v8cint32(),ybuf,0xBA98,0xFEDC,qbuf,4,zoffs,inv,15); x1 = ext_hi(o0);
		ybuf = upd_w(ybuf,1,*pid); pid += od5; qbuf = upd_v(qbuf,1,ptw4[td6]); o0 = half_butterfly_dit(o0,undef_v8cint32(),ybuf,       0xFEDC,qbuf,4,zoffs,inv   ); x6 = ext_hi(o0);

		v4cint32 a = ext_w(ybuf,0);
		ubuf = concat(lsrs(x1,shift),lsrs(x6,shift));  
			
		ybuf = upd_w(ybuf,1,*piu); piu += od1; qbuf = upd_v(qbuf,1,ptw4[td2]); o0 = half_butterfly_dit(o0,undef_v8cint32(),ybuf,       0xFEDC,qbuf,4,zoffs,inv); x2 = ext_hi(o0);
		ybuf = upd_w(ybuf,1,*pid); pid += od5; qbuf = upd_v(qbuf,1,ptw4[td5]); o0 = half_butterfly_dit(o0,undef_v8cint32(),ybuf,       0xFEDC,qbuf,4,zoffs,inv); x5 = ext_hi(o0);
		ybuf = upd_w(ybuf,1,*piu);             qbuf = upd_v(qbuf,1,ptw4[td3]); o0 = half_butterfly_dit(o0,undef_v8cint32(),ybuf,       0xFEDC,qbuf,4,zoffs,inv); x3 = ext_hi(o0); 
		ybuf = upd_w(ybuf,1,*pid);             qbuf = upd_v(qbuf,1,ptw4[0]);   o0 = half_butterfly_dit(o0,undef_v8cint32(),ybuf,       0xFEDC,qbuf,4,zoffs,inv); x4 = ext_hi(o0); 
		 
		v4cacc48 o1 = msc4_conj_sym   (ups(a,upsft),ubuf,0,0x3210,4,zbuf,0,0x0000);    
		v4cacc48 o2 = msc4_conj_sym   (ups(a,upsft),ubuf,0,0x3210,4,zbuf,1,0x0000);
		v4cacc48 o3 = msc4_conj_sym   (ups(a,upsft),ubuf,0,0x3210,4,zbuf,2,0x0000);
		v4cacc48 o4 = msc4_conj_sym_nc(ups(a,upsft),ubuf,0,0x3210,4,zbuf,2,0x0000);
		v4cacc48 o5 = msc4_conj_sym_nc(ups(a,upsft),ubuf,0,0x3210,4,zbuf,1,0x0000);
		v4cacc48 o6 = msc4_conj_sym_nc(ups(a,upsft),ubuf,0,0x3210,4,zbuf,0,0x0000);
			
		ubuf = concat(lsrs(x2,shift),lsrs(x5,shift));
		o1 = msc4_conj_sym   (o1,ubuf,0,0x3210,4,zbuf,1,0x0000);
		o2 = msc4_conj_sym_nc(o2,ubuf,0,0x3210,4,zbuf,2,0x0000);
		o3 = msc4_conj_sym_nc(o3,ubuf,0,0x3210,4,zbuf,0,0x0000);
		o4 = msc4_conj_sym   (o4,ubuf,0,0x3210,4,zbuf,0,0x0000);
		o5 = msc4_conj_sym   (o5,ubuf,0,0x3210,4,zbuf,2,0x0000);
		o6 = msc4_conj_sym_nc(o6,ubuf,0,0x3210,4,zbuf,1,0x0000);

		fbuf = concat(lsrs(x3,shift),lsrs(x4,shift));   
		o1 = msc4_conj_sym   (o1,fbuf,0,0x3210,4,zbuf,2,0x0000);
		o2 = msc4_conj_sym_nc(o2,fbuf,0,0x3210,4,zbuf,0,0x0000);
		o3 = msc4_conj_sym   (o3,fbuf,0,0x3210,4,zbuf,1,0x0000);
		o4 = msc4_conj_sym_nc(o4,fbuf,0,0x3210,4,zbuf,1,0x0000);
		o5 = msc4_conj_sym   (o5,fbuf,0,0x3210,4,zbuf,0,0x0000);
		o6 = msc4_conj_sym_nc(o6,fbuf,0,0x3210,4,zbuf,2,0x0000);
			
		*po = lsrs(ext_lo(o0),shift); po += os1;
		*po = lsrs(o1,        shift); po += os1;
		*po = lsrs(o2,        shift); po += os1;
		*po = lsrs(o3,        shift); po += os1;
		*po = lsrs(o4,        shift); po += os1;
		*po = lsrs(o5,        shift); po += os1;
		*po = lsrs(o6,        shift); po += os0;
					
		piu  = fft_data_incr(piu, r/4,px, cnt);
		ptw4 = fft_twiddle_incr(ptw4,cnt,2);
	}
}

#endif // __FFT_STAGES_H__

