function H = Ric_model(K_dB, L)
% Rician Channel Model
% Input
%       K_dB : K factor[dB]
%       L    : Number of channel realizations
% Output
%       H    : Channel vector
K = 10^(K_dB/10);
H = sqrt(K/(K+1)) + sqrt(1/(K+1)) * Ray_model(L);