function [ mat_out ] = rf2mat( cell_in )
    
    
    
    n_scales = numel(cell_in); 
    [M,N,n_orient] = size(cell_in{1});
    
    mat_out = zeros(M,N,n_scales,n_orient);
    

            for s=1:n_scales
                for o=1:n_orient
                    mat_out(:,:,s,o) = cell_in{s}(:,:,o);
                end
            end

    

end

