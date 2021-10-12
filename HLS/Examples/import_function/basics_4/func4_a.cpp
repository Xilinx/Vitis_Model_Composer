// function definition


#include "func4_a.h"

void func4_a(int16_t in[5], int16_t out[5])
{
    int16_t c=1;
    for(int i=0;i<5;i++) {
          out[i] = in[i] + c;
    }
}


