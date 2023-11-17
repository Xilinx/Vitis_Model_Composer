
<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://raw.githubusercontent.com/Xilinx/Image-Collateral/main/xilinx-logo.png" width="30%"/><h1>AI Engine Development</h1>
    <a href="https://www.xilinx.com/products/design-tools/vitis.html">See Vitis™ Development Environment on xilinx.com</br></a>
    <a href="https://www.xilinx.com/products/design-tools/vitis/vitis-ai.html">See Vitis™ AI Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# Connecting AI Engine and HDL Subsystems

This lab will explore how to model heterogeneous systems (consisting of AI Engine and PL components) in Vitis Model Composer. 

## Review the Tutorial Model

1. Open the model `AIE_HDL.slx`. 

2. Right-click on an empty part of the canvas and ensure that the following options are selected:
* **Sample Time Display -> All**
* **Sample Time Display -> Timing Legend**
* **Other Displays -> Signals & Ports -> Signal Dimensions**
* **Other Displays -> Signals & Ports -> Port Data Types**.

3. On the **Modeling tab**, select **Update Model**.

This model implements a simple passthrough design that sends integer data from the PL to the AI Engine and back.

![](./Images/model1.png)

The interfaces between the AI Engine and HDL parts of the design are initially implemented with placeholder blocks. In this tutorial, we will see how to replace these placeholders with the **HDL to AIE** and **AIE to HDL** blocks.

## HDL Subsystem

The Vitis Model Composer HDL block library performs cycle-accurate simulation. The sample times in Simulink will match the sample times of the design running on the hardware.

4. Double-click on the **HDL_Subsystem** to open it.

![](./Images/model2.png)

This HDL subsystem contains a simple FIFO block and AXI-Stream input and output interfaces. The AXI-Stream interface is required to interface an HDL subsystem with the AI Engine.

Note that the signal lines are all a single color, indicating a single sample rate for this subsystem. Referring to the timing legend, the sample period of this subsystem is 2 ns, corresponding to a sample rate of 500 MHz.

![](./Images/model3.png)

>**TIP:** You can click the button labeled `1/P` in the Timing Legend to view timing information in terms of rate instead of period.

**How is the sample time set in Vitis Model Composer?**

In this case, the following settings are necessary to set the sample rate to 500 MHz for the HDL subsystem.
* The **Gateway In AXIS** and **Gateway Out AXIS** blocks' Sample Period parameter.

![](./Images/gateway_blocks.png)

* The **FPGA clock period** and **Simulink system period** settings in the Vitis Model Composer Hub block.

![](./Images/vmchub.png)

When the **FPGA clock period** corresponds to the hardware clock rate, and **Simulink system period** is equal to the same value, then the sample times observed in Simulink will match those of the design running in hardware.

## AIE Subsystem

Unlike the HDL block library, the Vitis Model Composer AI Engine blocks do not perform cycle-accurate simulation. In fact, the observed sample times in the Simulink model do not correspond to the AI Engine's hardware clock rate.

5. Return to the top-level `AIE_HDL` model and double-click the **AIE_Subsystem** to open it.

The AIE subsystem contains a single kernel that performs a simple passthrough. You can view the AIE kernel code in the `passthrough.cpp` file.

6. Double-click on the **passthrough** block.

![](./Images/aie_kernel.png)

In the function declaration, note that this kernel's input and output are `int32` values. Also note the `FRAME_LENGTH` parameter, set to 16, which also corresponds to the size of the input and output buffers.

7. Close the **passthrough** block parameters and open the first **PLIO** block.

![](./Images/plio.png)

The PLIO block defines the hardware interface between the AI Engine and the PL. Here, **PLIO width** is `64`, which means that 2 `int32` values will be transferred from the PL to the AIE on each PL clock cycle. The **PLIO frequency** is 500 MHz, which matches the expected rate of our HDL subsystem (see above). The combination of the PLIO width and frequency mean that the AI Engine effectively consumes `int32` values at a rate of 1 GHz.

>**IMPORTANT:** The parameters specified in the PLIO block do not affect the functional simulation or observed sample times in Simulink. These parameters only affect the generated AI Engine graph code and how the design is simulated in the cycle-approximate `aiesimulator`.

