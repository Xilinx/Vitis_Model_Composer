# Debugging Multirate designs

Selecting Sample Frequencies (MHz) in the Hub block helps visualize the available sampling frequencies for input and output ports in your multi-rate design. This is useful for debugging and validating timing.

# How to Debug Sampling Frequencies in the design ?

1. Open the design that contains multiple sample rates using one of the following:

    - At the MATLAB command prompt, type `interpolator.slx`
    - Double-click **interpolator.slx** in the Current Folder browser.

2. After opening the design, locate and open the Vitis Model Composer Hub block.

3. Double-click the Hub block and navigate to the Analyze tab.

4. In the Block Icon Display dropdown, choose `Sample Frequencies (MHz)`.

5. Click `Update the model` to apply the changes.

6. Input and output ports will now display their respective sampling frequencies in MHz.

The animation below demonstrates how to display sampling frequencies in the design:

<img src="images/MultirateSampling.gif"  width=500px; height=auto>

7. The design used in the above animation is an interpolator with an integer rate change value of 5. We can observe that the input and output ports have been updated to display 20 and 100, respectively.

**Input Sampling Frequency:** 20 MHz

**Output Sampling Frequency:** 100 MHz

8. Make sure **FPGA Clock Period(ns)** is set to `10`, and **Simulink System Period** is set to `1/100e6` or `10e-9` in the Hub block.

# How to Compute Simulink System Period and FPGA Clock Period

The **Simulink System Period** value should be the greatest common divisor(gcd) of all the sample periods that appear in the model.

**Simulink System Period** Computation is explained below:

* **Input Sample Rate**: 20MHz (Input Sample Period: 1/20MHz = 50ns)

* **Expected Output Sample Rate**: (Input Sample Rate) * (Rate change value) = 20MHz * 5 = 100 MHz

* **Output Sample Period**: 1/100MHz = 10ns

`gcd(Input Sample Period, Output Sample Period) = gcd(50,10) = 10`

**Simulink System Period(sec)** in the Hub block: 10e-9 

**FPGA Clock Period(ns)**: (Simulink System Period) * 10e9 = 10

**Note:** Ensure that the FPGA clock period in the Hub block matches the Simulink system period. Otherwise, the displayed sample frequencies across the design may not be accurate.
 
For more details on setting Simulink System Period and FPGA Clock Period, please click [here](https://github.com/Xilinx/Vitis_Model_Composer/tree/2025.2/Tutorials/HDL_Library/Lab7)


# Conclusions

:bulb: This feature provides a quick visual check of input and output sampling rates, making it easier to debug multi-rate designs and ensure correct timing.


--------------
Copyright (c) 2025 Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.