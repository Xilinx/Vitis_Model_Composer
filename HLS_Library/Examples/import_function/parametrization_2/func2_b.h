// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
// In this example two editable fields will get added to the block dialog box.
// Here template parameters can only be integer values.

#include <stdint.h>

template <int P1,int P2>
void func2_b(int16_t in, int8_t &out)
{
   out = P1*in + P2;
}


