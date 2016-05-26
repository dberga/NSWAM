
function channel_out = normalize_Zp(channel_in)

    if sum(channel_in(:)) > 0
	s_mean = mean(channel_in(:));
	s_sdev = std(channel_in(:));
	channel_out = (channel_in - s_mean) ./ s_sdev;
    channel_out(channel_out < 0) = 0;
    else
        channel_out = channel_in;
    end

end

