function [ coeff ] = coeffCalc( alpha, Re, ReIndex, polar )
% The "coeffCalc" function, as its name implies, calculates the lift or 
% drag coefficients corresponding to the given angle of attack and Reynolds 
% number at each blade section by means of 2D interpolation.
%
% Inputs:
% alpha     [Nx1 double]    AoA values at each blade section         [deg]
% Re        [Nx1 double]    Reynolds numbers at each blade section   [-]
% ReIndex   [Nx1 double]    Index of the Reynolds numbers' range     [-]
% polar     [NxM double]    Aerodynamic data (Cl or Cd vs AoA vs Re) [-]
%
% Outputs:
% coeff     [Nx1 double]    Interpolated lift or drag coefficients   [-]

% Mesh with the sample points (X: AoA, Y: Re)
[X, Y] = meshgrid(polar(:,1), ReIndex');

% Corresponding function values at each sample point (Z: Cl or Cd)
V = polar(:,2:end)';

% Coordinates of the query points (the ones that are going to be
% interpolated)
[Xq, Yq] = meshgrid(alpha, Re);

% Linearly interpolated coefficients
Vq = interp2(X, Y, V, Xq, Yq);

% Take only the values that correspond the indicated AoA and Re, which are
% the ones located on the diagonal
coeff = diag(Vq);

end