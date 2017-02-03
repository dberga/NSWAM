function [ gaussian ] = bmap2gaussian( bmap, sigma )
    
    [sn, sm, c]=size(bmap);
    n=max([sn sm]);
    
    if nargin < 2; sigma = round(sqrt(n*sqrt(n/3))/(sqrt(sum(sum(bmap))))); end;
    
    fc = n*sqrt(log(2)/(2*(pi^2)*(sigma^2)));
    %fc = round(sqrt(sum(sum(bmap))/2);

    gaussian = antonioGaussian_mod(bmap,fc);

end

