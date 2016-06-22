function [cartx,carty]=Schwartz(positionGrid,a,b,alpha1)
% [cartx,carty]=newSchwartz(positionGrid,a,b,K)
%**************************************************************************
%      written August 2006 by Mark Schira, mark@ski.org
%      The Smith-Kettlewell Eye Research Inst., San Francisco
%      published as part of work by Schira, Wade & Tyler in 2006
%      This model, is based on Balasubramanian et al. 2002*
%**************************************************************************
%
% positionGrid contains a list of n positions in the visual field as follows
% positionGrid(1,n) = Eccentricity (in degree)
% positionGrid(2,n) = Polar position (in radian),0 = horizontal meridian
% a and b are model parameters describing the two singularities.
% b values larger than 200 are ignored by changing the model to a
% monopole model.  (see line 29).


if nargin==3
    alpha1=1;
end

positionGrid(2,:)=positionGrid(2,:)*alpha1;



% ______________________________________________________________
% applying the complex-log-transform

if b<200
    w=log( (  (positionGrid(1,:)  .*  exp(i*(positionGrid(2,:)))  ) + a) ...
        ./((positionGrid(1,:)  .*  exp(i*positionGrid(2,:))  ) + b ));
else
    w=log( (  (positionGrid(1,:)  .*  exp(i*(positionGrid(2,:))  ) + a)));
end



% ______________________________________________________________
% converting the result to Cartesian coordinates
logAngle=angle(w);
logRad=abs(w);
[cartx,carty]=pol2cart(logAngle,logRad);



%Balasubramanian, M., Polimeni, JR., Schwartz, EL. (2002).
%The V1–V2–V3 complex: quasiconformal dipole maps in primate
% striate and extra-striate cortex. Neural Networks, 15(10), 1157–1163.