function [FadMtx,tf] = SUI_fading(P_dB,K_factor,Doppler_shift_Hz,Fnorm_dB,N,M,Nfosf)
% SUI fading generation using FWGN with filtering in frequency domain
% Inputs
%   P_dB             : Power in each tap in dB
%   K_factor         : Rician K-factor in linear scale
%   Doppler_shift_Hz : A vector containing the maximum Doppler frequency of each path in Hz
%   Fnorm_dB         : Gain normalization factor in dB
%   N                : Number of independent random realizations
%   M                : Length of Doppler filter, i.e., size of IFFT
%   Nfosf            : Fading oversampling factor 
%  Outputs
%   FadMtx           : Length(P_dB) x N fading matrix
%   tf               : Fading sample time = 1/(Max Doppler BW * Nfosf)
Power = 10.^(P_dB/10);                    % Calculate linear power
s2 = Power./(K_factor+1);                 % Calculate variance
s = sqrt(s2);
m2 = Power.*(K_factor./(K_factor+1));     % Calculate constant power
m = sqrt(m2);                             % Calculate constant part
L =length(Power);                          % Number of tabs
fmax = max(Doppler_shift_Hz);
tf = 1/(2*fmax*Nfosf);
if isscalar(Doppler_shift_Hz)
    Doppler_shift_Hz= Doppler_shift_Hz*ones(1,L);
end
path_wgn = sqrt(1/2)*complex(randn(L,N),randn(L,N));
for p = 1:L
    filt = gen_filter(Doppler_shift_Hz(p),fmax,M,Nfosf,'sui');
    path(p,:) = fftfilt(filt,[path_wgn(p,:) zeros(1,M)]); % Filtering WGN
end
FadMtx = path(:,M/2+1:end-M/2);
for i = 1:L
    FadMtx(i,:)=FadMtx(i,:)*s(i) + m(i)*ones(1,N);
end
FadMtx = FadMtx*10^(Fnorm_dB/20);