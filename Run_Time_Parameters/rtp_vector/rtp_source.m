%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2020 Xilinx
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

classdef (StrictDefaults)rtp_source < matlab.System & matlab.system.mixin.Propagates
    
    properties
        % RTP Value
        RTP_Value = 1;
    end
    
    properties
        % Samlpe Time
        SampleTime = -1;
    end
    
    properties
        % Form output after final data
        AfterFinal = "Empty"
    end
    
    properties (Constant, Hidden)
        AfterFinalSet = matlab.system.StringSet({...
            'Empty', ...
            'Hold final value', ...
            'Cyclic repetition'});
    end
    
    properties (DiscreteState)
        index;
    end
    
    methods
        function this = rtp_input(varargin)
            setProperties(this, nargin, varargin{:});
        end
    end
    
    methods(Access=protected)
        
        function resetImpl(obj)
            obj.index = 1;
        end
        
        function [sz,dt,cp] = getDiscreteStateSpecificationImpl(~,name)
            if strcmp(name,'index')
                sz = [1 1];
                dt = 'double';
                cp = false;
            else
                error(['Error: Incorrect State Name: ', name.']);
            end
        end
        
        %         function validatePropertiesImpl(obj)
        %         end
        
        function rtp = stepImpl(obj)
            if obj.index <= size(obj.RTP_Value,2)
                if ~isnan(obj.RTP_Value(1,obj.index))
                    rtp = obj.RTP_Value(:,obj.index);
                else
                    rtp = cast([],'like', obj.RTP_Value);
                end
                obj.index = obj.index + 1;
            else
                if strcmp(obj.AfterFinal,"Empty")
                    rtp = cast([],'like', obj.RTP_Value);
                elseif strcmp(obj.AfterFinal,"Hold final value")
                    rtp = obj.RTP_Value(:,obj.index-1);
                else strcmp(obj.AfterFinal,"Hold final value")
                    obj.index = 1;
                    rtp = obj.RTP_Value(:,obj.index);
                    obj.index = obj.index + 1;
                end
            end
        end
        
        function num = getNumOutputsImpl(~)
            num = 1;
        end
        
        function sz1 = getOutputSizeImpl(obj)
            sz1 = size(obj.RTP_Value,1);
        end
        
        function fz1 = isOutputFixedSizeImpl(~)
            fz1 = false;
        end
        
        function dt1 = getOutputDataTypeImpl(obj)
            dt1 = class(obj.RTP_Value);
        end
        
        function cp1 = isOutputComplexImpl(obj)
            cp1 = ~isreal(obj.RTP_Value);
        end
        
        function sts = getSampleTimeImpl(obj)
            
            if obj.SampleTime == -1
                sts = createSampleTime(obj);
            else
                sts = createSampleTime(obj,'Type','Discrete',...
                    'SampleTime',obj.SampleTime,'OffsetTime',0);
            end
        end
    end
    
end