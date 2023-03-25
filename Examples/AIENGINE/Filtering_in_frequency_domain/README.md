# Filtering in Frequency Domain

In the frequency domain, the filtering operation involves the multiplication of the Fourier transform of the input and the Fourier transform of the 
impulse response followed by an inverse Fourier transform.
As the length of the impulse response increases, the frequency-domain filtering technique becomes more efficient compared to time-domain filtering.

## The Algorithm

This example uses the Overlap-Save method. The diagram below depicts this algorithm at a high level:

<img src="./Images/high_level.png" width="600">

The input stream is divided into overlapping segments of size NFFT, where each segment has an overlap of NumLen samples. NFFT represents the length of the FFT, while NumLen is the length of the FIR filter. To process each segment, the FFT of the segment is multiplied by the FFT of the FIR numerator, both of length NFFT. The resulting product undergoes an inverse fast Fourier transform (IFFT), and the last NFFT – NumLen samples are directed to the output. Any remaining samples are discarded.

For this specific implementation, NFFT is 128, and the filter length is 32. The input is provided in 96-sample frames, where the sum of the input frame size and the filter size equals the FFT length.

To obtain the coefficients for the time domain and filter domain for this implementation, we use the MATLAB script called test_tap32_fft128.m.

## The Design

![](./Images/design.png)

This design uses the _AIE Kenrel_ block to import the Overlap-Save kernel and uses the _ AIE Class Kernel_ block to import the kernel that applies the freqency domain coefficinets.

The definition of the Overlap-Save is shown below:

```
void __attribute__ ((noinline)) overlap_save( adf::input_buffer<cint16,adf::extents<WIN_SIZE>, adf::margin<TAP_NUM> > & restrict win_i,
                                              adf::output_buffer<cint16,adf::extents<FFT_SIZE> > & restrict win_o )
{
  auto win_ot = aie::begin_vector<8>( win_o );
  auto win_it = aie::begin_vector<8>( win_i );
  
  // Loop over input window, copy to output window:
  for ( unsigned int ll=0; ll < (WIN_SIZE + TAP_NUM) / 8; ll++)
    chess_loop_range(4,)
    chess_prepare_for_pipelining
  {
    aie::vector<cint16, 8> w = *win_it++;
    *win_ot++ = w;
  }
}
```

Note that this kernel is using an input buffer with the size of WIN_SIZE = 96 and a margin of TAP_NUM = 32. 

The image below depicts how the Overlap-save algorithm processes input data to generate output blocks of 128 samples each:

<img src="./Images/overlap_save.png" width="600">

Note the second class that applies the filter coefficients is using a non-default constructor to initialize a static array with the frequency domain filter coefficients. The image below depicts the block mask where the filter coefficients is passed to the constructor. 

<img src="./Images/constructor.png" width="600">

## Simulation results

In this design, we are comparing the output of the frequency domain filtering using the AI Engine blocks with FIR block from MathWorks DSP System Toolbox. 

<img src="./Images/simulink_design.png" width="900">

The output of the spectrum analyzer is shown below. As you can see the output of the two paths are almost completely overlapping. 

<img src="./Images/spectrum.png" width="500">

## Throughput

It is easy to access the throughput of this design in Model Composer. You need to generate code and run the cycle approximate aie simulation from the Hub block. Set the hub block as shown below:

<img src="./Images/hub.png" width="500">

After running the cycle approximate aie simulation, the Simulink Data Inspector will pop up and you would see the output signal and the estimated throughput there:

<img src="./Images/throughput_1.png" width="500">

### Increasing thoughput by using more AI Engine cores
The estimated throughput of 326 MHz is limited by the FFT blocks. To increase the throughput, you can increase the value of the Number of Cascade Length parameters of the FFT and IFFT blocks. This spreads the FFT operation over more than one AI Engine tile and will result in a throughput increase. The results for Number of Cascade Length of 2 and 4 are shown below:

| Cascade length = 2      | Cascade length = 4  |
| ------------- |:-------------:|
| <img src="./Images/throughput_2.png" width="400">     | <img src="./Images/throughput_4.png" width="400"> |



Note that there are three factors in play that result in a higher throughput:
* PLIO of width 64
* PLIO frequency of 500MHz
* Number of cascade length of 4 for each FFT



