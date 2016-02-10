function [siz]=scale2size(s, type,epsilon)

switch(type)
    case (-2) % modified [gop14] for Gabor coefficients
        siz=6+s;
        disp('Warning: that s arbitrary! Should be modified!')
    case (-1)
        % epsilon is a correcting factor for balancing assimilation and contrast
        siz=ceil((2*epsilon).^(s));  % note: we use ceil since siz entries should assume integer values
    case (0)
	siz=2.^(s-1);
    case (1)
	siz=2.^(s);
    case (2)
        siz=3.^(s);  % 1.^(s), i.e. no change in the size, gives too much contrast
    %case (3)
    %    epsilon=1.8; % epsilon is a correcting factor for balancing assimilation and contrast
    %    siz=ceil((2*epsilon).^(s));  % note: we use ceil since siz entries should assume integer values
    %case (4)
    %    epsilon=1.1; % epsilon is a correcting factor for balancing assimilation and contrast
    %    siz=ceil((2*epsilon).^(s));  % note: we use ceil since siz entries should assume integer values    
end
end
