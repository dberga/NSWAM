%**************************************************************************
%      written August 2009 by Mark Schira, mark@ski.org
%      University of New South Wales
%      part of Schira, Tyler, Spehar and Breakspear 2009
%**************************************************************************
%
%Purpose: Demonstrating the models described in the paper.

modelToDemonstrate=2; %1 = 2D-Parametric-Shear Model, 2 = Divisory Model, 3 = Schwartz Dipole Model
switch modelToDemonstrate
    case 1
        model='DoubleSech';
    case 2
        model='bandedDoubleSech';
    case 3
        model='Schwartz';
end
    % basic common Model Parameters:
a=0.75; % Foveal pole
b=90;  % Peripheral pole
K=18;  % scaling parameter
    % shear parameters alpha 1 to 3 
V1linShear=1; 
V2linShear=0.5;
V3linShear=0.4;

%  a few more parameters determening the precrision and time for computation 
minEcc=0.05;
maxEcc=24;
% now open a small gui to set these Parameters
[model,a,b,K,V1linShear,V2linShear,V3linShear,minEcc,maxEcc]= selectDemoParams(model,a,b,K,V1linShear,V2linShear,V3linShear,minEcc,maxEcc);

% now a few more settings that we provide no GUI support for.
isoEccRings=7;
isoPolarRays=7;

resolution=200; % resolution of the dots along the grid
squareDens=76; % precision of anisotropy estimate, bigger = better 
               % will project for squareDens^2 for each V1-V3  
               % must be even
               % 50 is fast and fairly O.K.; 200 takes about 4 minutes 

% Graphic parameters
fontSize=13;
dotSize=5;
colors=[1 0 0; 0 1 0; 0 0 1];

tic

%% ------------------------------------------------------------------------ 
%
% get a isopolar and isoeccentricity Grid of the visual field 
%
%--------------------------------------------------------------------------

complexGrid=makeVisualGrid(minEcc,maxEcc,isoEccRings,isoPolarRays,resolution);
uHemi=complexGrid(2,:)>0; % this is needed later for a some plots

%plotting visual field plot
figure(1);clf;
set(1,'Name','The visual field, starting point.','NumberTitle','off');
subplot(2,1,1);
polar(complexGrid(2,:),complexGrid(1,:),'.k');
title('polar grid');
subplot(2,2,3);
plotVisFieldPhaseColored(complexGrid,complexGrid(2,:));
colormap marksCmapTrunc;
title('polar');
subplot(2,2,4);
plotVisFieldPhaseColored(complexGrid,complexGrid(1,:));
title('eccentricity');
colormap hsv;

%% ------------------------------------------------------------------------ 
%
% now Assembling the V1-V3 intermediate step (i.e. Model Step 1)
%
%
%--------------------------------------------------------------------------

[V1Grid,V2Grid,V3Grid]=assembleV1V3Complex(complexGrid,[V1linShear,V2linShear,V3linShear],0);

% and plotting it nice and with lots of colors!
figure(2);clf;
set(2,'Name','intermediate pacman step','NumberTitle','off');clf;

subplot(2,1,1);hold on;
hh=polar(V1Grid(2,:),V1Grid(1,:),'.');
set(hh,'color',colors(1,:));
hh=polar(V2Grid(2,:),V2Grid(1,:),'.');
set(hh,'color',colors(2,:));
hh=polar(V3Grid(2,:),V3Grid(1,:),'.');
set(hh,'color',colors(3,:));
axis equal; axis off;
title('polar grid');

subplot(2,2,3);hold on;
plotVisFieldPhaseColored(V1Grid,complexGrid(2,:));
plotVisFieldPhaseColored(V2Grid(:,uHemi),complexGrid(2,uHemi));
plotVisFieldPhaseColored(V2Grid(:,~uHemi),complexGrid(2,~uHemi));
plotVisFieldPhaseColored(V3Grid(:,uHemi),complexGrid(2,uHemi));
plotVisFieldPhaseColored(V3Grid(:,~uHemi),complexGrid(2,~uHemi));
colormap marksCmapTrunc;
title('polar');
subplot(2,2,4);hold on;
plotVisFieldPhaseColored(V1Grid,complexGrid(1,:));
plotVisFieldPhaseColored(V2Grid(:,uHemi),complexGrid(1,uHemi));
plotVisFieldPhaseColored(V2Grid(:,~uHemi),complexGrid(1,~uHemi));
plotVisFieldPhaseColored(V3Grid(:,uHemi),complexGrid(1,uHemi));
plotVisFieldPhaseColored(V3Grid(:,~uHemi),complexGrid(1,~uHemi));
colormap hsv;
title('eccentricity');


