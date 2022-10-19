%% Setup for ScanRAM

ctrlPeriod = 1/50e6;
firPeriod = 1/491.52e6;

periodScale = 1;
firPeriod = firPeriod*periodScale;

%ctrlPeriod = firPeriod;
%firPeriod = ctrlPeriod;

% WE Locations (port A)
WELocs = [0,3];
ctotalRegisters = 4; % This value determines size of RAMaddr, currentCount

cdataNBits = 32;
caddrNBits = ceil(log2(ctotalRegisters));


% Individual Register Sizes
inReg_0_NBits = 16;
inReg_0_BinPt = 8;
inReg_1_NBits = 32;
inReg_1_BinPt = 28;
inReg_2_NBits = 32;
inReg_2_BinPt = 28;
inReg_3_NBits = 8;
inReg_3_BinPt = 4;

%% Computations
WEVectorA = 0;
for jj=1:length(WELocs)
    WEVectorA = WEVectorA + 2^WELocs(jj);
end

% WE Locations (port B) (inverse of A)
WEVectorB = (2^(ctotalRegisters+1) -1) - WEVectorA;
%WEVectorB = 16;