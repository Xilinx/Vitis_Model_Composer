load twid.mat

twidA0 = int16(twidA0*2^15);
twidA1 = int16(twidA1*2^15);
twidB0 = int16(twidB0*2^15);
twidB1 = int16(twidB1*2^15);
twidC0 = int16(twidC0*2^15);
twidC1 = int16(twidC1*2^15);
twidD0 = int16(twidD0*2^15);
twidD1 = int16(twidD1*2^15);

N = 1024*2;

R = repmat(0:28:N*28-1,4,1);

I1 = reshape([14 7 28 21]'*ones(1,N) + R,[],1);
I2 = reshape([13 6 27 20]'*ones(1,N) + R,[],1);
I3 = reshape([12 5 26 19]'*ones(1,N) + R,[],1);
I4 = reshape([11 4 25 18]'*ones(1,N) + R,[],1);
I5 = reshape([10 3 24 17]'*ones(1,N) + R,[],1);
I6 = reshape([9  2 23 16]'*ones(1,N) + R,[],1);
I7 = reshape([8  1 22 15]'*ones(1,N) + R,[],1);

ch0 = 1;
ch1 = 1;
ch2 = 1;
ch3 = 1;
ch4 = 1;
ch5 = 1;
ch6 = 1;
ch7 = 1;
ch8 = 1;
ch9 = 1;
ch10 = 1;
ch11 = 1;
ch12 = 1;
ch13 = 1; 
ch14 = 1;
ch15 = 1;

taps_init;