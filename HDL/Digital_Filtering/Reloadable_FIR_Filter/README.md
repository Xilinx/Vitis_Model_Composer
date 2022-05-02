# Reloadable FIR Filter


This design example shows how the FIR Compiler block can be configured as a reloadable coefficient FIR filter. 
In this example, the first set of coefficients is specified and loaded by the core, and the second set is loaded from an external
source. The first set of coefficients specifies a symmetric filter, [1 2 3 2 1]. Note the filter structure is *inferred* from the coefficients provided to the block per the setting depicted in the image below.

<img src="images/infer.png" width="400">

The reloadable filter must be of the same specification and size of the initial filter loaded by the core. In this example, the reloadable filter should also be symetric. Here we have chosen [-1 2 -3 2 -1] as the relodable filter. However, we need to process this filter by the **xlGetReOrderedCoeff** function and provide the output of this function to the *reload_tdata_data* input signal of the core. 


Use the function

outCoeff = **xlGetReOrderedCoeff**(new_coeff_set, returnType, block_handle)

to get the reordered coefficients based on the settings and coefficients specified in the core.

* new_coeff_set   =  New coefficient set to be loaded
* returnType      =  'Coeff' or 'Index'
* block_handle    =  FIR Compiler block handle in the design which can be specified as 'gcbh'

Example :

1.	In the Simulink model, select the FIR Compiler 7.2 block.

2.	In the MATLAB Command Window, enter the following commands: 

		>new_coeff = [-1 2 -3 2 -1] 

		 new_coeff =

		     -1 2 -3 2 -1

		>xlGetReOrderedCoeff(new_coeff,'coeff',gcbh)

		ans =

		     -1
 		      2
		     -3


To understand the use the FIR Compiler 7.2 design for a reloadable filter, 
observe the following:

* Double-click the FIR Compiler block and you can see the set of coefficients [1 2 3 2 1] was specified.
This set of coefficients is pre-loaded in the core.

* The set of inputs connected to the FIR Compiler block (reload_tvalid, reload_tlast, and 
      reload_tdata_data) perform the following on the FIR Compiler 7.2 block:
    * *reload_tdata_data* and *reload_tvalid*: After the initial set of coefficients specified  by the core [1 2 3 2 1]
            is compiled, the new set of coefficients ([-1 2 -3], output of **xlGetReOrderedCoeff** function) is loaded via the *reload_tdata_data* input port.
            The *reload _tvalid* control signal must be high during this reload period. In this case *reload _tvalid* must
            be high for 3 clock cycles.
            In the Scope block, the *reload_tdata_data* signal appears as *coef_din*, and the *reload _tvalid* signal 
            appears as *coef_we*.
    * *reload_tlast*: This signal must be high on the last coefficient data to indicate that the last data has been
            loaded. In the Scope block, the *reload_tlast* signal appears as *coef_ld*.

* The inputs that are connected to the three *reload_** signals are vectors in this format:

    * *reload_tvalid* has input [zeros(1,20) 1 1 1]  = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1]. 
	      The format zeros(1,N) returns 1-by-N vectors of zeros. This is “zero padding”, an interpolation method
		which interprets time-domain samples as extending from 0 to N-1.
    * *reload_tlast* has input [zeros(1,20) 0 0 1]. *reload_tlast* goes high at the 23rd simulation time for 1 sample 
		period to indicate the last coefficient data.   
    * Similarly, *reload_tdata_data* has input as [zeros(1,20) -1 2 -3]  (see below for more details).

* Once the coefficinets are lodaed, to use the new coefficinets, the *config_tvalid* input should be set to one for one cycle.

* Now, Double-click the Scope block and observe the following:

    * The *reload _tvalid* control signal goes high during the reload period, 
		when the new set of coefficients is loaded via the *reload_tdata_data* input port.		
          
    * *reload_tlast*  goes high at the 20th simulation time for 1 sample period, 
		to indicate the last coefficient data.
    * New filter will take effect after the *config_tvalid* signal is set for a clock cycle.


Coefficients can be symmetric or asymmetric. 

:bulb: Note that the reloadable input to the filter must be unsigned. In this example, the gateway block is set to produce unsinged output and the *Overflow mode* is set to *wrap*. 

![](images/screen_shot.PNG)

------------
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
