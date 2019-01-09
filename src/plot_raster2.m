

function [ h ] = plot_raster2( activity )

if nargin < 1, activity=rand(1,100)*2; end

dt=1/100;
duration=size(activity,2);
nTrials=size(activity,1);
tSim=1;
[spikeMat, tVec] = poissonSpikeGen(activity, tSim, nTrials,dt);
plotRaster(spikeMat, tVec*duration);

xlabel('Time (ms)');
ylabel('Trial Number');
yticks(1:nTrials);

h = gcf;

end



function [spikeMat, tVec] = poissonSpikeGen(fr_in, tSim, nTrials,dt)

nBins = floor(tSim/dt);
for n=1:nTrials
    frMat(n,:)=imresize(fr_in(n,:),[1 nBins],'nearest');
    spikeMat(n,:) = rand(1,nBins) < frMat(n,:);
end
tVec = 0:dt:tSim-dt;
end

function [] = plotRaster(spikeMat, tVec)
hold all;

% M2014colors=[         
%     0         0.4470    0.7410;
%     0.8500    0.3250    0.0980;
%     0.9290    0.6940    0.1250;
%     0.4940    0.1840    0.5560;
%     0.4660    0.6740    0.1880;
%     0.3010    0.7450    0.9330;
%     0.6350    0.0780    0.1840];

M2014colors=repmat([0 0 0],9,1);
% M2014colors=[1 0 0; 0 0 1; 0 0 0];
% M2014colors=flipud([0 0 0; .2 .2 .2; .4 .4 .4; .6 .6 .6; .8 .8 .8]); 
% M2014colors=[1 0 0; 0 1 1; .5 1 0]; 

for trialCount = 1:size(spikeMat,1)
    spikePos = tVec(spikeMat(trialCount, :));
    spikeColor=M2014colors(trialCount,:);
    for spikeCount = 1:length(spikePos)
        plot([spikePos(spikeCount) spikePos(spikeCount)], ...
            [trialCount-0.4 trialCount+0.4], 'k',...
            'Color',spikeColor);
    end
end
ylim([0 size(spikeMat, 1)+1]);
end


% function spikes = makeSpikes(timeStepS, spikesPerS, durationS, numTrains)
% 
% if (nargin < 4)
%     numTrains = 1;
% end
% times = [0:timeStepS:durationS];
% spikes = zeros(numTrains, length(times));
% for train = 1:numTrains
%     vt = rand(size(times));
%     spikesPerS=imresize(spikesPerS,size(vt),'nearest');
%     spikes(train, :) = (spikesPerS*timeStepS) > vt;
% end
% end

