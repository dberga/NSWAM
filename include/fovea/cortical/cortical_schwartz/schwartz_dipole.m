function [X,Y] = schwartz_dipole(i,j,lambda,a,b)
% X and Y are in mm
% i and j are in radians

neg_j = find(j<0);
neg_i = find(i<0);

Z = complex(abs(j),abs(i));

angle2rad = pi/180;
Z = Z/angle2rad;

W = lambda*log((Z+a)./(Z+b));


X = real(W);
Y = imag(W);

X(neg_j) = -X(neg_j);
Y(neg_i) = -Y(neg_i);

end
