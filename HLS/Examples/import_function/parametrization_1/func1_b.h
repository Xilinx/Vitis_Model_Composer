// In this example two editable fields will get added to the block dialog box.
// You can assign a default argument but they should appear at the end of
// the function argument list.

#include <stdint.h>

#pragma XMC PARAMETER P1, P2
void func1_b(int16_t in, int8_t &out, double P1, int8_t P2 = 10)
{
   out = in*P1 + P2;
}


