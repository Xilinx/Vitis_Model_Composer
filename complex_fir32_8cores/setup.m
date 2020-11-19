N = 32;  % number of taps
T = 10000; % Simulink simulation period

%% Filter coefficients
c = [30 31 28 29 26 27 24 25 22 23 20 21 18 19 16 17 ...
    14 15 12 13 10 11 8 9 6 7 4 5 2 3 0 1];

%Note that if you have a 32 tap filter designed in MATLAB (mfilt) you can take 
%the follwoing steps to create the header files:

% index = [30 31 28 29 26 27 24 25 22 23 20 21 18 19 16 17 ...
%    14 15 12 13 10 11 8 9 6 7 4 5 2 3 0 1];
%
% c= mfilt(index)
%  eq_coef0_0 = fliplr(c(32/2+1:2:end))
%  eq_coef0_1 = fliplr(c(1:2:32/2))
%  eq_coef1_0 = fliplr(c(1:2:end))
%  eq_coef1_1 = fliplr(c(2:2:end))


%input = repmat(randi([-10 10],1,20),1,T/20);
in = randi([-100 100],1,T);

in = complex(int16(in),int16(0));

in_even = in(1:2:end);
in_odd = in(2:2:end);
in_even_skip_1 =in_even(2:end);
in_even_skip_9 = in_even(10:end);
in_even_skip_8 = in_even(9:end);
in_odd_skip_8 = in_odd(9:end);





