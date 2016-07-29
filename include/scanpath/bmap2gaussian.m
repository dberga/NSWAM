function [ gaussian ] = bmap2gaussian( bmap )

    %fc = round(sqrt(sum(sum(bmap)))/2);
    fc = 6;
    gaussian = bmap2gaussian(bmap,fc);

end

