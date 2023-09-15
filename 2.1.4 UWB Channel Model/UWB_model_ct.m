function [h,t,t0,np] = UWB_model_ct(Lam,lam,Gam,gam,num_ch,nlos,sdi,sdc,sdr)
% IEEE 802.15.3a UWB channel model for PHY proposal evaluation
%      continuous-time realization of modified S-V channel model
% Inputs
%   Lam   : Cluster arrival rate in GHz (avg # of clusters per nsec)
%   lam   : Ray arrival rate in GHz (avg # of rays per nsec)
%   Gam   : Cluster decay factor (time constant, nsec)
%   gam   : Ray decay factor (time constant, nsec)
%   num_ch: number of random realizations to generate
%   nlos  : Flag to specify generation of Non Line Of Sight channels
%   sdi   : Standard deviation of log-normal shadowing of entire impulse response
%   sdc   : Standard deviation of log-normal variable for cluster fading
%   sdr   : Standard deviation of log-normal variable for ray fading
% Outputs
%   h     : A matrix with num_ch columns, each column having a random 
%           realization of the channel model (impulse response)
%   t     : Organized as h, but holds the time instances (in nsec) of the 
%           paths whose signed amplitudes are stored in h
%   t0    : The arrival time of the first cluster for each realization
%   np    : The number of paths for each realization.
%
% Thus, the k'th realization of the channel impulse response is the 
% sequence of (time,value) pairs given by (t(1:np(k),k), h(1:np(k),k))

% Initialize and precompute some things
std_L = 1/sqrt(2*Lam);   % std dev (nsec) of cluster arrival spacing
std_lam = 1/sqrt(2*lam); % std dev (nsec) of ray arrival spacing
mu_const = (sdc^2+sdr^2)*log(10)/20;  % Pre-compute for later
h_len = 1000;  % There must be a better estimate of # of paths than this
for k = 1:num_ch       % Loop over number of channels
    tmp_h = zeros(h_len,1);   tmp_t = zeros(h_len,1);
    if nlos
        Tc = (std_L*randn)^2+(std_L*randn)^2;  % First cluster random arrival
    else
        Tc = 0;        % First cluster arrival occurs at time 0
    end                               
    t0(k) = Tc;
    path_ix = 0;
    while (Tc < 10*Gam)
        % Determine Ray arrivals for each cluster
        Tr = 0;  % First ray arrival defined to be time 0 relative to cluster
        ln_xi = sdc*randn;   % Set cluster fading (new line added in rev. 1)
        while (Tr < 10*gam)
            t_val = Tc+Tr;  % Time of arrival of this ray
            mu = (-10*Tc/Gam-10*Tr/gam)/log(10) - mu_const; % Eq.(2.19)
            ln_beta = mu + sdr*randn;
            pk = 2*round(rand)-1;
            h_val = pk*10^((ln_xi+ln_beta)/20);
            path_ix = path_ix + 1;  % Row index of this ray
            tmp_h(path_ix) = h_val;  tmp_t(path_ix) = t_val;
            Tr = Tr + (std_lam*randn)^2 + (std_lam*randn)^2;
        end
        Tc = Tc + (std_L*randn)^2 + (std_L*randn)^2; 
    end
    np(k) = path_ix;  % Number of rays (or paths) for this realization
    [sort_tmp_t,sort_ix] = sort(tmp_t(1:np(k))); % Sort in ascending time order
    t(1:np(k),k) = sort_tmp_t;
    h(1:np(k),k) = tmp_h(sort_ix(1:np(k)));
    % Now impose a log-normal shadowing on this realization
    fac = 10^(sdi*randn/20)/sqrt(h(1:np(k),k)'*h(1:np(k),k));
    h(1:np(k),k) = h(1:np(k),k)*fac;
end