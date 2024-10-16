# Monitoring cascade signals in an AIE Engine design

In a Versal-AIE device, data from one AI Engine can be forwarded to another by using cascade streams. In AIE each cascade stream is 384 bit wide. In other words, in one clock cycles, we can transfer 384 bit data from one AIE tile to a neighboring tile in an AIE device. In an AIE-ML device a cascade steam is 512 bit wide.

In Vitis Model Composer, you can import a kernel with cascade input and output ports using the AIE Kenel block and easily monitor the cascade signal for debugging purposes. 

## Example
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
	value = inIter++;
  	writeincr(out,value );
}

```

The screen shot below depicts the kernel above imported as an AI Engine block for an AIE-ML device. The kernel accepts a buffer of size 64 (set by the parameter on the kernel block mask) and produces a cascade output of 64 int8 samples (also set by another parameter on the kernel block mask). As you see, you can connect the output to a display block and monitor the cascade signal. Likewise, you can connect it to a scope block or to an AMD "Variable Size Signal to Workspace" block.

![image](https://github.com/user-attachments/assets/a60e4f65-ca5d-4003-89d1-f0948c66964a)

<div class="noteBox">
  In this example, we are fully utilizing the entire cascade signal width (512 bits for an AIE ML) device, to pass the largest amount of data from one AIE Kernel to another AIE Kernel in one clock cycle, getting the highest throughput.
</div>

## 




