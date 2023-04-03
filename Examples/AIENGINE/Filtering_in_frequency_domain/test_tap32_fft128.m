Nfft = 128;
NUM_OF_FRAMES = 2;

%% Generate a 32-tap filter:
% --> quantize to <s,16,0> representation:
tmp = firgr(30,[0,0.2,0.5,1],[1,1,0,0]);
tmp = double(int16(tmp*2^16))/2^16;
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
taps_fd = double(int16(fft([taps_td,zeros(1,Nblock)])*2^15))/2^15;