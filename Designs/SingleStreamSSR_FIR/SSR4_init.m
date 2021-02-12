%% SSR4 initialization

DISPLAY = 0;

% N is frame size.
N = 4;

Norm = 32768;
i = sqrt(-1);
UTaps = CreateFilter(32);
Taps = NormalizeCoef(UTaps,32768);



if(DISPLAY==1)
fprintf('---------------------------------------------------------------------\n');
fprintf('Normalization Coef %8d --> Result %d\n\n',Norm,sum(IntCoef));
fprintf('Real Part     : %8d  ->  %8d\n',min(real(IntCoef)),max(real(IntCoef)));
fprintf('Imaginary Part: %8d  ->  %8d\n',min(imag(IntCoef)),max(imag(IntCoef)));
fprintf('---------------------------------------------------------------------\n\n\n');
Lspec = 2048;
freqz(Taps/(Norm/Lspec),Lspec,'whole');
end

SaveTaps(Taps,'src/FilterTaps.txt');


SHIFT_ACC = 15;
NPHASES = 4;
BURST_LENGTH = 512;

phi_3 = fliplr(Taps(1:4:end));
phi_2 = fliplr(Taps(2:4:end));
phi_1 = fliplr(Taps(3:4:end));
phi_0 = fliplr(Taps(4:4:end));

%Specifying Location Constraints
LOCATION_0_0 = [25,0];
LOCATION_1_0 = [28,1];
LOCATION_2_0 = [25,2];
LOCATION_3_0 = [28,3];

%PLIO Frequency

PLIO_FREQ = 500;

