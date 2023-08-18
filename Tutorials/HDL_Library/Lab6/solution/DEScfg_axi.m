% This function takes as arguments the DES key, a message string (char
% array), and an optional "decrypt" switch (default is to encrypt). It
% performs simple input validation, formats the message into a uint32 array
% with appropriate padding to the DES block size, and finally prepares a
% struct for use during the simulation. This struct should be assigned to
% the workspace variable A for use with the Simulink model.
function y = DEScfg_axi(k,m,e)
    y = struct();
    if nargin < 1
        error('DEScgf:argChk', 'Wrong number of input arguments');
    end
    if ~ischar(m) || ~ischar(k)
        error('DEScfg:IllegalInputs', 'Illegal input parameters');
    end
    
    y.decrypt = false;
    
    if nargin == 3 
        if ~ischar(e) || (~strcmpi(e,'encrypt') && ~ strcmpi(e,'decrypt'))
            error('DEScfg:IllegalOp', 'Illegal operation specified');
        end
        if strcmpi(e,'decrypt')
            y.decrypt = true;
        end
    end
    
    
    if strfind(k,'0x') == 1
        % hexstring beginning with '0x'
        k(1:2) = '  ';
        k = strtrim(k);
    end
    if strfind(k,'$') == 1
        % hexstring beginning with '$'
        k(1) = ' ';
        k = strtrim(k);
    end
    
    % parse the key input parameter (char array type) as a hex string
    % 8 hex characters at a time, then convert each word to uint32.
    klen = length(k);
    kwords = floor(klen/8);
    krem = mod(klen, 8);
    if krem > 0 || kwords ~= 2
        error('DEScfg:argChk', 'Key string has illegal length');
    end
    key = zeros(kwords,1,'uint32');
    for i = 1:kwords
        lo = 8*(i-1)+1;
        hi = (8*i);
        substr = k(lo:hi);
        key(i) = hex2dec(substr);
    end
    
    y.key = key;
    
    % parse message input (char array)
    mLen = length(m);       % determine length of unpadded message
    nBlk = ceil(mLen/8);    % number of blocks for message padded to next even multiple of block size (8 bytes)
    nPad = nBlk * 8 - mLen; % difference is number of padding bytes to add
    
    % cast char to uint8, append null-bytes as padding to create full blocks, 
    % typecast as uint32 array (wordsize of the 32-bit AXI-Stream interface)
    % The byte order adjustments to match the DES algorithm conventions are
    % made in the receive / transmit interface blocks now.
    paddedMsg = typecast(padarray(cast(m, 'uint8'), [0 nPad], 0, 'post'), 'uint32');

    nPhases = 2;
    Rate = 3;
    initialDelay = 16;
    Time = kron((initialDelay:Rate:(nBlk*nPhases*Rate + initialDelay-1) - ones(1,nPhases*nBlk)), [1 1]) + repmat([0 1], 1, nPhases*nBlk);
    % Message time series
    y.M = timeseries(kron(paddedMsg, uint32([1 0])), Time, 'Name', 'Msg');
    % AXI Stream _tvalid
    y.valid = timeseries(kron(ones(1,nPhases*nBlk), [1 0]), Time, 'Name', 'tvalid');
    % AXI Stream _tlast end-of-frame delimiter
    y.last = timeseries(kron([zeros(1,nPhases*nBlk-1) 1], [1 0]), Time, 'Name', 'tlast');
    
    y.len = nBlk;
    %y.runtime = Time(end) + 8 + 32 + 16;
end

