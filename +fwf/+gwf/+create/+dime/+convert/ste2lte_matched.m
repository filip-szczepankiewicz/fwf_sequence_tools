function [gwf_lte, v] = ste2lte_matched(gwf, rf, t, p)
% function [gwf_lte, v] = ii_gwf2TunedLte(gwf, rf, t, p)

Mp = now.calc.spectralMomentTensor(gwf, rf, t, [], p, 1e4);

[~, ~, R] = eig(Mp);

% gwf in PAS for M-tensor
gpas = gwf*R;

% Select diagonal projection that takes equally from all components
u = [1 1 1]'/sqrt(3);

gwf_lte = (gpas * u) * [1 0 0]; 

% Calcultat the projection direction in case this is interesting
v = u'*R';
