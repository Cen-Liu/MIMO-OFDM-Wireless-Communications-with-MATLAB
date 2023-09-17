function h = ray_fading(M,PDP,BS_PHI_rad,MS_theta_deg,v_ms,theta_v_deg,lambda,t)
% Inputs
%   M            : Number of subrays
%   PDP          : 1 x Npath Power at delay
%   BS_theta_deg : (Npath x M) DoA per path in degree at BS
%   BS_PHI_rad   : (Npath x M) random phase in degree at BS
%   MS_theta_deg : (Npath x M) DoA per path in degree at MS
%   v_ms         : Velocity in m/s
%   theta_v_deg  : DoT of mobile in degree
%   lambda       : wavelength in meter
%   t            : current time
% Outputs
%   h            : Length(PDP) x length(t) channel coefficient matrix
MS_theta_rad = deg2rad(MS_theta_deg);
theta_v_rad = deg2rad(theta_v_deg);
% Generate channel coefficients using Eq.(2.32)
for n = 1:length(PDP)
    tmph=exp(-1i*BS_PHI_rad(n,:)')*ones(size(t)) .* ...
    exp(-1i*2*pi/lambda*v_ms*cos(MS_theta_rad(n,:)'-theta_v_rad)*t);
    h(n,:) = sqrt(PDP(n)/M)*sum(tmph);
end