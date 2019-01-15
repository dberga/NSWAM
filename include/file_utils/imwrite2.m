function [  ] = imwrite2( img,path, flag )
    if nargin<3, flag=1; end
    
    if flag==1 %overwrite
        imwrite(img,path);
    else
        if ~exist(path,'file')
            imwrite(img,path);
        end
    end

end

