function [ channel_out ] = normalize_range( channel_in )
%NORMALIZE_RANGE Summary of this function goes here
%   Detailed explanation goes here

    if sum(channel_in(:)) > 0
	s_min = min(channel_in(:));
	s_max = max(channel_in(:));
	channel_out = (channel_in - s_min) ./ (s_max - s_min);
    else
    channel_out = channel_in;
    end
    
end

