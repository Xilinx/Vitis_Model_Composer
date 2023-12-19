<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://raw.githubusercontent.com/Xilinx/Image-Collateral/main/xilinx-logo.png" width="30%"/><h1>AI Engine Development</h1>
    <a href="https://www.xilinx.com/products/design-tools/vitis.html">See Vitis™ Development Environment on xilinx.com</br></a>
    <a href="https://www.xilinx.com/products/design-tools/vitis/vitis-ai.html">See Vitis™ AI Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# Vitis Model Composer for AIE-PL System Development

Vitis Model Composer can be used to create complex systems targeting the PL (HDL and HLS block libraries) and the AI Engine array (AI Engine block library) at the same time. The complete system can be simulated in Simulink, and the design exported to generated code (RTL for the PL and C++ graph for the AI Engine array) or to Vitis. The Hardware Validation flow can be used to reproduce the Simulink testbench running on the hardware.

Vitis Model Composer simulates HDL designs in a cycle-accurate manner, while AIE and HLS simulation is functional only and does not provide cycle-accurate timing information. Because of this, Vitis Model Composer has interface blocks (**AIE to HDL**, **HDL to AIE**, **AIE to HLS**, **HLS to AIE**) that bridge between the simulation domains.

These tutorials will give a greater understanding of how the different processing domains are modeled in Simulink. They will also explain how to configure the interface blocks to accurately model how the AIE and PL will interact in hardware.

:warning: AI Engine development must be performed in a Linux environment.

### [Connecting AI Engine and HDL Subsystems](./AIE_HDL_tutorial/README.md)

### [Connecting AI Engine and HLS Subsystems](./AIE_HLS_tutorial/README.md)

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
