function [z] = Winh_ind(y)


sigma_y=1;
% Gaussian model for excitation

z=exp(-y^2/sigma_y^2)/(sqrt(2*pi)*sigma_y);