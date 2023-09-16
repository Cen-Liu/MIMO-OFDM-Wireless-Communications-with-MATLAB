function [FadMtx,tf] = FWGN_tf(Np,fm_Hz,N,M,Nfosf,type,varargin)
% Fading generation using FWGN with fitering in the time domain
% Inputs
%   Np     : Number of multipath
%   fm_Hz  : A vector of maximum Doppler frequency of each path[Hz]
%   N      : Number of independent random realization
%   M      : Length of Doppler filter, i.e., size of IFFT
%   Nfosf  : Fading oversampling factor 
%   type   : Doppler spectrum type
%            'flat'=flat, 'class'=classical, 'sui'=spectrum of SUI channel
%            '3gpprice'=rice spectrum of 3GPP 
% Outputs
%   FadMtx : Np x N fading matrix 

% Generates scatter components having CN(0,1)
if isscalar(fm_Hz), fm_Hz = fm_Hz*ones(1,Np); end
fmax = max(fm_Hz);
path_wgn = sqrt(1/2)*complex(randn(Np,N),randn(Np,N));
for p = 1 : Np
   filt = gen_filter(fm_Hz(p),fmax,M,Nfosf,type,varargin{:});
   path(p,:) = fftfilt(filt,[path_wgn(p,:) zeros(1,M)]); % Filtering WGN
end
FadMtx = path(:,M/2+1:end-M/2);
tf = 1/(2*fmax*Nfosf); % Fading sample time = 1/(Max. Doppler BW*Nfosf)
% Normalize to 1
FadMtx = FadMtx./sqrt(mean(abs(FadMtx).^2,2)*ones(1,size(FadMtx,2))); 