function [gwf, rf, dt] = fwf_gwf_force_balance(gwf, rf, dt, verbose)
% function [gwf, rf, dt] = fwf_gwf_force_balance(gwf, rf, dt, verbose)
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

for i = 1:numel(m0)

    if m0(i)>0
        ind = eg(:,i)>0;
    elseif m0(i)<0
        ind = eg(:,i)<0;
    else
        ind = [];
    end

    % potential for change
    pot = sum(eg(ind,i));

    % multiplication factor
    fac = 1-abs(m0(i)/pot);

    % Adjust appropriate elements
    eg(ind,i) = eg(ind,i) * fac;

    if verbose
        if abs(1-fac) > 0.01
            warning(['Correction factor is larger than 1%! value for axis ' num2str(i) ' is ' num2str(fac) '!'])
        end

        if abs(1-fac) > 0.05
            warning(['Correction factor is larger than 5%! value for axis ' num2str(i) ' is ' num2str(fac) '!'])
        end
    end
end

gwf = eg .* rf;

