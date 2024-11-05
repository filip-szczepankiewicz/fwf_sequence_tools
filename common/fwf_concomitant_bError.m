function bError = fwf_concomitant_bError(c, radius, gl, bl)
% function bError = fwf_concomitant_bError(c, radius, gl, bl)

x = radius*gl'./bl;
bError = c(1)*x + c(2)*x.^2; % In percent
