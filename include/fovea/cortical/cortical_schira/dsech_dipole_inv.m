function [i,j] = dsech_dipole_inv(X,Y,lambda,a,b,eccWidth,isoPolarGrad)
% X and Y are in mm
% i and j are in radians


neg_X = find(X<0);
neg_Y = find(Y<0);

W = complex(abs(X),abs(Y));

Z = (a-b*exp(W/lambda))./(exp(W/lambda)-1);

angle2rad = pi/180;
Z = Z*angle2rad;

i = imag(Z);
j = real(Z);

f_a = cortical_shear(j,i,a,eccWidth,isoPolarGrad); %mal
f_b = cortical_shear(j,i,b,eccWidth,isoPolarGrad); %mal

i_a = i .* f_a;
i_b = i .* f_b;
i = i_a;

i(neg_Y) = -i(neg_Y);
j(neg_X) = -j(neg_X);

end


% f = sech(x) = 2/(exp(x)+exp(-x)); 
% x = log((1-f+sqrt((1+-f^2)/f^2))/y);


