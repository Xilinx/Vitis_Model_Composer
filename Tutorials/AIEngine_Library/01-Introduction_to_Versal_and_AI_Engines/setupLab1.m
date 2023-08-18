% Copyright 2023 Advanced Micro Devices, Inc.
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%

%%
close all;
clear;

%% Identify lab file folders
labRoot = pwd;
commonRoot = [labRoot '/../common'];
workDir = [labRoot '/work'];

%% Add common folders, which contain Simulink models and MATLAB scripts, to path
addpath(commonRoot);
addpath([commonRoot '/matlab']);
setenv('AIESRC', [commonRoot '/src']);

%% Prepare the work folder with files needed for the lab
if exist(workDir, 'dir')
    rmdir(workDir,'s');
end
mkdir(workDir);
copyfile([commonRoot '/DecimationChain.slx'], workDir);
copyfile([commonRoot '/matlab/CreateFilter.m'], workDir);

%% Change to work folder
cd(workDir);

%% Create filter coefficients
CreateFilter;

