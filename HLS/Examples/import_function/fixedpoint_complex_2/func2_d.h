// You can also define a function template that uses a fixed-point data type
// of variable word length and integer length using function templates.
// The word length and integer length will be inherited from the input
// signal to the block.

#include <stdint.h>
#include <ap_fixed.h>

#pragma XMC OUTPORT out
template <int WordLen, int IntLen, int SIZE>
void func2_d(const ap_fixed<WordLen,IntLen> in1[SIZE],
             ap_fixed<WordLen+1,IntLen> &out)
{
   ap_fixed<WordLen,IntLen> acc = 0;
   for (int i=0; i<SIZE; i++) {
      acc = acc + in1[i];
   }
   out = acc;
}


