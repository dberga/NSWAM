function [ mat_out ] = multidimcell2multidimmatrix( cell_in )

if iscell(cell_in)
    for dim=1:length(cell_in)
        try 
            mat_out=cell2mat(cell_in{dim}); 
        catch
            [ mat_out ] = multidimcell2multidimmatrix( cell_in{dim} );
        end
    end
else
    mat_out=cell_in;
end
    
end

