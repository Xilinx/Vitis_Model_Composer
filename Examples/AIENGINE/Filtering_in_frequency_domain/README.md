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
template <int NUM_OF_FRAMES>
void __attribute__ ((noinline)) overlap_save(adf::input_buffer<cint16,adf::extents<adf::inherited_extent>, adf::margin<TAP_NUM>> & restrict win_i,
                                                   adf::output_buffer<cint16> & restrict win_o )
{
    auto win_ot = aie::begin_vector<8>( win_o );
    auto win_it = aie::begin_vector<8>( win_i );

    for ( unsigned int jj=0; jj < NUM_OF_FRAMES; jj++) 
    {
            // Loop over input window, copy to output window:
            for ( unsigned int ll=0; ll < (WIN_SIZE + TAP_NUM) / 8; ll++)
                chess_loop_range(4,)
                chess_prepare_for_pipelining
            {
                aie::vector<cint16, 8> w = *win_it++;
                *win_ot++ = w;
            }

        win_it -= TAP_NUM/8;
    }

}
```

The kernel uses an input buffer of size WIN_SIZE = 96, as specified in the block mask, along with a margin of TAP_NUM = 32 samples. The template parameter, NUM_OF_FRAMES, defaults to one, and the purpose for requiring it will be explained later when discussing design throughput. The margin is utilized in situations where an algorithm requires a certain number of samples from the previous frame. In this scenario, every 128-sample output block comprises a 96-sample input frame and 32 samples from the previous input frame. The process by which the Overlap-save algorithm produces output blocks of 128 samples is depicted in the following image:

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

| Cascade length| Throughput(MSPS)|
| ------------- |:-------------:|
|1  | 326|
|2|451|
|3|500|
|4|500|

Note that increasing the cascade length beyond 3 is no longer increasing the thoughput. To increase the throughput furthur, we need to inlcresae the PLIO width

### Increasing throughput by incresaing the PLIO width
The PLIO width can be configured to 32, 64, or 128. In this example, the PLIO width has been set to 32 and the PLIO frequency has been set to 500MHz. This implies that the AI Engine will receive data from the PL at a maximum rate of 500 MSPS, with each sample being 32 bits. Consequently, the maximum throughput is limited to 500 MSPS (see the table above). However, if we increase the PLIO width to 64, while maintaining the PLIO frequency at 500MHz, the PL can send data to the AI Engine at a rate of 500 MSPS with each sample being 64 bits. This means the AI Engine can process incoming 32-bit data at 1GSPS, potentially achieving a throughput of 1GSPS.

Here are the new throughput numbers with a PLIO width of 64:

| Cascade length| Throughput(MSPS)|
| ------------- |:-------------:|
|1  | 326|
|2|454|
|3|549|
|4|718|

### Increasing throughput by increasing the number of frames fed to the FFT blocks

Increasing the value of the Input Window Size parameter of the FFT/IFFT blocks can boost the throughput. By setting this parameter as an integer multiple of the FFT size, multiple FFT iterations can be performed on a given input window, generating multiple iterations of output samples. This reduces the number of times the kernel needs to be triggered to process a given number of input data samples, resulting in lower overheads during kernel triggering and an overall increase in throughput.

To increase the number of frames that are supplied to the FFT blocks, you can set the variable NUM_OF_FRAMES to an integer value in the MATLAB command window. The default value for this variable is one.

The table below illustrates the impact on throughput as we increase the number of input frames for a PLIO of 64 and cascade lengths of 4:

| Number of frames| Throughput(MSPS)|
| ------------- |:-------------:|
|1  | 718|
|2|874|
|4|976|
|8|1000|

By employing the mentioned techniques to boost the throughput, we have achieved a 1GSPS throughput. However, this comes at the cost of higher resource usage due to the increased cascade length and increased design latency resulting from the higher number of frames. 





