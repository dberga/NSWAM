function [ smap ] = rec_to_smap( rec )


%normalize each color channel
normalized_color_smap = zeros(size(rec,1),size(rec,2));
for op=1:3 %for each opponent channel, normalize with respect to sum value
  normalized_color_smap(:,:,op) = normalize_channel(rec(:,:,op));
end



%combine channels and normalize final map with respect to max values
smap = channelcombine(normalized_color_smap);
normalized_smap = normalize_map(smap);
smap = normalized_smap;
smap = uint8(smap);


end

