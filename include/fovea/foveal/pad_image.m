function [ output_image, ifix, jfix ] = pad_image( input_image, ifix, jfix)

    [M,N,C] = size(input_image);
    
    %CALCULATE PADDING (RECTANGULAR IMAGES)
    [x_margin, y_margin] = padding_get_margins(M,N);
    
    %RELOCATE FIXATION ON PADDING
    ifix =  ifix+y_margin;
    jfix = jfix+x_margin;
    
    %ADD PADDING (-inf)
    output_image = padding_rectangle2square(input_image,x_margin,y_margin,-inf);
    
    %CHANGE -inf PADDING TO MEAN
    output_image =  padding_zeros2mean(output_image,input_image, -inf);
    
    

end

