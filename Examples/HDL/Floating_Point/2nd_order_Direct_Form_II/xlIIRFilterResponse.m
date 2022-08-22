function f = xlIIRFilterResponse(filter_ip, filter_op)
persistent iir_ip;
persistent iir_op;
persistent samplecount;
f = [1];

%Clear every thing
if nargin == 0,
    iir_ip = [];
    iir_op = [];
    samplecount = [];
    return;
end;

if (isempty(iir_ip))
    iir_ip = [];
    iir_op = [];
end;

if (isempty(samplecount))
    samplecount = 0;
end;

FREQ_RES = 48000;

if samplecount == FREQ_RES,
    Filter_Nr = [ 0.006724179185729 0 -0.006724179185729];
    Filter_Dr = [ 1.000000000000000  -1.576037380547040   0.986551641628541];
    h = figure;
    clf;
    set(h,'Name','  Second Order IIR Peaking Filter');
    set(h,'Position',[100 50 1000 800]);

    subplot(2,2,1);
    freqz(Filter_Nr, Filter_Dr);
    title('Second Order IIR Peaking Filter (Q:95)');

    freq_ip_raw = abs(fft(iir_ip,FREQ_RES));
    ip_max = max(freq_ip_raw);
    freq_ip = 20*log(freq_ip_raw/ip_max);
    subplot(2,2,3);
    plot(freq_ip(1:FREQ_RES/2) );
    xlabel('Frequency(Hz)');
    ylabel('Magnitude(dB)');
    Ti = 'NoisyInput - Fs: 48KHz; Sig Freq: 5KHz; SNR: -13dB';
    title(Ti);

    freq_op_raw = abs(fft(iir_op,FREQ_RES));
    freq_op = 20*log(freq_op_raw/ip_max);
    subplot(2,2,4);
    plot(freq_op(1:FREQ_RES/2));
    xlabel('Frequency(Hz)');
    ylabel('Magnitude(dB)');
    title('Filter Output - Fs: 48KHz; Sig Freq: 5KHz;');

    set_param(bdroot(gcbh),'SimulationCommand','stop');
    return;
else
    iir_ip(end+1) = filter_ip;
    iir_op(end+1) = filter_op;
    samplecount = samplecount + 1;
end;





