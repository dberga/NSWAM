function [ target_features ] = template2params( input_image, mask, conf_struct )
    if nargin<3, 
        conf_struct.color_params.gamma=2.4;
        conf_struct.color_params.srgb_flag=1;
        conf_struct.wave_params.multires='a_trous';
        conf_struct.wave_params.ini_scale=1;
        conf_struct.wave_params.fin_scale_offset=1;
        conf_struct.wave_params.mida_min=8;
        conf_struct.wave_params.extra=3;
        conf_struct.gaze_params.foveate=0;
        conf_struct.zli_params.n_membr=10;
        conf_struct.zli_params.bScaleDelta=1;
        conf_struct.zli_params.Delta=15;
        conf_struct.resize_params.autoresize_ds=-1;
        conf_struct.resize_params.autoresize_nd=0;
        conf_struct.search_params.method='coefficients';
        conf_struct.search_params.topdown=1;
        conf_struct.gaze_params.orig_height=size(input_image,1);
        conf_struct.gaze_params.orig_width=size(input_image,2);
        conf_struct.gaze_params.fov_x=round(conf_struct.gaze_params.orig_width.*0.5);
        conf_struct.gaze_params.fov_y=round(conf_struct.gaze_params.orig_height.*0.5);
    end
if conf_struct.search_params.topdown==1
    
    %get boolean 2D mask
    if size(mask,3) > 1 %10/255
        mask=rgb2gray(mask);
    end
    mask=normalize_minmax(im2double(mask));
    
    %image to opp
    opp_image = get_rgb2opp(input_image,conf_struct);
    opp_image=normalize_channels(opp_image);
    C=size(opp_image,3);
    
    %image to LGN/V1
%     switch conf_struct.gaze_params.foveate
%         case 1 %foveate before DWT
% 
%             [opp_image_foveated] = get_foveate(opp_image,conf_struct);
%             [conf_struct.wave_params.n_scales, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale]= calc_scales(opp_image_foveated, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires); % calculate number of scales (n_scales) automatically
%             [conf_struct.wave_params.n_orient] = calc_norient(opp_image_foveated,conf_struct.wave_params.multires,conf_struct.wave_params.n_scales,conf_struct.zli_params.n_membr);            
%             [curvs,residuals] = get_DWT([],conf_struct,[],[],C,1,opp_image_foveated);
% 
%             [mask] = get_foveate(mask,conf_struct,1);
%             
%         case 3 %foveate after DWT
% 
%             [opp_image_foveated] = get_foveate(opp_image,conf_struct);
%             [conf_struct.wave_params.n_scales, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale]= calc_scales(opp_image_foveated, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires); % calculate number of scales (n_scales) automatically
%             [conf_struct.wave_params.n_orient] = calc_norient(opp_image_foveated,conf_struct.wave_params.multires,conf_struct.wave_params.n_scales,conf_struct.zli_params.n_membr);            
%             [curvs,residuals] = get_DWT([],conf_struct,[],[],C,1,opp_image);
%             [curvs,residuals]=get_foveate_multires(curvs,residuals,conf_struct);
%             
%             [mask] = get_foveate(mask,conf_struct,1);
%         otherwise %do not foveate
% 
%             [opp_image] = get_resize(opp_image,conf_struct);
%             %[curvs,residuals]=get_resize_multires(curvs,residuals,conf_struct);
%             [conf_struct.wave_params.n_scales, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale]= calc_scales(opp_image, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires); % calculate number of scales (n_scales) automatically
%             [conf_struct.wave_params.n_orient] = calc_norient(opp_image,conf_struct.wave_params.multires,conf_struct.wave_params.n_scales,conf_struct.zli_params.n_membr);            
%             [curvs,residuals] = get_DWT([],conf_struct,[],[],C,1,opp_image);
% 
%             [conf_struct.resize_params.M, conf_struct.resize_params.N, ~] = size(get_resize(opp_image,conf_struct));
%             [conf_struct.resize_params.fov_x,conf_struct.resize_params.fov_y] = movecoords( conf_struct.gaze_params.orig_height, conf_struct.gaze_params.orig_width, conf_struct.gaze_params.fov_x, conf_struct.gaze_params.fov_y , conf_struct.resize_params.M, conf_struct.resize_params.N); 
%             
%             [mask] = get_resize(mask,conf_struct);
%     end
    
    %get curvs (wavelet coefficients) from image
    [conf_struct.wave_params.n_scales, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale]= calc_scales(opp_image, conf_struct.wave_params.ini_scale, conf_struct.wave_params.fin_scale_offset, conf_struct.wave_params.mida_min, conf_struct.wave_params.multires); % calculate number of scales (n_scales) automatically
    [conf_struct.wave_params.n_orient] = calc_norient(opp_image,conf_struct.wave_params.multires,conf_struct.wave_params.n_scales,conf_struct.zli_params.n_membr);            
    [curvs,residuals] = get_DWT([],conf_struct,[],[],C,1,opp_image);
