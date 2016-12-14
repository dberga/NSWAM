

 
function [gaussian] = get_gaussian(M,N,sigma, factor, coordN, coordM)

    if nargin < 5
        coordM = round(M/2);
        coordN = round(N/2);
    end
        
        
	gaussian = fspecial('Gaussian',[M N],sigma);
	gaussian = normalize_minmax(gaussian)*factor; %doubles go from 0 to 1 (factor = 1, floor_flag = 0)
    gaussian = blankshift(gaussian, coordM,coordN);
    
end


function [mat_out] = blankshift(mat_in,y,x) %y,x are rows, columns. be careful
    [M,N] = size(mat_in);
    rM = round(M/2);
    rN = round(N/2);
    
    mat_out = circshift(mat_in,[-rM -rN]);
    
    mat_out = circshift(mat_out,[x y]);
       
    
    
    if x > round(M/2)
         pad_row = 1:x-rM;
        mat_out(pad_row,:) = 0;
    
    else
        if  x < round(M/2)
            pad_row = x+rM:M;
            mat_out(pad_row,:) = 0;
        else
            %do nothing
        end
    end
    
    if y > round(N/2)
         pad_col = 1:y-rN; 
        mat_out(:,pad_col) = 0;
    else
        if  y < round(N/2)
            
            pad_col = y+rN:N; 
            mat_out(:,pad_col) = 0;
        else
            %do nothing
        end
    end
    
    
end
