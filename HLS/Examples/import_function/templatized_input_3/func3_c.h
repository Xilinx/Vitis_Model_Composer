// 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
// You can create a block that accepts arrays of different dimensions

#include <stdint.h>
template <int SIZE>
void func3_c(const int16_t in1[SIZE],
             const int16_t in2[SIZE],
             int16_t out[SIZE])
{
   int16_t temp = 0;
   for (int i = 0; i < SIZE; i++) {
      out[i] = temp + in1[i] + in2[i];
      temp = temp + 1;
   }
}


