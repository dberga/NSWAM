function [cartx,carty]=bandedDoubleSech(positionGrid,a,b,shiftAmount,isoPolarGrad,eccWidth)
%%**************************************************************************
%      written August 2009 by Mark Schira, mark@ski.org
%      University of New South Wales
%      part of Schira, Tyler, Spehar and Breakspear 2009
%**************************************************************************
%
% Purpose: the projection function of the "Banded Double Sech"
% essentially this functon does nothing more than implement the band,
% before then using DoubleSech.m 

if ~exist('a','var')
    a=0.75;
end

if ~exist('b','var')
    b=90;
end

if ~exist('shiftAmount','var')
    shiftAmount=0.4;
end

if ~exist('isoPolarGrad','var')
    isoPolarGrad=0.1821;
end

if ~exist('eccWidth','var')
    eccWidth=0.7609;
end

%% band the grid 

thetaPos=abs(positionGrid(2,:));
shifter=(thetaPos/-pi+1)*2;%linear implementation - simplest aproach

%shifter=sqrt((thetaPos/-pi+1)*2); %non linear example would match the
                                    %empirical data better, but may be 
                                    %considered overfitting at this point

shifter(shifter>1)=1; % >1 means essentially angle<pi/2  -> in V1 which will be shifted completly 
shifter=shifter*shiftAmount; % now here the free paramter shiftAmount,
                             %specifying the amount of shift. Can be determined using an optimization 

[X,Y]=pol2cart(positionGrid(2,:),positionGrid(1,:));
[shiftedGrid(2,:),shiftedGrid(1,:)]=cart2pol(X+shifter,Y);


%% use DoubleSech.m

[cartx,carty]=DoubleSech(shiftedGrid,a,b,isoPolarGrad,eccWidth);
