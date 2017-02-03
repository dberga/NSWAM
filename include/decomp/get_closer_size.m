function [ nnn ] = get_closer_size( nn, target_scale )
    nnn = nn;
    for s=1:target_scale-1
        nnn = nnn/2;
    end

end

