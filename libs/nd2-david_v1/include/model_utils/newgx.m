function [X]=newgx(X)
% 
% Tx=1;
% 
% ind1=find(X <= Tx);
% ind2=find(X <= Tx+1);
% ind3=find(X > Tx+1);
% X(ind2)=X(ind2)-1;
% 
% X(ind1)=0;
% 
% X(ind3)=1;
% 


X=X-1;

X(X<0)=0;

X(X>1)=1;

