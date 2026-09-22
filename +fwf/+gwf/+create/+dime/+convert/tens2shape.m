function shape = tens2shape(t)
% function function shape = dime.convert.tens2shape(t)
% By Filip Szczepankiewicz, Lund University
% 
% Calculate tensor shape from full 3x3 tensor.

% trt = trace(t);
% 
% shape = 0;
% 
% for i = 1:3
%     for j = 1:3
%        shape = shape + 3*t(i,j)^2 - t(i,i)*t(j,j);
%     end
% end
% 
% % Normalize
% shape = shape/(2*trt^2);

% Matrix variant
trt2  = trace(t)^2;
shape = (3*t(:)'*t(:) - trt2) / (2*trt2);