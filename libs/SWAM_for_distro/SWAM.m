function smap = SWAM(img, window_sizes, wlev, gamma, srgb_flag, nu_0)
% returns saliency map for image
%
% outputs:
%   smap: saliency map for image
%
% inputs:
%   imag: input image
%   window sizes: window sizes for computing relative contrast; suggested 
%   value of [13 26]
%   wlev: # of wavelet levels
%   gamma: gamma value for gamma correction
%   srgb_flag: 0 if img is rgb; 1 if img is srgb
%   nu_0: peak spatial frequency for CSF; suggested value of 4

% convert opponent colour space of colour images:
opp_img = rgb2opponent(img, gamma, srgb_flag);

% generate swam for each channel:
rec(:,:,1) = SWAM_per_channel(opp_img(:,:,1),wlev,nu_0,'colour',window_sizes);
rec(:,:,2) = SWAM_per_channel(opp_img(:,:,2),wlev,nu_0,'colour2',window_sizes);
rec(:,:,3) = SWAM_per_channel(opp_img(:,:,3),wlev,nu_0,'intensity',window_sizes);

% combine channels:
[m n p] = size(img);
s_map   = sqrt(sum(rec.^2,3))*(m*n);

% normalise:
map_max = max(s_map(:));
map_min = min(s_map(:));
smap    = floor(255*(s_map - map_min)/(map_max - map_min));

end

function rec = SWAM_per_channel(channel,wlev,nu_0,mode,window_sizes)
% returns saliency map for channel
%
% outputs:
%   rec: saliency map for channel
%
% inputs:
%   channel: opponent colour channel for which saliency map will be computed
%   wlev: # of wavelet levels
%   nu_0: peak spatial frequency for CSF; suggested value of 4
%   mode: type of channel i.e. colour or intensity
%   window sizes: window sizes for computing relative contrast; suggested 
%   value of [13 26]

channel = double(channel);
[w wc]  = DWT(channel,wlev);

%figure;
allZctr = cell([wlev 3]);
allws = cell([wlev 3]);
allalpha = cell([wlev 3]);

% for each scale:
for s = 1:wlev
    % for horizontal, vertical and diagonal orientations:
    for orientation = 1:3
           
    	% retrieve wavelet plane:
        ws = w{s,1}(:,:,orientation);
        allws{s}{orientation} = ws;
        
        
        
    	% calculate center-surround responses:
        Zctr = relative_contrast(ws,orientation, window_sizes);
        allZctr{s}{orientation} = Zctr;
        
        
        % return alpha values:
        alpha = generate_csf(Zctr, s, nu_0, mode);
        allalpha{s}{orientation} = alpha;
        
        % save alpha value:
        wp{s,1}(:,:,orientation) = alpha;
    end

    % set residual data to zero:
    wc{s,1} = zeros(size(alpha/2,1)/2,size(alpha/2,2)/2) + 1;
end

 
        
% reconstruct the image using inverse wavelet transform:
rec = IDWT(wp,wc,size(channel,2),size(channel,1));

%%%display
[figure_ws] = displayfig_s_o(allws,1,wlev,1,3);
writefig_matrix(figure_ws,'ws_swam','libs/SWAM_for_distro/output_figs','',['_channel(' mode ')' ],'jpg');
[figure_zctr] = displayfig_s_o(allZctr,1,wlev,1,3);
writefig_matrix(figure_zctr,'zctr_swam','libs/SWAM_for_distro/output_figs','',['_channel(' mode ')' ],'jpg');
[figure_alpha] = displayfig_s_o(allalpha,1,wlev,1,3);
writefig_matrix(figure_alpha,'alpha_swam','libs/SWAM_for_distro/output_figs','',['_channel(' mode  ')' ],'jpg');


 
% normalization:
if sum(rec(:)) > 0
    rec = rec./sum(rec(:));
end

%map_max = max(rec(:));
%map_min = min(rec(:));
%smap_channel    = floor(255*(rec - map_min)/(map_max - map_min));
%figure_disp = imshow(uint8(smap_channel));
%SWAM_channel_figure_display(figure_disp,'jpg','output/','nsal','',mode);

end

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





function [figure_disp] = SWAM_channel_display_texample(image,sinit,sfinal,oinit,ofinal,channel)
    

        figure_disp = figure;
        
        count = 0;
        for s=sinit:sfinal
            for o=oinit:ofinal
                count = count +1;
                
                
                subplot(length(sinit:sfinal),length(oinit:ofinal),count), subimage(image{s}{o}(:,:));
                title([channel '_t(mean)']);
                xlabel(['scale=' int2str(s)]);
                ylabel(['orientation' int2str(o)]);
                
                
            end
        end
        
end

function [] =  SWAM_channel_figure_display(figin,format,output_folder,output_prefix,output_suffix,channel)

    saveas(figin,[output_folder output_prefix '_' channel '_' output_suffix '.' format]);
    
end

