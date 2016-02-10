function [orientacio] = OrientAngle (angle, nAngles, multires)
%
% Returns orientation of processing for a given scale and angle for a
% curvelet transform. nAngles is the number of angles in the 's' scale of
% the curvelet transform.
%
% Returns 0 for horizontal orientation, and 1 for vertical
%

switch multires
   case 'curv'
      nAngperOrient=nAngles/4;
      orientacio = round(mod(real((angle-1)/nAngperOrient),2));
   case 'wav'
      orientacio=angle;
   case 'gabor'
      orientacio=mod(angle/nAngles*2,2);
end
