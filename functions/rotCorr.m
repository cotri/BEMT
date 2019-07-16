function [ cl3D, cd3D ] = rotCorr( cl2D, cd2D, alpha, prop, c, r, Vinf, ...
                                   V_L, omega, rotFlowModel )
% The "rotCorr" function applies different 3D rotational flow corrections
% to the lift and/or drag coefficients based on the correction models 
% presented in Snel et al. and Du and Selig papers.
%
% Inputs:
% cl2D          [Nx1 double]    2D lift coefficient at each section         [-]
% cd2D          [Nx1 double]    2D drag coefficient at each section         [-]
% alpha         [Nx1 double]    Angle of attack at each section             [deg]
% prop          [1x1 struct]    Propeller geometric data
% c             [Nx1 double]    Chord value at each section                 [m]
% r             [Nx1 double]    Radial distance at each section             [m]
% Vinf          [1x1 double]    Free-stream velocity                        [m/s]
% V_L           [Nx1 double]    Local (resultant) velocity at each section  [m/s]
% omega         [1x1 double]    Rotation speed                              [rad/s]
% rotFlowModel  [1xM   char]    3D flow corection model
%
% Outputs:
% cl3D          [Nx1 double]    Corrected lift coefficient value            [-]
% cd3D          [Nx1 double]    Corrected drag coefficient value            [-]

% Ideal lift curve's slope [deg⁻¹]
cl_alpha = 0.1;

% Potential lift and drag coefficients [-]
cl_pot = cl_alpha.*alpha;
cd_pot = 0;

switch rotFlowModel
    case 'none'
        fCl = 0;
        fCd = 0;
        
    case 'Snel'
        fCl = 1.5 .* (c./r).^2 .* (omega.*r./V_L).^2; 
        fCd = 0;
        
    case 'DuSelig'
        Lambda = (omega .* prop.Rt)./sqrt(Vinf^2 +(omega.*r).^2);
        mi = (c./r).^(prop.Rt./(Lambda.*r));
        
        fCl = 1/(2*pi) .* ((1.6.*(c./r)./0.1267) .* (1 -mi)./(1 +mi));
        fCd = -fCl;
        
   otherwise
        error('3D correction model not defined.')
end

cl3D = cl2D +fCl.*(cl_pot -cl2D);
cd3D = cd2D +fCd.*(cd_pot -cd2D);

end