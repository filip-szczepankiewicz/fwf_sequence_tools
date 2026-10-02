function b = par2bval(tru, trd, ftt, tp, gamp)
% function b = optSDE.convert.par2bval(amp, tru, trd, ftt, tp, gamma)
% By Filip Szczepankiewicz, Lund University

brel = ...
      (tp * ( trd + 2*ftt + tru )^2) / 4   ...          % (p*(d+2*f+u)^2)/4
    + (trd * ( 8*trd^2 + 40*trd*ftt + 20*trd*tru ...
    + 60*ftt^2 + 60*ftt*tru + 15*tru^2 ) )/30   ...     % d*(…)/30
    + (ftt * ( 4*ftt^2 + 6*ftt*tru + 3*tru^2 ) )/6 ...  % f*(…)/6
    + (tru^3) / 10;                                     % u^3/10

b = gamp^2 * brel;
