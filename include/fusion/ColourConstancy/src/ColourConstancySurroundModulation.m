function [ColourConstantImage, luminance] = ColourConstancySurroundModulation(InputImage, params)
%ColourConstancySurroundModulation  our model of surround modulation.
%
% inputs
%   InputImage  the biased image.
%   params      the desired parameters.
%
% outputs
%   ColourConstantImage  the colour corrected image.
%   luminance            the estimated luminance
%

if nargin < 2
  params = {3, 1.5, 2, 5, -0.77, -0.67, 1, 1, 4, 'single', []};
end

[rows, cols, chns] = size(InputImage);
if isa(InputImage, 'uint16')
  MaxVal = (2 ^ 16) - 1;
elseif isa(InputImage, 'uint8')
  MaxVal = (2 ^ 8) - 1;
else
  MaxVal = 1;
end
InputImageDouble = double(InputImage);

InputImageDouble = InputImageDouble ./ MaxVal;

rc = InputImageDouble(:, :, 1);
bc = InputImageDouble(:, :, 2);
gc = InputImageDouble(:, :, 3);

[dorg, doyb, dowb] = ApplyAllChannels(rc, bc, gc, params);

doresponse = zeros(rows, cols, chns);
doresponse(:, :, 1) = dorg;
doresponse(:, :, 2) = doyb;
doresponse(:, :, 3) = dowb;

if strcmpi(params{end - 1}, 'single')
  luminance = CalculateLuminanceSingle(doresponse, InputImage);
  luminance = reshape(luminance, 1, 3);
  luminance = luminance ./ sum(luminance(:));
  ColourConstantImage = MatChansMulK(InputImageDouble, 1 ./ luminance);
  ColourConstantImage = ColourConstantImage ./ max(ColourConstantImage(:));
  ColourConstantImage = uint8(ColourConstantImage .* 255);
elseif strcmpi(params{end - 1}, 'multi')
  luminance = CalculateLuminanceMulti(doresponse, InputImage);
  ColourConstantImage = InputImageDouble ./ luminance;
  ColourConstantImage = ColourConstantImage ./ max(ColourConstantImage(:));
  ColourConstantImage = uint8(ColourConstantImage .* 255);
else
  luminance = [1, 1, 1];
  ColourConstantImage = InputImage;
end

end

function [orc, ogc, obc] = ApplyAllChannels(irc, igc, ibc, params)

orc = ApplyOneChannel(irc, params);
ogc = ApplyOneChannel(igc, params);
obc = ApplyOneChannel(ibc, params);

end

function dorg = ApplyOneChannel(isignal, params)

CentreSize = params{1};
GaussianSigma = params{2};
ContrastEnlarge = params{3};
SurroundEnlarge = params{4};
s1 = params{5};
s4 = params{6};
c1 = params{7};
c4 = params{8};
nk = params{9};

[rgc, rgs] = RelativePixelContrast(isignal, CentreSize, round(SurroundEnlarge) * CentreSize);
mrgc = mean(rgc(:));
mrgs = mean(rgs(:));
c1 = c1 + mrgc;
c4 = c4 + mrgs;

ab = SingleContrast(isignal, GaussianSigma, ContrastEnlarge, nk);
ba = SingleGaussian(isignal, GaussianSigma * SurroundEnlarge);

ss = linspace(s1, s4, nk);
cs = linspace(c1, c4, nk);

dorg = ApplyNeighbourImpact(isignal, ab, ba, ss, cs);

end

function luminance = CalculateLuminanceSingle(ModelResponse, InputImage)

% to make the comparison exactly like Grey Edge
SaturationThreshold = max(InputImage(:));
DarkThreshold = min(InputImage(:));
MaxImage = max(InputImage, [], 3);
MinImage = min(InputImage, [], 3);
SaturatedPixels = dilation33(double(MaxImage >= SaturationThreshold | MinImage <= DarkThreshold));
SaturatedPixels = double(SaturatedPixels == 0);
sigma = 2;
SaturatedPixels = set_border(SaturatedPixels, sigma + 1, 0);

for i = 1:3
  ModelResponse(:, :, i) = ModelResponse(:, :, i) .* (ModelResponse(:, :, i) > 0);
  ModelResponse(:, :, i) = ModelResponse(:, :, i) .* SaturatedPixels;
end

CentreSize = floor(min(size(InputImage, 1), size(InputImage, 2)) .* 0.01);
if mod(CentreSize, 2) == 0
  CentreSize = CentreSize - 1;
