%This file initializes different values used in the IIR-model
Fs = 200;
%This variable defines the relative speed at which the iir system has to
%run to satisfy timing constraint. 
scale = 5;


%filter numerators
NUM1=0.006724179185729;
NUM3=-0.006724179185729;

%filter denominators
DEN2=1.576037380547040;
DEN3=-0.986551641628541;