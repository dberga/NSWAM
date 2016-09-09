function [X,Y] = eye2cortex(i,j)
% X and Y are in radians
% i and j are in radians

neg = find (j<0);
j(neg)=-j(neg);


[az,e] = cart2pol(j,i);

Z = complex(e,abs(az));

% W = log(Z+1);
W = log1p(Z);

% [X,Y] = pol2cart(imag(W).*sign(az),real(W));

X = real(W);
Y = imag(W).*sign(az);

X(neg)=-X(neg);


end
