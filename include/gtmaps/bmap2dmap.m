function [ dmap ] = bmap2dmap( bmap, option)
    if nargin < 2, option = 1; end
        
switch option

    case 1 %antonioGaussian old sigma
        dmap = run_antonioGaussian(bmap);

    case 2 %Zhong2012
        dmap = zhong2012(bmap);

    case 3 %ImgSalGaussian
        dmap = imgSalGaussian( bmap );

    case 4 %inverse distance transform
	dmap = normalize_minmax(imcomplement(bwdist(bmap)));

end

end