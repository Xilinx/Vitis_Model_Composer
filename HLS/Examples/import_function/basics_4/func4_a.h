
// In this example, we see how to specify port directions explicitly using 
// XMC pragma.Note the usage of .h for function declaration and .cpp file 
// for function definition.
// Without the pragmas, both arguments will be set as output ports of the block.

#include <stdint.h>

#pragma XMC INPORT in
#pragma XMC OUTPORT out

void func4_a(int16_t in[5], int16_t out[5]);


