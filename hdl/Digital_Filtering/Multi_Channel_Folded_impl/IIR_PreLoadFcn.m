% This file is used to initialize all the parameters

num_channels=15;

bits_needed_1=ceil(log2(4*num_channels));
bits_needed_2=ceil(log2(20*num_channels));
bits_needed_3=ceil(log2(16*num_channels));

data_width_nbits=28;
data_width_frac=24;

mult_width_nbits=45;
mult_width_frac=38;

% coefficient b0
coeff_b0=0.2*ones([1,4*num_channels]);  % set it all to 0.2 for simplicity, 
                                        %users can parameterize it to their specifications.

%[-a1/b0, b2/b0, b1/b0, -a2/b0, 0]
coeffs=[0.4938, 0.9999, 2.0035, -0.0664, 0, ...%1st channel 1st biquad stage
        0.4400, 1.1363, 2.1316, -0.0671, 0, ...%2nd channel 1st biquad stage
        0.5784, 1.0467, 2.0458, -0.1099, 0, ...%3rd channel 1st biquad stage
        0.5174, 1.1021, 2.0983, -0.1175, 0, ...%4th channel 1st biquad stage
        0.4668, 1.0872, 2.0826, -0.1322, 0, ...%5th channel 1st biquad stage    
        0.6302, 1.0098, 2.0089, -0.2093, 0, ...%6th channel 1st biquad stage
        0.5693, 1.0379, 2.0343, -0.2295, 0, ...%7th channel 1st biquad stage 
        0.5164, 1.0120, 2.0078, -0.2526, 0, ...%8th channel 1st biquad stage     
        0.7305, 0.9704, 1.9696, -0.4018, 0, ...%9th channel 1st biquad stage 
        0.6603, 0.9637, 1.9601, -0.4261, 0, ...%10th channel 1st biquad stage 
        0.5982, 0.9420, 1.9381, -0.4509, 0, ...%11th channel 1st biquad stage 
        0.9078, 0.9461, 1.9453, -0.7419, 0, ...%12th channel 1st biquad stage 
        0.4920, 1.0109, 2.0014, -0.0654, 0, ...%13th channel 1st biquad stage  
        0.4300, 1.1263, 2.1346, -0.0671, 0, ...%14th channel 1st biquad stage
        0.5684, 1.0487, 2.0459, -0.1119, 0, ...%15th channel 1st biquad stage        
        0.5174, 1.1021, 2.0983, -0.1175, 0, ...%1st channel 2nd biquad stage
        0.4668, 1.0872, 2.0826, -0.1322, 0, ...%2nd channel 2nd biquad stage   
        0.6302, 1.0098, 2.0089, -0.2093, 0, ...%3rd channel 2nd biquad stage
        0.4938, 0.9999, 2.0035, -0.0664, 0, ...%4th channel 2nd biquad stage
        0.4400, 1.1363, 2.1316, -0.0671, 0, ...%5th channel 2nd biquad stage
        0.5784, 1.0267, 2.0458, -0.1099, 0, ...%6th channel 2nd biquad stage
        0.5274, 1.1521, 2.0983, -0.1175, 0, ...%7th channel 2nd biquad stage
        0.4768, 1.0972, 2.0826, -0.1322, 0, ...%8th channel 2nd biquad stage  
        0.6402, 1.0198, 2.0089, -0.2093, 0, ...%9th channel 2nd biquad stage
        0.5174, 1.1021, 2.0983, -0.1175, 0, ...%10th channel 2nd biquad stage
        0.4668, 1.0872, 2.0826, -0.1322, 0, ...%11th channel 2nd biquad stage    
        0.6302, 1.0098, 2.0089, -0.2093, 0, ...%12th channel 2nd biquad stage
        0.5174, 1.1021, 2.0983, -0.1175, 0, ...%13th channel 2nd biquad stage
        0.4668, 1.0872, 2.0826, -0.1322, 0, ...%14th channel 2nd biquad stage    
        0.6302, 1.0098, 2.0089, -0.2093, 0, ...%15th channel 2nd biquad stage
        0.5693, 1.0379, 2.0343, -0.2295, 0, ...%1st channel 3rd biquad stage 
        0.5164, 1.0120, 2.0078, -0.2526, 0, ...%2nd channel 3rd biquad stage     
        0.7305, 0.9704, 1.9696, -0.4018, 0, ...%3rd channel 3rd biquad stage 
        0.5693, 1.0379, 2.0343, -0.2295, 0, ...%4th channel 3rd biquad stage 
        0.5164, 1.0120, 2.0078, -0.2526, 0, ...%5th channel 3rd biquad stage     
        0.7305, 0.9704, 1.9696, -0.4018, 0, ...%6th channel 3rd biquad stage 
        0.4938, 0.9999, 2.0035, -0.0664, 0, ...%7th channel 3rd biquad stage
        0.4400, 1.1363, 2.1316, -0.0671, 0, ...%8th channel 3rd biquad stage
        0.5784, 1.0467, 2.0458, -0.1099, 0, ...%9th channel 3rd biquad stage
        0.5693, 1.0379, 2.0343, -0.2295, 0, ...%10th channel 3rd biquad stage  
        0.5164, 1.0120, 2.0078, -0.2526, 0, ...%11th channel 3rd biquad stage     
        0.7305, 0.9704, 1.9696, -0.4018, 0, ...%12th channel 3rd biquad stage
        0.5693, 1.0379, 2.0343, -0.2295, 0, ...%13th channel 3rd biquad stage 
        0.5164, 1.0120, 2.0078, -0.2526, 0, ...%14th channel 3rd biquad stage    
        0.7305, 0.9704, 1.9696, -0.4018, 0, ...%15th channel 3rd biquad stage
        0.6603, 0.9637, 1.9601, -0.4261, 0, ...%1st channel 4th biquad stage 
        0.5982, 0.9420, 1.9381, -0.4509, 0, ...%2nd channel 4th biquad stage 
        0.9078, 0.9461, 1.9453, -0.7419, 0, ...%3rd channel 4th biquad stage 
        0.6603, 0.9637, 1.9601, -0.4261, 0, ...%4th channel 4th biquad stage 
        0.5982, 0.9420, 1.9381, -0.4509, 0, ...%5th channel 4th biquad stage 
        0.9078, 0.9461, 1.9453, -0.7419, 0, ...%6th channel 4th biquad stage 
        0.6603, 0.9637, 1.9601, -0.4261, 0, ...%7th channel 4th biquad stage 
        0.5982, 0.9420, 1.9381, -0.4509, 0, ...%8th channel 4th biquad stage 
        0.9078, 0.9461, 1.9453, -0.7419, 0, ...%9th channel 4th biquad stage 
        0.4938, 0.9999, 2.0035, -0.0664, 0, ...%10th channel 4th biquad stage
        0.4400, 1.1363, 2.1316, -0.0671, 0, ...%11th channel 4th biquad stage
        0.5784, 1.0467, 2.0458, -0.1099, 0, ...%12th channel 4th biquad stage 
        0.6603, 0.9637, 1.9601, -0.4261, 0, ...%13th channel 4th biquad stage 
        0.5982, 0.9420, 1.9381, -0.4509, 0, ...%14th channel 4th biquad stage 
        0.9078, 0.9461, 1.9453, -0.7419, 0];%15th channel 4th biquad stage 
    
