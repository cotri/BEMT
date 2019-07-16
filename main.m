%% Load variables

clc; clear
data = 'nacaXfoil';
init

%% User input

tipLossModel = 'DeVries';       % none  Prandtl  Prandtl2  DeVries
rotFlowModel = 'DuSelig';       % none  Snel  DuSelig

% Revolutions per minute [rpm]
n = 6519;

% Free stream velocity [m/s]
Vinf = 10:0.1:23.5;

%% Calculation process

% If only one value of Vinf is / If an array of values are input
if length(Vinf) == 1
    flag = true;
    J = zeros(length(prop.r_R), 1);
    perf = zeros(length(prop.r_R), 5);
elseif length(Vinf) > 1
    J = zeros(length(Vinf), 1);
    perf = zeros(length(Vinf), 5);
else
    error('Empty free-stream velocity (Vinf) value.')
end

% Pre-allocate variables
cl = zeros(length(prop.r_R), 1);
[C_T, C_Q, C_P, eta_pr] = deal(J, J, J, J);
[cd, ca, ct] = deal(cl, cl, cl);
coeff = zeros(length(prop.r_R), 5, length(Vinf)); % coeffCol

% Determine lift coefficient curve's linear range
linearRange = linRange(polar.cl(:,1), polar.cl(:,2:end));

% Obtain the mean a0 values for each Reynolds number
mean_a0 = clSlope(ReIndex, polar.cl(:,1), polar.cl(:,2:end), linearRange);

for i=1:length(Vinf)
    % Blade Element Momentum Theory
    [J, C_T, C_Q, C_P, eta_pr, cl, cd, ca, ct] = bemt(n, Vinf(i), prop, ...
    	air, ReIndex, polar, mean_a0, tipLossModel, rotFlowModel, flag);

    % Performance matrix
    if ~flag
        perf(i,1:end) = [J C_T C_Q C_P eta_pr];
    elseif flag
        perf(:,1:end) = [J C_T C_Q C_P eta_pr];
    end
    
    % Coefficients along the blade span
    coeff(:,1:end,i) = [prop.r_R, cl, cd, ca, ct];
end

%% Plotting

if ~flag
    x = perf(:,1);
    label = 'Advance ratio, J';
elseif flag
	x = prop.r_R;
    label = 'Blade span, r/R';
end

figure
subplot(2,2,1)
plot(x,perf(:,2), uiuc(:,1),uiuc(:,2),'.'); grid on
xlabel(label)
ylabel('Thrust coefficient, C_T')

subplot(2,2,2)
plot(x,perf(:,3), uiuc(:,1),uiuc(:,4),'.'); grid on
xlabel(label)
ylabel('Torque coefficient, C_Q')

subplot(2,2,3)
plot(x,perf(:,4), uiuc(:,1),uiuc(:,3),'.'); grid on
xlabel(label)
ylabel('Power coefficient, C_P')

subplot(2,2,4)
plot(x, perf(:,5), uiuc(:,1),uiuc(:,5),'.'); grid on
xlabel(label)
ylabel('Propulsive efficiency, \eta_{pr}')

% [...]
