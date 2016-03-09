
function channel_out = normalize_energy(channel_in)

    if sum(channel_in(:)) > 0
        channel_out = channel_in./sum(channel_in(:));
    else
        channel_out = channel_in;
    end

end