%% ------------------------------------------------------------------------ 
%
%  Evaluating and plotting the model (Step 2 of the model)
%
%
%--------------------------------------------------------------------------

%executing the model
eval(['[V1cartx,V1carty]=',model,'(V1Grid,a,b);']);
eval(['[V2cartx,V2carty]=',model,'(V2Grid,a,b);']);
eval(['[V3cartx,V3carty]=',model,'(V3Grid,a,b);']);

%plotting the cortex model
figure (3);clf;
set(3,'Name','Modelled Cortex, final projection.','NumberTitle','off');
subplot(2,1,1);hold on;
hh=plot(V1cartx,V1carty,'.'); set(hh,'color',colors(1,:));
hh=plot(V2cartx,V2carty,'.'); set(hh,'color',colors(2,:));
hh=plot(V3cartx,V3carty,'.'); set(hh,'color',colors(3,:));
axis equal, axis off; 
title('polar grid on cortex');
subplot(2,2,3);hold on;
plotCartMapPhaseColored([V1cartx,V2cartx,V3cartx],[V1carty,V2carty,V3carty],...
    [complexGrid(2,:),complexGrid(2,:),complexGrid(2,:)]);
title('polar');
colormap marksCmapTrunc
subplot(2,2,4);hold on;
plotCartMapPhaseColored([V1cartx,V2cartx,V3cartx],[V1carty,V2carty,V3carty],...
    [complexGrid(1,:),complexGrid(1,:),complexGrid(1,:)]);
title('eccentricity');


%% ------------------------------------------------------------------------ 
%
%  now test and plot local Anisotropy
%
%
%--------------------------------------------------------------------------

rings=logspace(log10(minEcc),log10(maxEcc),squareDens);
widthOfSq=0.0001;
[TH,R]=MakePolarSquares(rings,squareDens,widthOfSq,[-pi/2,pi/2]);
squarePiece=cat(1,R,TH);
%transform them to V1V3 complex
[V1sq,V2sq,V3sq]=assembleV1V3Complex(squarePiece,[V1linShear,V2linShear,V3linShear],0);
%project them through the model
eval(['[squareX,squareY]=',model,'([V1sq,V2sq,V3sq],a,b);']);
% calculate anisotropies
[XX,YY,localAniso,meridionalAniso]=calcAnisotropy(squareX,squareY,squareDens); %carefull using this function see help 


%plotting them
figure(4); clf; 
set(4,'Name','Local and Meridional Anisotropy','NumberTitle','off');
hold on;

t=delaunay(XX,YY);

%plotting local
subplot(1,2,1);
trisurf(t,XX,YY,zeros(length(XX),1),localAniso);
shading interp;
colorbar south;
view(0,90);
axis off; axis equal;
set(gca,'Clim',[0.9 7]);
hold on;
hh=plot(V1cartx,V1carty,'.'); set(hh,'color',colors(1,:));
hh=plot(V2cartx,V2carty,'.'); set(hh,'color',colors(2,:));
hh=plot(V3cartx,V3carty,'.'); set(hh,'color',colors(3,:));
title('local anisotropy');

%plotting meridional
subplot(1,2,2);
trisurf(t,XX,YY,zeros(length(XX),1),meridionalAniso);
shading interp;
colorbar south;
view(0,90);
axis off; axis equal;
set(gca,'Clim',[0.35 6]);
hold on;
hh=plot(V1cartx,V1carty,'.'); set(hh,'color',colors(1,:));
hh=plot(V2cartx,V2carty,'.'); set(hh,'color',colors(2,:));
hh=plot(V3cartx,V3carty,'.'); set(hh,'color',colors(3,:));
title('meridional anisotropy');

%% ------------------------------------------------------------------------ 
%
%  Magnification
%
%
%--------------------------------------------------------------------------

magnification


toc
