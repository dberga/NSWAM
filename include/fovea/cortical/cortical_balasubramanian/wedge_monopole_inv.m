function [ i,j, i1, i2, i3 ] = wedge_monopole_inv( X,Y,lambda,a, alpha1, alpha2, alpha3 )



neg_X = find(X<0);
neg_Y = find(Y<0);

W = complex(abs(X),abs(Y));

Z = exp(W/lambda)-a;

angle2rad = pi/180;
Z = Z*angle2rad;

i = imag(Z);
j = real(Z);

%azimuth from V1
i1 = theta1_inv(i,alpha1);
%azimuth from V2
i2 = theta2_inv(i,alpha1,alpha2);
%azimuth from V3
i3 = theta3_inv(i,alpha1,alpha2,alpha3);

i(neg_Y) = -i(neg_Y);
j(neg_X) = -j(neg_X);

i=i1;
%or concat all?

end

