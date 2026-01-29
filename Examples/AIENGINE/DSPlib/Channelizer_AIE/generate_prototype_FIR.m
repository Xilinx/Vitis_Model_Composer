% setup prototype channel FIR coeffs
filt_len  = num_ch*6;
pb_mag    = 0.1;
sb_mag    = 90;

pb_freq   = (1/num_ch)*0.9;
sb_freq   = (1/num_ch);

pf = cfirpm(filt_len-1,[0,pb_freq,sb_freq,1],@lowpass,[pb_mag,sb_mag]);

% fvtool(pf); % display prototype FIR response

% chop up FIR coefficients column major for PL channelizer
pf_fp = pf;
for lpi = 0:5
    ch0(lpi+1) = pf_fp(lpi*32+1);
    ch1(lpi+1) = pf_fp(lpi*32+2);
    ch2(lpi+1) = pf_fp(lpi*32+3);
    ch3(lpi+1) = pf_fp(lpi*32+4);
    ch4(lpi+1) = pf_fp(lpi*32+5);
    ch5(lpi+1) = pf_fp(lpi*32+6);
    ch6(lpi+1) = pf_fp(lpi*32+7);
    ch7(lpi+1) = pf_fp(lpi*32+8);
    ch8(lpi+1) = pf_fp(lpi*32+9);
    ch9(lpi+1) = pf_fp(lpi*32+10);
    ch10(lpi+1) = pf_fp(lpi*32+11);
    ch11(lpi+1) = pf_fp(lpi*32+12);
    ch12(lpi+1) = pf_fp(lpi*32+13);
    ch13(lpi+1) = pf_fp(lpi*32+14);
    ch14(lpi+1) = pf_fp(lpi*32+15);
    ch15(lpi+1) = pf_fp(lpi*32+16);
    ch16(lpi+1) = pf_fp(lpi*32+17);
    ch17(lpi+1) = pf_fp(lpi*32+18);
    ch18(lpi+1) = pf_fp(lpi*32+29);
    ch19(lpi+1) = pf_fp(lpi*32+20);
    ch20(lpi+1) = pf_fp(lpi*32+21);
    ch21(lpi+1) = pf_fp(lpi*32+22);
    ch22(lpi+1) = pf_fp(lpi*32+23);
    ch23(lpi+1) = pf_fp(lpi*32+24);
    ch24(lpi+1) = pf_fp(lpi*32+25);
    ch25(lpi+1) = pf_fp(lpi*32+26);
    ch26(lpi+1) = pf_fp(lpi*32+27);
    ch27(lpi+1) = pf_fp(lpi*32+28);
    ch28(lpi+1) = pf_fp(lpi*32+29);
    ch29(lpi+1) = pf_fp(lpi*32+30);
    ch30(lpi+1) = pf_fp(lpi*32+31);
    ch31(lpi+1) = pf_fp(lpi*32+32);
end

% fixed point coefficients
scale=2^18; %scaling factor for fixed point
ch0f=int16(scale*ch0);
ch1f=int16(scale*ch1); 
ch2f=int16(scale*ch2); 
ch3f=int16(scale*ch3); 
ch4f=int16(scale*ch4); 
ch5f=int16(scale*ch5); 
ch6f=int16(scale*ch6); 
ch7f=int16(scale*ch7); 
ch8f=int16(scale*ch8); 
ch9f=int16(scale*ch9); 
ch10f=int16(scale*ch10); 
ch11f=int16(scale*ch11); 
ch12f=int16(scale*ch12); 
ch13f=int16(scale*ch13); 
ch14f=int16(scale*ch14); 
ch15f=int16(scale*ch15); 
ch16f=int16(scale*ch16); 
ch17f=int16(scale*ch17); 
ch18f=int16(scale*ch18); 
ch19f=int16(scale*ch19); 
ch20f=int16(scale*ch20); 
ch21f=int16(scale*ch21); 
ch22f=int16(scale*ch22); 
ch23f=int16(scale*ch23); 
ch24f=int16(scale*ch24); 
ch25f=int16(scale*ch25); 
ch26f=int16(scale*ch26); 
ch27f=int16(scale*ch27); 
ch28f=int16(scale*ch28); 
ch29f=int16(scale*ch29); 
ch30f=int16(scale*ch30); 
ch31f=int16(scale*ch31); 

% AIE filter coeffs
filtAIE=single(pf); % test against simulink Golden reference using single precision floats
filtAIE2=reshape(filtAIE,[32,6]); % for AIE 32 ch filter % was AIE1 which is commented out
filtAIE2 = flip(filtAIE2); % reverse coefficient processing
filtAIE1=filtAIE2'; % make channel data a column for Simulink

filtAIE1_fp=int16(scale*pf); %/(max(pf)*2) ); % scale to 14 bits; cast to int16
filtAIE2_fp=reshape(filtAIE1_fp,[32,6]); % for AIE 32 ch filter % was AIE1 which is commented out
filtAIE2_fp = flip(filtAIE2_fp); % reverse coefficient processing
filtAIE1_fp=filtAIE2_fp'; % make channel data a column for Simulink
