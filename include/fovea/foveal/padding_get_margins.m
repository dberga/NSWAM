function [ x_margin, y_margin ] = padding_get_margins( M,N )


x_margin = 0;
y_margin = 0;
if M > N %vertical rectangle, add padding on sides left,right
    x_margin = floor((M-N)/2);
    
end

if M < N %horizontal rectangle, add padding on up,down
    y_margin = floor((N-M)/2);
    
end

end

