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

function [output_args] = switchCallback(handle)

hws = get_param(bdroot,'modelworkspace');

if strcmp(get_param(handle,'sw'),'0')
    set_param(handle,'sw','1');
    source = 'moving_object';
    hws.assignin('gainValueHSV',4);
    hws.assignin('SourceMovingObject',true);
else
    set_param(handle,'sw','0');
    source = 'moving_people';
    hws.assignin('gainValueHSV',.2);
    hws.assignin('SourceMovingObject',false);
end

end

