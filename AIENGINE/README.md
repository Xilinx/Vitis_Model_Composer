
<table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Topic</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="left">
   <a href="./Importing_AIE_blocks/README.md">Importing Kernels and Graphs into Model Composer</a>
  <ul>
  <li><a href="./Importing_AIE_blocks/AIE_Class_Kernel_FIR/README.md">Importing a kernel class as a block</a></li>
  <li><a href="./Importing_AIE_blocks/AIE_Graph/README.md">Importing a graph as a block</a></li>
</ul> 
 </td>
 <td>Examples on importing Kernels and Graphs into Model Composer as blocks. This include importing templatized class based kernels, templatized AI Engine functions, and graphs. </td>
 </tr>
 <tr>
 <td align="left">
   <a href="./Run_Time_Parameters/README.md">Run time parameters (RTP)</a>
    <ul>
  <li><a href="./Run_Time_Parameters/rtp_scalar/README.md">A design with a scalar RTP input</a></li>
  <li><a href="./Run_Time_Parameters/rtp_vector/README.md">A design with a vector RTP input</a></li>
</ul> 
 </td>
 <td>Examples of kernels with RTP input. RTP inputs can be sync or async. </td>
 </tr>
 <tr>
 <td align="left">
   <a href="./DSPlib/README.md">DSP Functions</a>
      <ul>
  <li><a href="./DSPlib/fir/README.md">Using the AI Engine FIR block from the library browser</a></li>
  <li><a href="./DSPlib/fft/README.md">Usign the AI Engine FFT block from the library browser</a></li>
  <li><a href="./DSPlib/matrix_multiply/README.md">Importing Matrix Multiply from DSPLib as a block</a></li>     
</ul> 
 </td>
 <td>AI Engine FIR filters and FFT. Importing Matrix Multiply as a graph into Vitis Model Composer.</td>
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
 

