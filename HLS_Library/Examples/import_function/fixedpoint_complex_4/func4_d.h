// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
// This example shows how to use complex signals and parameterize
// the datatype


#include <complex>
#pragma XMC OUTPORT Out

template <typename TYPE>
void func4_d(std::complex< TYPE > In1, std::complex< TYPE > In2,
             std::complex< TYPE > *Out)
{
   *Out = In1 * In2;
}





