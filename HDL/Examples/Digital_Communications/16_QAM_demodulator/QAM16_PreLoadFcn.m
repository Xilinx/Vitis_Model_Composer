% top level parameters
mu = 0.004;
chan = [1+j*0.1 .2 j*0.2 0 0 0 0 0 0 0];
theta_0 = 2*pi/1000;
eta = sqrt(2)/2;
theta_1 = 2*pi/8000;
eta1 = sqrt(2)/2;
k=9;
T=1;

% channel coefficients
k_i0= (4*theta_0*theta_0)/(1+2*eta*theta_0+theta_0*theta_0);
k_p0= (4*eta*theta_0)/(1+2*eta*theta_0+theta_0*theta_0);
k_i1= (4*theta_1*theta_1)/(1+2*eta1*theta_1+theta_1*theta_1);
k_p1= (4*eta1*theta_1)/(1+2*eta1*theta_1+theta_1*theta_1);

% input data
xn_ni = 16;
xn_nf = 12;
coeff_ni = 24;
coeff_nf = 20;

% defs for cmplx mult in LMS update engine
lms_mult_ni = 36;
lms_mult_nf = 28;
lms_mult_post_add_ni = 36;
lms_mult_post_add_nf = 28;

% precision of ACC in LMS engine
lms_acc_ni = 36;
lms_acc_nf = 28;

% defs for cmplx mult in FIR
fir_mult_ni = 36;
fir_mult_nf = 28;
fir_mult_post_add_ni = 36;
fir_mult_post_add_nf = 28;

% precision of ACC in FIR
fir_acc_ni = 20; 
fir_acc_nf = 16;;

% error signal
err_ni = 18;
err_nf = 16;

% adaption control
mu_ni = 24;
mu_nf = 20;
mu_mult_ni = 18;
mu_mult_nf = 16;
err_ni = 24;
err_nf = 20;

% coefficient precision used in FIR
coeff_ni = 18;
coeff_nf = 16;

% slicer input signal defs
slicer_in_ni = 12;
slicer_in_nf = 10;

% DDS defs
dds_nbits = 16;

% cordic defs
cordic_pe_nbits_total = 23;
cordic_pe_nbits_frac = 20;
cordic_pe_nbits_int = cordic_pe_nbits_total - cordic_pe_nbits_frac;
atan_nbits = 23;
atan_nbits_frac = 20;
atan_nbits_int = atan_nbits - atan_nbits_frac;
cordic_pe_z_correct_nbits_total = atan_nbits;
cordic_pe_z_correct_nbits_frac = atan_nbits_frac;
cordic_pe_z_correct_nbits_int = cordic_pe_z_correct_nbits_total - cordic_pe_z_correct_nbits_frac;

% shaping filter definition
hh=sinc(-3:.25:3);
randn('state',1.0e+009 * [2.62981801700000 3.38998616400000]' );
dx=sign(randn(1,1000));
dy=sign(randn(1,1000));
r4=abs((1/3)+j*(1/3))^4+2*abs((1/3)+j*1)^4+abs(1+j*1)^4;
r2=abs((1/3)+j*(1/3))^2+2*abs((1/3)+j*1)^2+abs(1+j*1)^2;
rp=r4/r2;
