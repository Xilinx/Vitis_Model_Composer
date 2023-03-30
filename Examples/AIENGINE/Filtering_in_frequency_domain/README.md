# Filtering in Frequency Domain

In the frequency domain, the filtering operation involves the multiplication of the Fourier transform of the input and the Fourier transform of the 
impulse response followed by an inverse Fourier transform.
As the length of the impulse response increases, the frequency-domain filtering technique becomes more efficient compared to time-domain filtering.

## The Algorithm

This example uses the Overlap-Save method. The diagram below depicts this algorithm at a high level:

<img src="./Images/high_level.png" width="600">

The input stream is divided into overlapping segments of size FFT_SIZE, where each segment has an overlap of TAP_NUM samples (see image in the design section). FFT_SIZE represents the length of the FFT, while TAP_NUM is the length of the FIR filter. To process each segment, the FFT of the segment is multiplied by the FFT of the FIR numerator, both of length FFT_SIZE. The resulting product undergoes an inverse fast Fourier transform (IFFT), and the last FFT_SIZE – TAP_NUM samples are directed to the output. Any remaining samples are discarded.

For this specific implementation, FFT_SIZE is 128, and the TAP_NUM is 32. The input is provided in 96-sample frames, where the sum of the input frame size and the filter size equals the FFT length.

To obtain the coefficients for the time domain and filter domain for this implementation, we use a MATLAB script called `test_tap32_fft128.m`.

## The Design

![](./Images/design.png)

This design uses the _AIE Kernel_ block to import the Overlap-Save kernel and uses the _AIE Class Kernel_ block to import the kernel that applies the frequency domain coefficinets.

The definition of the Overlap-Save kernel is shown below:

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

This kernel is using an input buffer with the size of WIN_SIZE = 96 and a margin of TAP_NUM = 32 samples. In cases where an algorithm needs a certain number of samples from the previous frame, _margin_ is utilized. Specifically, for this particular scenario, every 128-sample output block is made up of a 96-sample input frame and 32 samples from the previous input frame. The following image illustrates the process by which the Overlap-save algorithm operates on input data to produce output blocks consisting of 128 samples each:

<img src="./Images/overlap_save.png" width="600">

Note the second class that applies the filter coefficients is using a non-default constructor to initialize a static array with the frequency domain filter coefficients. The image below depicts the block mask where the filter coefficients are passed to the constructor. 

<img src="./Images/constructor.png" width="600">

## Simulation results

In this design, we are comparing the output of the frequency domain filtering using the AI Engine blocks with the FIR block from MathWorks DSP System Toolbox. 

<img src="./Images/simulink_design.png" width="900">

The output of the spectrum analyzer is shown below. As you can see, the spectra of the two paths are almost completely overlapping. 

<img src="./Images/spectrum.png" width="500">

## Throughput

It is easy to estimate the throughput of this design in Vitis Model Composer. You need to generate code and run the cycle-approximate AI Engine simulation from the Hub block. The Hub block configuration is shown below:

<img src="./Images/hub.png" width="500">

After running the cycle-approximate AI Engine simulation, the Simulink Data Inspector will pop up and you will see the output signal and the estimated throughput:

<img src="./Images/throughput_1.png" width="500">

### Increasing throughput by using more AI Engine cores
The estimated throughput of 326 MHz is limited by the FFT blocks. To increase the throughput, you can increase the value of the Number of Cascade Length parameters of the FFT and IFFT blocks. This spreads the FFT operation over more than one AI Engine tile and will result in a throughput increase. The results for Number of Cascade Length of 2 and 4 are shown below:

| Cascade length = 2   (454 MHz)   | Cascade length = 4   (790 MHz)|
| ------------- |:-------------:|
| <img src="./Images/throughput_2.png" width="400">     | <img src="./Images/throughput_4.png" width="400"> |



Note that there are three factors in this design that result in a higher throughput:
* PLIO width of 64 bits
* PLIO frequency of 500MHz
* Cascade length greater than one for the FFT and IFFT blocks. 



