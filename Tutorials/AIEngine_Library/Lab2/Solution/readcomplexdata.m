function res = readcomplexdata(inputFileName)
%READCOMPLEXDATA Summary of this function goes here
%   Reads a delimited file into a 1 dimensional array of complex data
resMatrix = dlmread(inputFileName);
res = resMatrix(:,1) + 1i*resMatrix(:,2);
end

