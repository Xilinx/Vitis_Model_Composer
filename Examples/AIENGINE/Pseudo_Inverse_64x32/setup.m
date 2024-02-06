%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2022 AMD
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


  read_complex_data('input', 'input.txt');
  
MATMULT_INPUT_SAMPLES 	=	2048;
MATMULT_OUTPUT_SAMPLES 	=	576;

CHOLESKY_32x32_INPUT_SAMPLES =	MATMULT_OUTPUT_SAMPLES;
CHOLESKY_32x32_OUTPUT_SAMPLES= 	CHOLESKY_32x32_INPUT_SAMPLES; 

LINV_INPUT_SAMPLES 	=	CHOLESKY_32x32_OUTPUT_SAMPLES;
LINV_OUTPUT_SAMPLES 	=	640;  %granularity of 8

TRIMULT_INPUT_SAMPLES 	=	LINV_OUTPUT_SAMPLES;
TRIMULT_OUTPUT_SAMPLES 	=	1024;   %populating whole matrix

MATMULT_RH_INPUT0_SAMPLES = 	TRIMULT_OUTPUT_SAMPLES;
MATMULT_RH_INPUT1_SAMPLES =	MATMULT_INPUT_SAMPLES;
MATMULT_RH_OUTPUT_SAMPLES =	MATMULT_INPUT_SAMPLES;
  
%% Other parameters
%user_params
% setenv("COMMSLIB_ROOT",'../../../../')
% setenv("AIESRC_ROOT",'../')
% setenv("DSPLIB_ROOT",xmcLibraryPath('get','dsplib'))

%%Location constraints 
% xoff = 0;
% yoff = 0;
% dir  = 1;

