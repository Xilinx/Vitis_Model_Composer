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





