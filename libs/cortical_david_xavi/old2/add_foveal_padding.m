function [ output_image ] = add_foveal_padding( input_image, margin_up, margin_down, margin_left, margin_right)
%ADD_FOVEAL_PADDING Summary of this function goes here
%   Detailed explanation goes here

[M,N,C] = size(input_image);

m_up = zeros(margin_vertical,N+margin_left+margin_right);
m_down = zeros(margin_vertical,N+margin_left+margin_right);

n_left = zeros(M+margin_up+margin_down,margin_horizontal);
n_right = zeros(M+margin_up+margin_down,margin_horizontal);

output_image = [ m_up ; n_left input_image n_right; m_down];


end

