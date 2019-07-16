%% Add working directories

% addpath(genpath('functions'));
% addpath(genpath('data'));

%% Propeller and air properties related variables

file_name = 'geometry.txt';
geometry = load(file_name);

% Wind tunnel data
load('uiuc_6519');

% Propeller geometric properties
prop.r_R   = geometry(:,1);             % Non-dimensional radial dist. [-]
prop.c_R   = geometry(:,2);             % Chord distribution           [-]
prop.theta = deg2rad(geometry(:,3));	% Geometric pitch angle        [rad]
prop.D     = 0.254;                     % Propeller diameter           [m]
prop.Rh    = 0.01905;                   % Hub radius                   [m]
prop.Rt    = prop.D/2;                  % Tip radius                   [m]
prop.B     = 2;                         % Number of blades             [-]

% Ambient constants
air.T_0    = 288.15;                    % Temperature at MSL           [K]
air.rho    = 1.1991;                    % Density at UIUC wind tunnel  [kg/m³]
air.mu     = 1.79e-5;                   % Dry air dynamic viscosity    [kg/m-s]
air.nu     = air.mu/air.rho;            % Dry air kinematic viscosity  [m²/s]
air.R      = 287.05;                    % Air specific constant        [J/kg-K]
air.gamma  = 1.4;                       % Isentropic coefficient       [-]

%% Areodynamic data

% "Single Vinf value" flag
flag = false;

% Pre-defined Reynolds number values 
ReIndex = [2e4; 4.5e4; 7.5e4; 1e5; 2.5e5; 5e5; 7.5e5; 1e6];

switch data
    case 'nacaXfoil'
        load('polar_naca_xfoil');
        
%     case 'blablabla'
%         load('blablabla');
        
    otherwise
        error('Aerodynamic data not defined.')
end