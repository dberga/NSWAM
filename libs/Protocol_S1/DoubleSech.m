function [cartx,carty]=DoubleSech(positionGrid,a,b,isoPolarGrad,eccWidth)
% [cartx,carty]=DoubleSech(positionGrid,a,b,isoPolarGrad,eccWidth)
%**************************************************************************
%      written August 2009 by Mark Schira, mschira@unsw.edu.au
% 
%      published as part of Schira, Tyler ,Spehar & Breakspear 2009
%**************************************************************************
%
% positionGrid contains a list of n positions in the visual field as follows
% positionGrid(1,n) = Eccentricity (in degree)
% positionGrid(2,n) = Polar position (in radian),0 = horizontal meridian
% a and b are model parameters describing the two singularities.
% b values larger than 200 are ignored by changing the model to a
% monopole model.  (see lines 33 and 43)
%
% This function aproximates equal-area using a double sech shear.
% Optimal parameters isoPolarGrad eccWidth are mostly independent from a
% and b, so they can be left unchanged if a and b don't change to much. 
% If a and b are strongly changed (for a differen species for example),
% we suggest using a fMin procedure for finding optimal equal-area parameters 


if ~exist('a','var')
    a=0.77;
end

if ~exist('b','var')
    b=150;
end

if ~exist('isoPolarGrad','var')
    isoPolarGrad=0.1821;
end

if ~exist('eccWidth','var')
    eccWidth=0.7609;
end


E=positionGrid(1,:);
P=positionGrid(2,:);


% ______________________________________________________________
% computing the parametric shear

if b<200 % dipole
    corrFacDepEcca=sech(log(E/a)*eccWidth)*isoPolarGrad;
    corrFacDepEccb=sech(log(E/b)*eccWidth)*isoPolarGrad;
    corrFacDepEcc=corrFacDepEcca+corrFacDepEccb;
else % monopole
    corrFacDepEcc=sech(log(E/a)*eccWidth)*isoPolarGrad;
end

corrPolar=(P.* ( sech(P).^corrFacDepEcc ));


% ______________________________________________________________
% applying the complex-log-transform

if b<200 % dipole
    w=log( (  (E  .*  exp(i*(corrPolar))  ) + a) ...
        ./((E  .*  exp(i*corrPolar)  ) + b ));
else % monopole
    w=log( (  (E  .*  exp(i*(corrPolar)  ) + a)));
end


% ______________________________________________________________
% converting the result to Cartesian coordinates
logAngle=angle(w);
logRad=abs(w);
[cartx,carty]=pol2cart(logAngle,logRad); 
