# Filtering in Frequency Domain

In the frequency domain, the filtering operation involves the multiplication of the Fourier transform of the input and the Fourier transform of the 
impulse response followed by an inverse fourier transofrm.
As the length of the impulse response increases, the frequency-domain filtering technique becomes more efficient compared to time-domain filtering.

## The Algorithm

This exmaple uses the Overlap-Save method. The diagram below depicts this algorithm at a high level:

![](./Images/high_level.png)

The input stream is partitioned into overlapping blocks of size NFTT, with an overlap of NumLen samples. NFFT is the FFT length and NumLen is the length of the FIR filter. The FFT of each block of input samples is computed and multiplied with the FFT of length NFFT of the FIR numerator. The inverse fast Fourier transform (IFFT) of the result is performed, and the last NFFT – NumLen samples are streamed the output. The remaining samples are discarded.

In this example the FFT length is 128 and the filter lenght is 32.

## The Design

![](./Images/design.png)

This design uses the Class Import block to import the Overlap-Save and the Discarding kernels. The class declaration for the Overlap-Save is shown below:

```
class OverlapSave {
    private:
    alignas(32) cint16 overlap_state [TAP_NUM];

    public:
    void overlap_save(adf::input_buffer<cint16,adf::extents<WIN_SIZE> > & restrict win_i,
                      adf::output_buffer<cint16,adf::extents<FFT_SIZE> > & restrict win_o);

    static void registerKernelClass()
    {
        REGISTER_FUNCTION(OverlapSave::overlap_save);
    };
};
```

Note that the Class is using a state array variable which is the same size as the filter length.

The image below depicts how the the Overlap-Size algorithm processes input data to generate ouptu blocks of 128 sample each:

![](./Images/overlap_save.png)
