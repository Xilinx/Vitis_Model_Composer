# Filtering in Frequency Domain

In the frequency domain, the filtering operation involves the multiplication of the Fourier transform of the input and the Fourier transform of the 
impulse response followed by an inverse fourier transofrm.
As the length of the impulse response increases, the frequency-domain filtering technique becomes more efficient compared to time-domain filtering.

# The Algorithm

This exmaple uses the Overlap-Save method. The diagram below depicts this algorithm at a high level:

![](./Images/high_level.png)


