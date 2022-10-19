function [pr, pi] = complex_mult(ar, ai, br, bi, negate_bi)
% types:
%     ar, ai = xfix(12,10)
%     br, bi = xfix(18,10)
  
% partial products pipeline registers
persistent pr0, pr0 = xl_state(0, {xlSigned, 30, 20});
persistent pr1, pr1 = xl_state(0, {xlSigned, 30, 20});

persistent pr2, pr2 = xl_state(0, {xlSigned, 30, 20});
persistent pr3, pr3 = xl_state(0, {xlSigned, 30, 20});

persistent pr4, pr4 = xl_state(0, {xlSigned, 30, 20});
persistent pr5, pr5 = xl_state(0, {xlSigned, 30, 20});

persistent pr6, pr6 = xl_state(0, {xlSigned, 30, 20});
persistent pr7, pr7 = xl_state(0, {xlSigned, 30, 20});

%output sum pipeline registers
persistent pr8, pr8 = xl_state(0, {xlSigned, 36, 28});
persistent pr9, pr9 = xl_state(0, {xlSigned, 36, 28});

persistent pr10, pr10 = xl_state(0, {xlSigned, 36, 28});
persistent pr11, pr11 = xl_state(0, {xlSigned, 36, 28});

if (negate_bi == 0)
  pr  = pr9;
  pr9 = pr8;
  pr8 = pr1 - pr3;
else
  pr  = pr8;
  pr8 = pr1 + pr3;
end


if (negate_bi == 0)
  pi   = pr11;
  pr11 = pr10;
  pr10 = pr5 + pr7;
else
  pi   = pr10;
  pr10 = pr7 - pr5;
end

pr1 = pr0;
pr0 = ar * br;

pr3 = pr2;
pr2 = ai * bi;

pr5 = pr4;
pr4 = ar * bi;

pr7 = pr6;
pr6 = ai * br;
