function [X,Y] = schwartz_monopole(i,j,lambda,a)
% X and Y are in mm
% i and j are in radians

neg_j = find(j<0);
neg_i = find(i<0);

zero_i = find(i==0);
zero_j = find(j==0);

Z = complex(abs(j),abs(i));

angle2rad = pi/180;
Z = Z/angle2rad;

W = lambda*log(Z+a);

X = real(W);
Y = imag(W);

 X(neg_j) = -X(neg_j);
 Y(neg_i) = -Y(neg_i);

%  zero_zone=[zero_j-511 zero_j];
%  X(zero_zone(256:511+256))=linspace(28,-28,length(zero_zone(256:511+256)));
%  X(zero_zone(256:511+256))=fliplr(X(zero_zone(256:511+256)));

 
end
