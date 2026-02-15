function biasTest(b)

if nargin < 1
    b = ones(1,1)* [0 .5 1];
    b = b(:);
end

D = 1;

s = exp(-b*D);

e = linspace(1, 0.9, numel(s))';

sb = s .* e;


f = fit(b,s,'exp1');
fb = fit(b,sb,'exp1');


bp = linspace(0,max(b),5);
p  = exp(bp*f.b);
pb = exp(bp*fb.b);


semilogy(b, s/f.a, 'k.')
hold on
semilogy(b, sb/fb.a, 'r.')
semilogy(bp, p, 'k--')
semilogy(bp, pb, 'r')
title(-fb.b)