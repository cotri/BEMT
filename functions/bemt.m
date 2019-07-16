function [ J, C_T, C_Q, C_P, eta_pr, cl, cd, ca, ct ] = bemt ( n, Vinf, ... 
    prop, air, ReIndex, polar, mean_a0, tipLossModel, rotFlowModel, flag )
% The "bemt" function calculates the thrust, torque and power coefficients
% as well as the propulsive efficiency of the propeller data introduced 
% based on the analitical Blade Element Momentum Theory or BEMT for short.
%
% Inputs:
% n             [1x1 double]    Revolutions per minute                    [rpm]
% Vinf          [1xM double]    Free-stream velocity                      [m/s]
% prop          [1x1 struct]    Propeller geometric data
% air           [1x1 struct]    Air properties data
% ReIndex       [Nx1 double]    Index of the Reynolds numbers' range      [-]
% polar         [1x1 struct]    Aerodynamic data (Cl-Cd vs AoA vs Re)     [-]
% mean_a0       [Nx2 double]    Mean Reynolds numbers' lift curve's slope [-]
% tipLossModel  [1xM   char]    Tip loss corection model
% rotFlowModel  [1xM   char]    3D rotational flow corection model
% flag          [1x1 double]    "Single Vinf value" flag
% 
% Outputs:
% J             [1x1 double]    Advance ratio                           [-]
% C_T           [N/1x1 double]  Thrust coefficient (each element/whole) [-]
% C_Q           [N/1x1 double]  Torque coefficient                      [-]
% C_P           [N/1x1 double]  Power coefficient                       [-]
% eta_pr        [N/1x1 double]  Propulsive efficiency                   [-]
% cl            [NxM double]    Lift coefficient at each section        [-]
% cd            [NxM double]    Drag coefficient at each section        [-]
% ca            [NxM double]    Axial forces at each section            [-]
% ct            [NxM double]    Tangential forces at each section       [-]

%% Parameter definition

% Infinitesimal blade element [-]
dx = diff(prop.r_R(1:2));

% Radial distance at each section [m]
r = prop.r_R*prop.Rt;

% Chord at each section [m]
c = prop.c_R*prop.Rt;

% Rotation speed [rad/s]
omega = n*pi/30;

% Tip velocity [m/s]
V_T = omega*prop.Rt;

% Local solidity [-]
sigma = prop.B.*c./(pi*prop.Rt);

%% Calculations

% Resultant velocity at each section [m/s]
V_R = sqrt((omega.*r).^2 +Vinf.^2);

% Relative wind angle at each section [rad]
phi = atan2(Vinf, omega.*r);

% Inflow ratio [-]
lambda = Vinf./V_T;

% Advande ratio [-]
J = lambda*pi;

% Reynolds number at each section [-]
Re = V_R.*c./air.nu;

% If the Reynolds numbers are not in range
if all(Re < ReIndex(1)) && all(Re > ReIndex(end))
	error('Reynolds number values are out of limits.')
end

% Lift coefficient slope for each Reynolds number [rad⁻¹]
a0 = interp1(mean_a0(:,1), mean_a0(:,2), Re, 'linear');

% Induced angle of attack at each section [rad]
alpha_i = alphaI(prop, lambda, sigma, a0, V_R, V_T, phi);

% Angle of attack at each section [deg]
alpha = rad2deg(prop.theta -alpha_i -phi);

% If the angle of attack values are not in range
if all(alpha < polar.cl(1)) && all(alpha > polar.cl(end,1))
    error('Angle of attack values are out of limits.')
end

% Lift and drag coefficients for each blade section [-]
cl = coeffCalc(alpha, Re, ReIndex, polar.cl);
cd = coeffCalc(alpha, Re, ReIndex, polar.cd);

% Mach number correction [-]
cl = machCorr(cl, V_R, air);

% 3D rotational flow effects correction [-]
[cl, cd] = rotCorr(cl, cd, alpha, prop, c, r, Vinf, V_R, omega, rotFlowModel);

% Axial and tangencial forces [-]
ca = cl.*cos(phi +alpha_i) -cd.*sin(phi +alpha_i);
ct = cl.*sin(phi +alpha_i) +cd.*cos(phi +alpha_i);

% Tip loss correction [-]
F = tipLoss(tipLossModel, prop, omega, Vinf, r, phi);

% Thrust and power coefficients [-]
[J, C_T, C_P, C_Q, eta_pr] = forceCoeffs(prop, ca, ct, J, sigma, dx, F, flag);

end