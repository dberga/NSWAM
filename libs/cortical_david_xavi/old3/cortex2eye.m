function [i,j] = cortex2eye(X,Y)
% X and Y are in radians
% i and j are in radians

neg = find(X<0);
X(neg)=-X(neg);

% [az,e] = cart2pol(X,Y);
az = Y;
e = X;

W = complex(e,abs(az));

% Z = exp(W)-1;
Z = expm1(W);

[j,i] = pol2cart(imag(Z).*sign(az),real(Z));

j(neg)=-j(neg);

end
