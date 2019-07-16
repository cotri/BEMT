function [ linearRange ] = linRange( alpha, cl )
% The "linRange" function loops through all Reynolds numbers to obtain the
% linear range (in terms of angle of attack degrees) for the Cl-AoA curve.
%
% Inputs:
% alpha         [Nx1 double]    Sampled angle of attack values      [deg]
% cl            [NxM double]    Lift coefficient variation with the angle  
%                               of attack for each Reynolds number	[-]
%
% Outputs:
% linearRange   [NxM double]    Min and max AoA values in which the Cl-AoA
%                               curve has a linear behaviour

% Pre-allocate linear range matrix
linearRange = zeros(size(cl,2), 2);

% Iterate trough each Reynolds number
for i=1:size(cl,2)
    linearRange(i,:) = linCl(alpha, cl(:,i));
end

end

function [ linearRange ] = linCl( alpha, cl )
% The function "linCl" goes over the lift coefficient curve in order to
% estimate the min and max AoA values which contain the linear range.
%
% Inputs:
% alpha         [Nx1 double]    Sampled angle of attack values      [deg]
% cl            [NxM double]    Lift coefficient variation with the angle  
%                               of attack for each Reynolds number	[-]
%
%
% Outputs:
% linearRange   [NxM double]    Min and max AoA values in which the Cl-AoA
%                               curve has a linear behaviour

%% Local constants

% Tolerance (how many times can the Cl slope be smaller)
tol = 0.50;

% Minimum threshold of curvature for "linear" determination
maxCurv = -4e-2;

% Ideal Cl slope
cla = 2*pi*(pi/180);

%% Estimation of the linear range

% First and second derivates of the Cl vs AoA curve
step = 0.5;
yp = diff(cl)/step;
ypp = diff(yp)/step;

% Initialization of loop variables
foundMin = false;
foundMax = false;
finished = false;

n = 1;
while ~finished
    % Head 
    % If the slope value remains higher than the lower threshold, the
    % curvature is negative and close to zero (linear) and the minimum
    % value has not been found yet
    if (yp(n) > tol*cla) && ( (ypp(n) < 0) && (ypp(n) > maxCurv) ) && (~foundMin)
        foundMin = true;
        indexMin = n;
    end
    
    % Tail
    if (yp(end-n) > tol*cla) && ( (ypp(end-n) < 0) && (ypp(end-n) > maxCurv) ) && (~foundMax)
        foundMax = true;
        indexMax = length(ypp) -n;
    end
    
    if foundMin && foundMax
        finished = true;
    elseif foundMin
        if (length(ypp) -(n +1)) <= (indexMin +1)
            finished = true;
        end
    elseif foundMax
        if (length(ypp) -(indexMax+1)) >= (n +1)
            finished = true;
        end
    end
    
    n = n +1;
end

linearRange = [alpha(indexMin) alpha(indexMax)];

%{
figure
subplot(2,4,[1,2]);
plot(alpha,cl,'-.', 'lineWidth', 0.8); hold on
plot(alpha(indexMin:indexMax),cl(indexMin:indexMax), 'color', 'm', 'lineWidth', 1.5); grid on
legend('cl-alpha curve','Linear range')
xlim([-90, 90])

subplot(2,4,[3,4])
plot(alpha(1:end-1), yp); hold on; grid on
plot(alpha(1:end-1), tol*cla*ones(size(alpha(1:end-1))), 'color', 'm', 'lineWidth', 1.5); grid on
legend('Slope', 'Min. threshold')
xlim([-20, 20])
ylim([-0.2, 0.2])

subplot(2,4,[5,8])
bar(alpha(1:end-2), ypp); hold on; grid on
plot(alpha(1:end-2), zeros(size(alpha(1:end-2))), 'color', 'm', 'lineWidth', 1.5); grid on
plot(alpha(1:end-2), maxCurv*ones(size(alpha(1:end-2))), 'color', 'm', 'lineWidth', 1.5); grid on
legend('Curvature', 'Max. curvature', 'Min. curvature')
xlim([-20, 20])
ylim([-3e-2, 3e-2])
%}

end