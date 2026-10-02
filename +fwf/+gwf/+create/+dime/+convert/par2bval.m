function b = par2bval(amp, tru, trd, ftt, tp, gamma)
% function b = dime.convert.par2bval(amp, tru, trd, ftt, tp, gamma)
% By Filip Szczepankiewicz, Lund University

if nargin < 6
    gamma = 1;
end

% From Filips equation: b = (p*(d + 2*f + u)^2)/4 + (d*(8*d^2 + 40*d*f + 20*d*u + 60*f^2 + 60*f*u + 15*u^2))/30 + (f*(4*f^2 + 6*f*u + 3*u^2))/6 + u^3/10

brel = ...
      (tp * ( trd + 2*ftt + tru )^2) / 4   ...          % (p*(d+2*f+u)^2)/4
    + (trd * ( 8*trd^2 + 40*trd*ftt + 20*trd*tru ...
    + 60*ftt^2 + 60*ftt*tru + 15*tru^2 ) )/30   ...     % d*(…)/30
    + (ftt * ( 4*ftt^2 + 6*ftt*tru + 3*tru^2 ) )/6 ...  % f*(…)/6
    + (tru^3) / 10;                                     % u^3/10

b = gamma^2 * amp^2 * brel;
