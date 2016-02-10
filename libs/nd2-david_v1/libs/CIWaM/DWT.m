function [w c] = DWT(image, wlev)
% Implementation of Mallate Discrete Wavelet Transform.
%
% outputs:
%   w: cell array of length wlev, containing wavelet planes in 3
%   orientations.
%   c: cell array of length c, containing residual planes.
%
% inputs:
%   image: input image to be decomposed.
%   wlev: # of wavelet levels.

% pad image so that dimensions are powers of 2:
image = add_padding(image);

% Defined 1D Gabor-like filter:
h = [1./16.,1./4.,3./8.,1./4.,1./16.];

energy = sum(h);
inv_energy = 1/energy;
h = h*inv_energy;
w = cell(wlev,1);
c = cell(wlev,1);

for s = 1:wlev
    img_dim = size(image,1);
    orig_image = image;
    inv_sum = 1/sum(h);
   
    % decimate image along horizontal direction
    prod = symmetric_filtering(image, h)*inv_sum;          % blur
    HF = prod;
    tmp_prod = zeros(size(prod));
    tmp_prod(:,1:2:img_dim) = prod(:,1:2:img_dim);         % downsample
    
    tmp_prod2 = symmetric_filtering(tmp_prod, h)*inv_sum;  % blur downsampled image horizontally
    GF = image - 2*tmp_prod2;                              % horizontal frequency info                            
    
    % decimate image along vertical direction   
    prod = symmetric_filtering(HF, h')*inv_sum;            % blur
    HHF = prod;
    tmp_prod = zeros(size(prod));
    tmp_prod(1:2:img_dim,:) = prod(1:2:img_dim,:);         % downsample
    
    tmp_prod2 = symmetric_filtering(tmp_prod, h')*inv_sum; % blur downsampled image vertically
    GHF = HF - 2*tmp_prod2;                                % vertical wavelet plane
   
    % decimate GF along vertical direction
    prod = symmetric_filtering(GF, h')*inv_sum;            % blur 
    tmp_prod = zeros(size(prod));
    tmp_prod(1:2:img_dim,:) = prod(1:2:img_dim,:);         % downsample
    
    HGF = 2*symmetric_filtering(tmp_prod, h')*inv_sum;     % horizontal wavelet plane                               
   
    % save horizontal and vertical wavelet planes:
    w{s,1}(:,:,1) = HGF;
    w{s,1}(:,:,2) = GHF;
   
    % Downsample residual image, HHF:
    HHF = HHF(1:2:img_dim,1:2:img_dim);
   
    % save residual
    C      = HHF;
    c{s,1} = C;
   
    % upsample residual image:
    HHF = upsample(upsample(HHF,2)',2)';
   
    % blur with vertical filter:
    image = 2*symmetric_filtering(HHF, h')*inv_sum; 
   
    % blur with horizontal filter:
    image = 2*symmetric_filtering(image, h)*inv_sum;
   
    % Create and save wavelet plane:
    DF = orig_image - (image + HGF + GHF);
    w{s,1}(:,:,3) = DF;
   
    % Downsample residual image:
    image = HHF(1:2:img_dim,1:2:img_dim);
   
end

end

