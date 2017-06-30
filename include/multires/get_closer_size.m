function [ nnn ] = get_closer_size( nn, target_scale,ini_scale )
    if nargin<3, ini_scale=1; end
    nnn = nn;
    for s=ini_scale:target_scale-1
        nnn = nnn/2;
    end

end

