function [ nnn ] = get_closer_size_inv( nn, target_scale,fin_scale )
    nnn = nn;
    for s=fin_scale:-1:target_scale
        nnn = nnn/2;
    end


end

