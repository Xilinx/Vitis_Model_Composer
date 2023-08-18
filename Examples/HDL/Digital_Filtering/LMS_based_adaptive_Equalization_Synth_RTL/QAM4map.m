function v = QAM4map(i)
% symbolic constants
twoThirds = xfix({xlUnsigned, 8, 8, xlRound, xlSaturate}, 2/3);
oneThird  = xfix({xlSigned, 9, 8, xlRound, xlSaturate}, 1/3);
minusOne = xfix({xlSigned, 9, 8, xlRound, xlSaturate}, -1);
minusOneThird  = xfix({xlSigned, 9, 8, xlRound, xlSaturate}, -1/3);
one = xfix({xlUnsigned, 1, 0, xlRound, xlSaturate}, 1);
msb = xl_slice(i, xl_nbits(i)-1, xl_nbits(i)-1);

% state variables
persistent r0, r0 = xl_state(0, {xlSigned, 10, 8});
persistent r1, r1 = xl_state(0, {xlSigned, 10, 8});

%pipeline latency = 2 sample periods
v  = r1;
r1 = r0;

if (msb == 1)
  if (twoThirds < -i)
    r0 = minusOne;
  else
    r0 = minusOneThird;
  end
else
  if (twoThirds < i)
    r0 = one;
  else
    r0 = oneThird;
  end
end
r0 = xfix({xlSigned, 10, 8, xlRound, xlSaturate}, r0);
