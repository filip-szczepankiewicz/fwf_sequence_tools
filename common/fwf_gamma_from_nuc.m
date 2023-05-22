function gamma = fwf_gamma_from_nuc(str)
% function gamma = fwf_gamma_from_nuc(str)

if nargin < 1 || isempty(str)
    str = '1H';
end

switch str
    case '1H'
        gamma = 2.6751e+08;
        
    otherwise
        error('Nucleus not recognized')
end

