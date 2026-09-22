function opt = options(gmax, smax, dur)
% function opt = optDDE.options(gmax, smax, dur)
% By Filip Szczepankiewicz, Lund University

% Get some reasonable ramp time limits
minRamp = gmax/smax*1e3; % ms
maxRamp = (dur-2.1*minRamp)/2 + minRamp;

% Design options
opt.stimMode   = 1;
opt.stimTol    = 95;

% Optimization bounds and guess
opt.lb = [ minRamp minRamp .5];
opt.ub = [ maxRamp maxRamp  1];
opt.x0 = [ minRamp minRamp  1];

% Pick optimization strategy
opt.optMode = 2; % 0, 1, and 2 are single, global, and multistart.
opt.numTrialPts   = 1000; % For globalOpt
opt.numInitialPts = 200;  % For globalOpt
opt.numStartPts   = 75;   % For multiStart

% Fmincon options
opt.fmc = optimoptions('fmincon');
opt.fmc.ConstraintTolerance = 1e-5;
opt.fmc.OptimalityTolerance = 1e-5;
opt.fmc.MaxFunctionEvaluations = 1e5;
opt.fmc.MaxIterations = 1e5;
opt.fmc.Display = "final";
opt.fmc.Algorithm = "sqp"; % "interior-point" also works