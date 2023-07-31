#include <ap_fixed.h>

#pragma XMC INPORT vector_in
template<int NUMOFELEMENTS, int W, int I>
void Demux(ap_fixed<W,I> vector_in[NUMOFELEMENTS], ap_fixed<W,I> vector_out0[NUMOFELEMENTS/2], 
           ap_fixed<W,I> vector_out1[NUMOFELEMENTS/2]) {
    
    for (int i = 0; i < NUMOFELEMENTS/2; i++) {
        vector_out0[i] = vector_in[i];
        vector_out1[i] = vector_in[i+NUMOFELEMENTS/2];
    }
}

#pragma XMC INPORT vector_in0
#pragma XMC INPORT vector_in1
template<int NUMOFELEMENTS, int W, int I>
void Mux(ap_fixed<W,I> vector_in0[NUMOFELEMENTS], ap_fixed<W,I> vector_in1[NUMOFELEMENTS], 
         ap_fixed<W,I> vector_out[NUMOFELEMENTS*2]) {
    
    for (int i = 0; i < NUMOFELEMENTS; i++) {
        vector_out[i] = vector_in0[i];
        vector_out[i+NUMOFELEMENTS] = vector_in1[i];
    }
}