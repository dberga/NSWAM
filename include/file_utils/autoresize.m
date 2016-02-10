

 
 
 function [input_image_resized] = autoresize(input_image,ds)
    if nargin < 2
	ds = 2;
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
