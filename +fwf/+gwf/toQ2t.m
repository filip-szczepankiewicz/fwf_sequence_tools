function q2t = toQ2t(gwf, rf, dt, gamma)
% function q2t = fwf.gwf.toQ2t(gwf, rf, dt, gamma)

if nargin < 4
    gamma = fwf.util.gammaFromNuc();
end

qt = fwf.gwf.toQt(gwf, rf, dt, gamma);

q2t(:,1) = cumsum( qt(:,1).*qt(:,1), 1 ) * dt;
q2t(:,2) = cumsum( qt(:,2).*qt(:,2), 1 ) * dt;
q2t(:,3) = cumsum( qt(:,3).*qt(:,3), 1 ) * dt;
q2t(:,4) = cumsum( qt(:,1).*qt(:,2), 1 ) * dt;
q2t(:,5) = cumsum( qt(:,1).*qt(:,3), 1 ) * dt;
q2t(:,6) = cumsum( qt(:,2).*qt(:,3), 1 ) * dt;