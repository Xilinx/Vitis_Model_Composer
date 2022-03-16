# Multi-channel, folded implementation

This design demonstrates how multiple IIR filters can be implemented using a single time-shared second-order section (biquad). Specifically, 15 distinct IIR filters, each consisting of four cascaded biquads, are realized in a "folded" architecture that uses a single hardware biquad. Hardware folding is a technique to time-multiplex many algorithm operations onto a single functional unit (e.g. adder, multiplier). For low sample rate applications like audio and control, the required silicon area can be much reduced by time-sharing the hardware resources.

In this design, the several individual folding techniques are employed:

the biquad is time-multiplexed among fifteen channels
the biquad is time-multiplexed among four cascade stages for each channel
the biquad is implemented using two multipliers and a single adder instead of the straightforward 5 multipliers and 4 adders (a biquad output is calculated in every 5 system clock cycles).
The maximum clock frequency for the top-level design is device dependent. The speed for each channel (4-cascade-stage IIR filter) is maximum clock frequency for the FPGA( MHz) / (15 channels*4 biquads/channel*5 clks/biquad).

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
