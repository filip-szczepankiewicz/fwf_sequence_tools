function R = fwf_uvec_to_rmsc ( tx, ty, tz, ang2 )
% function R = fwf_uvec_to_rmsc ( tx, ty, tz, ang2 )
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden

if nargin < 4
    ang2 = 0;
end

tmpRotMat1 = eye(3);

% Normalize target input
t_norm = sqrt(tx*tx + ty*ty + tz*tz);


% If the input vector is zero, set the rotation matrix to the unitymatrix and return.
if (t_norm == 0.0)
    R = tmpRotMat1;
    return;
end


% Normalize the target vector
nx = tx / t_norm;
ny = ty / t_norm;
nz = tz / t_norm;


% Assume that original vector is o = [1 0 0]
% Calculate necessary rotation angle a = acos(dot(o, t))
ox   = 1.0;
oy   = 0.0;
oz   = 0.0;

ang1 = acos(ox*nx + oy*ny + oz*nz);


% Calculate rotation axis v = cross(o, t)
rx = oy*nz - oz*ny;
ry = oz*nx - ox*nz;
rz = ox*ny - oy*nx;


% Check if o and t are parallel or antiparallel
% If they are, force the rotaion to be along the y-axis
if (rx == 0.0 && ry == 0.0 && rz == 0.0)
    ry = 1.0;
end

r_norm = sqrt(rx*rx + ry*ry + rz*rz);
rx = rx / r_norm;
ry = ry / r_norm;
rz = rz / r_norm;

% Set the rotation matrix
tmpRotMat1 = CalculateRotationMatrixForRotationAroundVector ( rx, ry, rz, ang1 );


% If there is no rotataion along target axis, set the temp matrix
if ( ang2 == 0.0 )
    
    R = tmpRotMat1;
    return;
end


% If an aditional rotation is present around the target axis, calc the second temp mat
tmpRotMat2 = CalculateRotationMatrixForRotationAroundVector ( nx, ny, nz, ang2 );


% Perform matrix multiplication to get final rotation matrix
R = tmpRotMat2 * tmpRotMat1;

end


function R = CalculateRotationMatrixForRotationAroundVector (x, y, z, ang )

R = nan(3);

norm = sqrt(x*x + y*y + z*z);

x = x / norm;
y = y / norm;
z = z / norm;

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
