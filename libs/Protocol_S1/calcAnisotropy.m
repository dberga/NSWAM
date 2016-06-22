function [XX,YY,localAniso,meridionalAniso]=calcAnisotropy(squareX,squareY,nRings)
%**************************************************************************
%      written August 2009 by Mark Schira, mark@ski.org
%      University of New South Wales
%      part of Schira, Tyler, Spehar and Breakspear 2009
%**************************************************************************
%
% Purpose: Calculating meridional anisotropy from projected squares
% To compute proper meridional anisotropy, this function has to assume a
% certain ordering of the squares.
%
%

% first loop across each square and calculate area and length ratios

for thisSquare=1:length(squareX)/4;
    thisPoint=((thisSquare-1)*4)+1;
    %compute the area of the square for meridional Aniso
    sqArea(thisSquare)=QuadrilateralArea([squareX(thisPoint),squareY(thisPoint)],...
        [squareX(thisPoint+1),squareY(thisPoint+1)],...
        [squareX(thisPoint+3),squareY(thisPoint+3)],...
        [squareX(thisPoint+2),squareY(thisPoint+2)],...
        0); 
    %magnification in both directions for local anisotropy
    magP(thisSquare)=measureDist(squareX(thisPoint),squareY(thisPoint),squareX(thisPoint+1),squareY(thisPoint+1));
    magE(thisSquare)=measureDist(squareX(thisPoint),squareY(thisPoint),squareX(thisPoint+2),squareY(thisPoint+2));
    % mean position of the square
    XX(thisSquare)=mean(squareX(thisPoint:thisPoint+3));
    YY(thisSquare)=mean(squareY(thisPoint:thisPoint+3));
end

% local isotropy is easy and robust
localAniso=round(magE./magP*100)/100; %local aniso is the ratio of the two magnifications


% meridional anisotropy is a bit more tricky, it has to normalized to V1
% horizontal meridian. We have three areas, each area should have nRings^2
% squares, first come the V1s then the V2s then the V3s
% should be in the very middle of each isoeccentricity ring of squares.
meridionalAniso=[];
squaresPArea=nRings^2;
IsoEccDots=[1:nRings,[1:nRings]+squaresPArea,[1:nRings]+squaresPArea*2];

for isoEccRing=1:nRings % this is why we needed the nRings in the input
    thisDots=IsoEccDots+(isoEccRing-1)*nRings;
    meridionalAniso(thisDots)= sqArea(thisDots)/sqArea(thisDots(round(nRings/2)));
    %plot(XX(thisDots),YY(thisDots),'.')
    %plot(meridionalAniso(thisDots));
end

return


function dist=measureDist(X1,Y1,X2,Y2)
dist=sqrt( (X1-X2)^2+(Y1-Y2)^2);
