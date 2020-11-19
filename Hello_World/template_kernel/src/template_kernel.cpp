#include "src/template_kernel.h"

template <typename T, int N>
void
template_func(input_stream<T> *i1,
         output_stream<T> *o1)
{
   writeincr(o1, N + readincr(i1));
}

