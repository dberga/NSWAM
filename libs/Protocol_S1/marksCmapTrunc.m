function map = marksCmapTrunc(m)
if nargin < 1, m = size(get(gcf,'colormap'),1); end
startMap=hsv(6);
startMap=[startMap(1:3,:);[0 0.5 0];startMap(4:5,:)];

samplePoints = linspace(1,size(startMap,1), m);
map = interp1(startMap,samplePoints);


