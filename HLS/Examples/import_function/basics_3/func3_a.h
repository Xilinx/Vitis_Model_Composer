// In this example, we create a block with matrix input and
// matrix output

#include <stdint.h>

void func3_a(const int16_t in1[3][5],
             const int16_t in2[3][5],
             int16_t out[3][5])
{
   for (int i = 0; i<3; i++) {
      for (int j = 0; j<5; j++) {
         out[i][j] = in1[i][j] + in2[i][j];
      }
   }
}


