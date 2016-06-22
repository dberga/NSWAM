function plotCartMapPhaseColored(cX,cY,origPhase)
doHold=ishold(gca);
[B,II,JJ]=unique([cX;cY]','rows');
origPhase=origPhase(II);
cX=B(:,1);
cY=B(:,2);
lhemi=cY<0;
try
 t=delaunay(cX(lhemi),cY(lhemi));
 trisurf(t,cX(lhemi),cY(lhemi),zeros(length(cX(lhemi)),1),origPhase(lhemi));
catch
end
hold on;
try
 t=delaunay(cX(~lhemi),cY(~lhemi));
 trisurf(t,cX(~lhemi),cY(~lhemi),zeros(length(cX(~lhemi)),1),origPhase(~lhemi));
catch
end

 shading interp;
 colormap hsv;
 view(0,90);
 if ~doHold
     hold off;
 end
 
 
axis off; axis equal;

return
