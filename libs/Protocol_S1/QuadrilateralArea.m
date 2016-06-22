function area=QuadrilateralArea(A,B,C,D,verbose)
% area=QuadrilateralArea(A,B,C,D)
%computes the area of a quadrilateral
% Usage:
% i.e. A=[1,2]; B=[2,4];C=[3,3]; D=[3,1];
% or
% A=[1 2 3 3; 1 4 3 1];    (which would be the same quadrilateral)
% i.e. A=[x1:x4;y1:y4];
% each corner has to be defined by it's two coordinates in the two
% dimesional space in witch the quadrilateral lies.
%
% if there are 2 inputarguments it will understand the second as a verbose
% variable. Verbose is usefull to check if the coordinates were in a good
% order. If it plots a Z something went wrong, Us should be all good.
%
%the corners can have to be ordered clock or counterclockwise, starting at
%any corner, however they must not be scrambeled, i.e. two diagonal corners
%following each other.
%
%
%        A-----
%       /       \---------B
%      /                   |
%     /                    |
%    C---------------------D
%
% C: Mark Schira written in 2006



if nargin==1
    B=A([3 4]);
    C=A([5 6]);
    D=A([7 8]);
    A=A([1 2]);
    verbose=0;
end

if nargin==2
    verbose=B;
    B=A([3 4]);
    C=A([5 6]);
    D=A([7 8]);
    A=A([1 2]);
end

a= sqrt( (A(1)-B(1))^2  +  (A(2)-B(2))^2 );
b= sqrt( (B(1)-C(1))^2  +  (B(2)-C(2))^2 );
c= sqrt( (C(1)-D(1))^2  +  (C(2)-D(2))^2 );
d= sqrt( (D(1)-A(1))^2  +  (D(2)-A(2))^2 );

e= sqrt( (A(1)-C(1))^2  +  (A(2)-C(2))^2 );
f= sqrt( (B(1)-D(1))^2  +  (B(2)-D(2))^2 );



area= real ( 1/4*   sqrt( ( 4*(e^2)*(f^2) ) - (b^2 + d^2 - a^2 - c^2)^2  ));

if verbose
    figure (1000);clf;hold on;
    vekt=[A;B;C;D];
    plot(A(1),A(2),'or');
    plot(B(1),B(2),'og');
    plot(C(1),C(2),'ob');
    plot(D(1),D(2),'ok');
    legend('A','B','C','D');
    plot(vekt(:,1),vekt(:,2),'--k');
    title(['Area: ',num2str(area)]);
end

