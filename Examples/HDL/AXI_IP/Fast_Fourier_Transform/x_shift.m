% x_shift.m
%
% - shift down input by 0-9 bit
% - assume din is 8 bit interger

function [dout] = x_shift(din, shift)

nbit   = xl_nbits(din);
nbinpt = xl_binpt(din);
tout=0;
switch shift
    case 0 
    tout = din;
    case 1 
    tout = din/2;
    case 2 
    tout = din/4;
    case 3 
    tout = din/8;
    case 4 
    tout = din/16;
    case 5 
    tout = din/32;
    case 6 
    tout = din/64;
    case 7 
    tout = din/128;
    case 8 
    tout = din/256;
    case 9 
    tout = din/512;
end

dout = tout;



