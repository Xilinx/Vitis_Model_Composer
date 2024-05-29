
% All frequency values are in Hz.

Fs = 100e3;  % Sampling Frequency
Fpass = 5000;              % Passband Frequency
Fstop = 18100;             % Stopband Frequency
Dpass = 0.1;   % Passband Ripple
Dstop = 0.0002;  % Stopband Attenuation
dens  = 16;                % Density Factor
% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);
% Calculate the coefficients using the FIRPM function.
coeffs = single(firpm(N, Fo, Ao, W, {dens}));

coeffs_AIE = [coeffs(16) coeffs(16) coeffs(16) coeffs(16) coeffs(16) coeffs(16) coeffs(16) coeffs(16)
              coeffs(15) coeffs(15) coeffs(15) coeffs(15) coeffs(15)  coeffs(15) coeffs(15) coeffs(15)
              coeffs(14) coeffs(14) coeffs(14) coeffs(14) coeffs(14)  coeffs(14) coeffs(14) coeffs(14)
              coeffs(13) coeffs(13) coeffs(13) coeffs(13) coeffs(13)  coeffs(13) coeffs(13) coeffs(13)
              coeffs(12) coeffs(12) coeffs(12) coeffs(12) coeffs(12)  coeffs(12) coeffs(12) coeffs(12)
              coeffs(11) coeffs(11) coeffs(11) coeffs(11)  coeffs(11)  coeffs(11) coeffs(11) coeffs(11)
              coeffs(10) coeffs(10) coeffs(10) coeffs(10) coeffs(10)  coeffs(10) coeffs(10) coeffs(10)
              coeffs(9) coeffs(9) coeffs(9)  coeffs(9) coeffs(9)  coeffs(9) coeffs(9) coeffs(9)
              coeffs(8) coeffs(8) coeffs(8) coeffs(8) coeffs(8)  coeffs(8) coeffs(8) coeffs(8)
              coeffs(7) coeffs(7) coeffs(7) coeffs(7)  coeffs(7)  coeffs(7) coeffs(7) coeffs(7)
              coeffs(6) coeffs(6) coeffs(6) coeffs(6) coeffs(6)  coeffs(6) coeffs(6) coeffs(6)
              coeffs(5) coeffs(5) coeffs(5) coeffs(5) coeffs(5)  coeffs(5) coeffs(5) coeffs(5)
              coeffs(4) coeffs(4) coeffs(4) coeffs(4) coeffs(4)  coeffs(4) coeffs(4) coeffs(4)
              coeffs(3) coeffs(3) coeffs(3) coeffs(3) coeffs(3)  coeffs(3) coeffs(3) coeffs(3)
              coeffs(2) coeffs(2) coeffs(2) coeffs(2) coeffs(2)  coeffs(2) coeffs(2) coeffs(2)
              coeffs(1) coeffs(1) coeffs(1) coeffs(1) coeffs(1)  coeffs(1) coeffs(1) coeffs(1)];

