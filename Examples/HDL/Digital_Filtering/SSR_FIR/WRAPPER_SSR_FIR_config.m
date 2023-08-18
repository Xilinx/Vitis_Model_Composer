
function WRAPPER_SSR_FIR_config(this_block)

  % Revision History:
  %
  %   10-Jan-2022  (11:03 hours):
  %     Original code was machine generated by Xilinx System Generator after parsing
  %     C:\SSRFIR\WRAPPER_SSR_FIR.vhd
  %
  %

  this_block.setTopLevelLanguage('Verilog');

  this_block.setEntityName('WRAPPER_SSR_FIR');

  parent = get_param(this_block.blockName,'Parent');
maskParamNameValuePairs = get_param(parent, 'MaskWSVariables');

% now step through each MASK to get the name and the evaluated value
for i=1:length(maskParamNameValuePairs)
    if (strcmpi(maskParamNameValuePairs(i).Name, 'OX'))
        OX = maskParamNameValuePairs(i).Value;
    end
    if (strcmpi(maskParamNameValuePairs(i).Name, 'OY'))
        OY = maskParamNameValuePairs(i).Value;
    end
%    if (strcmpi(maskParamNameValuePairs(i).Name, 'FAMILY'))
%        FAMILY = maskParamNameValuePairs(i).Value;
%    end
     if (strcmpi(maskParamNameValuePairs(i).Name, 'DDR'))
        DDR = maskParamNameValuePairs(i).Value;
    end
   if (strcmpi(maskParamNameValuePairs(i).Name, 'SSR'))
        SSR = maskParamNameValuePairs(i).Value;
    end
    if (strcmpi(maskParamNameValuePairs(i).Name, 'TAPS'))
        TAPS = maskParamNameValuePairs(i).Value;
    end
    if (strcmpi(maskParamNameValuePairs(i).Name, 'COEFFICIENT'))
        COEFFICIENT = maskParamNameValuePairs(i).Value;
    end
    if (strcmpi(maskParamNameValuePairs(i).Name, 'I_HIGH'))
        I_HIGH = maskParamNameValuePairs(i).Value;
    end
    if (strcmpi(maskParamNameValuePairs(i).Name, 'I_LOW'))
        I_LOW = maskParamNameValuePairs(i).Value;
    end
    if (strcmpi(maskParamNameValuePairs(i).Name, 'C_HIGH'))
        C_HIGH = maskParamNameValuePairs(i).Value;
    end
    if (strcmpi(maskParamNameValuePairs(i).Name, 'C_LOW'))
        C_LOW = maskParamNameValuePairs(i).Value;
    end
    if (strcmpi(maskParamNameValuePairs(i).Name, 'O_HIGH'))
        O_HIGH = maskParamNameValuePairs(i).Value;
    end
    if (strcmpi(maskParamNameValuePairs(i).Name, 'O_LOW'))
        O_LOW = maskParamNameValuePairs(i).Value;
    end
    if (strcmpi(maskParamNameValuePairs(i).Name, 'ROUNDING'))
        ROUNDING = maskParamNameValuePairs(i).Value;
    end
    if (strcmpi(maskParamNameValuePairs(i).Name, 'SYMMETRY'))
        SYMMETRY = maskParamNameValuePairs(i).Value;
    end
end

family = this_block.getDeviceFamilyName;
if(contains(family,"7") || strcmp(family,"zynq") || strcmp(family,"qzynq") || strcmp(family,"azynq"))
    FAMILY = 1; % use 1 for selecting DSP48E1 
elseif(contains(family,"versal"))
    FAMILY = 3; % use 1 for selecting DSP58 
else
    FAMILY = 2; % use 2 for selecting DSP48E2
end

% System Generator has to assume that your entity  has a combinational feed through; 
  %   if not, then comment out the following line:
  %this_block.tagAsCombinational;

  this_block.addSimulinkInport('I');
  this_block.addSimulinkInport('VI');

  this_block.addSimulinkOutport('O');
  this_block.addSimulinkOutport('VO');

  VO_port = this_block.port('VO');
  VO_port.setType('UFix_1_0');
  VO_port.useHDLVector(false);

  % -----------------------------
  if (this_block.inputTypesKnown)
    % do input type checking, dynamic output type and generic setup in this code block.

    % (!) Port 'I' appeared to have dynamic type in the HDL -- please add type checking as appropriate;
  %  inp_width = this_block.port('I').width; % this should be SSR*(I_HIGH-I_LOW+1)
    this_block.port('I').useHDLVector(true);

    if (this_block.port('VI').width ~= 1);
      this_block.setError('Input data type for port "VI" must have width=1.');
    end

    this_block.port('VI').useHDLVector(false);

  % (!) Port 'O' appeared to have dynamic type in the HDL
  % --- you must add an appropriate type setting for this port
  this_block.port('O').setType(['UFix_' num2str(SSR*(O_HIGH-O_LOW+1)) '_' num2str(0)]);
