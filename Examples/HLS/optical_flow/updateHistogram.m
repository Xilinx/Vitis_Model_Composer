%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2021 Xilinx
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
% http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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