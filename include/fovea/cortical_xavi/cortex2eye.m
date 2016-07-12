function [i,j] = cortex2eye(X,Y,lambda,e0)
% X and Y are in mm
% i and j are in radians

neg_X = find(X<0);
neg_Y = find(Y<0);

W = complex(abs(X),abs(Y));


% Z = exp(W)-1;
Z = expm1(W/lambda)*e0;


i = imag(Z);
j = real(Z);

i(neg_Y) = -i(neg_Y);
j(neg_X) = -j(neg_X);

end
