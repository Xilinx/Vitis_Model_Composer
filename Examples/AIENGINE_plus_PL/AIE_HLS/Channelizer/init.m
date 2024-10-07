%% Basic parameters
N = 1024*2;
Ts = 16*(7/4)/8.75e9;
ch_filt_coef = rcosdesign(0.22,4,28,'normal');
ch_filt_coef = 28 * ch_filt_coef / sum(ch_filt_coef(:));

%% Twiddle factors
load twid.mat
twidA0 = int16(twidA0*2^15);
twidA1 = int16(twidA1*2^15);
twidB0 = int16(twidB0*2^15);
twidB1 = int16(twidB1*2^15);
twidC0 = int16(twidC0*2^15);
twidC1 = int16(twidC1*2^15);
twidD0 = int16(twidD0*2^15);
twidD1 = int16(twidD1*2^15);

%% Filter taps
taps_init;

%% Dashboard controls
% enable individual subchannels
ch0_en = 0; ch1_en = 1; ch2_en = 1; ch3_en = 0;
ch4_en = 0; ch5_en = 1; ch6_en = 1; ch7_en = 0;
ch8_en = 0; ch9_en = 0; ch10_en = 0; ch11_en = 0; 
ch12_en = 0; ch13_en = 0; ch14_en = 0; ch15_en = 0;

% enable QAM modulation on subchannel
ch0_qam = 0; ch1_qam = 0; ch2_qam = 0; ch3_qam = 0; 
ch4_qam = 0; ch5_qam = 1; ch6_qam = 1; ch7_qam = 0;
ch8_qam = 0; ch9_qam = 0; ch10_qam = 0; ch11_qam = 0;
ch12_qam = 0; ch13_qam = 0; ch14_qam = 0; ch15_qam = 0;

% enable frequency sweep on subchannel
ch0_swp = 0; ch1_swp = 0; ch2_swp = 0; ch3_swp = 0; 
ch4_swp = 0; ch5_swp = 0; ch6_swp = 0; ch7_swp = 0; 
ch8_swp = 0; ch9_swp = 0; ch10_swp = 0; ch11_swp = 0;
ch12_swp = 0; ch13_swp = 0; ch14_swp = 0; ch15_swp = 0;

% set sweep rate on subchannels
swp_rate0 = 0; swp_rate1 = 0; swp_rate2 = 0; swp_rate3 = 0;
swp_rate4 = 0; swp_rate5 = 0; swp_rate6 = 0; swp_rate7 = 0;
swp_rate8 = 0; swp_rate9 = 0; swp_rate10 = 0; swp_rate11 = 0;
swp_rate12 = 0; swp_rate13 = 0; swp_rate14 = 0; swp_rate15 = 0;

% select subbands to display on spectrum analyzers
spec1_ch = 1; spec2_ch = 2; spec3_ch = 5; spec4_ch = 6;