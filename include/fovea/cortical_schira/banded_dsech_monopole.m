function [X,Y] = banded_dsech_monopole(i,j,lambda,a,eccWidth,isoPolarGrad, shiftAmount)
% X and Y are in mm
% i and j are in radians

[i,j] = cortical_shift(j,i,shiftAmount);

f_a = cortical_shear(j,i,a,eccWidth,isoPolarGrad);
i = i .* f_a;

neg_j = find(j<0);
neg_i = find(i<0);

Z = complex(abs(j),abs(i));


angle2rad = pi/180;
Z = Z/angle2rad;

W = lambda*log(Z+a);


X = real(W);
Y = imag(W);

X(neg_j) = -X(neg_j);
Y(neg_i) = -Y(neg_i);

end
