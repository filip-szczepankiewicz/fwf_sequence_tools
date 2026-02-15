function [gwf, rf, dt, ind] = chun98(g, s, d, dp, dt, mode)
% function [gwf, rf, dt, ind] = fwf.gwf.create.chun98(g, s, d, dp, dt, mode)
%
% Single-Shot Diffusion-Weighted Trace Imaging on a Clinical Scanner
% Terry Chun, Aziz M. Ulug, Peter C.M. van Zijl
% Magnetic Resonance in Medicine, 01 Oct 1998, 40(4):622-628
% DOI: 10.1002/mrm.1910400415 PMID: 9771579
%
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% d  is the duration of the pulse group in s
% dp is the duration of the pause in s
% dt is the time step size in s
% mode controls design variants as described below
% If no input, create example gwf at approximately b2000 and 80 mT/m.

if nargin < 1
    g = 80e-3;
    s = 100;
    d = 8.65e-3;
    dp = 8e-3;
    dt = 0.05e-3;
    
    clf
    [gwf, rf, dt, ind] = fwf.gwf.create.chun98(g, s, d, dp, dt);
    fwf.plot.wf2d(gwf, rf, dt)
    return
end

if nargin < 6
    mode = 1;
end

% See axis permutations in Table 1 of the source paper. 
% Notation: 1 is +/- and -1 is -/+.

switch mode
    case 1
        u1 = [ 1  1  1];
        u2 = [ 1 -1 -1];
        u3 = [ 1  1 -1];
        u4 = [ 1 -1  1];
        
    case 2
        u1 = [ 1  1  1];
        u2 = [ 1 -1 -1];
        u3 = [ 1 -1  1];
        u4 = [ 1  1 -1];
        
    case 3
        u1 = [ 1  1  1];
        u2 = [-1  1 -1];
        u3 = [ 1  1 -1];
        u4 = [-1  1  1];
        
    case 4
        % This one is K-nulled!
        u1 = [ 1  1  1];
        u2 = [-1 -1  1];
        u3 = [ 1 -1  1];
        u4 = [-1  1  1];
        
    case 5
        u1 = [ 1  1  1];
        u2 = [-1  1 -1];
        u3 = [-1  1  1];
        u4 = [ 1  1 -1];
        
    case 6
        % This one is K-nulled!
        u1 = [ 1  1  1];
        u2 = [-1 -1  1];
        u3 = [-1  1  1];
        u4 = [ 1 -1  1];
        
end


n = round(d/dt);

trp = fwf.gwf.create.trapezoid(g, s, dt, n);
trp = trp(1:(end-1));
bip = [trp -trp];

wfz = zeros(1, ceil(dp/dt));

gwf = [
    bip'*u1;
    bip'*u2;
    wfz'*[1 1 1];
    bip'*u3;
    bip'*u4;
    [0 0 0]
    ];

rf = ones(size(gwf,1),1);
mind = round(size(gwf,1)/2);
rf(mind:end) = -1;

ind = zeros(length(gwf),1);
ind(1:length([bip bip 0])) = 1;
ind(length([bip bip wfz 0]):end) = 2;

