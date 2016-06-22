function plotVisFieldPhaseColored(Grid,origPhase)
%**************************************************************************
%      written August 2009 by Mark Schira, mark@ski.org
%      University of New South Wales
%      part of Schira, Tyler, Spehar and Breakspear 2009
%**************************************************************************
%
%Purpose: plotting the visual field or intermediate steps in a colored
%fashion (i.e. like typically used in Retinotopic mapping studies.

doHold=ishold(gca);

[cX,cY]=pol2cart(Grid(2,:),Grid(1,:));
[B,inI]=unique([cX',cY'],'rows');

t=delaunay(cX(inI),cY(inI));
trisurf(t,cX(inI),cY(inI),zeros(length((inI)),1),origPhase(inI));
hold on;
plot([-4 4],[0 0]); plot([0 0],[-4 4])

shading interp;
colormap hsv;
view(0,90);
axis off; axis equal;
if ~doHold
    hold off;
end


% lhemi=Grid(2,:)<0;
% try
%  [cX,cY]=pol2cart(Grid(2,lhemi),Grid(1,lhemi));
%  t=delaunay(cX,cY);
%  trisurf(t,cX,cY,zeros(length(cX),1),origPhase(lhemi));
%  hold on;
% catch
% end
%
% try
%  [cX,cY]=pol2cart(Grid(2,~lhemi),Grid(1,~lhemi));
%  t=delaunay(cX,cY);
%  trisurf(t,cX,cY,zeros(length(cX),1),origPhase(~lhemi));
% catch
% end
%
% hold on;
% plot([-4 4],[0 0]); plot([0 0],[-4 4])
%
%  shading interp;
%  colormap marksCmap;
%  view(0,90);
%
%  if ~doHold
%      hold off;
%  end
%
%
% axis off; axis equal;
%
% return
