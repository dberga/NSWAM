

 
 
 function [input_image_resized] = autoresize(input_image,ds)
    %factor denominador = 2^ds
        %exemple: ds = 2^2 = 4
        %if s=256x256,ds=2 -> snew = 256/4 = 64x64
 
    
    if nargin < 2
        ds = 0;
        image_resized = input_image;
        while max(size(image_resized)) > 256
            ds = ds +1;
            image_resized = autoresize(input_image,ds);
        end
    end
    
    

    if ds == 0
        input_image_resized = input_image;
    else
        [m n p]    = size(input_image);
        m_resiz    = round(m/(2.^ds));
        n_resiz    = round(n/(2.^ds));
        input_image_resized = imresize(input_image, [m_resiz n_resiz]);    
    end

end
