#include <stdio.h>
#include <cardano.h>

void mysquare(input_window_int32 * win, 
              output_window_int32 *out) { 

  
  for (unsigned i = 0 ; i < 8 ; i++) {
    int j = window_readincr(win);
    window_writeincr(out,j*j);
  }

}
