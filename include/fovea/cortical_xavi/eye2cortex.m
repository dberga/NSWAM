function [X,Y] = eye2cortex(i,j,lambda,e0)
% X and Y are in mm
% i and j are in radians

neg_j = find(j<0);
neg_i = find(i<0);

Z = complex(abs(j),abs(i));


% W = log(Z+1);
W = lambda*log1p(Z/e0);


X = real(W);
Y = imag(W);

X(neg_j) = -X(neg_j);
Y(neg_i) = -Y(neg_i);

end
