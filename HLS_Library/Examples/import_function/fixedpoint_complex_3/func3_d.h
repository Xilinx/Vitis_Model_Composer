// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
// This example shows how to use complex signals and how to perform
// simple arithmetic operations on them

#include <complex>
#pragma XMC OUTPORT Out

void func3_d(std::complex< double > In1, std::complex< double > In2,
             std::complex< double > *Out)
{
   *Out = In1 + In2;
}





