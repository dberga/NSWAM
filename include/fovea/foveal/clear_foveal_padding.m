function [ output_image ] = clear_foveal_padding( input_image, margin_up, margin_down, margin_left, margin_right )
%CLEAR_PADDING Summary of this function goes here
%   Detailed explanation goes here

output_image = input_image(margin_up:end-margin_down,margin_left:end-margin_right,:);


end

