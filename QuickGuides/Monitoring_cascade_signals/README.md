# Monitoring cascade signals in an AIE Engine design

In a Versal-AIE device, data from one AI Engine can be forwarded to another by using cascade streams. In AIE each stream is 384 bit wide. In AIE-ML a cascade steam is 512 bit wide. In other words, in one clock cycles, we can transfer 384 bit data from one AIE tile to a neighboring tile in an AIE device.

In Vitis Model Composer, you can import a kernel with cascade input and output ports using the AIE Kenel block and easily moniotr the cascade signsl for debugging purposes. 


