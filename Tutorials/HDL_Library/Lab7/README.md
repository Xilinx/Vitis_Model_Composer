# Lab 7: FIR Compiler 7.2

In this lab, you will learn how to verify the functionality of HDL FIR Compiler block in Vitis Model Composer.

### Objectives

After completing this lab, you will be able to:

* Configure FIR Compiler as an Interpolator or Decimator with Integer or Fixed-Fractional rate change.

* Configure FIR Compiler as a singe rate filter.

* Choose correct hardware oversampling specification format in order to get required output sample rate.

### Procedure 

This lab has four primary parts:

* In Step 1 you will learn how to configure FIR Compiler as a single rate filter.

* In Step 2 Configure FIR Compiler as an interpolator with Hardware Oversampling Specification format: Output Sample Period.

* In Step 3 Configure FIR Compiler as a decimator with Hardware Oversampling Specification format: input Sample Period.

* In Step 4 FIR Compiler with Hardware Oversampling Specification format: Hardware Oversampling Rate.

* In Step 5 Configure FIR Compiler with fixed-fractional rate change.

## Step 1: Configure FIR Compiler as a Single rate filter

1. Invoke Vitis Model Composer.
    - On Windows systems select **Windows > AMD Design Tools > Vitis Model Composer 2024.2.**
    - On Linux systems, type `model_composer` at the command prompt.

2. Navigate to the Lab7 folder: `\HDL_Library\Lab7.`

You can view the directory contents in the MATLAB® Current Folder browser, or type ls at the command line prompt.

3. Open the Lab7 design using one of the following:
    - At the MATLAB command prompt, type `open Lab7_1.slx`
    - Double-click Lab7_1.slx in the Current Folder browser.

Lab7_1 opens as shown in figure below:

![](Images/Lab7_1.png)

Input to the design: 

Input has two sine waves with frequencies 1 MHz and 5 MHz respectively and sampled at 100 MHz.
A random noise is added to create a real-time scenario.

FDA Tool settings:

FDA tool is added to the design to generate filter coefficients.
Fitler coefficients with passband: Fpass = 2 MHz and stopband:  Fstop = 4 MHz are generated.
Double click on FDA tool to observe the settings.

4. From the Simulink Toolstrip, click on simulink library browser and then AMD Toolbox---> HDL---> DSP---> AXI-S.

![](Images/step1_1.png)

5. Right click on FIR Compiler 7.2 to add this block to the model as shown below:

![](Images/step1_2.png)

6. Double click on FIR Compiler and add `double(xlfda_numerator(strcat(bdroot,'/FDATool')))` to cofficient vector field under Filter Coefficients.

<div class="noteBox">
You could also define the coefficients as a variable in the MATLAB workspace and specify the variable name in this field.
</div>

7. Select filter type as `Single_Rate` under filter specification field as shown below:

![](Images/step1_3.png)

8. Go to Channel Specification tab and make sure `Maximum_Possible` format is selected under Hardware Oversampling Specification.

![](Images/step1_4.png)

9. Go to the Implementation tab and select Coefficient Options as shown in figure below:

![](Images/step1_5.png)

10. Connect Gateway In block to data_tdata_real port of FIR Compiler.

11. Connect Gateway Out blocks to tready, tvalid and tdata as shown in figure below:

![](Images/step1_6.png)

12. Left click on canvas and drag mouse to select FIR Compiler, Gateway In and Gateway Out blocks.

13. Right click and choose Create Subsystem from Selection.

14. Subsystem will be created as shown below:

![](Images/step1_7.png)

15. Rename the Substem as HDL_DUT and connect the input and output ports as shown in figure below:

![](Images/step1_8.png)

16. Double click on Vitis Model Composer Hub block, swich to code generation tab and select HDL_DUT.

17. Go to settings tab set FPGA Clock Period(ns) to 10 and Simulink System Period to 1/100e6, click Apply.

18. Run the design and observe the FIR Compiler output signals displayed in the scope and spectrum analyzer as shown below:

![](Images/step1_9.png)

![](Images/step1_10.png)

19. Input to FIR Compiler has two signals (1 MHz and 5 MHz) but the output has only one signal (1 MHz).

20. The signal with 5 MHz is attenuated because it is falling in the stopband of the filter.

21. Double click on FDA tool, change the passband (Fpass) from 2 to 5 and the stopband (Fstop) from 4 to 10 and then click on Design Filter. 
    Now the filter coefficients are generated with Fpass = 5MHz and Fstop = 10 MHz.

![](Images/step1_11.png)

22. Run the design again to observe the FIR Compiler output signals.

23. Now you can see two signals (with 1MHz and 5MHz) at the FIR Compiler output:

![](Images/step1_12.png) 

You can observe the output sample rate displayed at the bottom toolstrip of spectrum analyzer.
 
24. Input sample rate to filter is 100 MHz and output sample rate is also 100 MHz. There is no rate change applied for the filter because we configured FIR Compiler as a single rate filter.

### Updating the design with sampling rate 50 MHz:

25. Double click on each input signal (including random source) and change the Sample time from 1/100e6 to 1/50e6 as shown below:

![](Images/step1_13.png) 

26. Double click on HDL_DUT subsystem, select Gateway In block and double click to change sample period to 1/50e6 and then click Apply. 

27. Go one level up and double click on Vitis Model Composer Hub block, swich to code generation tab and select HDL_DUT.

28. Change FPGA Clock Period(ns) from 10 to 20, and Simulink System Period from 1/100e6 to 1/50e6, click Apply.

29. Double click on FDA Tool, change Fs from 100 to 50, click on design filter and close FDA Tool.

30. Run the design to to observe the FIR Compiler output signal sample rate is updated to 50MHz as shown below:

![](Images/step1_14.png) 

## Summary

In this lab you learned how to configure FIR Compiler as a Decimator and an interpolator with integer and fixed fractional rate changes. 

--------------
Copyright 2024 Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
