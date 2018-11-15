function ImageContrast = LocalStdContrast(InputImage, WindowSize, CentreSize)
%LocalStdContrast  calculates the local std of an image
%
% inputs
%   InputImage  the input image with n channel.
%   WindowSize  the size of the neighbourhoud.
%   CentreSize  if provided the centre is set to 0.
%
% outputs
%   ImageContrast  calculated local std of each channel.
%

InputImage = double(InputImage);

if nargin < 2
  WindowSize = 5;
end
if length(WindowSize) == 1
  WindowSize(1, 2) = WindowSize(1, 1);
end
if nargin < 3
  CentreSize = 0;
end
if length(CentreSize) == 1
  CentreSize(1, 2) = CentreSize(1, 1);
end

hc = fspecial('average', WindowSize);
hc = CentreZero(hc, CentreSize);
hc = hc ./ sum(hc(:));
MeanCentre = imfilter(InputImage, hc, 'symmetric');
stdv = (InputImage - MeanCentre) .^ 2;
MeanStdv = imfilter(stdv, hc, 'symmetric');
ImageContrast = sqrt(MeanStdv);

end
