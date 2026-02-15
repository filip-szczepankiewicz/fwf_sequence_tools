function R = fromVecToVec ( v_from, v_to, ang2 )
% function R = fwf.util.rotMat.fromVecToVec ( v_from, v_to, ang2 )
% 
% If the input vectors are specified as rows, 1x3, then the intended
% use is to multiply the vector from the right by the transpose 
% v_to = v_from*R';
% If the input vectors are specified as columns, 3x1, the the intended use
% is to multiply from the left without using the transpose.
% v_to = R*v_from;

if nargin < 3
    ang2 = 0;
end


% Normalize inputs
f_norm = vecnorm(v_from,2);
t_norm = vecnorm(v_to,2);


% If the input vector is zero, set the rotation matrix to the unitymatrix and return.
if (t_norm == 0.0)
    R = eye(3);
    return;
end

ang1 = acos(sum((v_from.*v_to)/f_norm/t_norm));

% Calculate rotation axis r
r = cross(v_from/f_norm, v_to/t_norm);

% Check if o and t are parallel or antiparallel
% If they are, force the rotaion to be along the y-axis
if all(r==0)
    r(2) = 1.0;
end


% Set the rotation matrix
tmpRotMat1 = CalculateRotationMatrixForRotationAroundVector ( r, ang1 );


% If there is no rotataion along target axis, set the temp matrix
if ( ang2 == 0.0 )
    R = tmpRotMat1;
    return;
end


% If an aditional rotation is present around the target axis, calc the second temp mat
tmpRotMat2 = CalculateRotationMatrixForRotationAroundVector ( v_to, ang2 );


% Perform matrix multiplication to get final rotation matrix
R = tmpRotMat2 * tmpRotMat1;

end


function R = CalculateRotationMatrixForRotationAroundVector ( r, ang )

R = nan(3);

r = r/vecnorm(r,2);
x = r(1);
y = r(2);
z = r(3);

s = sin(ang);
c = cos(ang);
m = 1 - c;

R(1,1) = (x*x*m + c  );
R(1,2) = (x*y*m - z*s);
R(1,3) = (x*z*m + y*s);
R(2,1) = (y*x*m + z*s);
R(2,2) = (y*y*m + c  );
R(2,3) = (y*z*m - x*s);
R(3,1) = (z*x*m - y*s);
R(3,2) = (z*y*m + x*s);
R(3,3) = (z*z*m + c  );

end
