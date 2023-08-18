function y = DES_print(data, valid, last)
    y = [];
    if nargin ~= 3
        error('DES_print:argChk', 'Wrong number of input arguments');
    end
    if (~strcmp(class(data),'uint32') || ~strcmp(class(valid),'embedded.fi') || ~strcmp(class(last),'embedded.fi'))
        error('DES_print:IllegalInputs', 'Illegal input parameters');
    end

    indices = find(double(valid));  % find valid indices (non-zero values)
    final = find(double(last));     % find the end-of-frame delimiter index
    if isempty(final)
        error('DES_print:IncompleteData', 'Incomplete Data: missing end-of-frame indicator in tlast');
    end
    if indices(end) ~= final
        error('DES_print:IncompleteData', 'Incomplete Data: truncated output sequence');
    end
    
    message = data(indices);    % only pick data where valid is asserted
    
    y = char(typecast(message,'uint8'))';
end