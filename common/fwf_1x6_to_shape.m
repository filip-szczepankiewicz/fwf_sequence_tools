function shape = fwf_1x6_to_shape(T)
% function shape = fwf_1x6_to_shape(T)
%
% The shape is the same as b_delta^2 in axisymmetric tensors.
% It is also the same as (T'*T):shear / (T'*T):bulk / 2 but this definition
% is taken from Lundell and Lasic 2020

shape = zeros(size(T,1), 1);
for i = 1:size(T,1)
    shape(i) = tens2shape( tm_1x6_to_3x3(T(i,:)) );
end

end


function shape = tens2shape(T)

tr  = trace(T);
tr2 = trace(T.^2);

shape = ( 2*tr2 - 2*T(1,1)*T(2,2) - 2*T(1,1)*T(3,3) + 3*T(1,2)^2 + 3*T(1,3)^2 + 3*T(2,1)^2 - 2*T(2,2)*T(3,3) + 3*T(2,3)^2 + 3*T(3,1)^2 + 3*T(3,2)^2 )/(2*tr^2+eps);
end