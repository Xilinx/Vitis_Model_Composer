// You can also pass arrays or matices as parameters

#include <stdint.h>

#pragma XMC PARAMETER P1, P2
void func3_b(int16_t in, double out[3], double P1[2][3], int8_t P2[3])
{
   // Calculate P1*P2
   double product[3];
   for (int i = 0; i < 3; i++) {
      double row_sum = 0;
      for (int j=0; j<2; j++) {
         row_sum += P1[j][i] * (double)P2[i];
      }
      product[i] = row_sum;
   }

   // Add input to the result
   for (int i = 0; i < 3; i++) {
      out[i] = product[i] + in;
   }
}


