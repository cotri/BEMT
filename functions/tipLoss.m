function [ F ] = tipLoss( tipLossModel, prop, omega, Vinf, r, phi )
% The "tipLoss" function takes into account the fact that the lift
% coefficient tends to zero towards the blade tip.
%
% Inputs:
% tipLossModel  [1xM   char]    Tip loss corection model
% prop          [1x1 struct]    Propeller geometric data
% omega         [1x1 double]    Rotation speed                  [rad/s]
% Vinf          [1x1 double]    Free-stream velocity            [m/s]
% r             [Nx1 double]    Radial distance at each section	[m]
% phi           [Nx1 double]    Relative wind angle             [rad]
%
% Outputs:
% F             [Nx1 double]    Tip loss correction factor      [-]

switch tipLossModel
    case 'none'
        F = 1;
    
    case 'Prandtl'
        f = (prop.B/2.*(prop.Rt -r)./(r.*sin(phi)));
        F = 2/pi.*acos(exp(-f));
        
    case 'DeVries'
        c1 = 0.125;
        c2 = 21;
        lambda = omega.*r./Vinf;
        g = exp(-c1.*(prop.B.*lambda -c2));
        F = 2/pi.*acos(exp(-g.*(prop.B.*(prop.Rt -r))./(2.*prop.Rt.*sin(phi)) ));
        
    otherwise
        error('Tip loss model not defined.');
end

end