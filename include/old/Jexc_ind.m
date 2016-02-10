function [z] = Jexc_ind(x)


sigma_x=1;
% Gaussian model for excitation

z=exp(-x^2/sigma_x^2)/(sqrt(2*pi)*sigma_x);