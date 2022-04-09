# PL + AI Engine design Examples <a name="heterogeneous"></a>


Versal AI Core devices are highly integrated, multicore compute platform that can adapt with evolving and diverse algorithms. These devices include both Programmable Logic (PL) and an AI Engine array. Vitis Model Composer provides a design environment, based on industry standard MATLAB and Simulink tools, to model and simulate designs with both PL and AI Engine components.


 <p align="center">
  <img src="images/aie_plus_pl.png" align ="center" width = 70%>
</p>
 

 

# Examples
<table style="width:100%">
<tr>
  <td align="center" colspan="2" style="bold" ><b><a href="./AIE_HLS/README.md">Design with both AI Engines and HLS kernels</a></b>
</tr>

<tr>
<td>
<a href="./AIE_HLS/Tx_chain_200MHz/README.md">TX Chain 200MHz </a>
</td>
<td>
This design showcases the Vitis Model Composer implementation of the commslib example, TX chain 200MHz, which is part of the communications Library Early access program.
</td>
</tr> 
 
<tr>
<td>
<a href="./AIE_HLS/AIE_HLS_with_interface/README.md">AI Engines and HLS Kernel with interface blocks</a>
</td>
<td>
A desgin with both AI Engine and HLS Kernel blocks connected through interface blocks.
</td>
</tr> 
 
<tr>
<td>
<a href="./AIE_HLS/AIE_HLS_without_interface/README.md">AI Engines and HLS Kernel connected directly</a>
</td>
<td>
A desgin with both AI Engine and HLS Kernel blocks connected directly.
</td>
</tr>

<tr> 
<td>
<a href="./AIE_HLS/FFT2D/README.md">2D FFT</a>
</td>
<td>
A 2D FFT desgin with both AI Engine and HLS Kernel.
</td>
 </tr>
</table>




<br/>
<br/>
<table style="width:100%">
<tr>
  <td align="center" colspan="2" style="bold" ><b><a href="./AIE_HDL/README.md">Designs with both AI Engine and HDL blocks</a></b>
</tr>

<tr>
<td>
<a href="./AIE_HDL/AIE_HDL_cosim/README.md">Design with HDL and AI Engine blocks</a>
</td>
<td>
Design with HDL and AI Engine blocks
</td>
</tr> 
 
<tr>
<td>
<a href="./AIE_HDL/AIE_HDL_cosim_rtl_blackbox/README.md">Design with imported RTL and AI Engine blocks</a>
</td>
<td>
Design with imported RTL and AI Engine blocks.
</td>
</tr>
 
<td>
<a href="./AIE_HDL/FFT2D/README.md">2D FFT</a>
</td>
<td>
A 2D FFT desgin with both AI Engine and HDL Kernel.
</td>
</tr>

<tr> 
<td>
<a href="./SingleStreamSSR_FIR_withPL/README.md">Super Sample Rate FIR filter with PL</a>
</td>
<td>
This design showcases a Super Sample Rate FIR filter to process a 4GSPS input stream. In this design we consider latencies within the kernels, which are implemented into the FIFO's included in AXI-Stream Interconnect(PL).
</td>
</tr>
 
</table>

