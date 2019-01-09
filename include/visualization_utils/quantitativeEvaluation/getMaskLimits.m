function [ inifil, finfil, inicol, fincol ] = getMaskLimits( mask )

	[fils,cols]=find(mask);
	inifil=min(fils);
	finfil=max(fils);
	inicol=min(cols);
	fincol=max(cols);

end

