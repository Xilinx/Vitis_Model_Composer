%% Number of blocks to run:
Nb = 100;
Nfft = 128;

%% Generate a 32-tap filter:
% --> quantize to <s,16,0> representation:
tmp = firgr(30,[0,0.2,0.5,1],[1,1,0,0]);
tmp = double(fi(tmp,1,16,16,'RoundingMethod','Nearest','OverflowAction','Saturate'));
taps_td = zeros(1,32);
taps_td(2:end) = tmp;

%% Plot filter characteristics:
figure;
[H,f] = freqz(taps_td,1,1e3,1);
subplot(2,1,1); 
stem(taps_td); xlabel('Sample Index'); ylabel('Tap Magnitude'); title('32-tap Filter');
subplot(2,1,2);
plot(f,20*log10(abs(H)),'b-');
grid on; xlabel('Normalized Frequency (Fs)'); ylabel('Magnitude (dB)');

%% Calculate filter taps in frequency domain
Ntaps = numel(taps_td);
Nblock = Nfft - Ntaps;
taps_fd_fxp = fi( fft([taps_td,zeros(1,Nblock)]), 1, 16, 15, 'RoundingMethod','Nearest','OverflowAction','Saturate');
taps_fd = double(taps_fd_fxp);