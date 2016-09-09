function [X,Y] = MFactor_to_coords(MFactor,i,j,lambda)
    
    X = i + lambda .* log(MFactor);
    Y = j + lambda .* log(MFactor);

    
    %Y = irel + MFactor .* irel;
    %X = jrel + MFactor .* jrel;
    

end

