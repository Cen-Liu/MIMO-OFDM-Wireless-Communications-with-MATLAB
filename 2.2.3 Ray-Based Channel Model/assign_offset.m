function theta_AoA_deg = assign_offset(AoA_deg,AS_deg)
% Assigns AoA/AoD offset to mean AoA/AoD 
%   Inputs
%       AoA_deg       : Mean AoA/AoD
%       AS            : Angle spread
%   Output
%       theta_AoA_deg : AoA_deg + offset_deg
offset = equalpower_subray(AS_deg);
theta_AoA_deg = zeros(length(AoA_deg),length(offset));
for n = 1:length(AoA_deg)
    for m = 1:length(offset)
        theta_AoA_deg0(n,2*m-1:2*m) = AoA_deg(n) + [offset(m) -offset(m)];
    end
end
% tmp=[offset; -offset]; tmp=tmp(:).'; 
% theta_AoA_deg = repmat(AoA_deg(:), 1,2*length(offset)) ...
%        + repmat(tmp, length(AoA_deg),1);
%discrepancy= norm(theta_AoA_deg-theta_AoA_deg0)