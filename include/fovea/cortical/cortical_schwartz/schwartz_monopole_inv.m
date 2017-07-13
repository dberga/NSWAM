function [i,j] = schwartz_monopole_inv(X,Y,lambda,a)
% X and Y are in mm
% i and j are in radians

neg_X = find(X<0);
neg_Y = find(Y<0);

W = complex(abs(X),abs(Y));

Z = exp(W/lambda)-a;

angle2rad = pi/180;
Z = Z*angle2rad;

i = imag(Z);
j = real(Z);

i(neg_Y) = -i(neg_Y);
j(neg_X) = -j(neg_X);


end
