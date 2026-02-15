function gamma = gammaFromNuc(str)
% function gamma = fwf.util.gammaFromNuc(str)
%
% Returns gyromagnetic constant in rad/s/T

if nargin < 1 || isempty(str)
    str = '1H';
end

switch str
    case '1H'
        gamma = 2.6751e+08;

    case '31P'
        gamma = 1.08291e+08;
        
    otherwise
        error('Nucleus not recognized')
end

