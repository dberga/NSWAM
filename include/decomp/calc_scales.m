
function [n_scales, ini_scale, fin_scale] = calc_scales(img, ini_scale, fin_scale_offset, mida_min, multires)

    
        if(fin_scale_offset==0)
            extra=2;  % parameter to adjust the correct number of the last wavelet plane (obsolete)
        else
            extra=3;
        end

        switch(multires)
            case('gabor_HMAX')
                n_scales=8;
                fin_scale=n_scales;
    % 		case('a_trous')
    % 			n_scales=6;
                %fin_scale= struct.wave.n_scales - struct.wave.fin_scale_offset;
            otherwise
                n_scales=floor(log(max(size(img(:,:,1))-1)/mida_min)/log(2)) + extra;
    %			n_scales=floor(log2(	min(size(img(:,:,1)))-1) )-n_scale_max;
                fin_scale= n_scales - fin_scale_offset;
        end
    
    %%a_trous uses same scaling per scale (wont crash), other decomp. would crash afterwards
    
end
