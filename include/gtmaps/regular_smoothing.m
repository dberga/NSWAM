function [ map ] = regular_smoothing( map, smoothing )

            sigval=max(size(smap))*smoothing*0.01;
            sigwin=[round(6*sigval) round(6*sigval)];
            map=filter2(fspecial('gaussian',sigwin,sigval),map);

end