end
CentreSize = max(CentreSize, 3);
ModelResponse = ModelResponse ./ max(ModelResponse(:));
StdImg = LocalStdContrast(ModelResponse, CentreSize);
CutOff = mean(StdImg(:));
ModelResponse = ModelResponse .* ((2 ^ 8) - 1);
MaxVals = zeros(1, 3);
for i = 1:3
  tmp = ModelResponse(:, :, i);
  tmp = tmp(SaturatedPixels == 1);
  MaxVals(1, i) = PoolingHistMax(tmp(:), CutOff, false);
end

luminance = MaxVals;

end

function RegionImage = GetSpatialRegions(rows, cols, nRegionsI, nRegionsJ)

RegionImage = ones(rows, cols);

RowChunks = floor(rows / nRegionsI);
ColChunks = floor(cols / nRegionsJ);
for i = 1:nRegionsI
  RowIndex = (i - 1) * RowChunks + 1;
  for j = 1:nRegionsJ
    ColIndex = (j - 1) * ColChunks + 1;
    RegionImage(RowIndex:RowIndex + RowChunks - 1, ColIndex:ColIndex  + ColChunks - 1) = (i - 1) * nRegionsI + j;
  end
end

end

function luminance = CalculateLuminanceMulti(ModelResponse, InputImage)

% to make the comparison exactly like Grey Edge
SaturationThreshold = max(InputImage(:));
DarkThreshold = min(InputImage(:));
MaxImage = max(InputImage, [], 3);
MinImage = min(InputImage, [], 3);
SaturatedPixels = dilation33(double(MaxImage >= SaturationThreshold | MinImage <= DarkThreshold));
SaturatedPixels = double(SaturatedPixels == 0);
sigma = 2;
SaturatedPixels = set_border(SaturatedPixels, sigma + 1, 0);

for i = 1:3
  ModelResponse(:, :, i) = ModelResponse(:, :, i) .* (ModelResponse(:, :, i) > 0);
  ModelResponse(:, :, i) = ModelResponse(:, :, i) .* SaturatedPixels;
end

CentreSize = floor(min(size(InputImage, 1), size(InputImage, 2)) .* 0.01);
if mod(CentreSize, 2) == 0
  CentreSize = CentreSize - 1;
end
CentreSize = max(CentreSize, 5);
ModelResponse = ModelResponse ./ max(ModelResponse(:));

StdImg = LocalStdContrast(ModelResponse, CentreSize);

ModelResponse = ModelResponse .* ((2 ^ 8) - 1);

[rows, cols, ~] = size(ModelResponse);
nRegionsI = 2;
nRegionsJ = 2;
RegionImage = GetSpatialRegions(rows, cols, nRegionsI, nRegionsJ);

nRegions = length(unique(RegionImage));

luminance = ones(size(ModelResponse));
ContrastChannel = mean(StdImg, 3);
for i = 1:3
  LuminanceChannel = luminance(:, :, i);
  ModelChannel = ModelResponse(:, :, i);
  for r = 1:nRegions
    CurrentRegion = ContrastChannel(RegionImage == r);
    CurrentRegion = CurrentRegion ./ max(CurrentRegion(:));
    CutOff = mean(CurrentRegion);
    tmp = ModelChannel(RegionImage == r & SaturatedPixels == 1);
    if length(tmp) > 500
      LuminanceChannel(RegionImage == r) = PoolingHistMax(tmp(:), CutOff, false);
    else
      % if region is too small just get the max of it
      LuminanceChannel(RegionImage == r) = max(tmp(:));
    end
  end
  luminance(:, :, i) = LuminanceChannel;
end

end

function osignal = ApplyNeighbourImpact(isignal, ab, ba, SurroundImpacts, CentreImpacts)

nContrastLevels = length(SurroundImpacts);
SurroundSize = [17, 17];
ContrastImage = GetContrastImage(isignal, SurroundSize);

ContrastLevels = GetContrastLevels(ContrastImage, nContrastLevels);

nContrastLevels = unique(ContrastLevels(:));
nContrastLevels = nContrastLevels';

osignal = zeros(size(isignal));
for i = nContrastLevels
  osignal(ContrastLevels == i) = OverlapGaussian(ab(ContrastLevels == i), ba(ContrastLevels == i), SurroundImpacts(i), CentreImpacts(i));
end

