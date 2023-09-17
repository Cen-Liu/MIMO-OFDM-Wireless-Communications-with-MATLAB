function [BS_theta_deg,MS_theta_deg,BS_PHI_rad] = gen_phase(BS_theta_LOS_deg,BS_AS_deg,BS_AoD_deg,MS_theta_LOS_deg,MS_AS_deg,MS_AoA_deg,M)
% Generates phase at BS and MS
%   Inputs
%     BS_theta_LOS_deg : AoD of LOS path in degree at BS
%     BS_AS_deg        : Angle spread (AS) of BS in degree
%     BS_AoD_deg       : AoD of BS in degree
%     MS_theta_LOS_deg : AoA of LOS path in degree at MS
%     MS_AS_deg        : AS of MS in degree
%     MS_AoA_deg       : AoA of MS in degree
%     M                : Number of subrays
%   Outputs:
%     BS_theta_deg     : (Npath x M) DoA per path in degree at BS
%     MS_theta_deg     : (Npath x M) DoA per path in degree at MS
%     BS_PHI_rad       : (Npath x M) random phase in degree at BS
if nargin==6, M=10; end
BS_PHI_rad = 2*pi*rand(length(BS_AoD_deg),M);   % Uniform phase
BS_theta_deg = assign_offset(BS_theta_LOS_deg+BS_AoD_deg,BS_AS_deg);
MS_theta_deg = assign_offset(MS_theta_LOS_deg+MS_AoA_deg,MS_AS_deg);
% Random pairing
index = randperm(M);
MS1 = size(MS_theta_deg,1);
for n = 1:MS1
    MS_theta_deg(n,:) = MS_theta_deg(n,index);
end