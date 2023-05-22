function [gwf, rf, dt] = fwf_gwf_create_butts97(g, s, d, dp, dt)
% function [gwf, rf, dt] = fwf_gwf_create_butts97(g, s, d, dp, dt)
%
% Butts et al. (1997)
% MRM 3&741-749
% DOI: 10.1002/mrm.1910380510
%
% This waveform is a split version of the Wong et al. 1995 design, which
% makes it easier to balance and can be run in a non-self-balanced mode.
% Note that this design was later used by Moffat et al. 2004 without
% citation?

if nargin < 1
    g = 80e-3;
    s = 100;
    d = 25e-3;
    dp = 8e-3;
    dt = 0.1e-3;

    [gwf, rf, dt] = fwf_gwf_create_butts97(g, s, d, dp, dt);
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end

ntot = round(d/dt);

f1 = 1/4;

n1 = round(f1 * d / dt);
n2 = round(0.5 * d / dt);
nz = round(dp/dt);

wf1 = [fwf_gwf_create_trapezoid(g, s, dt, n1) 0, -fwf_gwf_create_trapezoid(g, s, dt, ntot-n1) 0];

wf2 = [fwf_gwf_create_trapezoid(g, s, dt, n2) 0, -fwf_gwf_create_trapezoid(g, s, dt, ntot-n2) 0];

wfz = zeros(1, nz);

gwf = [
    [wf1 wfz flip(wf1)];
    [wf2 wfz -wf2];
    [wf2 wfz wf2]];

gwf = gwf';

rf = ones(size(gwf,1),1);
mind = round(size(gwf,1)/2);
rf(mind:end) = -1;


% This factor depends on timing
bt = fwf_gwf_to_btens(gwf, rf, dt);
xfactor = sqrt(bt(2,2)/bt(1,1));
gwf = gwf .* [xfactor 1 1];

