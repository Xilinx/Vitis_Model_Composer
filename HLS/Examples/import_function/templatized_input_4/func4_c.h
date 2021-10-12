// You can create a block that accepts matrics of different dimensions

#include <stdint.h>
template <int R1 , int C1 , int R2 , int C2>
void func4_c(const int16_t in1[R1][C1],
             const int16_t in2[R2][C2],
             int16_t out[R1][C2])
{
   int16_t result[R1][C2];
   int16_t i, j, k;
   for (i = 0; i < R1; i++) {
      for (j = 0; j < C2; j++) {
         result[i][j] = 0;
      }
   }
   for (i = 0; i < R1; i++) {
      for (j = 0; j < C2; j++) {
         for (k = 0; k < C1 ; k++) {
            result[i][j] += in1[i][k] * in2[k][j];
         }
      }
   }
   for (i = 0; i < R1; i++) {
      for (j = 0; j < C2; j++) {
         out[i][j] = result[i][j];
      }
   }
}


