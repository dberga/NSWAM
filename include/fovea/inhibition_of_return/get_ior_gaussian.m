function [ gaussian ] = get_ior_gaussian( fov_x, fov_y, ior_factor, ior_angle, M, N, img_diag_angle)



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
bmap = scanpath2bmap([fov_x fov_y],[M N]);
n = max([M N]);
%n_scales = floor(log((n-1)/mida_min)/log(2))+3-1;
nn = 2^(get_closer_2exp(n));
sigma = get_closer_size(nn,ior_angle+3);
fc = n*sqrt(log(2)/(2*(pi^2)*(sigma^2)));
gaussian = ior_factor .* normalize_minmax(antonioGaussian_mod(bmap,fc));


end

