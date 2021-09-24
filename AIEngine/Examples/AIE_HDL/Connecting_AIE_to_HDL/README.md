# Connecting AI Engine blocks with HDL blocks
In Vitis Model Composer, simulation of the AI Engine blocks is untimed while the simulation of HDL blocks is timed (cycle accurate). 
If you are simulating a heterogeneous system with both PL (modeled with HDL blocks) and AI Engine, you need to use “AIE to HDL” and “HDL to AIE” blocks to properly 
manage the sampling times across the two domains. This mini tutorial explains how to set these two blocks properly and what to be aware of.

# Setting the AIE to HDL block
## Step 1 Know the initiation interval(ii) of your HDL design
A factor in setting the parameters of the AIE to HDL block is the initiation interval of the HDL subsystem. 
As mentioned earlier, simulation in HDL domain is cycle accurate. 
An HDL design may not be ready to accept a new data at every cycle (the tready signal from the HDL design will be set to zero when the HDL design cannot accept new samples). 
For example, if an HDL design accepts a new sample every 10th cycles, the design would have an initiation interval (or ii) of 10. A design that can accept a new sample at every clock cycle has an initiation interval of one.

## Step 2 Set the parameter Output Data Type of the AIE to HDL block
The *Output Data Type* parameter is limited to 32, 64, and 128 bits wide. This reflects the permissible data bit-width between AI Engine array and PL. 
There are more constraints in place. For example, if the input signal is of type int64, the output data type can only be of type int64.  
If the input is of type int16(c), then the output should be uint32. Note that if you are using an AIE Siganl Spec block to specify the PLIO width (to optimize throughput between AI Engine array and PL), then the Output Data Type should have the same number of bits as the PLIO width specified. In the absense of the AIE Singal Spec block, the generated code will have a PLIO width equal to the bitwidth of the signal leaving the AI Engine subsytem or 32 bits, whichever is larger. See the image at the end of this section and the examples in the table.  

![AIE_to_HDL](images/AIE_to_HDL.png)

Here are some examples:

| Data type into the block | PLIO     | Output Data Type |
|--------------------------|----------|------------------|
| int16                    | 64 bits  | uint64           |
| int16(c)                 | Not set  | uint32           |
| int32                    | 128 bits | ufix128          |
| int8                     | Not set  | uint32           |

## Step 3 Set the parameter Output Sample Time of the AIE to HDL block
Set the *Output Sample Time* to

*(Input Sample Period)/(Input Size)/ii*

Let’s understand the reason for this formula. 
For the moment, assume ii is one (tready is always set to one). 
If the input to the “AIE to HDL block” is a variable size signal of size *Input Size*, and the period is 
*Input Period* (you can determine the sample period by opening the [Timing Legend](https://www.mathworks.com/help/simulink/ug/how-to-view-sample-time-information.html) in Simulink),
this means in the time period *Input Period*, we are feeding *Input Size* samples into the block. 
To prevent the internal buffer of the block to overflow, the output rate from the AIE to HDL block should be the same as its input. 
The input rate is *(Input Size)/(Input Period)* and the output rate is *1/(Output Sample Time)*. When ii is larger than one, the output rate is reduced to *1/(Output Sample Time)/ii*. 


## Step 4 Set the system clock
Open the Clocking tab in the System Generator block.There are two parameters there, the *FPGA clock period* and the *Simulink system period*. These two numbers define the scaling factor between time in a Simulink simulation, and time in the actual hardware implementation. Set the *Simulink system period* to the time calculated in step 3. Here we are assuming that the HDL desgin is a single rate desgin. To learn more about these two parameters, refer to [UG1483](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2021_1/ug1483-model-composer-sys-gen-user-guide.pdf). 

![System Generator](images/system_generator.png)


![High Level AIE to HDL](images/high_level2.png)


# Setting the HDL to AIE block 

## Step 1 Set the Output Data Type
The Output Data Type should be set to the data type that the consuming AI Engine block accepts. 
Note that the size you set for the PLIO should match the input bitwidth to the HDL to AIE 
block while the output data type of the AIE to HDL block should match the input data type of the consuming AIE block. See the figure at the buttom of this page.

![GDL_to_AIE](images/HDL_to_AIE.png)

## Step 2 Set the Output frame size
Let’s assume the consuming AIE block has a window input size of P, or it has a 
stream input that needs to read P samples to unblock (for example a readincr_v4 requires 4 input samples to unblock). Set samples per output frame to P.

## Step 3 Set the Output Sample Time
Set the Output Sample Time to:

output sample time= input sample time*(output bit width)/(input bit width)

## Step 4 Set the tready Sample Time
tready Sample Time should be the same as the HDL design sample time.

![highlevel](images/high_level.png)

# Examples
In this GitHub repository, you can find several examples in which the AIE to HDL and HDL to AIE blocks are being used:

* <a href="../../Designs/FFT2D">2D FFT (AI Engines + HDL/HLS) </a>
* <a href="../../AIE_HDL/README.md">Designs with both AI Engine and RTL blocks</a>

--------------
Copyright 2020 Xilinx

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.