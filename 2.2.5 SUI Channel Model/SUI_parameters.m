function [Delay_us,Power_dB,K_factor,Doppler_shift_Hz,Ant_corr,Fnorm_dB] = SUI_parameters(ch_no)
% SUI Channel Parameters from Table 2.8
%  Inputs
%    ch_no            : Channel scenario number
%  Ouptuts:
%    Delay_us         : Tap delay[us]
%    Power_dB         : Power in each tap[dB]
%    K_factor         : Ricean K-factor in linear scale
%    Doppler_shift_Hz : Doppler maximal frequency parameter[Hz]
%    Ant_corr         : Antenna (envelope) correlation coefficient
%    Fnorm_dB         : Gain normalization factor[dB]
if ch_no<1||ch_no>6, error('Not supports channnel number'); end
Delays = [0 0.4 0.9; 0 0.4 1.1; 0 0.4 0.9; 0 1.5 4; 0 4 10; 0 14 20];
Powers = [0 -15 -20; 0 -12 -15; 0 -5 -10; 0 -4 -8; 0 -5 -10; 0 -10 -14]; 
Ks = [4 0 0; 2 0 0; 1 0 0; 0 0 0; 0 0 0; 0 0 0];
Dopplers = [0.4 0.3 0.5; 0.2 0.15 0.25; 0.4 0.3 0.5; 
            0.2 0.15 0.25; 2 1.5 2.5; 0.4 0.3 0.5];
Ant_corrs = [0.7 0.5 0.4 0.3 0.5 0.3];
Fnorms = [-0.1771 -0.393 -1.5113 -1.9218 -1.5113 -0.5683];
Delay_us = Delays(ch_no,:);
Power_dB = Powers(ch_no,:);
K_factor = Ks(ch_no,:);
Doppler_shift_Hz = Dopplers(ch_no,:); 
Ant_corr = Ant_corrs(ch_no);
Fnorm_dB = Fnorms(ch_no);