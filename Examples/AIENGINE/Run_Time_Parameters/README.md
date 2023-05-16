# Run Time Parameters (RTP)
These examples demonstrate modeling and simulation of Run Time Parameters in Model Composer. In Versal Adaptive SoCs with AI Engines, the processing system (PS) can be used to dynamically load,
monitor, and control the graphs that are executing on the AI Engine array. Even if the AI Engine
graph is loaded once as a single bitstream image, the PS program can be used to monitor the
state of the execution and modify the Run-Time Parameters of the graph. This is done through Run Time Parameters. 

## Examples
Here we demonstrate two exmaples:

- [A design with a scalar RTP input](rtp_scalar/README.md)
- [A design with a vector RTP input](rtp_vector/README.md)

 



## Knowledge nuggets
:bulb: An RTP input can be a scalar or a vector.


------------
Copyright 2020-2022 Xilinx
Copyright 2023 Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
