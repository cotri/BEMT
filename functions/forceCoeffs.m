function [ J, C_T, C_P, C_Q, eta_pr ] = forceCoeffs( prop, ca, ct, J, ...
    sigma, dx, F, flag )
% The "forceCoeffs" function calculates the thrust, power and torque 
% coefficients.
% 
% Inputs:
% prop      [1x1 struct]    Propeller geometric data
% ca        [Nx1 double]    Axial forces acting on each element      [-]
% ct        [Nx1 double]    Tangential forces acting on each element [-]
% J         [1x1 double]    Advande ratio                            [-]
% sigma     [Nx1 double]    Local solidity at each blade element	 [-]
% dx        [Nx1 double]    Infinitesimal blade element              [-]
% F         [Nx1 double]    Tip loss correction factor               [-]
% flag      [1x1 double]    "Single Vinf value" flag
% 
% Outputs:
% C_T       [N/1x1 double]  Thrust coefficient (each element/whole)  [-]
% C_P       [N/1x1 double]  Power coefficient                        [-]
% C_Q       [N/1x1 double]  Torque coefficient                       [-]
% eta_pr    [N/1x1 double]  Propulsive efficiency                    [-]

% Thrust and power coefficients
C_T = pi/8  .*(F .*sigma .*(J^2 +(pi.*prop.r_R).^2) .*ca.*dx);
C_P = pi^2/8.*(F .*sigma .*(J^2 +(pi.*prop.r_R).^2) .*prop.r_R.*ct.*dx);

% If the "single Vinf value" flag is not turn on return the sum of all 
% differential force coefficients
if flag == 0
    C_T = sum(C_T);
    C_P = sum(C_P);
elseif flag == 1
    J = repmat(J, length(prop.r_R), 1);
end

% Torque coefficient and propulsive efficiency
C_Q = C_P./(2*pi);
eta_pr = J.*(C_T./C_P);

end