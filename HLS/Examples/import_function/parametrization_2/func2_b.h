// In this example two editable fields will get added to the block dialog box.
// Here template parameters can only be integer values.

#include <stdint.h>

template <int P1,int P2>
void func2_b(int16_t in, int8_t &out)
{
   out = P1*in + P2;
}


