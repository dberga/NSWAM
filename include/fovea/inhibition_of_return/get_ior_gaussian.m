function [ gaussian ] = get_ior_gaussian( fov_x, fov_y, ior_factor, ior_angle, M, N, img_diag_angle)

img_diag_pix = sqrt(N*N+M*M);

a_degree_diagonal_pix = img_diag_pix/img_diag_angle;
gaussian_diameter_pix = ior_angle*a_degree_diagonal_pix;

sigma = round(gaussian_diameter_pix);
gaussian = get_gaussian(M,N,sigma,ior_factor,fov_x,fov_y);



end

