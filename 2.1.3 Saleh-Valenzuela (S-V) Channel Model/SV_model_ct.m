function [h,t,t0,np] = SV_model_ct(Lam,lam,Gam,gam,num_ch,b002,sdi,nlos)
% S-V Channel Model
% Input 
%   Lam    : Cluster arrival rate in GHz (avg # of clusters per nsec)
%   lam    : Ray arrival rate in GHz (avg # of rays per nsec)
%   Gam    : Cluster decay factor (time constant, nsec)
%   gam    : Ray decay factor (time constant, nsec)
%   num_ch : Number of random realizations to generate
%   b002   : Power of first ray of first cluster
%   sdi    : Standard deviation of log-normal shadowing of entire impulse response[dB]
%   nlos   : Flag to specify generation of NLOS channels
% Output 
%   h      : A matrix with num_ch columns, each column having a random 
%            realization of channel model (impulse response)
%   t      : Time instances (in nsec) of the paths whose signed 
%              amplitudes are stored in h
%   t0     : Arrival time of the first cluster for each realization
%   np     : Number of paths for each realization
if nargin<8,  nlos=0;  end  % LOS environment
if nargin<7,  sdi=0;  end   % 0dB
if nargin<6,  b002=1;  end  % Power of first ray of first cluster
h_len = 1000;
for k = 1:num_ch            % Loop over number of channels
    tmp_h = zeros(h_len,1);  tmp_t = zeros(h_len,1);
    if nlos
       Tc = exprnd(1/Lam);  % First cluster random arrival ???
    else
       Tc = 0;              % First cluster arrival occurs at time 0
    end
    t0(k) = Tc;
    path_ix = 0;
    while (Tc<10*Gam)       % Cluster loop
        Tr = 0;
        while (Tr<10*gam)   % Ray loop
            t_val = Tc+Tr;  % Time of arrival of this ray
            bkl2 = b002*exp(-Tc/Gam)*exp(-Tr/gam);  % Ray power, Eq.(2.14)
            r = sqrt(randn^2+randn^2)*sqrt(bkl2/2);
            h_val = exp(1i*2*pi*rand)*r;  % Uniform phase
            path_ix = path_ix+1;  % Row index of this ray
            tmp_h(path_ix) = h_val; tmp_t(path_ix) = t_val;
            Tr = Tr + exprnd(1/Lam);  % Ray arrival time based on Eq.(2.11)
        end
        Tc = Tc + exprnd(1/lam);  % Cluster arrival time based on Eq.(2.10)
    end
    np(k)=path_ix;  % Number of rays/paths for this realization
    [sort_tmp_t,sort_ix] = sort(tmp_t(1:np(k)));  % In ascending order
    t(1:np(k),k) = sort_tmp_t;
    h(1:np(k),k) = tmp_h(sort_ix(1:np(k)));   
    % Log-normal shadowing on this realization
    fac = 10^(sdi*randn/20)/sqrt(h(1:np(k),k)' * h(1:np(k),k));
    h(1:np(k),k) = h(1:np(k),k)*fac; % Eq.(2.15)
end