function [rows, cols] = custom_ind2sub(mat_size, subs)
    rows = zeros(size(subs));
    cols = zeros(size(subs));
    
    for i=1:numel(subs)
        rows(i) = floor(subs(i)/(mat_size(2)+1))+1; 
        cols(i) = mod(subs(i)-1,(mat_size(2)))+1; 
    end
    
     %the +1 and +1 are to adjust to matlab (in matlab, vectors start at 0)
    
    
end

