% 
% © Copyright 2022 Advanced Micro Devices, Inc.
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http:%www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

clear;
close all;

rng(1);

TT = numerictype(1,16,15);
FF = fimath('RoundingMethod','Nearest','OverflowAction','Saturate');

% ------------------------------------------------------------
% Channelizer Model
% ------------------------------------------------------------

% Specify # samples to match depth of DDR PL Data Movers:
% --> to yield desired 512 x 4 samples per stream, we need to scale down by 16 since channelizer model scales up 'dac_o' by this amount:
NSAMP_PER_CHAN = 512 / 16 * 4; 

app = channelizer_init(NSAMP_PER_CHAN, TT, FF);

% This computes the I/O permutation needed to drive the streams:
all_idx = [];
for ii = 0 : 7
  all_idx = cat(2,all_idx,circshift([0:15]',app.oversamp_ratio*ii));
end

% ------------------------------------------------------------
% Create Testbench Stimulus & Golden Reference for HLS Kernels
% ------------------------------------------------------------
permutei = permute_fb_i_gen_vectors(app, all_idx, TT,FF);
permuteo = permute_fb_o_gen_vectors(app, all_idx, TT,FF);
cyclicshift = cyclic_shift_gen_vectors(app, TT, FF);

% ------------------------------------------------------------
% Create Testbench Stimulus & Golden Reference for AIE Graphs
% ------------------------------------------------------------
dft = dft_gen_vectors(TT, FF);
filterbank = filterbank_gen_vectors(app, all_idx, TT, FF);

% ------------------------------------------------------------
% Create Testbench Stimulus & Golden Reference for Full Channelizer
% ------------------------------------------------------------
channelizer = channelizer_model(app, TT, FF );


function cyclicshift = cyclic_shift_gen_vectors(app, TT, FF) %#ok<STOUT>
    % ------------------------------------------------------------
    % Create Testbench Stimulus
    % ------------------------------------------------------------

    SSR_I = 8;
    SSR_O = 8;
    Nsamp = 128;

    % Generate inputs:
    backoff_dB = -18;
    sig = sqrt(0.5)*10^(0.05*backoff_dB)*complex(randn(app.Mchan,Nsamp),randn(app.Mchan,Nsamp));
    % Quantize:
    sig_i = double(fi(sig,TT,FF));


   % ------------------------------------------------------------
   % Cyclic Shift and RX IFFT
   % ------------------------------------------------------------
   state = 0;
   sig_o = zeros(app.Mchan,Nsamp);
   for bb = 1 : Nsamp
     % Compute shift amount:
     shift = state * app.Nshift;
     % Perform shift for next FFT input:
     sig_o(:,bb) = circshift(sig_i(:,bb),shift);
     % Update state:
     state = mod(state+1,app.Ncyclic);
   end

    % ------------------------------------------------------------
    % Write I/O Vectors
    % ------------------------------------------------------------
    idx = 1;
    for ss = 1 : 2 : Nsamp
      for xx = 1 : SSR_I
            % Create Simulink input vectors
            cyclicshift.sig(xx).i(idx) = sig_i(xx,ss+0);
            cyclicshift.sig(xx).i(idx+1) = sig_i(xx+SSR_I,ss+0);  
            cyclicshift.sig(xx).i(idx+2) = sig_i(xx,ss+1);
            cyclicshift.sig(xx).i(idx+3) = sig_i(xx+SSR_I,ss+1);

      end
      idx = idx + 4;
    end

    idx = 1;
    for ss = 1 : 2 : Nsamp
      for xx = 1 : SSR_O
            % Create golden reference output vectors
            cyclicshift.sig(xx).o(idx) = sig_o(2*xx-1,ss+0);
            cyclicshift.sig(xx).o(idx+1) = sig_o(2*xx,ss+0);    
            cyclicshift.sig(xx).o(idx+2) = sig_o(2*xx-1,ss+1);
            cyclicshift.sig(xx).o(idx+3) = sig_o(2*xx,ss+1);
      end
      idx = idx + 4;
    end
end

function permuteo = permute_fb_o_gen_vectors(app,all_idx,TT,FF) %#ok<STOUT>
    % ------------------------------------------------------------
    % Create Testbench Stimulus
    % ------------------------------------------------------------

    SSR = 8;
    Nsamp = 128;

    % Generate inputs:
    backoff_dB = -18;
    sig_i = sqrt(0.5)*10^(0.05*backoff_dB)*complex(randn(app.Mchan,Nsamp),randn(app.Mchan,Nsamp));

    % Quantize:
    sig_i = double(fi(sig_i,TT,FF));

    % Format inputs as they come from AIE FILTERBANK kernel:
    mix_i = zeros(SSR,2*Nsamp);
    mix_i(1,:) = reshape(cat(1,reshape(sig_i( 1,:),4,[]),reshape(sig_i( 2,:),4,[])),1,[]);
    mix_i(2,:) = reshape(cat(1,reshape(sig_i( 3,:),4,[]),reshape(sig_i( 4,:),4,[])),1,[]);
    mix_i(3,:) = reshape(cat(1,reshape(sig_i( 5,:),4,[]),reshape(sig_i( 6,:),4,[])),1,[]);
    mix_i(4,:) = reshape(cat(1,reshape(sig_i( 7,:),4,[]),reshape(sig_i( 8,:),4,[])),1,[]);
    mix_i(5,:) = reshape(cat(1,reshape(sig_i( 9,:),4,[]),reshape(sig_i(10,:),4,[])),1,[]);
    mix_i(6,:) = reshape(cat(1,reshape(sig_i(11,:),4,[]),reshape(sig_i(12,:),4,[])),1,[]);
    mix_i(7,:) = reshape(cat(1,reshape(sig_i(13,:),4,[]),reshape(sig_i(14,:),4,[])),1,[]);
    mix_i(8,:) = reshape(cat(1,reshape(sig_i(15,:),4,[]),reshape(sig_i(16,:),4,[])),1,[]);

    % Introduce 8 blocks of latency to match AIE filterbank
    sig_i = cat(2,zeros(app.Mchan,8),sig_i(:,1:end-8));
    
    % Generate outputs:
    perm = 0;
    sig_o = zeros(app.Mchan,Nsamp);
    for ss = 1 : Nsamp
      % Load next inputs into state:
      sig_o(:,ss) = sig_i(1+all_idx(:,1+perm),ss);
      perm = mod(perm+1,app.Ncyclic);
    end

    % ------------------------------------------------------------
    % Write I/O Vectors
    % ------------------------------------------------------------
    idx = 1;
    for ss = 1 : 4: size(mix_i,2)
      for xx = 1 : SSR
        % Create Simulink input vectors
        permuteo.sig(xx).i(idx) = mix_i(xx,ss+0);
        permuteo.sig(xx).i(idx+1) = mix_i(xx,ss+1);    
        permuteo.sig(xx).i(idx+2) = mix_i(xx,ss+2);
        permuteo.sig(xx).i(idx+3) = mix_i(xx,ss+3);
      end
      idx = idx + 4;
    end
   
    idx = 1;
    for ss = 1 : 2 : Nsamp
      for xx = 1 : SSR
        % Create golden reference output vectors
        permuteo.sig(xx).o(idx) = sig_o(xx,ss+0);
        permuteo.sig(xx).o(idx+1) = sig_o(xx+SSR,ss+0);    
        permuteo.sig(xx).o(idx+2) = sig_o(xx,ss+1);
        permuteo.sig(xx).o(idx+3) = sig_o(xx+SSR,ss+1);
      end
      idx = idx + 4;
    end
end

function permutei = permute_fb_i_gen_vectors(app,all_idx,TT,FF) %#ok<STOUT>

    % ------------------------------------------------------------
    % Create Testbench Stimulus
    % ------------------------------------------------------------

    SSR_I = 7;
    SSR_O = 8;
    Nsamp = 128;

    % Generate inputs:
    backoff_dB = -18;
    sig_i = sqrt(0.5)*10^(0.05*backoff_dB)*complex(randn(app.oversamp_ratio,Nsamp),randn(app.oversamp_ratio,Nsamp));

    % Quantize:
    sig_i = double(fi(sig_i, TT, FF));

    % Generate outputs:
    state = zeros(app.Mchan,1);
    perm = 0;
    sig_o = zeros(app.Mchan,Nsamp);
    for ss = 1 : Nsamp
      % Load next inputs into state:
      state(1:app.oversamp_ratio,1) = sig_i(:,ss);
      sig_o(1+all_idx(:,1+perm),ss) = state(:,1);
      perm = mod(perm+1,app.Ncyclic);
      state = circshift(state,app.oversamp_ratio);
    end

    % Introduce 8 blocks of latency to match C++ model:
    sig_o = cat(2,zeros(app.Mchan,8),sig_o(:,1:end-8));

    % Format into streams for Polyphase FIR AIE kernel:
    all_o = zeros(SSR_O,2*Nsamp);
    all_o(1,:) = reshape(cat(1,reshape(sig_o( 1,:),4,[]),reshape(sig_o( 2,:),4,[])),1,[]);
    all_o(2,:) = reshape(cat(1,reshape(sig_o( 3,:),4,[]),reshape(sig_o( 4,:),4,[])),1,[]);
    all_o(3,:) = reshape(cat(1,reshape(sig_o( 5,:),4,[]),reshape(sig_o( 6,:),4,[])),1,[]);
    all_o(4,:) = reshape(cat(1,reshape(sig_o( 7,:),4,[]),reshape(sig_o( 8,:),4,[])),1,[]);
    all_o(5,:) = reshape(cat(1,reshape(sig_o( 9,:),4,[]),reshape(sig_o(10,:),4,[])),1,[]);
    all_o(6,:) = reshape(cat(1,reshape(sig_o(11,:),4,[]),reshape(sig_o(12,:),4,[])),1,[]);
    all_o(7,:) = reshape(cat(1,reshape(sig_o(13,:),4,[]),reshape(sig_o(14,:),4,[])),1,[]);
    all_o(8,:) = reshape(cat(1,reshape(sig_o(15,:),4,[]),reshape(sig_o(16,:),4,[])),1,[]);
    
    % ------------------------------------------------------------
    % Write I/O Vectors
    % ------------------------------------------------------------
    idx = 1;
    for ss = 1 : 2 : Nsamp
      for xx = 1 : SSR_I
        % Create Simulink input vectors
        permutei.sig(xx).i(idx) = sig_i(xx,ss+0);
        permutei.sig(xx).i(idx+1) = sig_i(xx+SSR_I,ss+0);
        permutei.sig(xx).i(idx+2) = sig_i(xx,ss+1);
        permutei.sig(xx).i(idx+3) = sig_i(xx+SSR_I,ss+1);
      end
      idx = idx + 4;
    end
   
    idx = 1;
    for ss = 1 : 4 : 2*Nsamp
      for xx = 1 : SSR_O
        % Create golden reference output vectors
        permutei.sig(xx).o(idx) = all_o(xx,ss+0);
        permutei.sig(xx).o(idx+1) = all_o(xx,ss+1);    
        permutei.sig(xx).o(idx+2) = all_o(xx,ss+2);
        permutei.sig(xx).o(idx+3) = all_o(xx,ss+3);
      end
      idx = idx + 4;
    end


end

function filterbank = filterbank_gen_vectors(app, all_idx, TT, FF)

    % ------------------------------------------------------------
    % Create input signal to Polyphase filter
    % ------------------------------------------------------------

    Nsamp = 7*256*app.Mchan;
    backoff_dB = -18;
    sig_i = sqrt(0.5)*10^(0.05*backoff_dB)*complex(randn(1,Nsamp),randn(1,Nsamp));

    % Quantize:
    sig_i = double(fi(sig_i,TT,FF));


    % ------------------------------------------------------------
    % Golden Model
    % ------------------------------------------------------------

    taps_rx = double(reshape(app.taps,app.Mchan,[]));
    dac_o = sig_i;
    Nblock = numel(dac_o) / app.oversamp_ratio;
    data_i = reshape(dac_o,app.oversamp_ratio,[]);
    data_i = data_i(end:-1:1,:);            % Reverse order so newer samples at lower indices
    state = zeros(app.Mchan,app.Ntaps);             % Filter has Ntaps per phase
    rx_filt_o = zeros(app.Mchan,Nblock);
    collect_i = zeros(app.Mchan,Nblock);      % Collect input  data into filters
    collect_o = zeros(app.Mchan,Nblock);      % Collect output data from filters
    collect_s = zeros(app.Mchan,app.Ntaps);      % Collect state used in filters (debug)
    perm = 0;
    for bb = 1 : Nblock
      % Load next inputs into state:
      state(1:app.oversamp_ratio,1) = data_i(:,bb);
      % Compute next filter output:
      rx_filt_o(:,bb) = ...
          double(fi(sum(taps_rx .* state,2),1,16,15,'RoundingMethod','Nearest','OverflowAction','Saturate'));
      % Collect inputs and outputs:
      % --> Permute to assign to the proper filter engines:
      collect_i(1+all_idx(:,1+perm),bb) = state(:,1);
      collect_s = circshift(collect_s,1,2);
      collect_s(:,1) = state(:,1);
      collect_o(1+all_idx(:,1+perm),bb) = rx_filt_o(:,bb);
      perm = mod(perm+1,8);
      % Update state using serpentine shift:
      tmp = circshift(reshape(state,1,[]),app.oversamp_ratio);
      tmp(1:app.oversamp_ratio) = 0;
      state = reshape(tmp,app.Mchan,[]);
    end

    % Now, collect contains input into filter engines, need to assign to input streams:
    filterbank.sig0_i = reshape(cat(1,reshape(collect_i( 1,:),4,[]),reshape(collect_i( 2,:),4,[])),1,[]);
    filterbank.sig1_i = reshape(cat(1,reshape(collect_i( 3,:),4,[]),reshape(collect_i( 4,:),4,[])),1,[]);
    filterbank.sig2_i = reshape(cat(1,reshape(collect_i( 5,:),4,[]),reshape(collect_i( 6,:),4,[])),1,[]);
    filterbank.sig3_i = reshape(cat(1,reshape(collect_i( 7,:),4,[]),reshape(collect_i( 8,:),4,[])),1,[]);
    filterbank.sig4_i = reshape(cat(1,reshape(collect_i( 9,:),4,[]),reshape(collect_i(10,:),4,[])),1,[]);
    filterbank.sig5_i = reshape(cat(1,reshape(collect_i(11,:),4,[]),reshape(collect_i(12,:),4,[])),1,[]);
    filterbank.sig6_i = reshape(cat(1,reshape(collect_i(13,:),4,[]),reshape(collect_i(14,:),4,[])),1,[]);
    filterbank.sig7_i = reshape(cat(1,reshape(collect_i(15,:),4,[]),reshape(collect_i(16,:),4,[])),1,[]);

    % Now, collect contains input into filter engines, need to assign to input streams:
    filterbank.sig0_o = reshape(cat(1,reshape(collect_o( 1,:),4,[]),reshape(collect_o( 2,:),4,[])),1,[]);
    filterbank.sig1_o = reshape(cat(1,reshape(collect_o( 3,:),4,[]),reshape(collect_o( 4,:),4,[])),1,[]);
    filterbank.sig2_o = reshape(cat(1,reshape(collect_o( 5,:),4,[]),reshape(collect_o( 6,:),4,[])),1,[]);
    filterbank.sig3_o = reshape(cat(1,reshape(collect_o( 7,:),4,[]),reshape(collect_o( 8,:),4,[])),1,[]);
    filterbank.sig4_o = reshape(cat(1,reshape(collect_o( 9,:),4,[]),reshape(collect_o(10,:),4,[])),1,[]);
    filterbank.sig5_o = reshape(cat(1,reshape(collect_o(11,:),4,[]),reshape(collect_o(12,:),4,[])),1,[]);
    filterbank.sig6_o = reshape(cat(1,reshape(collect_o(13,:),4,[]),reshape(collect_o(14,:),4,[])),1,[]);
    filterbank.sig7_o = reshape(cat(1,reshape(collect_o(15,:),4,[]),reshape(collect_o(16,:),4,[])),1,[]);

end
% ============================================================

function dft = dft_gen_vectors(TT,FF)

    % ------------------------------------------------------------
    % Create input signal to IDFT
    % ------------------------------------------------------------
    Nsamp = 8*16384;
    backoff_dB = -18;
    sig_i = sqrt(0.5)*10^(0.05*backoff_dB)*complex(randn(1,Nsamp),randn(1,Nsamp));

    % Quantize:
    sig_i = fi(sig_i,TT,FF);

    % ------------------------------------------------------------
    % Create Twiddle Matrix for IDFT
    % ------------------------------------------------------------
    M = 16;
    twiddle = zeros(M,M);
    omega = exp(1i*2*pi/M);
    for rr = 1 : M
      for cc = 1 : M
        twiddle(rr,cc) = omega^((rr-1)*(cc-1));
      end
    end
    % Take transpose since we formulate the diagrams this way:
    twiddle = transpose(twiddle);

    % Quantize:
    twiddle = fi(twiddle,TT,'RoundingMethod','Convergent','OverflowAction','Saturate');

    % ------------------------------------------------------------
    % Compute Output of All Tiles
    % ------------------------------------------------------------
    
    % We will take transforms down the columns:
    sig_i = reshape(sig_i,M,[]);
    
    % Compute the whole transform:
    all_o = zeros(size(sig_i));
    for ii = 1 : size(sig_i,2)
        all_o(:,ii) = double(transpose(sig_i(:,ii))) * double(twiddle);
    end
    
    % Quantize:
    all_o   = fi(  all_o,TT,FF);

    % ------------------------------------------------------------
    % Create Input Files
    % ------------------------------------------------------------

    % Tile A Stream 0
    stream0 = reshape(sig_i(1:2,:),1,[]);
    dft(1).i = double(stream0);

    % Tile A Stream 1
    stream1 = reshape(sig_i(3:4,:),1,[]);
    dft(2).i = double(stream1);

    % Tile B Stream 0
    stream0 = reshape(sig_i(5:6,:),1,[]);
    dft(3).i = double(stream0);

    % Tile B Stream 1
    stream1 = reshape(sig_i(7:8,:),1,[]);
    dft(4).i = double(stream1);

    % Tile C Stream 0
    stream0 = reshape(sig_i(9:10,:),1,[]);
    dft(5).i = double(stream0);

    % Tile C Stream 1
    stream1 = reshape(sig_i(11:12,:),1,[]);
    dft(6).i = double(stream1);

    % Tile D Stream 0
    stream0 = reshape(sig_i(13:14,:),1,[]);
    dft(7).i = double(stream0);

    % Tile D Stream 1
    stream1 = reshape(sig_i(15:16,:),1,[]);
    dft(8).i = double(stream1);

    % ------------------------------------------------------------
    % Create Golden Outputs
    % ------------------------------------------------------------

    % Data comes out on even streams first, then odd streams second as we go across the columns:
    data = reshape(all_o,4,[]);

    stream0 = reshape(data(:,1:8:end),1,[]);
    dft(1).o = double(stream0);

    stream2 = reshape(data(:,2:8:end),1,[]);
    dft(3).o = double(stream2);

    stream4 = reshape(data(:,3:8:end),1,[]);
    dft(5).o = double(stream4);

    stream6 = reshape(data(:,4:8:end),1,[]);
    dft(7).o = double(stream6);

    stream1 = reshape(data(:,5:8:end),1,[]);
    dft(2).o = double(stream1);

    stream3 = reshape(data(:,6:8:end),1,[]);
    dft(4).o = double(stream3);

    stream5 = reshape(data(:,7:8:end),1,[]);
    dft(6).o = double(stream5);

    stream7 = reshape(data(:,8:8:end),1,[]);
    dft(8).o = double(stream7);

end

% ============================================================

% ------------------------------------------------------------
% Channelizer Initialization
% ------------------------------------------------------------

function [app] = channelizer_init( NSAMP_PER_CHAN, TT, FF )

   app = [];
   app.OSR_0.Value = 0;
   app.OSR_1.Value = 0;
   app.OSR_2.Value = 0;
   app.OSR_3.Value = 1;
   app.SamplingFrequencySwitch.Value = 10.5;
   app.ChannelsMKnob.Value = 16;
   app.Active.Value = 5;
   app.fs_Gsps = 10.5;
   app.Mchan = 16;
   app.Ntaps = 8;
   app.Active.Limits = [1,app.Mchan-2];
   list = randi([1,app.Mchan],1,10000);
   list_use = setdiff(list-1,[0,app.Mchan/2],'stable');
   app.chan_id = sort(list_use(1:app.Active.Value));
   app.bw_trans_oneside = 45;                 % Single-sided transition bandwidth (percent)
                                              % Signal construction filter:
   app.sig_passband_ripple_dB = 0.10;            % Peak-to-peak ripple
   app.sig_stopband_attenu_dB = -80;
   app.sig_passband = 0.50;                    % Fraction of 0.5*fc_Msps
   app.sig_stopband = 0.65;                    % Fraction of 0.5*fc_Msps
   app.Nframe = 1024;
   app.Nfrac_bits = 11;
   if ( app.OSR_0.Value == 1 )
     app.OSR = 0;
     app.P = 1;
     app.Q = 1;
     app.oversamp_ratio = app.Mchan*app.Q/app.P;
     app.Ncyclic = 1;
     app.Nshift = 0;
   elseif ( app.OSR_1.Value == 1)
     app.OSR = 1;
     app.P = 2;
     app.Q = 1;
     app.oversamp_ratio = app.Mchan*app.Q/app.P;
     app.Ncyclic = lcm(app.Mchan,app.oversamp_ratio)/app.oversamp_ratio;
     app.Nshift = app.Mchan / app.Ncyclic;
   elseif (app.OSR_2.Value == 1)
     app.OSR = 2;
     app.P = 4;
     app.Q = 3;
     app.oversamp_ratio = app.Mchan*app.Q/app.P;
     app.Ncyclic = lcm(app.Mchan,app.oversamp_ratio)/app.oversamp_ratio;
     app.Nshift = app.Mchan / app.Ncyclic;
   elseif (app.OSR_3.Value == 1)
     app.OSR = 3;
     app.P = 8; 
     app.Q = 7;
     app.oversamp_ratio = app.Mchan*app.Q/app.P;
     app.Ncyclic = lcm(app.Mchan,app.oversamp_ratio)/app.oversamp_ratio;
     app.Nshift = app.Mchan / app.Ncyclic;
   end
   app.Nsamp = app.Q * NSAMP_PER_CHAN;
   app.fc_Msps = 1000 * app.fs_Gsps / app.Mchan;
   app.fs_Msps = 1000 * app.fs_Gsps / app.Mchan * app.P / app.Q;
   % Design prototype filter to operate @ app.fc_Msps sampling rate:
   fp = (1-app.bw_trans_oneside/100) * (0.5*app.fc_Msps);
   fs = (1+app.bw_trans_oneside/100) * (0.5*app.fc_Msps);
   tmp = firgr(app.Ntaps*app.Mchan-2,[0,fp,fs,500*app.fs_Gsps]/(500*app.fs_Gsps),[1,1,0,0]);
   taps = [zeros(1,1),tmp];
   taps = double(fi(taps,TT,FF));
   app.taps = reshape(taps,app.Mchan,[]);
   
   % Design prototype filter to operate @ app.fc_Msps sampling rate (since implemented at TX):
   fp = app.sig_passband * 0.5 * app.fc_Msps;
   fs = app.sig_stopband * 0.5 * app.fc_Msps;
   ripple = [0.5*(10^(0.05*app.sig_passband_ripple_dB)-1),10^(0.05*app.sig_stopband_attenu_dB)];
   app.taps_sig = firgr('minevn',[0,fp,fs,0.5*app.fc_Msps]/(0.5*app.fc_Msps),[1,1,0,0],ripple);
   
   % Compute channel centers:
   tmp = -0.5*app.fs_Gsps : app.fs_Gsps/app.Mchan : 0.5*app.fs_Gsps;
   tmp = circshift(tmp(1:end-1),-app.Mchan/2);
   app.chan_centers_GHz = tmp(1+app.chan_id);
end

% ------------------------------------------------------------
% Channelizer Model
% ------------------------------------------------------------

function channelizer = channelizer_model( app, TT, FF)

    SSR_I = 7;

   % ------------------------------------------------------------
   % Create Input Channels
   % ------------------------------------------------------------

   backoff_dB = -18;
   sig_i = zeros(numel(app.chan_id),app.Nsamp);
   for mm = 1 : numel(app.chan_id)
     tmp = sqrt(0.5)*10^(0.05*backoff_dB)*complex(randn(1,app.Nsamp),randn(1,app.Nsamp));
     sig_i(mm,:) = filter(app.taps_sig,1,tmp);
   end
   sig_i = double(fi(sig_i,1,13,12,'RoundingMethod','Nearest','OverflowAction','Saturate'));

   % ------------------------------------------------------------
   % Perform TX IFFT
   % ------------------------------------------------------------

   % Note: use of IFFT here matches 'tuning concept' for upconversion:
   ifft_i = zeros(app.Mchan,app.Nsamp);
   ifft_i(1+app.chan_id,:) = sig_i;
   ifft_o = zeros(app.Mchan,app.Nsamp);
   for ss = 1 : app.Nsamp
     tmp = ifft_i(:,ss);       
     ifft_o(:,ss) = app.Mchan*ifft(tmp);
   end

   % ------------------------------------------------------------
   % Perform Polyphase Filtering at DAC:
   % ------------------------------------------------------------

   taps_tx = reshape(app.Mchan*app.taps,app.Mchan,[]); % Note scale factor due to interpolation
   filt_o = zeros(app.Mchan,app.Nsamp);
   for mm = 1 : app.Mchan
     tx_filt_o(mm,:) = filter(taps_tx(mm,:),1,ifft_o(mm,:));
   end
   dac_o = reshape(tx_filt_o,1,[]);
   
   % Quantize for H/W implementation:
   dac_o = double(fi(dac_o,TT,FF));

   % ------------------------------------------------------------
   % Perform Polyphase Filtering at ADC:
   % ------------------------------------------------------------

   % Now we assume P/Q oversampling at the RX channelizer:
   taps_rx = reshape(app.taps,app.Mchan,[]);
   Nblock = numel(dac_o) / app.oversamp_ratio;
   data_i = reshape(dac_o,app.oversamp_ratio,[]);
   data_i = data_i(end:-1:1,:);            % Reverse order so newer samples at lower indices
   state = zeros(app.Mchan,app.Ntaps);             % Filter has Ntaps per phase
   rx_filt_o = zeros(app.Mchan,Nblock);
   for bb = 1 : Nblock
     % Load next inputs into state:
     state(1:app.oversamp_ratio,1) = data_i(:,bb);
     % Compute next filter output:
     rx_filt_o(:,bb) = sum(taps_rx .* state,2);
     % Update state using serpentine shift:
     tmp = circshift(reshape(state,1,[]),app.oversamp_ratio);
     tmp(1:app.oversamp_ratio) = 0;
     state = reshape(tmp,app.Mchan,[]);
   end

   % Quantize to match AIE model:
   rx_filt_o = double(fi(rx_filt_o,TT,FF));

   % Introduce 16 blocks of latency to match system:
   rx_filt_o = cat(2,zeros(app.Mchan,16),rx_filt_o(:,1:end-16));
   
   % ------------------------------------------------------------
   % Create Twiddle Matrix for IDFT
   % ------------------------------------------------------------

   M = 16;
   twiddle = zeros(M,M);
   omega = exp(1i*2*pi/M);   
   for rr = 1 : M
     for cc = 1 : M
       twiddle(rr,cc) = omega^((rr-1)*(cc-1));  
     end
   end
   % Take transpose since we formulate the diagrams this way:
   twiddle = transpose(twiddle);

   % Quantize:
   twiddle = double(fi(twiddle,TT,'RoundingMethod','Convergent','OverflowAction','Saturate'));
   
   % ------------------------------------------------------------
   % Cyclic Shift and RX IFFT
   % ------------------------------------------------------------

   state = 0;
   fft_o = zeros(app.Mchan,Nblock);
   all_o = zeros(app.Mchan,Nblock);
   for bb = 1 : Nblock
     % Compute shift amount:
     shift = state * app.Nshift;
     % Perform shift for next FFT input:
     fft_i = circshift(rx_filt_o(:,bb),shift);
     % Apply transform:
     all_o(:,bb) = transpose(fft_i) * twiddle;
     fft_o(:,bb) = app.Mchan * ifft( fft_i );
     % Update state:
     state = mod(state+1,app.Ncyclic);
   end

   % ------------------------------------------------------------
    % Dump File I/O for HW Emulation / VCK190
    % ------------------------------------------------------------

    % Need to send these '4 samples at a time' for each stream, interleaving streams after each set of 4:
    idx = 1;
    for ss = 1 : 2 : size(data_i,2)
      for xx = 1 : SSR_I
            % Create Simulink input vectors
            channelizer(xx).i(idx) = data_i(xx,ss+0);
            channelizer(xx).i(idx+1) = data_i(xx+SSR_I,ss+0);
            channelizer(xx).i(idx+2) = data_i(xx,ss+1);
            channelizer(xx).i(idx+3) = data_i(xx+SSR_I,ss+1);

      end
      idx = idx + 4;
    end

    % Data comes out on even streams first, then odd streams second as we go across the columns:
    all_o = double(fi(all_o,TT,FF));
    data = reshape(all_o,4,[]);
    channelizer(1).o = reshape(data(:,1:8:end),1,[]);
    channelizer(3).o = reshape(data(:,2:8:end),1,[]);
    channelizer(5).o = reshape(data(:,3:8:end),1,[]);
    channelizer(7).o = reshape(data(:,4:8:end),1,[]);
    channelizer(2).o = reshape(data(:,5:8:end),1,[]);
    channelizer(4).o = reshape(data(:,6:8:end),1,[]);
    channelizer(6).o = reshape(data(:,7:8:end),1,[]);
    channelizer(8).o = reshape(data(:,8:8:end),1,[]);

end




