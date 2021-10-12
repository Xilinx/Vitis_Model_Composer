// In this example, the non-void function return type will
// result in an extra output port from the block

#include <stdint.h>

#pragma XMC INPORT in
#pragma XMC OUTPORT out

int16_t func5_a(int16_t in[5], int16_t out[5])
{
   int16_t acc=0;
   for (int i=0; i<5; i++) {
      out[i] = in[i]*2;
      acc = acc + in[i];
   }
   return acc;
}


