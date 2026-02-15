function [gout, rf, dt] = balance_v2(gwf, rf, dt, verbose)
% function [gout, rf, dt] = fwf.gwf.force.balance_v2(gwf, rf, dt, verbose)
% By FSz
% Function forces the zeroth moment to be zero given that this can be
% achieved by scaling pre or post wf.

if nargin < 4
    verbose = 0;
end

% Convert to effective waveform
eg = gwf.*rf;

% Calculate residual moment
m0 = sum(eg,1);

% Create mask
ind = eg .* m0 > 0;

% Potential
pot = sum(eg.*ind, 1);

% Factor (will be nan if pot=0, but this is skipped in loop)
fac = 1-m0./pot;

gout = gwf;

% Do correction
for i = 1:numel(fac)
    if m0(i)
        gout(ind(:,i),i) = gout(ind(:,i),i) - gout(ind(:,i),i)*m0(i)/pot(i);
    end
end


if verbose
    if any(abs(1-fac) > 0.01)
        warning(['Correction factor is larger than 1%! values are ' num2str(fac) '!'])
    end

    if any(abs(1-fac) > 0.05)
        warning(['Correction factor is larger than 5%! values are ' num2str(fac) '!'])
    end
end