#include "sine.h"

SineGen::SineGen()
   : freq(1048576),
     phase(0),
     numSamples(16)
   {
   }

void
SineGen::generate(int16 scale, output_window_cint16* out)
{
        cint16 sc = sincos(freq * phase++);
        sc.real >>= scale;
        sc.imag >>= scale;
        
        for (int i=0; i<numSamples; i++)            
            window_writeincr(out, sc);    
}