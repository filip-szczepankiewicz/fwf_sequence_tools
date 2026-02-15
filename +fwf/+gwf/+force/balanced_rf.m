function [gwf, rf, dt] = balanced_rf(gwf, rf, dt)
% function [gwf, rf, dt] = fwf.gwf.force.balanced_rf(gwf, rf, dt)
%
% Assumes that rf starts on +1

rfb = sum(rf);

if rfb==0
    return

else 

    gwf = [zeros(-rfb, 3); gwf; zeros(rfb, 3)];
    rf  = [ones(-rfb, 1); rf; -ones(rfb, 1)];

end

rfb = sum(rf);

if rfb
    error('Something went wrong!')
end


