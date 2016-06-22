%% estimating Areal Magnification
%**************************************************************************
%      written August 2009 by Mark Schira, mark@ski.org
%      University of New South Wales
%      part of Schira, Tyler, Spehar and Breakspear 2009
%**************************************************************************
%
%Purpose: estimating magnification
clear all; %close all;

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
maxEcc=16;

MagResolution=50;
rings=logspace(log10(minEcc),log10(maxEcc),MagResolution);
wedges=linspace(-pi/2,-0.00001,MagResolution);%We need a quartefield only, this avoids spitting the field

%Make set of dots to be projected
for thisRing=1:length(rings)
    thetaPiece=wedges;
    rPiece=repmat(rings(thisRing),[1 MagResolution]) ; % this may do more than needed
    squares(:,:,thisRing)=cat(1,rPiece,thetaPiece);
end

%make V1-V3 sets
[V1Grid,V2Grid,V3Grid]=assembleV1V3Complex(squares(:,:),[V1linShear,V2linShear,V3linShear],0);

%project through model...
eval(['[V1cartx,V1carty]=',model,'(V1Grid,a,b);']);
eval(['[V2cartx,V2carty]=',model,'(V2Grid,a,b);']);
eval(['[V3cartx,V3carty]=',model,'(V3Grid,a,b);']);
V1cartx=V1cartx*K; V1carty=V1carty*K;
V2cartx=V2cartx*K; V2carty=V2carty*K;
V3cartx=V3cartx*K; V3carty=V3carty*K;



%% now compute area of the projected rectangles
surfacesV1=zeros(MagResolution-1,1);
surfacesV2=zeros(MagResolution-1,1);
surfacesV3=zeros(MagResolution-1,1);
indBase=[1,2,MagResolution+2,MagResolution+1]; %the positions of the four corners of the very first quad
for thisRing=1:MagResolution-1
    figure (100);clf;hold on
    for thisWedge=1:MagResolution-1
        thisInd=indBase+(thisWedge -1)+(thisRing-1)*MagResolution;
        surfacesV1(thisRing)= surfacesV1(thisRing) + ...
        QuadrilateralArea([V1cartx(thisInd);V1carty(thisInd)],0);
          surfacesV2(thisRing)= surfacesV2(thisRing) + ...
        QuadrilateralArea([V2cartx(thisInd);V2carty(thisInd)],0);
              surfacesV3(thisRing)= surfacesV3(thisRing) + ...
        QuadrilateralArea([V3cartx(thisInd);V3carty(thisInd)],0);  

    end %wedges
end%rings


%
%visFieldArea=zeros((MagResolution-1)^2);
circAreas=(rings.^2)*pi;
bandAreas=(circAreas(2:end)-circAreas(1:end-1))/4;  %div by 4 because quarterfields

plot(rings(2:end),sqrt(surfacesV1'./bandAreas),'r');
plot(rings(2:end),sqrt(surfacesV2'./bandAreas),'g');
plot(rings(2:end),sqrt(surfacesV3'./bandAreas),'b');

set(gca,'YScale','log','XScale','log','YTick',[2 4 8 16 32],'Ylim',[0.5 48],'XTick',logspace(log10(0.125),log10(16),8),'Xlim',[0.1 17]);



