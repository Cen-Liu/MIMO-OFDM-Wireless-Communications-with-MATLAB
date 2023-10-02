function PDP = exp_PDP(tau_d,Ts,A_dB,norm_flag)
% Exponential Power Delay Profile(PDP) Generator
% Input
%   tau_d     : RMS delay spread[sec]
%   Ts        : Sampling time[sec]
%   A_dB      : Smallest noticeable power[dB]
%   norm_flag : Normalize total power to unit
% Output:
%   PDP       : PDP vector
if nargin<4,  norm_flag = 1;  end  % normalization
if nargin<3,  A_dB = -20;  end     % 20dB below
sigma_tau = tau_d;
A = 10^(A_dB/10); 
lmax = ceil(-tau_d*log(A)/Ts); % Eq.(2.2)
% Compute normalization factor for power normalization
if norm_flag
    p0 = (1-exp(-Ts/sigma_tau))/(1-exp(-(lmax+1)*Ts/sigma_tau)); % Eq.(2.4)
else
    p0 = 1/sigma_tau; 
end
% Exponential PDP
l = 0:lmax;
PDP = p0*exp(-l*Ts/sigma_tau); % Eq.(2.5)