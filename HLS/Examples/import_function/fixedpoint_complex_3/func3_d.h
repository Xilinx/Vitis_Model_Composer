// This example shows how to use complex signals and how to perform
// simple arithmetic operations on them

#include <complex>
#pragma XMC OUTPORT Out

void func3_d(std::complex< double > In1, std::complex< double > In2,
             std::complex< double > *Out)
{
   *Out = In1 + In2;
}





