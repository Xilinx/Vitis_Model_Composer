#include "basic_array.h"

void basic_array(
   uint8_t out1[4], 
   const uint8_t in1[4], 
   const uint8_t in2[4])
{
   for (uint8_t k0 = 0; k0 < 4; ++k0) {
      out1[k0] = in1[k0] + in2[k0];
   }
};
