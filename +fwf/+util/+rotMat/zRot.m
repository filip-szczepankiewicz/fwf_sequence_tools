function R = zRot(ang)
% function R = fwf.util.rotMat.zRot(ang)
% Rotate about z-axis by ang radians

R = [cos(ang) -sin(ang)  0 
     sin(ang)  cos(ang)  0
     0          0        1];