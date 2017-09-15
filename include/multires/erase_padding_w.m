function [ w,c ] = erase_padding_w( w, c, wlev,orig_size )

for s=1:wlev
    for o=1:size(w{s,1},3)
        w2{s,1}(:,:,o)=erase_padding(w{s,1}(:,:,o),orig_size);
        c2{s,1} = erase_padding(c{s,1},orig_size);
    end
    w{s,1}=w2{s,1};
    c{s,1}=c2{s,1};
end

end

