function [X]=newgy(X)


% % Zaoping Li
% Ly=1.2;
% g1=0.21;
% g2=2.5;

% Otazu
Ly=1.2;
g1=0.21;
g2=2.5;


% ind1=find(X<0);
X(X<0)=0;

% ind2=find(X < Ly);

X(X < Ly)=g1*X(X < Ly);


% ind3=find(Ly <= X);

% Diferencies entre Li i Machecler

X(Ly <= X)=g1*Ly+g2*(X(Ly <= X)-Ly); % Li
% X(ind3)=0.252*Ly+g2*(X(ind3)-Ly); % Machecler


% X(Ly <= X)=g1*Ly+g2*(X(Ly <= X)-Ly);

% X(ind2)=g1*X(ind2);

end