function [ w,c ] = erase_padding_w( w, c, wlev )

for s=1:wlev
    for o=1:size(w{s,1},3)
        w2{s,1}(:,:,o)=erase_padding(w{s,1}(:,:,o),size(aux_image));
        c2{s,1} = erase_padding(c{s,1},size(aux_image));
    end
    w{s,1}=w2{s,1};
    c{s,1}=c2{s,1};
end

end

