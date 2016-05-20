function [ output_image, ifix, jfix ] = unpad_image( input_image, ifix, jfix, original_M, original_N)

    %CALCULATE PADDING (RECTANGULAR IMAGES)
    [x_margin, y_margin] = padding_get_margins(original_M,original_N);
    
    %RELOCATE FIXATION ON PADDING
    ifix =  ifix+y_margin;
    jfix = jfix+x_margin;
    
    %ERASE PADDING MARGINS
    output_image = padding_square2original(input_image,x_margin,y_margin);
    
end

