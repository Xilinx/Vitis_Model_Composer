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


> In this example, we are fully utilizing the entire cascade signal width (512 bits for an AIE ML) device, to pass the largest amount of data from one AIE Kernel to another AIE Kernel in one clock cycle, getting the highest throughput.


## Cases where we don't use the entire cascade width

The case above uses 64 lanes for an int8 cascade. This maximizes the throughput. For AIE-ML, you can also use a lane size of 16 or 32 for int8 cascade signal. The AIE Kernel block only allows an output size of 64 or multiples of 64 for an AIE ML device and a cascade signal of int8 data type. In such a case, when monitoring the cascade signal, in case of a 32 lane, only the first 32 samples are valid and in case of a 16 lane, only the first 16 samples are valid. However, the consuming kernel should take in all the 64 samples to produce an output. 

## Example

Let's look into another example similar to the one above but with cint32 data types and two lanes. This is a total of 128 bits and as such it does not use the entire cascade bitwidth. 

```
#include "k_cascade_cint32.h"

#include "aie_api/aie.hpp"
#include "aie_api/aie_adf.hpp"

const uint8_t LANE = 2;

void dmover0(adf::input_buffer<cint32,adf::extents<adf::inherited_extent>>& in,
             output_cascade<cint32>* out)
{
	auto inIter=aie::begin_vector<LANE>(in);
  	aie::vector<cint32, LANE>  value;
	value = *inIter++;
  	writeincr(out,value );
}
```
The screen shot below depicts the kernel above imported as an AI Engine block for an AIE-ML device. The kernel accepts a buffer of size 2 (set by the parameter on the kernel block mask) and produces a cascade output of 8 cint32 samples (also set by another parameter on the kernel block mask). In this case, only the first two samples are valid. 

![image](https://github.com/user-attachments/assets/2a06185a-d588-4a3d-a7c9-29f9ded5614d)


> If the size of the cascade signal alowable by the block is larger than the number of lanes, only the first number of samples equal to the number of lanes are valid. 





