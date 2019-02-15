function [ gaussian ] = get_ior_gaussian( fov_x, fov_y, conf_struct)
ior_factor=1;
max_scale=conf_struct.gaze_params.maxidx_s;
ini_scale=conf_struct.wave_params.ini_scale;
fin_scale=conf_struct.wave_params.fin_scale;
mida_min=conf_struct.wave_params.mida_min;
M=conf_struct.gaze_params.orig_height;
N=conf_struct.gaze_params.orig_width;
img_diag_angle=conf_struct.gaze_params.img_diag_angle;
ior_angle = conf_struct.gaze_params.ior_angle;

bmap = scanpath2bmap([fov_x fov_y],[M N]);


%method1
% img_diag_pix = sqrt(N*N+M*M);
% a_degree_diagonal_pix = img_diag_pix/img_diag_angle;
% gaussian_diameter_pix = ior_angle*a_degree_diagonal_pix;
% sigma = round(gaussian_diameter_pix);
%gaussian = get_gaussian(M,N,sigma,ior_factor,fov_x,fov_y);

%method2
%bmap = scanpath2bmap([fov_x fov_y],[M N]);
%gaussian = ior_factor .* normalize_minmax(antonioGaussian(bmap,ior_angle));

%method3
% bmap = scanpath2bmap([fov_x fov_y],[M N]);
% n = max([M N]);
% %n_scales = floor(log((n-1)/mida_min)/log(2))+3-1;
% nn = 2^(get_closer_2exp(n));
% sigma = get_closer_size(nn,ior_angle+3);
% fc = n*sqrt(log(2)/(2*(pi^2)*(sigma^2)));
% gaussian = ior_factor .* normalize_minmax(antonioGaussian_mod(bmap,fc));

%method4
%  bmap = scanpath2bmap([fov_x fov_y],[M N]);
%  n = max([M N]);
%      %ini_scale corresponds to pixels of 1º visual angle
%      %fin_scale corresponds to maximum pixels of image
%     %ior_angle_pixels=rad2deg(img_diag_angle)+(n-rad2deg(img_diag_angle))*((max_scale-ini_scale)/(fin_scale-ini_scale));
%  gaussian = ior_factor .* normalize_minmax(zhong2012(bmap,ior_angle_pixels));
 
 %method5 (piramide ajustada)
%  bmap = scanpath2bmap([fov_x fov_y],[M N]);
%  n = max([M N]);
%  nn = 2^(get_closer_2exp(n));
%  for s=ini_scale:fin_scale
%     pyramid(s)=get_closer_size(nn,s);
%  end
%  pyramid=fliplr(pyramid);
%  nnn=pyramid(max_scale); 
%  ior_angle_pixels=(pyramid(end)-pyramid(1))*normalize_minmax(nnn+rad2deg(img_diag_angle),pyramid(1),pyramid(end)*2);
%  gaussian = ior_factor .* normalize_minmax(zhong2012(bmap,ior_angle_pixels));
 
%% method 6 scale adaptive
if conf_struct.gaze_params.ior_angle == 0.069813170079773 %token set by default, in conf this should be changed -1


    for s=ini_scale:fin_scale
    pyramid(s)=mida_min*2^(s-1);
    end
    ior_angle_pixels=pyramid(max_scale);
    gaussian = ior_factor .* normalize_minmax(zhong2012(bmap,ior_angle_pixels));
else
    
    
    %% method 7 scale specific
    ior_angle_pixels=rad2deg(ior_angle)*rad2deg(img_diag_angle);
    gaussian = ior_factor .* normalize_minmax(zhong2012(bmap,ior_angle_pixels));

end

end

