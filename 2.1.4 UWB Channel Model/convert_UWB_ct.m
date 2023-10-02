function [hN,N] = convert_UWB_ct(h_ct,t,np,num_channels,ts)
% Convert continuous-time channel model h_ct to N-times oversampled discrete-time samples
% h_ct, t, np, and num_channels are as specified in UWB model
% ts is the desired time resolution
% 
% hN will be produced with time resolution ts / N.
% It is up to the user to then apply any filtering and/or complex downconversion and then
% decimate by N to finally obtain an impulse response at time resolution ts.
min_Nfs = 100;  % GHz
N = max(1, ceil(min_Nfs*ts) );  % N*fs = N/ts is the intermediate sampling frequency before decimation
N = 2^nextpow2(N);  % Make N a power of 2 to facilitate efficient multi-stage decimation
 
% NOTE: if we force N = 1 and ts = 0.167, the resulting channel hN will be identical to
% the results from earlier versions that did not use continuous-time.
Nfs = N/ts;
t_max = max(t(:));  % Maximum time value across all channels
h_len = 1 + floor(t_max * Nfs);  % Number of time samples at resolution ts / N
hN = zeros(h_len,num_channels);
for k = 1:num_channels
    np_k = np(k);  % Number of paths in this channel
    t_Nfs = 1 + floor(t(1:np_k,k) * Nfs);  % Vector of quantized time indices for this channel
    for n = 1:np_k
        hN(t_Nfs(n),k) = hN(t_Nfs(n),k) + h_ct(n,k);
    end
end