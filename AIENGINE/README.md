# AI Engine Examples

Vitis Model Composer allows you to create AI Engine designs and generate code for them. The visualization and analysis capabilities of MATLAB and Simulink presents an excellent environment to debug any design and make sure the design functionally performs as expected.

<table style="width:100%">
<tr>
  <td align="center" colspan="2" style="bold" ><b><a href="./Importing_AIE_blocks/README.md">Importing Kernels and Graphs into Model Composer</a></b>
</tr>

<tr>
<td>
<a href="./Importing_AIE_blocks/AIE_Class_Kernel_FIR/README.md">Importing a kernel class as a block                      </a>
</td>
<td>
In this example we import an AI Engine class kernel into Vitis Model Compsoer as a block.
</td>
</tr> 
 
<tr>
<td>
<a href="./Importing_AIE_blocks/AIE_Graph/README.md">Importing a graph as a block</a>
</td>
<td>
In this example we import an AI Engine graph into Vitis Model Compsoer as a block.
</td>
</tr> 
</table>
<br/>

 
 
<table style="width:100%">
<tr>
  <td align="center" colspan="2" style="bold" ><b>  <a href="./Run_Time_Parameters/README.md">Run time parameters (RTP)</a></b>
</tr>

<tr>
<td>
<a href="./Run_Time_Parameters/rtp_scalar/README.md">A design with a scalar RTP input</a>
</td>
<td>
This example showcases a desgin that inlcudes a AI Engine kernel with a scalar input RTP.
</td>
</tr> 
 
<tr>
<td>
<a href="./Run_Time_Parameters/rtp_scalar/README.md">A design with a scalar RTP input</a>
</td>
<td>
This example showcases a desgin that inlcudes a AI Engine kernel with a vector input RTP.
</td>
</tr> 
</table>
<br/>
 
<table style="width:100%">
<tr>
  <td align="center" colspan="2" style="bold" ><b><a href="./DSPlib/README.md">DSP Functions</a></b>
</tr>

<tr>
<td>
<a href="./DSPlib/fft/README.md">Usign the AI Engine FFT block from the library browser</a>
</td>
<td>
This example showcases a desgin that inlcudes a AI Engine kernel with a scalar input RTP.
</td>
</tr> 
 
<tr>
<td>
<a href="./DSPlib/fft/README.md">Usign the AI Engine FFT block from the library browser</a>
</td>
<td>
This example showcases a desgin that inlcudes a AI Engine kernel with a vector input RTP.
</td>
</tr>
 
<tr>
<td>
<a href="./DSPlib/matrix_multiply/README.md">Importing Matrix Multiply from DSPLib as a block</a>
</td>
<td>
This example showcases how you can import a DSPLib function as a block.
</td>
</tr>
</table>
<br/>




<table style="width:100%">
<tr>
  <td align="center" colspan="2" style="bold" ><b>Other examples</b>
</tr>
 
 <tr>
 <td align="left">
   <a href="./SingleStreamSSR_FIR/README.md">Super Sample Rate FIR filter</a>
 </td>
 <td> This design showcases a Super Sample Rate FIR filter to process a 4GSPS input stream. In this design we also compare the output of our AI Engine subsystem with the output of a Simulink FIR block (our golden reference) both in time and in frequency. 
 </td> 
 </tr>
 
 <tr>
 <td align="left">
   <a href="./DualStreamSSR_FIR/README.md">Dual Stream Super Sample Rate FIR filter</a>
 </td>
 <td> This design showcases a Dual Stream Super Sample Rate FIR filter to process a 16GSPS input stream. In this design we also compare the output of the AI Engine subsystem with the output of a Simulink FIR block (the golden reference). 
 </td> 
 </tr>
 
  <tr>
 <td align="left">
 <a href="./Pseudo_Inverse_64x32/README.md">Pseudo Inverse 64x32 </a>
 </td>
 <td> This design showcases an AI Engine implementation of a 64x32 Pseudo Inverse in Vitis Model Composer. The AI Engine output is compared with the output of the pseudo inverse block in Simulink which is used as a reference.</td>
 </tr>
 
 </table>
 

