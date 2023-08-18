function q = sreg(din, len, init)

persistent regs, regs = xl_state(init, din, len);
q = regs.back;
regs.push_front_pop_back(din);

