function [mu_e_i, e_i, e_q, mu_e_q] = lmsErr(sym_i, filt_i, sym_q, filt_q, mu)

persistent r0, r0 = xl_state(mu, {xlSigned, 18, 15, xlRound, xlWrap});
persistent r1, r1 = xl_state(mu, {xlSigned, 18, 15, xlRound, xlWrap});
persistent r2, r2 = xl_state(mu, {xlSigned, 18, 15, xlRound, xlWrap});
persistent r3, r3 = xl_state(mu, {xlSigned, 18, 15, xlRound, xlWrap});
persistent r4, r4 = xl_state(mu, {xlSigned, 18, 15, xlRound, xlWrap});
persistent r5, r5 = xl_state(mu, {xlSigned, 18, 15, xlRound, xlWrap});

mu = xfix({xlSigned, 18, 15, xlRound, xlSaturate}, mu);

e_i = r4;
r4  = sym_i - filt_i;

e_q = r5;
r5  = sym_q - filt_q;

mu_e_i = r0;
r0 = r1;
r1 = r4 * mu;

mu_e_q = r2;
r2 = r3;
r3 = -r5 * mu;

    
