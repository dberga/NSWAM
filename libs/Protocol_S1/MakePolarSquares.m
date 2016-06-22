function [TH,R]=MakePolarSquares(rings,squaresPerRing,width,polarRange)
%**************************************************************************
%      written August 2006 by Mark Schira, mark@ski.org
%      The Smith-Kettlewell Eye Research Inst., San Francisco
%      published as part of work by Schira, Wade & Tyler in 2006
%**************************************************************************
%
%Purpose: create a set of Squares to test local anisotropy


if ~(exist('rings','var'))
    rings=[logspace(log10(0.5),log10(32),7)];
end

if ~(exist('squaresPerRing','var'))
    squaresPerRing=7;
end

if ~(exist('width','var'))
    width=0.0001;
end

if ~(exist('polarRange','var'))
    polarRange=[-pi/2,pi/2];
end


spokes=linspace(polarRange(1),polarRange(2),squaresPerRing);
complexGrid=[];

for thisRing=1:length(rings)
    thetaGridPiece=spokes;
    rGridPiece=ones(1,squaresPerRing).*rings(thisRing);
    complexPiece=cat(1,thetaGridPiece,rGridPiece);
    complexGrid=cat(2,complexGrid,complexPiece);
end



[X,Y]=pol2cart(complexGrid(1,:),complexGrid(2,:));
XX=[];YY=[];

for thisPoint=1:length(X)
    % make  Cartesian squares
    x=X(thisPoint);
    y=Y(thisPoint);
    [thisTH,thisR] = cart2pol(x,y);
    locwidth= abs(thisR*width);
    thisXX=cat(1,locwidth,locwidth,-locwidth,-locwidth);
    thisYY=cat(1,-locwidth,locwidth,-locwidth,locwidth);
    % rotate them depending on their polar position
    [thisXX,thisYY]=rotateSquare(thisXX,thisYY,-complexGrid(1,thisPoint));
    XX=cat(2,XX,thisXX+x);
    YY=cat(2,YY,thisYY+y);
end
[TH,R]=cart2pol(XX,YY);

% if you like to visualize them
%figure (2);clf; polar(TH,R,'.');
% -- for nicer view a larger width and lower number is suggested

return


%-----------------------------------------------------
% little helperfucntion to rotate squares
function [XX,YY]=rotateSquare(thisXX,thisYY,Theta);
    RotMatrix=[cos(Theta),-sin(Theta);sin(Theta),cos(Theta)];
    for ii=1:length(thisXX)
        ans=[thisXX(ii),thisYY(ii)]*RotMatrix;
        XX(ii)=ans(1);YY(ii)=ans(2);
    end
return



