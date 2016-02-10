

 
 
 function [input_image_resized] = autoresize(input_image)

    [m n p]    = size(input_image);
    ds         = 2;
    m_resiz    = round(m/(2.^ds));
    n_resiz    = round(n/(2.^ds));
    input_image_resized = imresize(input_image, [m_resiz n_resiz]);    
    

end
