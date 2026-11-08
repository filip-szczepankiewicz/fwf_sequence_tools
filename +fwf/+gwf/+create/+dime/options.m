function opt = options(gmax, smax, dur)
% function opt = dime.options(gmax, smax, dur)
% By Filip Szczepankiewicz, Lund University

% Get some reasonable ramp time limits
minRamp = gmax/smax*1e3; % ms
maxRamp = (dur-6.1*minRamp)/6 + minRamp; % ms

% Design options
opt.bAnisoTol  = 0.01;  % [1]
opt.mAnisoTol  = 0.01;  % [1]

opt.spectralOrder = 2;

opt.stimMode   = 7;     % [enum]
opt.stimTol    = 95;    % [%]

% Optimization bounds and guess
% Only elements 1:6 are optimized. ub(7) caps the amplitude scale (gmax),
% lb(7) is checked after optimization, and x0(7) is not used.
opt.lb = [ 0 .5  ones(1,4)*minRamp   .3];
opt.ub = [ 1  1  ones(1,4)*maxRamp    1];
opt.x0 = [ 1 2/3 ones(1,4)*minRamp*3  1] + randn(size(opt.lb))/100;

% Pick optimization strategy
opt.optMode = 2; % 0, 1, and 2 are single, global, and multistart.
opt.numTrialPts   = 1000; % For globalOpt
opt.numInitialPts = 200;  % For globalOpt
opt.numStartPts   = 16;   % For multiStart

% Fmincon options
opt.fmc = optimoptions('fmincon');
opt.fmc.ConstraintTolerance = 1e-5;
opt.fmc.OptimalityTolerance = 1e-5;
opt.fmc.MaxFunctionEvaluations = 1e5;
opt.fmc.MaxIterations = 1e5;
opt.fmc.Display = "final";
opt.fmc.Algorithm = "sqp"; % "interior-point" also works