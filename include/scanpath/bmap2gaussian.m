function [ gaussian ] = bmap2gaussian( bmap, fc )
    
    if nargin < 2; fc = round(sqrt(sum(sum(bmap)))/2); end;

    gaussian = antonioGaussian_mod(bmap,fc);

end

