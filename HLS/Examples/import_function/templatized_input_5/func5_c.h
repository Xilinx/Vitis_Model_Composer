// This example shows how to perform simple arithmetic operations
// on template parameters. In this example, the output size will be
// half the size of the input. 

#include <stdint.h>

#pragma XMC INPORT in
template<int NUMOFELEMENTS>
void func5_c(int16_t in[NUMOFELEMENTS], int16_t out0[NUMOFELEMENTS/2], 
           int16_t out1[2 * NUMOFELEMENTS - 15]) {
    
    for (int i = 0; i < NUMOFELEMENTS/2; i++) {
        out0[i] = in[i];
    }
    for (int i = 0; i < 2 * NUMOFELEMENTS - 15; i++) {
        out1[i] = NUMOFELEMENTS + i;  
    }
}
