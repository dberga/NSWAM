function [ X,Y, X1, Y1, X2, Y2, X3, Y3 ] = wedge_monopole( i,j,lambda,a, alpha1, alpha2, alpha3 )

%V1
i1 = theta1(i, alpha1);
%V2
i2 = theta2(i, alpha2);
%V3
i3 = theta3(i, alpha3);


neg_j = find(j<0);
neg_i1 = find(i1<0);
neg_i2 = find(i2<0);
neg_i3 = find(i3<0);

Z1 = complex(abs(j),abs(i1));
Z2 = complex(abs(j),abs(i2));
Z3 = complex(abs(j),abs(i3));


angle2rad = pi/180;
Z1 = Z1/angle2rad;
Z2 = Z2/angle2rad;
Z3 = Z3/angle2rad;

W1 = lambda*log(Z1+a);
W2 = lambda*log(Z2+a);
W3 = lambda*log(Z3+a);


X1 = real(W1);
Y1 = imag(W1);
X2 = real(W2);
Y2 = imag(W2);
X3 = real(W3);
Y3 = imag(W3);

X1(neg_j) = -X1(neg_j);
Y1(neg_i1) = -Y1(neg_i1);
X2(neg_j) = -X2(neg_j);
Y2(neg_i2) = -Y2(neg_i2);
X3(neg_j) = -X3(neg_j);
Y3(neg_i3) = -Y3(neg_i3);

%concat X1,X2,X3; Y1,Y2,Y3
X = X1; 
Y = Y1;
end

