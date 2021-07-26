%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) Copyright 2017-2017 Xilinx, Inc. All rights reserved.
% 
% This file contains confidential and proprietary information of Xilinx, Inc.
% and is protected under U.S. and international copyright and other
% intellectual property laws.
% 
% DISCLAIMER
% This disclaimer is not a license and does not grant any rights to the
% materials distributed herewith. Except as otherwise provided in a valid
% license issued to you by Xilinx, and to the maximum extent permitted by
% applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH
% ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS,
% EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES
% OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
% PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort,
% including negligence, or under any other theory of liability) for any
% loss or damage of any kind or nature related to, arising under or in
% connection with these materials, including for any direct, or any indirect,
% special, incidental, or consequential loss or damage (including loss of
% data, profits, goodwill, or any type of loss or damage suffered as a
% result of any action brought by a third party) even if such damage or loss
% was reasonably foreseeable or Xilinx had been advised of the possibility
% of the same.
% 
% CRITICAL APPLICATIONS
% Xilinx products are not designed or intended to be fail-safe, or for use
% in any application requiring fail-safe performance, such as life-support
% or safety devices or systems, Class III medical devices, nuclear
% facilities, applications related to the deployment of airbags, or
% any other applications that could lead to death, personal injury, or
% severe property or environmental damage (individually and collectively,
% "Critical Applications"). Customer assumes the sole risk and liability
% of any use of Xilinx products in Critical Applications, subject only to
% applicable laws and regulations governing limitations on product liability.
% 
% THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF
% THIS FILE AT ALL TIMES.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function updateHistogram(data)
%CREATEHISTOGRAM(DATA1)
%  DATA:  histogram data

persistent figure1;
persistent axes1;

if isSourceMovingObject()
    if  isempty(axes1) || ~isgraphics(axes1)
        figure1 = figure('name','Optical Flow, Xilinx Model Composer', ...
            'NumberTitle','off');
        % Create axes
        axes1 = axes('Parent',figure1);
    end
    
    % Create histogram
    histogram(axes1, data*180/pi,'NumBins',16,'BinLimits',[-180 180]);
    set(axes1, 'ylim',[0,100]);
    
    % Create xlabel
    xlabel('Angle');
    
    % Create title
    title('Histogram, Angle of optical flow vectors');
    
    % Create ylabel
    ylabel('Count');
    
    box(axes1,'on');
    % Set the remaining axes properties
    
    set(axes1,'XTick',[-180 -135 -90 -45 0 45 90 135 180]);
    
else
    if  isgraphics(figure1)
        close(figure1)
    end
end
end