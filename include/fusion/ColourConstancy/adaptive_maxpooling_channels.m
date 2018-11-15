
function [smap] = adaptive_maxpooling_channels(ModelResponse,CentreSize)

NChannels=size(ModelResponse,3);
%comment: ModelResponse should be a (M,N,C) matrix

if nargin<2, 
	CentreSize = floor(min(size(ModelResponse, 1), size(ModelResponse, 2)) .* 0.01);
end

if mod(CentreSize, 2) == 0
  CentreSize = CentreSize - 1;
end
CentreSize = max(CentreSize, 3);
ModelResponse = ModelResponse ./ max(ModelResponse(:));
StdImg = LocalStdContrast(ModelResponse, CentreSize);
CutOff = mean(StdImg(:));
ModelResponse = ModelResponse .* ((2 ^ 8) - 1);
MaxVals = zeros(1, NChannels);
for i = 1:NChannels
  tmp = ModelResponse(:, :, i);
  %tmp = tmp(SaturatedPixels == 1);
  MaxVals(1, i) = PoolingHistMax(tmp(:), CutOff, false);
end

for i = 1:NChannels
    smap = ModelResponse(:,:,i).*MaxVals(1,i);
end



end
