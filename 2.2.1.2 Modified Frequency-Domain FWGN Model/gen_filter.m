function filt=gen_filter(fm_Hz,fmax_Hz,Nfading,Nfosf,type,varargin)
% FIR filter weights generation
% Inputs
%   fm_Hz   : Max Doppler frequency of a tap
%   fmax_Hz : Max Doppler frequency of overall taps
%   Nfading : Doppler filter size, i.e., IFFT size
%   Nfosf   : Fading oversampling factor 
%   type    : Doppler spectrum type
%             'flat'=flat, 'class'=calssical, 'sui'=spectrum of SUI channel
%             '3gpprice'=rice spectrum of 3GPP 
% Outputs             
%   filt    : Filter coefficients     

% Doppler BW= 2*fm*Nfosf ==> 2*fmax_Hz*Nfosf
dfmax = 2*Nfosf*fmax_Hz/Nfading;      % Doppler frequency spacing 
% Respect to maximal Doppler frequency
Nd = floor(fm_Hz/dfmax)-1;    % 
if Nd<1
    error('The difference between max and min Doppler frequency is too large.\n increase the IFFT size?');
end                         
ftn_PSD = Doppler_PSD_function(type); % Corresponding Doppler function
switch lower(type(1:2))
    case '3g', PSD = ftn_PSD(-Nd:Nd,Nd);
               filt = [PSD(Nd+1:end-1) zeros(1,Nfading-2*Nd+1) PSD(2:Nd)];
    case 'la', PSD = ftn_PSD((-Nd:Nd)/Nd,varargin{:});
               filt = [PSD(Nd+1:end-1) zeros(1,Nfading-2*Nd+1) PSD(2:Nd)];
    otherwise, PSD=ftn_PSD((0:Nd)/Nd); 
               filt=[PSD(1:end-1) zeros(1,Nfading-2*Nd+3) PSD(end-1:-1:2)];    
               % constructs a symmetric Doppler spectrum
end
filt = real(ifftshift(ifft(sqrt(filt))));
filt = filt/sqrt(sum(filt.^2));