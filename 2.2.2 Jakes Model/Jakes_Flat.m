function [h,tf] = Jakes_Flat(fd,Ts,Ns,t0,E0,phi_N)
% Inputs
%   fd      : Doppler frequency
%   Ts      : Sampling time
%   Ns      : Number of samples
%   t0      : Initial time
%   E0      : Channel power
%   phi_N   : Inital phase of the maximum doppler frequency sinusoid
% Outputs
%   h       : Complex fading vector
%   tf      : Current time
if nargin<6, phi_N = 0; end
if nargin<5, E0 = 1;    end
if nargin<4, t0 = 0;    end
if nargin<3, error('More arguments are needed for Jakes_Flat()'); end
N0 = 8;       % As suggested by Jakes 
N = 4*N0+2;   % An accurate approximation              
wd = 2*pi*fd; % Maximum doppler frequency[rad]
t = t0+(0:Ns-1)*Ts; tf = t(end)+Ts; % Time vector and final time
coswt = [sqrt(2)*cos(wd*t); 2*cos(wd*cos(2*pi/N*(1:N0)')*t)]; % Eq.(2.26)
h = E0/sqrt(2*N0+1)*exp(1i*[phi_N pi/(N0+1)*(1:N0)])*coswt;   % Eq.(2.23)