%     [mask] = get_resize(mask,conf_struct);

    %normalize wavelet coefficients by normalized white noise std coefficients
    if isfield(conf_struct.search_params,'normalize')
        if conf_struct.search_params.normalize==1
            [whitefactor,whitefactor2]=wavelet_whitefactor(conf_struct.wave_params.mida_min,conf_struct.wave_params.n_scales);
        %     curvs{1} = wavelet_normalize_scales( curvs{1},whitefactor );
        %     curvs{2} = wavelet_normalize_scales( curvs{2},whitefactor );
        %     curvs{3} = wavelet_normalize_scales( curvs{3},whitefactor );
            curvs{1} = wavelet_normalize_scales_orients( curvs{1},whitefactor2 );
            curvs{2} = wavelet_normalize_scales_orients( curvs{2},whitefactor2 );
            curvs{3} = wavelet_normalize_scales_orients( curvs{3},whitefactor2 );
        end
    end
    
%     %% plot curvs
%     for c=1:length(curvs)
%         figure; [fig] = show_wav(curvs{c},1,conf_struct.wave_params.n_scales-1,1,conf_struct.wave_params.n_orient);
% %         close all;
%     end
    
    
    %build unique array from curvs (not cell)
    multidim=wav2multidim(curvs);
    %multidim=normalize_channels_multidim(multidim);
    %multidim=normalize_energy_multidim( multidim );
    
    %cut V1 slice with mask
    mask=normalize_minmax(mask);
    %mask(mask==0)=NaN;
    %mask(~isnan(mask))=1;
    multidim_cut=mask.*multidim;    
    %note: better if we mean M,N to erase local maxima?
    if isfield(conf_struct.search_params,'nonzeros')
         if conf_struct.search_params.nonzeros==1
            multidim_cut(find(multidim_cut==0))=NaN;
         end
    end
    
    %separate on and off signals
    [multidim_on,multidim_off]=multidim2onoff(multidim_cut);
    multidim_onoff(:,:,:,:,1,:)=multidim_on;
    multidim_onoff(:,:,:,:,2,:)=multidim_off;
    
    %get mean coefficients
    coef_mean1=squeeze(nanmean(nanmean(multidim_on,1),2));
    coef_mean2=squeeze(nanmean(nanmean(multidim_off,1),2));
    target_features.coefficients(:,:,1,:)=normalize_minmax(coef_mean1);
    target_features.coefficients(:,:,2,:)=normalize_minmax(coef_mean2);
    
    [maxval,idx_max]=max(coef_mean1(:));
    [max_s,max_o,max_c]=ind2sub(size(coef_mean1),idx_max);    
    [maxval2,idx_max2]=max(coef_mean2(:));
    [max_s2,max_o2,max_c2]=ind2sub(size(coef_mean2),idx_max2);

    if maxval > maxval2
	    target_features.channels=max_c;
	    target_features.scales=max_s;
	    target_features.orientations=max_o;
	    target_features.polarity=1;
	else
	    target_features.channels=max_c2;
	    target_features.scales=max_s2;
	    target_features.orientations=max_o2;
	    target_features.polarity=2;
    end

    if strcmp(conf_struct.search_params.method,'max')
	%get maximum (on) or minimum (off) for each dimension   
        [maxval,idx_max]=max(multidim_on(:));
        [max_M,max_N,max_s,max_o,max_c]=ind2sub(size(multidim_on),idx_max);
        [maxval2,idx_max2]=max(multidim_off(:));
    	[max_M2,max_N2,max_s2,max_o2,max_c2]=ind2sub(size(multidim_off),idx_max2);
    end
    %imagesc(multidim(:,:,max_s,max_o,max_c));
    %imagesc(multidim(:,:,max_s2,max_o2,max_c2));
        
else
    target_features=struct(); %empty struct for no topdown
end

end

