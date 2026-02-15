function shape = tensor1x6toShape(a, b)
% function shape = fwf.math.tensor1x6toShape(a, b)
% Based on resQ_1x6_to_shape(a, b)
% By Filip Sz
% Funciton returns the shape of the outer product of a * b
% It is (A'*B):shear / (A'*B):bulk / 2

if nargin < 2
    b = a;
end

E_iso   = eye(3)/3;
E_bulk  = E_iso(:) * E_iso(:)';
E_shear = eye(9)/3 - E_bulk;

n       = size(a,1);
shape   = zeros(n,1);

for i = 1:n

    A = tm_1x6_to_3x3( a(i,:) );
    B = tm_1x6_to_3x3( b(i,:) );

    O = A(:)*B(:)';

    shape(i) = (O(:)'*E_shear(:)) ./ (O(:)'*E_bulk(:)+eps) / 2;

end