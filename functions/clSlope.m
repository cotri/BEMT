function [ mean_a0 ] = clSlope( ReIndex, alpha, cl, linearRange )
% This function calculates the a0 values for each Reynolds number based on
% the lift coefficient's variation (within the linearity range) along the 
% angle of attack by means of linear interpolation.
%
% Inputs:
% ReIndex       [Nx1 double]    Index of the Reynolds numbers' range    [-]
% alpha         [Nx1 double]    Sampled angle of attack values          [deg]
% cl            [NxM double]    Lift coefficient variation with the angle  
%                               of attack for each Reynolds number      [-]
% linearRange   [Nx2 double]    Range in which the Cl-AoA curve is linear  
%
% Outputs:
% a0            [Nx1 double]    Interpolated lift coefficient slope     [rad⁻¹]

% Matrix in which all the a0 mean values are goin to be stored
mean_a0 = cat(2, ReIndex, zeros(size(ReIndex))); 
          % Concatenate along the second dimension

% Get the minimum and maximum AoA values for each linear range
alphaMin = min(linearRange, [], 2);
alphaMax = max(linearRange, [], 2);

for i=1:length(ReIndex)
    % Find the indices of the min and max angle of attack values
    n1 = find(alpha(:,1) == alphaMin(i));
    n2 = find(alpha(:,1) == alphaMax(i));
    
    % Fit first order polynomial
    p = polyfit(deg2rad(alpha(n1:n2,1)), cl(n1:n2,i), 1);
    
    % Get the slope (a0) of the fitted line
    mean_a0(i,2) = p(1);
end

end