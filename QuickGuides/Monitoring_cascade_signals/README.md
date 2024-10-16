# Monitoring cascade signals in an AIE Engine design

In a Versal-AIE device, data from one AI Engine can be forwarded to another by using cascade streams. In AIE each stream is 384 bit wide. In AIE-ML a cascade steam is 512 bit wide. In other words, in one clock cycles, we can transfer 384 bit data from one AIE tile to a neighboring tile in an AIE device.

In Vitis Model Composer, you can import a kernel with cascade input and output ports using the AIE Kenel block and easily moniotr the cascade signsl for debugging purposes. 

The kernel code below takes in an input buffer of 64 int8 samples and produces a cascade signal of int8 values. 

```
#include "k_cascade_int8.h"

#include "aie_api/aie.hpp"
#include "aie_api/aie_adf.hpp"

const uint8_t LANE = 64;

void dmover0(adf::input_buffer<int8,adf::extents<adf::inherited_extent>>& in,
             output_cascade<int8>* out)
{
	auto inIter=aie::begin_vector<LANE>(in);
  aie::vector<int8, LANE>  value;
  writeincr(out,value );
}

```






