lag = 2; 

e = convert_to_array(out.even_out);
o = convert_to_array(out.odd_out);

m_size = min(length(e), length(o));

filter_out = [e(1:m_size) o(1:m_size)];
filter_out = reshape(filter_out.', size(filter_out,1)*size(filter_out,2),1);

close all;
subplot(211)
plot(filter_out(lag+1:end));
hold on
axis tight
e_golden = out.even_out_golden;
e_golden = e_golden(:);
o_golden = out.odd_out_golden;
o_golden = o_golden(:);


m_size = min(length(e_golden), length(o_golden));

golden_out = [e_golden(1:m_size) o_golden(1:m_size)];
golden_out = reshape(golden_out.', size(golden_out,1)*size(golden_out,2),1);

plot(golden_out)
title("Overlap of AIE Kenrels and Simulink Model");
subplot(212)
shifted = filter_out(lag+1:end);
m_size = min(length(shifted), length(golden_out));
plot(double(shifted(1:m_size))-double(golden_out(1:m_size)))
title("Difference between AIE Kernels and Simulink Model");
axis tight