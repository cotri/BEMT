function [ cl ] = machCorr( cl, V_R, air )
% The "machCorr" function includes the mach number correction to the lift
% coefficient.
%
% Inputs:
% cl	[Nx1 double]    Lift coefficient at each blade element      [-]
% V_R	[Nx1 double]    Resultant velocity at each blade element    [m/s]
% air   [1x1 struct]    Air properties data
%
% Outputs:
% cl	[Nx1 double]    Corrected lift coeff. at each blade element [-]

M  = V_R./sqrt(air.gamma*air.R*air.T_0);
cl = cl./(sqrt(1 -M));

end