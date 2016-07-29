function zctr = relative_contrast(X,orientation,window_sizes)
% returns relative contrast for each coefficient of a wavelet plane
%
% outputs:
%   zctr: matrix of relative contrast values for each coefficient
% 
% inputs:
%   X: wavelet plane
%   window sizes: window sizes for computing relative contrast; suggested 
%   orientation: wavelet plane orientation

center_size   = window_sizes(1);
surround_size = window_sizes(2);

% horizontal orientation:
if orientation == 1
    
    % define center and surround filters:
    hc = ones(1,center_size);
    hs = [ones(1,surround_size) zeros(1,center_size) ones(1,surround_size)];
    
    % compute std dev:
    sigma_cen = imfilter(X.^2,hc.^2,'symmetric')/(length(find(hc==1)));
    sigma_sur = imfilter(X.^2,hs.^2,'symmetric')/(length(find(hs==1)));
    
% vertical orientation:
elseif orientation == 2
    % define center and surround filters:
    hc = ones(center_size,1);
    hs = [ones(surround_size,1); zeros(center_size,1); ones(surround_size,1)];
    
    % compute std dev:
    sigma_cen = imfilter(X.^2,hc.^2,'symmetric')/(length(find(hc==1)));
    sigma_sur = imfilter(X.^2,hs.^2,'symmetric')/(length(find(hs==1)));

% diagonal orientation:
elseif orientation == 3
    % define center and surround filters:
    hc = ceil((diag(ones(1,center_size)) + fliplr(diag(ones(1,center_size))))/4);
    hs = diag([ones(1,surround_size) zeros(1,center_size) ones(1,surround_size)]);
    hs = hs + fliplr(hs);
    
    % compute std dev:
    sigma_cen = imfilter(X.^2,hc.^2,'symmetric')/(length(find(hc==1)));
    sigma_sur = imfilter(X.^2,hs.^2,'symmetric')/(length(find(hs==1)));    
end

r    = sigma_cen./(sigma_sur+1.e-6);
zctr = r.^2./(1+r.^2);

end
