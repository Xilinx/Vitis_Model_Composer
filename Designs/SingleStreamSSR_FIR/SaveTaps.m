function SaveTaps(Taps,filename)

fp = fopen(filename,'w');

for i=1:length(Taps)
    fprintf(fp,'{ %5d , %5d }',real(Taps(i)),imag(Taps(i)));
    if(i<length(Taps))
        fprintf(fp,' , ');
    end
    if(rem(i,4)==0)
        fprintf(fp,'\n');
    end
end