end

function rfresponse = SingleContrast(isignal, StartingSigma, ContrastEnlarge, nContrastLevels)

[rows, cols, ~] = size(isignal);

ContrastImx = GetContrastImage(isignal, [17, 1]);
ContrastImy = GetContrastImage(isignal, [1, 17]);

if nargin < 4
  nContrastLevels = 4;
end

FinishingSigma = StartingSigma * ContrastEnlarge;
sigmas = linspace(StartingSigma, FinishingSigma, nContrastLevels);

ContrastLevelsX = GetContrastLevels(ContrastImx, nContrastLevels);
ContrastLevelsY = GetContrastLevels(ContrastImy, nContrastLevels);

nContrastLevelsX = unique(ContrastLevelsX(:));
nContrastLevelsX = nContrastLevelsX';

nContrastLevelsY = unique(ContrastLevelsY(:));
nContrastLevelsY = nContrastLevelsY';

rfresponse = zeros(rows, cols);
for i = nContrastLevelsX
  lambdaxi = sigmas(i);
  for j = nContrastLevelsY
    lambdayi = sigmas(j);
    rfi = GaussianFilter2(lambdaxi, lambdayi, 0, 0);
    rfresponsei = imfilter(isignal, rfi, 'replicate');
    rfresponse(ContrastLevelsX == i & ContrastLevelsY == j) = rfresponsei(ContrastLevelsX == i & ContrastLevelsY == j);
  end
end

end

function ContrastLevels = GetContrastLevels(ContrastIm, nContrastLevels)

MinPix = min(ContrastIm(:));
MaxPix = max(ContrastIm(:));
step = ((MaxPix - MinPix) / nContrastLevels);
levels = MinPix:step:MaxPix;
levels = levels(2:end-1);
ContrastLevels = imquantize(ContrastIm, levels);

end

function rfresponse = SingleGaussian(isignal, StartingSigma)

lambdax = StartingSigma;
lambday = StartingSigma;

rf = GaussianFilter2(lambdax, lambday, 0, 0);
rfresponse = imfilter(isignal, rf, 'replicate');

end

function rfresponse = OverlapGaussian(ab, ba, k, j)

rfresponse = j .* ab + k .* ba;
rfresponse = sum(rfresponse, 3);

end

function ContrastImage = GetContrastImage(isignal, SurroundSize, CentreSize)

if nargin < 2
  SurroundSize = [3, 3];
end
if nargin < 3
  CentreSize = [0, 0];
end
contraststd = LocalStdContrast(isignal, SurroundSize, CentreSize);

ContrastImage = 1 - contraststd;

end

function HistMax = PoolingHistMax(InputImage, CutoffPercent, UseAveragePixels)

if nargin < 3
  UseAveragePixels = false;
end

npixels = length(InputImage);
HistMax = zeros(1, 1);

MaxVal = max(InputImage(:));
if MaxVal == 0
  return;
end

if MaxVal < (2 ^ 8)
  nbins = 2 ^ 8;
elseif MaxVal < (2 ^ 16)
  nbins = 2 ^ 16;
end

if nargin < 2 || isempty(CutoffPercent)
  CutoffPercent = 0.01;
end

LowerMaxPixels = CutoffPercent .* npixels;
% setting the upper bound to 50% bigger than the lower bound, this means we
% try to find the final HistMax between the lower and upper bounds. However
% if we don't succeed we choose the closest value to the lower bound.
UpperMaxPixels = LowerMaxPixels * 1.5;

for i = 1:1
  ichan = InputImage;
  [ihist, centres] = hist(ichan(:), nbins);
  
  HistMax(1, i) = centres(end);
  jpixels = 0;
  for j = nbins - 1:-1:1
    jpixels = ihist(j) + jpixels;
    if jpixels > LowerMaxPixels(i)
      if jpixels > UpperMaxPixels
        % if we have passed the upper bound, final HistMax is the one
        % before the lower bound.
        HistMax(1, i) = centres(j + 1);
        if UseAveragePixels
          AllBiggerPixels = ichan(ichan >= centres(j + 1));
          HistMax(1, i) = mean(AllBiggerPixels(:));
        end
      else
        HistMax(1, i) = centres(j);
        if UseAveragePixels
          AllBiggerPixels = ichan(ichan >= centres(j));
          HistMax(1, i) = mean(AllBiggerPixels(:));
        end
      end
      break;
    end
  end
end

end
