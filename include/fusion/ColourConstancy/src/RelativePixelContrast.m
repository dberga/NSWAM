function [SigmaCentre, SigmaSurround] = RelativePixelContrast(InputImage, CentreSize, SurroundSize)
%RelativePixelContrast  calculates contrast per pixel.
%
% inputs
%   CentreSize    the size of neighbourhood, default is 17.
%   SurroundSize  the size of surround, default 5 times the centre.
%
% outputs
%   SigmaCentre    contrast of centre.
%   SigmaSurround  contrast of surround.
%

InputImage = double(InputImage);

if nargin < 2
  CentreSize(1) = 17;
end
if length(CentreSize) == 1
  CentreSize(2) = CentreSize(1);
end
if nargin < 3
  SurroundSize = 5 .* CentreSize;
end
if length(SurroundSize) == 1
  SurroundSize(2) = SurroundSize(1);
end

CentreSize = MakeSizeOdd(CentreSize);
SurroundSize = MakeSizeOdd(SurroundSize);

hc = ones(CentreSize(1), CentreSize(2));
hs = ones(SurroundSize(1), SurroundSize(2));
[hcx, hcy] = size(hc);
d = [(hcx + 1) / 2, (hcy + 1) / 2] - 1;
[hsx, hsy] = size(hs);
m = [(hsx + 1) / 2, (hsy + 1) / 2];
hs((m(1) - d(1)):(m(1) + d(1)), (m(2) - d(2)):(m(2) + d(2))) = 0;

[rows, cols, chns] = size(InputImage);
SigmaCentre = zeros(rows, cols, chns);
SigmaSurround = zeros(rows, cols, chns);
for i = 1:chns
  SigmaCentre(:, :, i) = stdfilt(InputImage(:, :, i), hc);
  SigmaSurround(:, :, i) = stdfilt(InputImage(:, :, i), hs);
end

end

function OddSize = MakeSizeOdd(InputSize)

OddSize = InputSize;

for i = 1:length(InputSize)
  if mod(InputSize(i), 2) == 0
    OddSize(i) = InputSize(i) + 1;
  end
end

end