## Interface From HDL to AIE

As mentioned above, the HDL blocks perform cycle-accurate simulation while AI Engine blocks do not. It is necessary to provide a "bridge" between the two simulation domains in Simulink. The **HDL to AIE** and **AIE to HDL** blocks accomplish this.

![](./Images/connectors_hdl.png)

These blocks translate between HDL and AI Engine data types. They also determine the Simulink sample rate of the AI Engine design, based on the HDL sample rate and the relationship between the HDL/AIE data types.

8. Remove the **HDL to AIE Placeholder** subsystem.

9. Click an open area of the canvas, type `HDL to AIE`, and select the **HDL to AIE** block (or select the block from the Simulink Library Browser).

10. Connect the **HDL to AIE** block where the placeholder block used to be.

![](./Images/connection1.png)

11. Double-click the **HDL to AIE** block to open its parameters.

![](./Images/hdl_aie_params1.png)

12. Configure the block as follows:

* **Input data type:** `uint64` The HDL output signal is 64 bits wide. In Simulink, this is modeled as a `uint64`.
* **Output data type:** `int32` The AI Engine kernel expects an `int32` input. On each HDL clock cycle, the HDL to AIE block will split the 64-bit input into 2 32-bit outputs at twice the rate.
* **Number of output samples:** `16` The AI Engine kernel's input buffer is 16 samples.
* **Reduce output sample rate by a factor of:** `1` The HDL subsystem produces valid data on every clock cycle.

>**When would you reduce the output sample rate?**
>
>If the HDL subsystem does not produce valid data on every clock cycle, the AI Engine subsystem will operate at a reduced rate. The **Reduce output sample rate** parameter allows the **HDL to AIE** block to model this behavior.
>
>For example, if the HDL subsystem asserts `tvalid` every 4 HDL clock cycles, set the **Reduce output sample rate by a factor of** parameter to 4. 

![](./Images/hdl_aie_params2.png)

13. Press **Apply** and **OK**.

14. Press `Ctrl+D` to update the model.

The **HDL to AIE** block's sample times and output data types and dimensions are updated:

![](./Images/connection2.png)

* The output sample rate (green color) is 62.5 MHz. This is calculated by `(HDL sample rate) * (Samples per HDL clock cycle) / (Number of output samples)`: `500 MHz * 2 / 16 = 62.5 MHz` 
* The output data type is `int32`.
* The output signal is a variable-sized signal with a maximum size of `16`.

## Interface From AIE to HDL

The bridge from AIE to HDL is more straightforward. We only need to know the HDL subsystem's input data type and sample rate.

15. Remove the **AIE to HDL Placeholder** subsystem.

16. Click an open area of the canvas, type `AIE to HDL`, and select the **AIE to HDL** block (or select the block from the Simulink Library Browser).

17. Connect the **AIE to HDL** block where the placeholder block used to be.

![](./Images/connection3.png)

18. Double-click the **AIE to HDL** block to open its parameters.

![](./Images/aie_hdl_params1.png)

19. Configure the block as follows:

* **Output Data Type:** `uint64` The HDL subsystem expects a 64-bit wide input, modeled in Simulink as a `uint64`. The AIE to HDL block will combine 2 subsequent `int32` inputs into a single `uint64` output.
* **Output Sample Time:** `Inherit: Same as tready` The HDL subsystem will determine its own sample rate.

![](./Images/aie_hdl_params2.png)

20. Press **Apply** and **OK**.

21. Press `Ctrl+D` to update the model.

The **AIE to HDL** block's sample times and output data types and dimensions are updated:

![](./Images/connection4.png)

* The output sample rate is 500 MHz. This is determined by the Sample Period parameter of the Gateway blocks inside of the HDL subsystem (`HDL_Subsystem1`).
* The output data type is `uint64`.
* The output signal is a scalar value.

## Conclusion

**Congratulations!** This concludes Lab 8

In this lab, 

---

&copy; Copyright 2023 Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

```
    http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

<p align="center"><sup>XD058 | &copy; Copyright 2023 Advanced Micro Devices, Inc.</sup></p>

