# Two Dimensional FFT using Corner Turning Technique for MRI Sagittal Image Reconstruction

## Introduction

Magnetic Resonance Imaging (MRI) is a medical diagnostic tool used to reveal anatomical details in greater detail than an X-ray. MRI image reconstruction is the process of reconstructing the image from MRI data. The MRI machine collects data in the spatial frequency domain (also referred to as K-space), and this data is then conditioned and processed to create the spatial image that can be meaningfully inspected. An important step of this image reconstruction is performing a two dimensional FFT on the input data. This demo focuses entirely on this particular step of the image reconstruction process.

## MRI Input Data and Reconstructed Image Output

In this design, the input data is 10 frames of 256x256 K-space MRI data of a human brain produced by an MRI machine. These 10 frames are adjacent slices parallel to the sagittal plane of the head. Because of the way the data was collected there is some spatial aliasing in the reconstructed image.

## Input and post-simulation output images:

![](Images/MRI_InputOutputResult.jpg)

## Methodology

This demo performs a two dimensional FFT (2D-FFT) on input data. Since the FFT is completely separable in two dimensions, a column wise FFT is performed on the input image, followed by row wise FFT to realize the 2D-FFT. An efficient implementation is to transpose the columns and rows in memory using a "corner-turning" technique before performing the 2nd FFT operation.

Buffer the incoming data in an rectangular array with P rows and Q columns. For the 256 point x 256 point FFT performed in this demo design, P=256, and Q=256.
##### For k=0:Q-1,
  ##### 1) Read kth column from the memory
  ##### 2) FFT of P samples
#### Perform transpose of array in memory
##### For j=0:P-1,
  ##### 1) Read jth column from the memory
  ##### 2) FFT of Q samples

![](Images/2DFFT_CornerTurn.jpg)
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
