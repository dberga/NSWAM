function [i,j] = dsech_monopole_inv(X,Y,lambda,a, eccWidth, isoPolarGrad)
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

f_a = cortical_shear(j,i,a,eccWidth,isoPolarGrad); %mal
i = i ./ f_a;

i(neg_Y) = -i(neg_Y);
j(neg_X) = -j(neg_X);

end



% f = sech(x) = 2/(exp(x)+exp(-x)); 
% x = log((1-f+sqrt((1+-f^2)/f^2))/y);
