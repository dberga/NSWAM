function [  ] = imwrite2( img,path, flag, args)
    if nargin<3, flag=1; end
    if nargin<4, 
        if flag==1 %overwrite
            imwrite(img,path);
        else
            if ~exist(path,'file')
                imwrite(img,path);
            end
        end
    else
        if flag==1 %overwrite
            imwrite(img,path,args);
        else
            if ~exist(path,'file')
                imwrite(img,path,args);
            end
        end
    end

end