end  % if(inputTypesKnown)
  % -----------------------------

  % -----------------------------
   if (this_block.inputRatesKnown)
     setup_as_single_rate(this_block,'CLK','CE')
   end  % if(inputRatesKnown)
  % -----------------------------

    uniqueInputRates = unique(this_block.getInputRates);

  % (!) Custimize the following generic settings as appropriate. If any settings depend
  %      on input types, make the settings in the "inputTypesKnown" code block.
  %      The addGeneric function takes  3 parameters, generic name, type and constant value.
  %      Supported types are boolean, real, integer and string.

  
  this_block.addGeneric('OX','INTEGER',num2str(OX));
  this_block.addGeneric('OY','INTEGER',num2str(OY));
  this_block.addGeneric('FAMILY','INTEGER',num2str(FAMILY));
  if (DDR==1) 
    this_block.addGeneric('DDR','BOOLEAN','TRUE');
  else
    this_block.addGeneric('DDR','BOOLEAN','FALSE');
  end
  this_block.addGeneric('SSR','INTEGER',num2str(SSR));
  this_block.addGeneric('TAPS','INTEGER',num2str(TAPS));
  this_block.addGeneric('C','STRING',strcat('"',num2str(COEFFICIENT,' %.16f'),'"'));
  this_block.addGeneric('I_HIGH','INTEGER',num2str(I_HIGH));
  this_block.addGeneric('I_LOW','INTEGER',num2str(I_LOW));
  this_block.addGeneric('C_HIGH','INTEGER',num2str(C_HIGH));
  this_block.addGeneric('C_LOW','INTEGER',num2str(C_LOW));
  this_block.addGeneric('O_HIGH','INTEGER',num2str(O_HIGH));
  this_block.addGeneric('O_LOW','INTEGER',num2str(O_LOW));
  if (ROUNDING==1) 
    this_block.addGeneric('ROUNDING','BOOLEAN','TRUE');
  else
    this_block.addGeneric('ROUNDING','BOOLEAN','FALSE');
  end
  this_block.addGeneric('SYMMETRY','STRING',convertStringsToChars(strcat('"',SYMMETRY,'"')));

  % Add addtional source files as needed.
  %  |-------------
  %  | Add files in the order in which they should be compiled.
  %  | If two files "a.vhd" and "b.vhd" contain the entities
  %  | entity_a and entity_b, and entity_a contains a
  %  | component of type entity_b, the correct sequence of
  %  | addFile() calls would be:
  %  |    this_block.addFile('b.vhd');
  %  |    this_block.addFile('a.vhd');
  %  |-------------

  this_block.addFile('TYPES_PKG.vhd');
  this_block.addFile('BDELAY.vhd');
  this_block.addFile('SDELAY.vhd');
  this_block.addFile('DSPx8_WRAPPER.vhd');
  this_block.addFile('SSR_FIR.vhd');
  this_block.addFile('WRAPPER_SSR_FIR.vhd');

return;


% ------------------------------------------------------------

function setup_as_single_rate(block,clkname,cename) 
  inputRates = block.inputRates; 
  uniqueInputRates = unique(inputRates); 
  if (length(uniqueInputRates)==1 & uniqueInputRates(1)==Inf) 
    block.addError('The inputs to this block cannot all be constant.'); 
    return; 
  end 
  if (uniqueInputRates(end) == Inf) 
     hasConstantInput = true; 
     uniqueInputRates = uniqueInputRates(1:end-1); 
  end 
  if (length(uniqueInputRates) ~= 1) 
    block.addError('The inputs to this block must run at a single rate.'); 
    return; 
  end 
  theInputRate = uniqueInputRates(1); 
  for i = 1:block.numSimulinkOutports 
     block.outport(i).setRate(theInputRate); 
  end 
  block.addClkCEPair(clkname,cename,theInputRate); 
  return; 

% ------------------------------------------------------------

