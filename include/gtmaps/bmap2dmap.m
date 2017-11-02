function [ dmap ] = bmap2dmap( bmap, option,params)
    if nargin < 3, params.pxva=40; params.sigma=10;
    if nargin < 2, option = 2; end
    
switch option

    case 1 %antonioGaussian old sigma
        dmap = run_antonioGaussian(bmap,params.pxva,params.sigma);

    case 2 %Zhong2012
        dmap = zhong2012(bmap,params.pxva);

    case 3 %ImgSalGaussian
        dmap = imgSalGaussian( bmap,params.pxva,params.sigma );

    case 4 %inverse distance transform
	dmap = bmap2distmap(bmap);

end

end
