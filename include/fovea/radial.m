function uv = radial(xy,t)
% Written by Sarah Bergstrom, based on the inv_transform routine
% in tform.m. 
% 
% xy must be M-by-2
% t.tdata must contain the following:
% [width/2 height/2 L polynomial_terms]
% where:
% width is the image width in pixels
% height is the image height in pixels
% L is either width/2 or height/2, whichever is larger.
% polynomial terms is 2 to 5 terms for the polynomial:
%   r_original = p1 + p2*r_final + p3*r_final^2 + p4*r_final^3 +
%                p5*r_final^4
% omitted terms at the end will result in a lower-order polynomial.

if size(xy,2) ~= 2
    msg = 'XY must have two columns.';
    eid = sprintf('Images:%s:xyMustHave2Cols',mfilename);
    error(eid,msg);
end

if size(xy,1) < 1
    msg = 'XY must have at least one row.';
    eid = sprintf('Images:%s:xyMustHaveOneRow',mfilename);
    error(eid,msg);
end

% tdata contains the following: 
% center value for x
% center value for y
% scaling factor so that r=1 at one edge.
% polynomial coefficients from lowest order to highest.

nterms=size(t.tdata,2);
switch nterms
    case 5
        order=1;
    case 6
        order=2;
    case 7
        order=3;
    case 8
        order=4;
    otherwise
        msg = 'TDATA is incorrectly sized';
        eid = sprintf('Images:%s:tdataWrongSize',mfilename);
        error(eid,msg);
end

global W fr Rnew R Theta uv 

cx=t.tdata(1); cy=t.tdata(2); L=t.tdata(3); W=t.tdata(4:end)';

[R,Theta]=xy2rth(xy,cx,cy,L);

fr = radialterms(order, R);

Rnew = fr * W;

uv=rth2xy(Rnew,Theta,cx,cy,L);
%
%----------------------------------
function [r,theta]=xy2rth(xy,cx,cy,L)

x = (xy(:,1) - cx)/L;
y = (xy(:,2) - cy)/L;
r=sqrt(x.^2 + y.^2);
theta=atan2(y,x);

%----------------------------------
function xy=rth2xy(r,theta,cx,cy,L)

x=L*r.*cos(theta)+cx;
y=L*r.*sin(theta)+cy;
xy=[x y];

%-------------------------------
%
%
function fr = radialterms(order,r)

M = size(r,1);

switch order
    case 1
        fr = [ones(M,1),  r];
    case 2   
        fr = [ones(M,1),  r, r.^2];
    
    case 3
        fr = [ones(M,1),  r, r.^2, r.^3];
    
    case 4
        fr = [ones(M,1),  r, r.^2, r.^3, r.^4];
    
    otherwise
        msg = 'ORDER must be 2, 3, or 4.';
        eid = sprintf('Images:%s:invalidOrder',mfilename);
        error(eid,msg);
end
