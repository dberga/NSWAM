function [V1Grid,V2Grid,V3Grid]=assembleV1V3Complex(visGrid,shearVals,verbose)
%**************************************************************************
%      written August 2009 by Mark Schira, mark@ski.org
%      University of New South Wales
%      part of Schira, Tyler, Spehar and Breakspear 2009
%**************************************************************************
%
%Purpose: assembling a V1, V2 and V3 complex as suggested by
%Balasubramanian et al. 2002 (Neur. Netw.)


if ~exist('visGrid','var')
    visGrid=makeVisualGrid(0.1,16,5,5,50);
end

standardSheer=[1 0.5 0.4];

if ~exist('shearVals','var')
    shearVals=standardSheer;
else
    standardSheer(1:numel(shearVals))=shearVals;
    shearVals=standardSheer;
end

if ~exist('verbose','var')
    verbose=1;
end


uHemi=(visGrid(2,:)>=0);
lHemi=(visGrid(2,:)<0);
V1Grid=[visGrid(1,:);visGrid(2,:)*shearVals(1)];
highOfMap=pi/2*shearVals(1);
lowOfMap=-highOfMap;

V2Grid=visGrid;
V2Grid(2,:)=V2Grid(2,:)*-1*shearVals(2); % the V2 phases are mirrored;
V2Grid(2,lHemi)=(V2Grid(2,lHemi))-highOfMap-(shearVals(2)*pi/2);
V2Grid(2,uHemi)=(V2Grid(2,uHemi))-lowOfMap+(shearVals(2)*pi/2);

highOfMap=pi/2*(shearVals(1)+shearVals(2));
lowOfMap=-highOfMap;
V3Grid=visGrid;
V3Grid(2,:)=V3Grid(2,:)*shearVals(3); % the V2 phases are mirrored;
V3Grid(2,~uHemi)=(V3Grid(2,~uHemi))-highOfMap;%-(shearVals(3)*pi/2);
V3Grid(2,uHemi)=(V3Grid(2,uHemi))-lowOfMap;%+(shearVals(3)*pi/2);

%now plot if asked
if verbose
    %% now plot the transformed visual field (intermediate step)

    figure (200);clf;hold on;
    colors=[1 0 0; 0 1 0; 0 0 1];
    hh=polar(V1Grid(2,:),V1Grid(1,:),'.');
    set(hh,'color',colors(1,:));
    hh=polar(V2Grid(2,:),V2Grid(1,:),'.');
    set(hh,'color',colors(2,:));
    hh=polar(V3Grid(2,:),V3Grid(1,:),'.');
    set(hh,'color',colors(3,:));
    axis equal; axis off;
    title('polar grid');


    axis equal;
end
