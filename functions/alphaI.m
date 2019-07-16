function [ alpha_i ] = alphaI( prop, lambda, sigma, a0, V_R, V_T, phi )
% "alphaI" function calculates the induced angle of attack of each blade
% section.
% 
% Inputs:
% prop      [1x1 struct]    Propeller geometric data
% lambda    [Nx1 double]    Inflow ratio at each blade element          [-]
% sigma     [Nx1 double]    Local solidity at each blade element        [-]
% a0        [Nx1 double]    Lift coefficient slope                      [rad⁻¹]
% V_R       [Nx1 double]    Resultant velocity at each blade element    [m/s]
% V_T       [1x1 double]    Tip velocity                                [m/s]
% phi       [Nx1 double]    Relative wind angle                         [rad]
% 
% Outputs:
% alpha_i   [Nx1 double]    Induced angle of attack at each element     [rad]  

% Induced AoA expression [rad]
alpha_i = 0.5.*( -(lambda./prop.r_R + (sigma.*a0.*V_R)./(8.*(prop.r_R).^2*V_T) ) ...
          +( (lambda./prop.r_R + (sigma.*a0.*V_R)./(8.*(prop.r_R).^2*V_T) ).^2 ...
          +( (sigma.*a0.*V_R)./(2.*(prop.r_R).^2*V_T) ).*(prop.theta-phi) ).^0.5 ); 
end