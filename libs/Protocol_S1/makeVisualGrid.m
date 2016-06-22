function grid=makeVisualGrid(minEcc,maxEcc,numRings,numSpokes,resolution)
%**************************************************************************
%      written August 2009 by Mark Schira, mark@ski.org
%      University of New South Wales
%      part of Schira, Tyler, Spehar and Breakspear 2009
%**************************************************************************
%
%Purpose: plotting the visual field or intermediate steps in a colored
%fashion (i.e. like typically used in Retinotopic mapping studies.

if ~exist('minEcc','var')
    minEcc=0.01;
end
if ~exist('maxEcc','var')
    maxEcc=16;
end
if ~exist('numRings','var')
    numRings=9;
end
if ~exist('numSpokes','var')
    numSpokes=9;
end
if ~exist('resolution','var')
    resolution=300;
end

if numel(numRings)==1
    rings=logspace(log10(minEcc),log10(maxEcc),numRings);
else
    rings=numRings;
end

spokes=linspace(-pi/2,pi/2,numSpokes);
a=find(spokes==0); % this is mostly cosmetical nature, you want some the horizontal spoke to be twice, so it ends on both sides of the split
if ~isempty(a)   
    spokes=[spokes(1:a-1),-0.00001,0.00001,spokes(a+1:end)];
end
grid=[];

for thisRing=1:length(rings)
    thetaGridPiece=linSpace(-pi/2,pi/2,resolution);
    rGridPiece=ones(1,resolution).*rings(thisRing);
    complexPiece=cat(1,rGridPiece,thetaGridPiece);
    grid=cat(2,grid,complexPiece);
end

for thisSpoke=1:length(spokes)
    thetaGridPiece=ones(1,resolution).*spokes(thisSpoke);
    rGridPiece=logspace(log10(min(rings)),log10(max(rings)),resolution);
    complexPiece=cat(1,rGridPiece,thetaGridPiece);
    grid=cat(2,grid,complexPiece);
end