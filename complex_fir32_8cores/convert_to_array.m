function array = convert_to_array(in)
values = in.signals.values;
valueDimensions = in.signals.valueDimensions;

array = zeros(sum(valueDimensions)*size(values,2),1);

index = 1;
for i = 1:length(valueDimensions)
    array(index:index+valueDimensions(i)-1) = values(i,1:valueDimensions(i)).';
    index = index + valueDimensions(i);
end

