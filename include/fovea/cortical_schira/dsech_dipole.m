function [X,Y] = dsech_dipole(i,j,lambda,a,b,eccWidth,isoPolarGrad)
% X and Y are in mm
% i and j are in radians

f_a = cortical_shear(j,i,a,eccWidth,isoPolarGrad);
f_b = cortical_shear(j,i,b,eccWidth,isoPolarGrad);
i_a = i .* f_a;
i_b = i .* f_b;
i = i_a;

neg_j = find(j<0);
neg_i = find(i<0);

Z = complex(abs(j),abs(i));
Z1 = complex(abs(j),abs(i1));
Z2 = complex(abs(j),abs(i2));

angle2rad = pi/180;
Z = Z/angle2rad;
Z1 = Z1/angle2rad;
Z2 = Z2/angle2rad;

%W = lambda*log((Z+a)./(Z+b));
W = lambda*log((Z1+a)./(Z2+b));

X = real(W);
Y = imag(W);

X(neg_j) = -X(neg_j);
Y(neg_i) = -Y(neg_i);

end
