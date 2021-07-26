// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
// simple example to define the usage of fixed point signals

#include <stdint.h>
#include <ap_fixed.h>
#pragma XMC OUTPORT out

void func1_d(const ap_fixed<16,11> in1,
             const ap_fixed<16,11> in2,
             ap_fixed<17,11> &out)
{
   out = in1+in2;
}


